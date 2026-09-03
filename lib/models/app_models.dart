import 'package:flutter/material.dart';

class ThemeColors {
  static const Color primary = Color(0xFF3525CD);
  static const Color primaryContainer = Color(0xFF4F46E5);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF00687A);
  static const Color secondaryContainer = Color(0xFF57DFFE);
  static const Color tertiary = Color(0xFF95002B);
  static const Color tertiaryContainer = Color(0xFFBF0F3C);
  static const Color surface = Color(0xFFFAF8FF);
  static const Color surfaceContainer = Color(0xFFEAEDFF);
  static const Color surfaceContainerLow = Color(0xFFF2F3FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerHighest = Color(0xFFDAE2FD);
  static const Color onSurface = Color(0xFF131B2E);
  static const Color onSurfaceVariant = Color(0xFF464555);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  static const Color outline = Color(0xFF777587);
}

class SpacedRepetitionItem {
  final String id;
  final String subject;
  final String topic;
  final String description;
  final String phase;
  final String duration;
  final int memoryScore;
  bool isCompleted;

  SpacedRepetitionItem({
    required this.id,
    required this.subject,
    required this.topic,
    required this.description,
    required this.phase,
    required this.duration,
    required this.memoryScore,
    this.isCompleted = false,
  });
}

class HomeworkItem {
  final String id;
  final String title;
  final String subject;
  final String deadline;
  final String detail;
  final int progress;
  final String priority;
  bool isCompleted;

  HomeworkItem({
    required this.id,
    required this.title,
    required this.subject,
    required this.deadline,
    required this.detail,
    required this.progress,
    required this.priority,
    this.isCompleted = false,
  });
}

class ExamEntry {
  final String title;
  final String date;
  final double turkishNet;
  final double mathNet;
  final double scienceNet;
  final double socialNet;
  final double totalNet;

  ExamEntry({
    required this.title,
    required this.date,
    required this.turkishNet,
    required this.mathNet,
    required this.scienceNet,
    required this.socialNet,
    required this.totalNet,
  });
}

class WrittenExam {
  final String subject;
  final String date;
  final String topics;
  final int targetScore;
  final int? actualScore;

  WrittenExam({
    required this.subject,
    required this.date,
    required this.topics,
    required this.targetScore,
    this.actualScore,
  });
}
