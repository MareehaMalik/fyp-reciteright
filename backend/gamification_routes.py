# -*- coding: utf-8 -*-
"""
Example Integration of Gamification Endpoints into Flask App
Add these routes to your existing app.py to enable gamification features
"""

from flask import Flask, request, jsonify
from gamification_service import get_gamification_service
from gamification_logic import (
    get_utc_today_date,
    get_week_start_date,
    get_today_progress,
    get_week_summary,
    get_current_streak,
    get_level_from_xp,
    calculate_xp_for_session,
    update_memorization_after_session,
    LEVEL_TITLES,
)
from gamification_models import Session
from database import get_database
import json
import uuid
from datetime import datetime


def setup_gamification_routes(app: Flask):
    """Setup all gamification routes on the Flask app"""

    service = get_gamification_service()

    # ════════════════════════════════════════════════════════════════════════════════
    # PRIMARY ENDPOINT: Aggregated home screen metrics
    # ════════════════════════════════════════════════════════════════════════════════

    @app.route("/api/gamification/home-metrics", methods=["GET"])
    def get_home_metrics():
        """
        GET /api/gamification/home-metrics?userId=USER_ID

        Returns aggregated metrics for home screen in single call
        """
        try:
            user_id = request.args.get("userId")
            if not user_id:
                return jsonify({"error": "userId required"}), 400

            db = get_database()

            # Get or create user profile
            user_profile = service.get_or_create_user(user_id)

            today_date = get_utc_today_date(timezone_offset_minutes=user_profile.get("timezone_offset", 0))
            metrics = service.get_home_metrics(user_id, user_profile, today_date)

            return jsonify(metrics.to_dict()), 200

        except Exception as e:
            print(f"❌ Error in get_home_metrics: {e}")
            import traceback
            traceback.print_exc()
            return jsonify({"error": str(e)}), 500


    # ════════════════════════════════════════════════════════════════════════════════
    # POST SESSION: Record new session after recitation
    # ════════════════════════════════════════════════════════════════════════════════

    @app.route("/api/gamification/session", methods=["POST"])
    def record_session():
        """
        POST /api/gamification/session

        Body:
        {
            "userId": str,
            "surah": int,
            "startAyah": int,
            "endAyah": int,
            "durationMinutes": float,
            "accuracyScore": float (0-100),
            "mode": str ("recitation" | "tajweed_lesson" | "review")
        }

        Returns:
        {
            "success": bool,
            "sessionId": str,
            "xpEarned": int,
            "levelUp": bool,
            "newLevel": int,
            "totalXp": int,
            "message": str
        }
        """
        try:
            data = request.get_json()
            user_id = data.get("userId")

            if not user_id:
                return jsonify({"error": "userId required"}), 400

            db = get_database()

            # Get or create user
            user_profile = service.get_or_create_user(user_id)

            # Create session object
            session_id = str(uuid.uuid4())
            today_date = get_utc_today_date(timezone_offset_minutes=user_profile.get("timezone_offset", 0))

            session_data = {
                "id": session_id,
                "user_id": user_id,
                "surah": int(data.get("surah")),
                "start_ayah": int(data.get("startAyah")),
                "end_ayah": int(data.get("endAyah")),
                "duration_minutes": float(data.get("durationMinutes", 0)),
                "date": today_date,
                "accuracy_score": float(data.get("accuracyScore", 0)),
                "mode": data.get("mode", "recitation"),
                "created_at": datetime.utcnow().isoformat() + "Z",
                "xp_earned": 0
            }

            session_obj = Session(**session_data)

            # Check if daily goal was met
            daily_goal_minutes = user_profile.get("daily_goal_minutes", 10)
            daily_sessions = db.get_sessions_by_date(user_id, today_date)
            total_minutes_today = sum(s.get("duration_minutes", 0) for s in daily_sessions) + session_data["duration_minutes"]
            daily_goal_met = total_minutes_today >= daily_goal_minutes

            # Calculate XP
            xp_earned = calculate_xp_for_session(session_obj, daily_goal_met)
            session_data["xp_earned"] = xp_earned

            # Add session to database
            service.add_session(user_id, session_data)

            # Update user XP
            old_xp = user_profile.get("xp", 0)
            updated_user = db.update_user_xp(user_id, xp_earned)
            new_xp = updated_user.get("xp", 0)

            # Check for level up
            old_level_info = get_level_from_xp(old_xp)
            new_level_info = get_level_from_xp(new_xp)
            level_up = new_level_info.level_number > old_level_info.level_number

            # Update memorization progress
            memo_progress = db.get_memorization_progress(user_id)
            updated_memo = update_memorization_after_session(session_obj, memo_progress)
            db.save_memorization_progress(user_id, updated_memo)

            # Update streak info
            if level_up:
                db.update_user_longest_streak(user_id, new_level_info.level_number)

            return jsonify({
                "success": True,
                "sessionId": session_id,
                "xpEarned": xp_earned,
                "levelUp": level_up,
                "newLevel": new_level_info.level_number,
                "totalXp": new_xp,
                "message": f"Session recorded! +{xp_earned} XP earned" + (" 🎉 Level Up!" if level_up else "")
            }), 201

        except Exception as e:
            print(f"❌ Error recording session: {e}")
            import traceback
            traceback.print_exc()
            return jsonify({"error": str(e)}), 500


    # ════════════════════════════════════════════════════════════════════════════════
    # DAILY PROGRESS
    # ════════════════════════════════════════════════════════════════════════════════

    @app.route("/api/gamification/daily-progress", methods=["GET"])
    def get_daily_progress():
        """
        GET /api/gamification/daily-progress?userId=USER_ID&date=YYYY-MM-DD

        Returns daily progress metrics
        """
        try:
            user_id = request.args.get("userId")
            date_str = request.args.get("date")
            daily_goal = int(request.args.get("dailyGoal", 10))

            if not user_id or not date_str:
                return jsonify({"error": "userId and date required"}), 400

            sessions = service.get_user_sessions(user_id)
            daily = get_today_progress(sessions, date_str, daily_goal)

            return jsonify(daily), 200

        except Exception as e:
            print(f"❌ Error getting daily progress: {e}")
            import traceback
            traceback.print_exc()
            return jsonify({"error": str(e)}), 500


    # ════════════════════════════════════════════════════════════════════════════════
    # WEEK SUMMARY
    # ════════════════════════════════════════════════════════════════════════════════

    @app.route("/api/gamification/week-summary", methods=["GET"])
    def get_week_summary():
        """
        GET /api/gamification/week-summary?userId=USER_ID&weekStart=YYYY-MM-DD

        Returns weekly progress metrics
        """
        try:
            user_id = request.args.get("userId")
            week_start = request.args.get("weekStart")

            if not user_id or not week_start:
                return jsonify({"error": "userId and weekStart required"}), 400

            sessions = service.get_user_sessions(user_id)
            week = get_week_summary(sessions, week_start)

            return jsonify(week), 200

        except Exception as e:
            print(f"❌ Error getting week summary: {e}")
            import traceback
            traceback.print_exc()
            return jsonify({"error": str(e)}), 500


    # ════════════════════════════════════════════════════════════════════════════════
    # STREAK
    # ════════════════════════════════════════════════════════════════════════════════

    @app.route("/api/gamification/streak", methods=["GET"])
    def get_streak():
        """
        GET /api/gamification/streak?userId=USER_ID

        Returns streak information
        """
        try:
            user_id = request.args.get("userId")
            if not user_id:
                return jsonify({"error": "userId required"}), 400

            db = get_database()
            user_profile = service.get_or_create_user(user_id)

            sessions = service.get_user_sessions(user_id)
            today_date = get_utc_today_date(timezone_offset_minutes=user_profile.get("timezone_offset", 0))

            streak_info = get_current_streak(sessions, today_date, user_profile.get("longest_streak", 0))

            return jsonify(streak_info.to_dict()), 200

        except Exception as e:
            print(f"❌ Error getting streak: {e}")
            import traceback
            traceback.print_exc()
            return jsonify({"error": str(e)}), 500


    # ════════════════════════════════════════════════════════════════════════════════
    # LEVEL INFO
    # ════════════════════════════════════════════════════════════════════════════════

    @app.route("/api/gamification/level", methods=["GET"])
    def get_level():
        """
        GET /api/gamification/level?userId=USER_ID

        Returns level and XP information
        """
        try:
            user_id = request.args.get("userId")
            if not user_id:
                return jsonify({"error": "userId required"}), 400

            db = get_database()
            user_profile = service.get_or_create_user(user_id)

            # Get XP from user profile
            total_xp = user_profile.get("xp", 0)

            level_info = get_level_from_xp(total_xp)

            return jsonify({
                **level_info.to_dict(),
                "levelTitle": LEVEL_TITLES.get(level_info.level_number, "Scholar")
            }), 200

        except Exception as e:
            print(f"❌ Error getting level: {e}")
            import traceback
            traceback.print_exc()
            return jsonify({"error": str(e)}), 500


    # ════════════════════════════════════════════════════════════════════════════════
    # MEMORIZATION PROGRESS
    # ════════════════════════════════════════════════════════════════════════════════

    @app.route("/api/gamification/memorization", methods=["GET"])
    def get_memorization():
        """
        GET /api/gamification/memorization?userId=USER_ID

        Returns memorization progress
        """
        try:
            user_id = request.args.get("userId")
            if not user_id:
                return jsonify({"error": "userId required"}), 400

            db = get_database()
            memo_progress = db.get_memorization_progress(user_id)

            from gamification_logic import (
                get_overall_memorization_percent,
                get_top_surahs
            )

            overall = get_overall_memorization_percent(memo_progress)
            top_surahs = get_top_surahs(memo_progress)

            return jsonify({
                "overallPercent": overall,
                "topSurahs": top_surahs
            }), 200

        except Exception as e:
            print(f"❌ Error getting memorization: {e}")
            import traceback
            traceback.print_exc()
            return jsonify({"error": str(e)}), 500


    # ════════════════════════════════════════════════════════════════════════════════
    # UPDATE DAILY GOAL
    # ════════════════════════════════════════════════════════════════════════════════

    @app.route("/api/gamification/daily-goal", methods=["PUT"])
    def update_daily_goal():
        """
        PUT /api/gamification/daily-goal

        Body:
        {
            "userId": str,
            "dailyGoalMinutes": int
        }
        """
        try:
            data = request.get_json()
            user_id = data.get("userId")
            new_goal = data.get("dailyGoalMinutes", 10)

            if not user_id:
                return jsonify({"error": "userId required"}), 400

            db = get_database()
            user = db.get_user(user_id)

            if not user:
                user = db.create_user(user_id, f"User {user_id[:8]}", f"{user_id}@example.com", new_goal)
            else:
                user["daily_goal_minutes"] = new_goal
                db.save_user(user_id, user)

            return jsonify({
                "success": True,
                "dailyGoalMinutes": new_goal
            }), 200

        except Exception as e:
            print(f"❌ Error updating daily goal: {e}")
            import traceback
            traceback.print_exc()
            return jsonify({"error": str(e)}), 500


# ════════════════════════════════════════════════════════════════════════════════
# INTEGRATION EXAMPLE
# ════════════════════════════════════════════════════════════════════════════════
#
# In your main app.py after creating Flask app:
#
#   app = Flask(__name__)
#   CORS(app)
#
#   # ... existing routes ...
#
#   # Setup gamification routes
#   from gamification_routes import setup_gamification_routes
#   setup_gamification_routes(app)
#
#   if __name__ == "__main__":
#       app.run(debug=True, port=8000, host="0.0.0.0")
#
# ════════════════════════════════════════════════════════════════════════════════

