# -*- coding: utf-8 -*-
"""Regression tests for gamification session schema normalization."""

import tempfile
import unittest

from database import Database
from gamification_service import GamificationService


class TestGamificationServiceSessionNormalization(unittest.TestCase):
    def test_get_user_sessions_accepts_recitation_schema(self):
        user_id = "user_schema_test"

        with tempfile.TemporaryDirectory() as tmpdir:
            db = Database(base_dir=tmpdir)
            db.create_user(user_id, "Schema User", "schema@example.com")
            db.save_recitation_session(
                user_id,
                {
                    "id": "sess-1",
                    "user_id": user_id,
                    "surah": 1,
                    "ayah": 3,
                    "mode": "practice",
                    "accuracy_score": 82.5,
                    "date_time": "2026-04-15T10:11:12Z",
                    "duration_seconds": 90,
                },
            )

            service = GamificationService()
            service.db = db
            service.sessions.clear()

            sessions = service.get_user_sessions(user_id)

            self.assertEqual(len(sessions), 1)
            session = sessions[0]
            self.assertEqual(session.start_ayah, 3)
            self.assertEqual(session.end_ayah, 3)
            self.assertEqual(session.date, "2026-04-15")
            self.assertAlmostEqual(session.duration_minutes, 1.5, places=2)

    def test_home_metrics_does_not_crash_with_recitation_schema(self):
        user_id = "user_metrics_test"

        with tempfile.TemporaryDirectory() as tmpdir:
            db = Database(base_dir=tmpdir)
            user_profile = db.create_user(user_id, "Metrics User", "metrics@example.com")
            db.save_recitation_session(
                user_id,
                {
                    "id": "sess-2",
                    "user_id": user_id,
                    "surah": 1,
                    "ayah": 1,
                    "mode": "practice",
                    "accuracy_score": 90.0,
                    "date_time": "2026-04-15T08:00:00Z",
                    "duration_seconds": 120,
                },
            )

            service = GamificationService()
            service.db = db
            service.sessions.clear()

            metrics = service.get_home_metrics(user_id, user_profile, "2026-04-15")

            self.assertEqual(metrics.streak.get("current"), 1)
            self.assertEqual(metrics.daily.get("minutes"), 2)

    def test_home_metrics_accepts_dict_memorization_progress(self):
        user_id = "user_memo_dict_test"

        with tempfile.TemporaryDirectory() as tmpdir:
            db = Database(base_dir=tmpdir)
            user_profile = db.create_user(user_id, "Memo User", "memo@example.com")
            db.update_memorization_progress(user_id, surah=1, ayah_count=3)

            service = GamificationService()
            service.db = db
            service.sessions.clear()

            metrics = service.get_home_metrics(user_id, user_profile, "2026-04-15")

            self.assertEqual(metrics.memorization.get("overallPercent"), 42.9)
            top_surahs = metrics.memorization.get("topSurahs")
            self.assertEqual(len(top_surahs), 1)
            self.assertEqual(top_surahs[0].get("ayahCountMemorized"), 3)


if __name__ == "__main__":
    unittest.main()

