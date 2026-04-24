#!/usr/bin/env python3
"""
Integration checks for the hybrid compare pipeline.
Requires backend to be running locally at BACKEND_URL (default: http://127.0.0.1:8000).
"""

import os
import tempfile
import unittest
import wave
import struct

import requests


BACKEND_URL = os.environ.get("BACKEND_URL", "http://127.0.0.1:8000")
COMPARE_URL = f"{BACKEND_URL}/api/compare"
HEALTH_URL = f"{BACKEND_URL}/api/health"


class TestComparePipeline(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        requests.get(HEALTH_URL, timeout=10).raise_for_status()

    def _make_silence_wav(self, duration_sec=1, sample_rate=16000):
        tmp = tempfile.NamedTemporaryFile(delete=False, suffix=".wav")
        tmp.close()
        n_samples = int(duration_sec * sample_rate)
        with wave.open(tmp.name, "wb") as wf:
            wf.setnchannels(1)
            wf.setsampwidth(2)
            wf.setframerate(sample_rate)
            frame = struct.pack("<h", 0)
            for _ in range(n_samples):
                wf.writeframesraw(frame)
        return tmp.name

    def _download_reference_sample(self, key="001001"):
        url = f"https://verses.quran.com/Alafasy/mp3/{key}.mp3"
        tmp = tempfile.NamedTemporaryFile(delete=False, suffix=".mp3")
        tmp.close()
        resp = requests.get(url, timeout=30)
        resp.raise_for_status()
        with open(tmp.name, "wb") as f:
            f.write(resp.content)
        return tmp.name

    def test_silent_audio_is_rejected(self):
        silence = self._make_silence_wav()
        try:
            with open(silence, "rb") as f:
                resp = requests.post(
                    COMPARE_URL,
                    files={"audio": f},
                    data={"surah": "1", "ayah": "1"},
                    timeout=60,
                )
            self.assertEqual(resp.status_code, 422)
            payload = resp.json()
            self.assertEqual(payload.get("reason"), "no_speech_detected")
        finally:
            if os.path.exists(silence):
                os.unlink(silence)

    def test_qari_id_changes_reference_url(self):
        sample = self._download_reference_sample()
        try:
            urls = {}
            for qari_id in ["7", "1"]:
                with open(sample, "rb") as f:
                    resp = requests.post(
                        COMPARE_URL,
                        files={"audio": f},
                        data={"surah": "1", "ayah": "1", "qari_id": qari_id},
                        timeout=120,
                    )
                self.assertEqual(resp.status_code, 200)
                payload = resp.json()
                self.assertTrue(payload.get("success"))
                urls[qari_id] = payload.get("reference_audio_url", "")

            self.assertIn("/Alafasy/", urls["7"])
            self.assertIn("/AbdulBaset/Mujawwad/", urls["1"])
            self.assertNotEqual(urls["7"], urls["1"])
        finally:
            if os.path.exists(sample):
                os.unlink(sample)

    def test_hybrid_formula_consistency(self):
        sample = self._download_reference_sample()
        try:
            with open(sample, "rb") as f:
                resp = requests.post(
                    COMPARE_URL,
                    files={"audio": f},
                    data={"surah": "1", "ayah": "1", "qari_id": "7"},
                    timeout=120,
                )
            self.assertEqual(resp.status_code, 200)
            payload = resp.json()

            hs = payload.get("hybrid_scoring", {})
            raw_calc = round(
                (float(hs.get("audio_quality_score", 0.0)) * 0.20)
                + (float(hs.get("phoneme_accuracy_score", 0.0)) * 0.60)
                + (float(hs.get("tajweed_timing_score", 0.0)) * 0.20),
                1,
            )
            final_calc = round(raw_calc * float(hs.get("confidence_multiplier", 0.0)), 1)

            self.assertAlmostEqual(float(hs.get("raw_hybrid_score", 0.0)), raw_calc, places=1)
            self.assertAlmostEqual(float(payload.get("overall_score", 0.0)), final_calc, places=1)
        finally:
            if os.path.exists(sample):
                os.unlink(sample)


if __name__ == "__main__":
    unittest.main()

