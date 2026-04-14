# -*- coding: utf-8 -*-
"""
Session and Progress API Endpoints
Provides real session data, progress metrics, and mistake tracking
"""
from flask import Flask, request, jsonify
from database import get_database
from session_metrics import (
    get_weekly_progress,
    get_recent_recitations,
    get_current_streak_from_sessions,
    get_mistakes_summary,
    get_today_minutes,
    get_this_week_minutes
)
from gamification_models import Session, MemorizationProgress
from gamification_logic import (
    update_memorization_after_session,
    get_overall_memorization_percent,
    get_top_surahs,
)
from memorization_models import MemorizationItem
from memorization_service import (
    build_memorization_summary,
    recommended_today,
    update_memorization_item,
)
from datetime import datetime, timedelta
import uuid


def setup_session_routes(app: Flask):
    """Setup all session and progress routes"""

    db = get_database()

    @app.route("/api/sessions", methods=["POST"])
    def save_user_session():
        """
        POST /api/sessions

        Save a recitation session with mistakes

        Body:
        {
            "userId": str,
            "surah": int,
            "ayah": int,
            "mode": str,
            "accuracyScore": float,
            "whisperScore": float,
            "mfccScore": float,
            "durationSeconds": int,
            "mistakes": [
                {
                    "word": str,
                    "ayah": int,
                    "surah": int,
                    "tajweedRules": [],
                    "errorType": str,
                    "similarity": float
                }
            ],
            "totalWords": int,
            "correctWords": int,
            "closeWords": int,
            "missingWords": int,
            "extraWords": int,
            "referenceAudioUrl": str,
            "transcribedText": str,
            "correctText": str
        }
        """
        try:
            data = request.get_json()
            user_id = data.get("userId")

            if not user_id:
                return jsonify({"error": "userId required"}), 400

            # Ensure user exists
            user = db.get_user(user_id)
            if not user:
                db.create_user(user_id, f"User {user_id[:8]}", f"{user_id}@example.com")

            # Create session object
            session_id = str(uuid.uuid4())
            session_data = {
                "id": session_id,
                "user_id": user_id,
                "surah": int(data.get("surah", 1)),
                "ayah": int(data.get("ayah", 1)),
                "mode": data.get("mode", "recitation"),
                "accuracy_score": float(data.get("accuracyScore", 0)),
                "whisper_score": float(data.get("whisperScore", 0)),
                "mfcc_score": float(data.get("mfccScore", 0)),
                "date_time": datetime.utcnow().isoformat() + "Z",
                "duration_seconds": int(data.get("durationSeconds", 0)),
                "mistakes": data.get("mistakes", []),
                "total_words": int(data.get("totalWords", 0)),
                "correct_words": int(data.get("correctWords", 0)),
                "close_words": int(data.get("closeWords", 0)),
                "missing_words": int(data.get("missingWords", 0)),
                "extra_words": int(data.get("extraWords", 0)),
                "reference_audio_url": data.get("referenceAudioUrl"),
                "transcribed_text": data.get("transcribedText", ""),
                "correct_text": data.get("correctText", ""),
            }

            # Save to database
            db.save_recitation_session(user_id, session_data)

            # Update memorization progress for this ayah using existing logic
            memo_raw = db.get_memorization_progress(user_id)
            memo_objects = {
                int(surah): MemorizationProgress.from_dict(value)
                for surah, value in memo_raw.items()
            }

            memo_session = Session(
                id=session_id,
                user_id=user_id,
                surah=session_data["surah"],
                start_ayah=session_data["ayah"],
                end_ayah=session_data["ayah"],
                duration_minutes=max(1.0, session_data["duration_seconds"] / 60.0),
                date=session_data["date_time"][:10],
                accuracy_score=session_data["accuracy_score"],
                mode=session_data["mode"],
                created_at=session_data["date_time"],
                xp_earned=0,
            )

            updated_memo = update_memorization_after_session(memo_session, memo_objects)
            db.save_memorization_progress(
                user_id,
                {surah: prog.to_dict() for surah, prog in updated_memo.items()}
            )

            # Ayah-level memorization updates are handled by /api/memorization/update
            # to avoid duplicate history writes and status drift.

            return jsonify({
                "success": True,
                "sessionId": session_id,
                "message": f"Session saved with {len(data.get('mistakes', []))} mistakes"
            }), 201

        except Exception as e:
            print(f"❌ Error saving session: {e}")
            import traceback
            traceback.print_exc()
            return jsonify({"error": str(e)}), 500


    @app.route("/api/user/progress", methods=["GET"])
    def get_user_progress_summary():
        """
        GET /api/user/progress?userId=USER_ID&weekStart=YYYY-MM-DD

        Get "Your Progress" screen data

        Returns:
        {
            "thisWeekCount": int,
            "avgAccuracy": float,
            "perfectCount": int,
            "days": [
                {"day": "Mon", "hasSession": bool, "sessionCount": int, "totalMinutes": int}
            ],
            "recentRecitations": [
                {
                    "title": str,
                    "mode": str,
                    "accuracy": float,
                    "daysAgo": int,
                    "sessionId": str
                }
            ]
        }
        """
        try:
            user_id = request.args.get("userId")
            if not user_id:
                return jsonify({"error": "userId required"}), 400

            # Get week start date (default to current week Monday)
            week_start = request.args.get("weekStart")
            if not week_start:
                today = datetime.utcnow()
                week_start = (today - timedelta(days=today.weekday())).strftime("%Y-%m-%d")

            # Load all sessions
            sessions = db.get_user_recitation_sessions(user_id)

            # Calculate metrics
            weekly = get_weekly_progress(user_id, sessions, week_start)

            return jsonify(weekly.to_dict()), 200

        except Exception as e:
            print(f"❌ Error getting user progress: {e}")
            import traceback
            traceback.print_exc()
            return jsonify({"error": str(e)}), 500


    @app.route("/api/user/home-metrics", methods=["GET"])
    def get_user_home_metrics():
        """
        GET /api/user/home-metrics?userId=USER_ID

        Get home screen metrics including streak

        Returns:
        {
            "currentStreak": int,
            "longestStreak": int,
            "lastSessionDate": str,
            "todayMinutes": int,
            "thisWeekMinutes": int
        }
        """
        try:
            user_id = request.args.get("userId")
            if not user_id:
                return jsonify({"error": "userId required"}), 400

            # Load sessions
            sessions = db.get_user_recitation_sessions(user_id)

            # Get streaks
            current_streak, longest_streak, last_session_date = get_current_streak_from_sessions(sessions)

            # Get minutes
            today_minutes = get_today_minutes(sessions)
            week_minutes = get_this_week_minutes(sessions)

            return jsonify({
                "currentStreak": current_streak,
                "longestStreak": longest_streak,
                "lastSessionDate": last_session_date,
                "todayMinutes": today_minutes,
                "thisWeekMinutes": week_minutes
            }), 200

        except Exception as e:
            print(f"❌ Error getting home metrics: {e}")
            import traceback
            traceback.print_exc()
            return jsonify({"error": str(e)}), 500


    @app.route("/api/user/mistakes", methods=["GET"])
    def get_user_mistakes():
        """
        GET /api/user/mistakes?userId=USER_ID&limit=50

        Get aggregated mistakes by ayah and word

        Returns:
        {
            "byAyah": [
                {
                    "surahNumber": int,
                    "surahName": str,
                    "ayah": int,
                    "mistakeCount": int,
                    "lastPracticedAt": str,
                    "words": [
                        {
                            "word": str,
                            "times": int,
                            "lastSimilarity": float,
                            "lastOccurredAt": str
                        }
                    ]
                }
            ],
            "totalMistakes": int,
            "mostRecentMistakeAt": str
        }
        """
        try:
            user_id = request.args.get("userId")
            if not user_id:
                return jsonify({"error": "userId required"}), 400

            limit = int(request.args.get("limit", 50))
            only_memorization = str(request.args.get("onlyMemorizationRelated", "false")).lower() == "true"

            # Load all mistakes
            all_mistakes = db.get_all_mistakes(user_id)

            if only_memorization:
                all_mistakes = [
                    m for m in all_mistakes if str(m.get("mode", "")).lower() == "memorization"
                ]

            # Limit if needed
            if limit:
                all_mistakes = all_mistakes[:limit]

            # Aggregate
            mistakes_summary = get_mistakes_summary(user_id, all_mistakes)

            return jsonify(mistakes_summary.to_dict()), 200

        except Exception as e:
            print(f"❌ Error getting mistakes: {e}")
            import traceback
            traceback.print_exc()
            return jsonify({"error": str(e)}), 500


    @app.route("/api/user/recitations", methods=["GET"])
    def get_user_recent_recitations():
        """
        GET /api/user/recitations?userId=USER_ID&limit=10

        Get recent recitations
        """
        try:
            user_id = request.args.get("userId")
            if not user_id:
                return jsonify({"error": "userId required"}), 400

            limit = int(request.args.get("limit", 10))

            # Load sessions
            sessions = db.get_user_recitation_sessions(user_id, limit=limit)

            # Get recent recitations
            recitations = get_recent_recitations(user_id, sessions, limit)

            return jsonify([r.to_dict() for r in recitations]), 200

        except Exception as e:
            print(f"❌ Error getting recitations: {e}")
            return jsonify({"error": str(e)}), 500


    @app.route("/api/user/memorization", methods=["GET"])
    def get_user_memorization_summary():
        """
        GET /api/user/memorization?userId=USER_ID

        Returns memorization summary:
        {
          "overallPercent": float,
          "topSurahs": [...]
        }
        """
        try:
            user_id = request.args.get("userId")
            if not user_id:
                return jsonify({"error": "userId required"}), 400

            memo_raw = db.get_memorization_progress(user_id)
            memo_objects = {
                int(surah): MemorizationProgress.from_dict(value)
                for surah, value in memo_raw.items()
            }

            overall = get_overall_memorization_percent(memo_objects)
            top_surahs = get_top_surahs(memo_objects, limit=8)

            return jsonify({
                "overallPercent": overall,
                "topSurahs": top_surahs,
            }), 200

        except Exception as e:
            print(f"❌ Error getting memorization summary: {e}")
            import traceback
            traceback.print_exc()
            return jsonify({"error": str(e)}), 500


    @app.route("/api/memorization/update", methods=["POST"])
    def update_memorization():
        """
        POST /api/memorization/update

        Body:
        {
          "userId": "...",
          "surah": 2,
          "ayah": 5,
          "overallScore": 92.5,
          "wordResults": [...],
          "sessionId": "...",
          "recordedAt": "..."
        }
        """
        try:
            data = request.get_json() or {}
            user_id = data.get("userId")
            surah = int(data.get("surah", 0))
            ayah = int(data.get("ayah", 0))
            if not user_id or not surah or not ayah:
                return jsonify({"error": "userId, surah, ayah required"}), 400

            item_raw = db.get_memorization_item(user_id, surah, ayah) or {
                "userId": user_id,
                "surahNumber": surah,
                "ayahNumber": ayah,
                "status": "not_started",
                "accuracyHistory": [],
                "timesRecited": 0,
                "lastRecitedAt": None,
                "lastStatusChangeAt": None,
            }
            item = MemorizationItem.from_dict(item_raw)

            recorded_at = data.get("recordedAt") or (datetime.utcnow().isoformat() + "Z")
            session_id = data.get("sessionId") or str(uuid.uuid4())

            updated = update_memorization_item(
                item,
                overall_score=float(data.get("overallScore", 0.0)),
                word_results=data.get("wordResults", []),
                session_id=session_id,
                recorded_at=recorded_at,
            )

            db.upsert_memorization_item(user_id, updated.to_dict())
            return jsonify({"success": True, "item": updated.to_dict()}), 200
        except Exception as e:
            print(f"❌ Error updating memorization: {e}")
            import traceback
            traceback.print_exc()
            return jsonify({"error": str(e)}), 500


    @app.route("/api/memorization/summary", methods=["GET"])
    def memorization_summary():
        """GET /api/memorization/summary?userId=..."""
        try:
            user_id = request.args.get("userId")
            if not user_id:
                return jsonify({"error": "userId required"}), 400

            items_raw = db.get_memorization_items(user_id)
            items = [MemorizationItem.from_dict(x) for x in items_raw]
            summary = build_memorization_summary(items)
            return jsonify(summary.to_dict()), 200
        except Exception as e:
            print(f"❌ Error getting memorization summary: {e}")
            return jsonify({"error": str(e)}), 500


    @app.route("/api/memorization/today", methods=["GET"])
    def memorization_today():
        """GET /api/memorization/today?userId=...&limit=5"""
        try:
            user_id = request.args.get("userId")
            if not user_id:
                return jsonify({"error": "userId required"}), 400
            limit = int(request.args.get("limit", 5))

            items_raw = db.get_memorization_items(user_id)
            items = [MemorizationItem.from_dict(x) for x in items_raw]
            recs = recommended_today(items, limit=limit)
            return jsonify({"items": recs}), 200
        except Exception as e:
            print(f"❌ Error getting memorization recommendations: {e}")
            return jsonify({"error": str(e)}), 500


    @app.route("/api/memorization/items", methods=["GET"])
    def memorization_items():
        """GET /api/memorization/items?userId=...&surah=..."""
        try:
            user_id = request.args.get("userId")
            if not user_id:
                return jsonify({"error": "userId required"}), 400

            surah_filter = request.args.get("surah")
            items_raw = db.get_memorization_items(user_id)
            items = [MemorizationItem.from_dict(x) for x in items_raw]
            if surah_filter:
                surah_num = int(surah_filter)
                items = [i for i in items if i.surah_number == surah_num]

            return jsonify({"items": [i.to_dict() for i in items]}), 200
        except Exception as e:
            print(f"❌ Error getting memorization items: {e}")
            return jsonify({"error": str(e)}), 500


    @app.route("/api/sessions/<session_id>", methods=["GET"])
    def get_session_detail(session_id):
        """
        GET /api/sessions/<sessionId>?userId=USER_ID

        Get details of a specific session
        """
        try:
            user_id = request.args.get("userId")
            if not user_id:
                return jsonify({"error": "userId required"}), 400

            # Load session
            session = db.get_recitation_session(user_id, session_id)

            if not session:
                return jsonify({"error": "Session not found"}), 404

            return jsonify(session), 200

        except Exception as e:
            print(f"❌ Error getting session: {e}")
            return jsonify({"error": str(e)}), 500


# Integration example:
# In app.py:
#
#   from session_routes import setup_session_routes
#   setup_session_routes(app)
#

