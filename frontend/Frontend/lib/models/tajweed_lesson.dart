import 'package:flutter/material.dart';

class TajweedLesson {
  final String id;
  final String category; // 'tajweed' | 'islamic'
  final String title;
  final String arabicTitle;
  final String description;
  final String icon;
  final Color color;
  final String duration;
  final List<LessonSection> sections;
  final List<QuizQuestion> questions;

  const TajweedLesson({
    required this.id,
    required this.category,
    required this.title,
    required this.arabicTitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.duration,
    required this.sections,
    required this.questions,
  });
}

class LessonSection {
  final String title;
  final String explanation;
  final String arabicExample;
  final String transliteration;
  final String howToLearn;
  final String commonMistake;
  final String tip;
  final int exampleSurah;
  final int exampleAyah;
  final bool showWordByWord;

  const LessonSection({
    required this.title,
    required this.explanation,
    required this.arabicExample,
    required this.transliteration,
    required this.howToLearn,
    required this.commonMistake,
    required this.tip,
    required this.exampleSurah,
    required this.exampleAyah,
    this.showWordByWord = false,
  });
}

class QuizQuestion {
  final String question;
  final String? arabicText;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    this.arabicText,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}
