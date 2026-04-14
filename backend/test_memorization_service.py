# -*- coding: utf-8 -*-
import unittest
from datetime import datetime, timedelta, timezone

from memorization_models import MemorizationItem, AccuracyEntry
from memorization_service import (
    build_memorization_summary,
    recommended_today,
    update_memorization_item,
)


class TestMemorizationStatusUpdate(unittest.TestCase):
    def _now(self):
        return datetime.now(timezone.utc)

    def test_becomes_memorized_after_required_high_scores(self):
        item = MemorizationItem(
            user_id='u1',
            surah_number=1,
            ayah_number=1,
            status='learning',
            accuracy_history=[
                AccuracyEntry(session_id='s1', score=91, recorded_at='2026-04-10T00:00:00Z'),
                AccuracyEntry(session_id='s2', score=93, recorded_at='2026-04-11T00:00:00Z'),
            ],
            times_recited=2,
            last_recited_at='2026-04-11T00:00:00Z',
        )

        updated = update_memorization_item(
            item,
            overall_score=95,
            word_results=[{'status': 'correct'}, {'status': 'close'}],
            session_id='s3',
            recorded_at='2026-04-12T00:00:00Z',
        )

        self.assertEqual(updated.status, 'memorized')
        self.assertEqual(updated.times_recited, 3)
        self.assertEqual(len(updated.accuracy_history), 3)

    def test_stays_learning_with_medium_score(self):
        item = MemorizationItem(
            user_id='u1', surah_number=2, ayah_number=5, status='not_started'
        )

        updated = update_memorization_item(
            item,
            overall_score=84,
            word_results=[{'status': 'close'}],
            session_id='sx',
            recorded_at='2026-04-12T00:00:00Z',
        )

        self.assertEqual(updated.status, 'learning')

    def test_downgrades_to_needs_review_on_low_score(self):
        item = MemorizationItem(
            user_id='u1',
            surah_number=2,
            ayah_number=6,
            status='memorized',
            last_recited_at='2026-04-10T00:00:00Z',
            times_recited=3,
        )

        updated = update_memorization_item(
            item,
            overall_score=72,
            word_results=[{'status': 'missing'}],
            session_id='s4',
            recorded_at='2026-04-12T00:00:00Z',
        )

        self.assertEqual(updated.status, 'needs_review')

    def test_decay_after_long_inactivity(self):
        old = (datetime.now(timezone.utc) - timedelta(days=20)).isoformat().replace('+00:00', 'Z')
        now = datetime.now(timezone.utc).isoformat().replace('+00:00', 'Z')

        item = MemorizationItem(
            user_id='u1', surah_number=3, ayah_number=1, status='memorized', last_recited_at=old
        )

        updated = update_memorization_item(
            item,
            overall_score=75,
            word_results=[{'status': 'correct'}],
            session_id='s5',
            recorded_at=now,
        )

        self.assertEqual(updated.status, 'needs_review')


class TestMemorizationSummary(unittest.TestCase):
    def test_summary_counts_and_percentages(self):
        items = [
            MemorizationItem(user_id='u1', surah_number=1, ayah_number=1, status='memorized'),
            MemorizationItem(user_id='u1', surah_number=1, ayah_number=2, status='learning'),
            MemorizationItem(user_id='u1', surah_number=112, ayah_number=1, status='memorized'),
            MemorizationItem(user_id='u1', surah_number=112, ayah_number=2, status='memorized'),
        ]

        summary = build_memorization_summary(items)
        self.assertTrue(summary.overall_percent > 0)
        self.assertEqual(len(summary.surah_summaries), 2)

        s1 = next(s for s in summary.surah_summaries if s.surah_number == 1)
        self.assertEqual(s1.memorized_ayahs, 1)
        self.assertEqual(s1.total_ayahs, 7)


class TestMemorizationRecommendations(unittest.TestCase):
    def test_recommendation_order(self):
        items = [
            MemorizationItem(user_id='u1', surah_number=2, ayah_number=1, status='learning', last_recited_at='2026-04-10T00:00:00Z'),
            MemorizationItem(user_id='u1', surah_number=2, ayah_number=2, status='needs_review', last_recited_at='2026-04-12T00:00:00Z'),
            MemorizationItem(user_id='u1', surah_number=2, ayah_number=3, status='not_started', last_recited_at=None),
        ]

        recs = recommended_today(items, limit=5)
        self.assertGreaterEqual(len(recs), 3)
        self.assertEqual(recs[0]['status'], 'needs_review')
        self.assertEqual(recs[1]['status'], 'learning')


if __name__ == '__main__':
    unittest.main()

