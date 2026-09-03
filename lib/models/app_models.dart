import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1565C0);
  static const Color secondary = Color(0xFF42A5F5);
  static const Color surface = Color(0xFFF5F7FF);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFE65100);
  static const Color error = Color(0xFFC62828);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A237E);
  static const Color textSecondary = Color(0xFF546E7A);
}

enum HomeworkStatus { pending, inProgress, completed }
enum HomeworkPriority { low, medium, high }

class HomeworkItem {
  final int? id;
  final String title;
  final String subject;
  final String? description;
  final DateTime dueDate;
  final HomeworkStatus status;
  final HomeworkPriority priority;
  final DateTime createdAt;

  HomeworkItem({
    this.id,
    required this.title,
    required this.subject,
    this.description,
    required this.dueDate,
    this.status = HomeworkStatus.pending,
    this.priority = HomeworkPriority.medium,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  HomeworkItem copyWith({
    int? id,
    String? title,
    String? subject,
    String? description,
    DateTime? dueDate,
    HomeworkStatus? status,
    HomeworkPriority? priority,
  }) =>
      HomeworkItem(
        id: id ?? this.id,
        title: title ?? this.title,
        subject: subject ?? this.subject,
        description: description ?? this.description,
        dueDate: dueDate ?? this.dueDate,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        createdAt: createdAt,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'subject': subject,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'status': status.index,
        'priority': priority.index,
        'createdAt': createdAt.toIso8601String(),
      };

  factory HomeworkItem.fromMap(Map<String, dynamic> map) => HomeworkItem(
        id: map['id'] as int?,
        title: map['title'] as String,
        subject: map['subject'] as String,
        description: map['description'] as String?,
        dueDate: DateTime.parse(map['dueDate'] as String),
        status: HomeworkStatus.values[map['status'] as int],
        priority: HomeworkPriority.values[map['priority'] as int],
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}

class ExamEntry {
  final int? id;
  final String examType;
  final String examName;
  final DateTime examDate;
  final int turkishCorrect;
  final int turkishWrong;
  final int mathCorrect;
  final int mathWrong;
  final int scienceCorrect;
  final int scienceWrong;
  final int socialCorrect;
  final int socialWrong;

  ExamEntry({
    this.id,
    required this.examType,
    required this.examName,
    required this.examDate,
    this.turkishCorrect = 0,
    this.turkishWrong = 0,
    this.mathCorrect = 0,
    this.mathWrong = 0,
    this.scienceCorrect = 0,
    this.scienceWrong = 0,
    this.socialCorrect = 0,
    this.socialWrong = 0,
  });

  double get net =>
      (turkishCorrect + mathCorrect + scienceCorrect + socialCorrect) -
      ((turkishWrong + mathWrong + scienceWrong + socialWrong) * 0.25);
  double get turkishNet => turkishCorrect - (turkishWrong * 0.25);
  double get mathNet => mathCorrect - (mathWrong * 0.25);
  double get scienceNet => scienceCorrect - (scienceWrong * 0.25);
  double get socialNet => socialCorrect - (socialWrong * 0.25);

  Map<String, dynamic> toMap() => {
        'id': id,
        'examType': examType,
        'examName': examName,
        'examDate': examDate.toIso8601String(),
        'turkishCorrect': turkishCorrect,
        'turkishWrong': turkishWrong,
        'mathCorrect': mathCorrect,
        'mathWrong': mathWrong,
        'scienceCorrect': scienceCorrect,
        'scienceWrong': scienceWrong,
        'socialCorrect': socialCorrect,
        'socialWrong': socialWrong,
      };

  factory ExamEntry.fromMap(Map<String, dynamic> map) => ExamEntry(
        id: map['id'] as int?,
        examType: map['examType'] as String,
        examName: map['examName'] as String,
        examDate: DateTime.parse(map['examDate'] as String),
        turkishCorrect: map['turkishCorrect'] as int,
        turkishWrong: map['turkishWrong'] as int,
        mathCorrect: map['mathCorrect'] as int,
        mathWrong: map['mathWrong'] as int,
        scienceCorrect: map['scienceCorrect'] as int,
        scienceWrong: map['scienceWrong'] as int,
        socialCorrect: map['socialCorrect'] as int,
        socialWrong: map['socialWrong'] as int,
      );
}

class WrittenExam {
  final int? id;
  final String subject;
  final String examName;
  final DateTime examDate;
  final double? score;
  final double targetScore;
  final String? notes;

  WrittenExam({
    this.id,
    required this.subject,
    required this.examName,
    required this.examDate,
    this.score,
    this.targetScore = 90.0,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'subject': subject,
        'examName': examName,
        'examDate': examDate.toIso8601String(),
        'score': score,
        'targetScore': targetScore,
        'notes': notes,
      };

  factory WrittenExam.fromMap(Map<String, dynamic> map) => WrittenExam(
        id: map['id'] as int?,
        subject: map['subject'] as String,
        examName: map['examName'] as String,
        examDate: DateTime.parse(map['examDate'] as String),
        score: map['score'] as double?,
        targetScore: (map['targetScore'] as num).toDouble(),
        notes: map['notes'] as String?,
      );
}

class Subject {
  final int? id;
  final String name;
  final String emoji;
  final Color color;
  final List<Topic> topics;

  Subject({
    this.id,
    required this.name,
    required this.emoji,
    required this.color,
    this.topics = const [],
  });

  double get completionRate {
    if (topics.isEmpty) return 0.0;
    return topics.where((t) => t.isCompleted).length / topics.length;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'color': color.value,
      };

  factory Subject.fromMap(Map<String, dynamic> map,
          {List<Topic> topics = const []}) =>
      Subject(
        id: map['id'] as int?,
        name: map['name'] as String,
        emoji: map['emoji'] as String,
        color: Color(map['color'] as int),
        topics: topics,
      );
}

class Topic {
  final int? id;
  final int subjectId;
  final String name;
  final bool isCompleted;
  final int reviewCount;
  final DateTime? lastReviewed;
  final DateTime? nextReview;

  Topic({
    this.id,
    required this.subjectId,
    required this.name,
    this.isCompleted = false,
    this.reviewCount = 0,
    this.lastReviewed,
    this.nextReview,
  });

  Topic copyWith({
    bool? isCompleted,
    int? reviewCount,
    DateTime? lastReviewed,
    DateTime? nextReview,
  }) =>
      Topic(
        id: id,
        subjectId: subjectId,
        name: name,
        isCompleted: isCompleted ?? this.isCompleted,
        reviewCount: reviewCount ?? this.reviewCount,
        lastReviewed: lastReviewed ?? this.lastReviewed,
        nextReview: nextReview ?? this.nextReview,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'subjectId': subjectId,
        'name': name,
        'isCompleted': isCompleted ? 1 : 0,
        'reviewCount': reviewCount,
        'lastReviewed': lastReviewed?.toIso8601String(),
        'nextReview': nextReview?.toIso8601String(),
      };

  factory Topic.fromMap(Map<String, dynamic> map) => Topic(
        id: map['id'] as int?,
        subjectId: map['subjectId'] as int,
        name: map['name'] as String,
        isCompleted: (map['isCompleted'] as int) == 1,
        reviewCount: map['reviewCount'] as int,
        lastReviewed: map['lastReviewed'] != null
            ? DateTime.parse(map['lastReviewed'] as String)
            : null,
        nextReview: map['nextReview'] != null
            ? DateTime.parse(map['nextReview'] as String)
            : null,
      );
}

class StudySession {
  final int? id;
  final String subject;
  final int durationMinutes;
  final String mode;
  final DateTime startTime;
  final DateTime? endTime;
  final bool completed;

  StudySession({
    this.id,
    required this.subject,
    required this.durationMinutes,
    required this.mode,
    required this.startTime,
    this.endTime,
    this.completed = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'subject': subject,
        'durationMinutes': durationMinutes,
        'mode': mode,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'completed': completed ? 1 : 0,
      };

  factory StudySession.fromMap(Map<String, dynamic> map) => StudySession(
        id: map['id'] as int?,
        subject: map['subject'] as String,
        durationMinutes: map['durationMinutes'] as int,
        mode: map['mode'] as String,
        startTime: DateTime.parse(map['startTime'] as String),
        endTime: map['endTime'] != null
            ? DateTime.parse(map['endTime'] as String)
            : null,
        completed: (map['completed'] as int) == 1,
      );
}

class SpacedRepetitionItem {
  final int? id;
  final String topicName;
  final String subject;
  final int intervalDays;
  final DateTime addedDate;
  final DateTime nextReviewDate;
  final int reviewCount;
  final double easeFactor;

  SpacedRepetitionItem({
    this.id,
    required this.topicName,
    required this.subject,
    required this.intervalDays,
    required this.addedDate,
    required this.nextReviewDate,
    this.reviewCount = 0,
    this.easeFactor = 2.5,
  });

  bool get isDueToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final rd = DateTime(
        nextReviewDate.year, nextReviewDate.month, nextReviewDate.day);
    return rd.compareTo(today) <= 0;
  }

  SpacedRepetitionItem copyWithNextReview(int quality) {
    double newEase =
        easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    if (newEase < 1.3) newEase = 1.3;
    int newInterval;
    if (quality < 3) {
      newInterval = 1;
    } else if (reviewCount == 0) {
      newInterval = 1;
    } else if (reviewCount == 1) {
      newInterval = 3;
    } else {
      newInterval = (intervalDays * newEase).round();
    }
    return SpacedRepetitionItem(
      id: id,
      topicName: topicName,
      subject: subject,
      intervalDays: newInterval,
      addedDate: addedDate,
      nextReviewDate: DateTime.now().add(Duration(days: newInterval)),
      reviewCount: reviewCount + 1,
      easeFactor: newEase,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'topicName': topicName,
        'subject': subject,
        'intervalDays': intervalDays,
        'addedDate': addedDate.toIso8601String(),
        'nextReviewDate': nextReviewDate.toIso8601String(),
        'reviewCount': reviewCount,
        'easeFactor': easeFactor,
      };

  factory SpacedRepetitionItem.fromMap(Map<String, dynamic> map) =>
      SpacedRepetitionItem(
        id: map['id'] as int?,
        topicName: map['topicName'] as String,
        subject: map['subject'] as String,
        intervalDays: map['intervalDays'] as int,
        addedDate: DateTime.parse(map['addedDate'] as String),
        nextReviewDate: DateTime.parse(map['nextReviewDate'] as String),
        reviewCount: map['reviewCount'] as int,
        easeFactor: (map['easeFactor'] as num).toDouble(),
      );
}

final List<Map<String, dynamic>> kDefaultSubjects = [
  {'name': 'Matematik', 'emoji': '📐', 'color': 0xFF1565C0},
  {'name': 'Türkçe', 'emoji': '📖', 'color': 0xFF6A1B9A},
  {'name': 'Fizik', 'emoji': '⚡', 'color': 0xFF0277BD},
  {'name': 'Kimya', 'emoji': '🧪', 'color': 0xFF00695C},
  {'name': 'Biyoloji', 'emoji': '🧬', 'color': 0xFF2E7D32},
  {'name': 'Tarih', 'emoji': '🏛️', 'color': 0xFF4E342E},
  {'name': 'Coğrafya', 'emoji': '🌍', 'color': 0xFF00838F},
  {'name': 'Felsefe', 'emoji': '💭', 'color': 0xFF37474F},
  {'name': 'İngilizce', 'emoji': '🌐', 'color': 0xFF283593},
  {'name': 'Din Kültürü', 'emoji': '☪️', 'color': 0xFF558B2F},
];
