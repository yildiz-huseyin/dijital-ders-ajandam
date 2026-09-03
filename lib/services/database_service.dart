import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/app_models.dart';

class DatabaseService {
  static Database? _db;
  static const _dbName = 'dijital_ders.db';
  static const _dbVersion = 1;

  static Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE homework(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        subject TEXT NOT NULL,
        description TEXT,
        dueDate TEXT NOT NULL,
        status INTEGER NOT NULL DEFAULT 0,
        priority INTEGER NOT NULL DEFAULT 1,
        createdAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE exam_entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        examType TEXT NOT NULL,
        examName TEXT NOT NULL,
        examDate TEXT NOT NULL,
        turkishCorrect INTEGER DEFAULT 0,
        turkishWrong INTEGER DEFAULT 0,
        mathCorrect INTEGER DEFAULT 0,
        mathWrong INTEGER DEFAULT 0,
        scienceCorrect INTEGER DEFAULT 0,
        scienceWrong INTEGER DEFAULT 0,
        socialCorrect INTEGER DEFAULT 0,
        socialWrong INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE written_exams(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject TEXT NOT NULL,
        examName TEXT NOT NULL,
        examDate TEXT NOT NULL,
        score REAL,
        targetScore REAL DEFAULT 90.0,
        notes TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE subjects(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        emoji TEXT NOT NULL,
        color INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE topics(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subjectId INTEGER NOT NULL,
        name TEXT NOT NULL,
        isCompleted INTEGER DEFAULT 0,
        reviewCount INTEGER DEFAULT 0,
        lastReviewed TEXT,
        nextReview TEXT,
        FOREIGN KEY (subjectId) REFERENCES subjects(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE study_sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject TEXT NOT NULL,
        durationMinutes INTEGER NOT NULL,
        mode TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT,
        completed INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE spaced_repetition(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topicName TEXT NOT NULL,
        subject TEXT NOT NULL,
        intervalDays INTEGER NOT NULL DEFAULT 1,
        addedDate TEXT NOT NULL,
        nextReviewDate TEXT NOT NULL,
        reviewCount INTEGER DEFAULT 0,
        easeFactor REAL DEFAULT 2.5
      )
    ''');
    // seed default subjects
    for (final s in kDefaultSubjects) {
      await db.insert('subjects', {
        'name': s['name'],
        'emoji': s['emoji'],
        'color': s['color'],
      });
    }
  }

  // HOMEWORK
  static Future<int> insertHomework(HomeworkItem item) async {
    final db = await database;
    final m = item.toMap()..remove('id');
    return db.insert('homework', m);
  }

  static Future<List<HomeworkItem>> getAllHomework() async {
    final db = await database;
    final rows = await db.query('homework', orderBy: 'dueDate ASC');
    return rows.map(HomeworkItem.fromMap).toList();
  }

  static Future<void> updateHomeworkStatus(int id, HomeworkStatus status) async {
    final db = await database;
    await db.update('homework', {'status': status.index},
        where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteHomework(int id) async {
    final db = await database;
    await db.delete('homework', where: 'id = ?', whereArgs: [id]);
  }

  // EXAM ENTRIES
  static Future<int> insertExamEntry(ExamEntry entry) async {
    final db = await database;
    final m = entry.toMap()..remove('id');
    return db.insert('exam_entries', m);
  }

  static Future<List<ExamEntry>> getAllExamEntries() async {
    final db = await database;
    final rows = await db.query('exam_entries', orderBy: 'examDate DESC');
    return rows.map(ExamEntry.fromMap).toList();
  }

  static Future<void> deleteExamEntry(int id) async {
    final db = await database;
    await db.delete('exam_entries', where: 'id = ?', whereArgs: [id]);
  }

  // WRITTEN EXAMS
  static Future<int> insertWrittenExam(WrittenExam exam) async {
    final db = await database;
    final m = exam.toMap()..remove('id');
    return db.insert('written_exams', m);
  }

  static Future<List<WrittenExam>> getAllWrittenExams() async {
    final db = await database;
    final rows = await db.query('written_exams', orderBy: 'examDate DESC');
    return rows.map(WrittenExam.fromMap).toList();
  }

  static Future<void> updateWrittenExamScore(int id, double score) async {
    final db = await database;
    await db.update('written_exams', {'score': score},
        where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteWrittenExam(int id) async {
    final db = await database;
    await db.delete('written_exams', where: 'id = ?', whereArgs: [id]);
  }

  // SUBJECTS + TOPICS
  static Future<List<Subject>> getAllSubjects() async {
    final db = await database;
    final sRows = await db.query('subjects', orderBy: 'name ASC');
    final subjects = <Subject>[];
    for (final sm in sRows) {
      final sid = sm['id'] as int;
      final tRows =
          await db.query('topics', where: 'subjectId = ?', whereArgs: [sid], orderBy: 'name ASC');
      subjects.add(Subject.fromMap(sm,
          topics: tRows.map(Topic.fromMap).toList()));
    }
    return subjects;
  }

  static Future<int> insertTopic(Topic topic) async {
    final db = await database;
    final m = topic.toMap()..remove('id');
    return db.insert('topics', m);
  }

  static Future<void> updateTopicCompletion(int id, bool isCompleted) async {
    final db = await database;
    await db.update('topics', {'isCompleted': isCompleted ? 1 : 0},
        where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteTopic(int id) async {
    final db = await database;
    await db.delete('topics', where: 'id = ?', whereArgs: [id]);
  }

  // STUDY SESSIONS
  static Future<int> insertStudySession(StudySession session) async {
    final db = await database;
    final m = session.toMap()..remove('id');
    return db.insert('study_sessions', m);
  }

  static Future<void> completeStudySession(int id) async {
    final db = await database;
    await db.update(
        'study_sessions',
        {'completed': 1, 'endTime': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [id]);
  }

  static Future<List<StudySession>> getTodaySessions() async {
    final db = await database;
    final now = DateTime.now();
    final todayStr = DateTime(now.year, now.month, now.day).toIso8601String();
    final tomorrowStr =
        DateTime(now.year, now.month, now.day + 1).toIso8601String();
    final rows = await db.query('study_sessions',
        where: 'startTime >= ? AND startTime < ?',
        whereArgs: [todayStr, tomorrowStr]);
    return rows.map(StudySession.fromMap).toList();
  }

  static Future<int> getTodayStudyMinutes() async {
    final sessions = await getTodaySessions();
    return sessions
        .where((s) => s.completed)
        .fold(0, (sum, s) => sum + s.durationMinutes);
  }

  // SPACED REPETITION
  static Future<int> insertSpacedRepetitionItem(
      SpacedRepetitionItem item) async {
    final db = await database;
    final m = item.toMap()..remove('id');
    return db.insert('spaced_repetition', m);
  }

  static Future<List<SpacedRepetitionItem>> getAllSRItems() async {
    final db = await database;
    final rows = await db.query('spaced_repetition',
        orderBy: 'nextReviewDate ASC');
    return rows.map(SpacedRepetitionItem.fromMap).toList();
  }

  static Future<void> updateSRItem(SpacedRepetitionItem item) async {
    final db = await database;
    await db.update('spaced_repetition', item.toMap(),
        where: 'id = ?', whereArgs: [item.id]);
  }

  static Future<void> deleteSRItem(int id) async {
    final db = await database;
    await db.delete('spaced_repetition', where: 'id = ?', whereArgs: [id]);
  }

  // DASHBOARD
  static Future<Map<String, dynamic>> getDashboardStats() async {
    final db = await database;
    final pendingHw = await db.query('homework',
        where: 'status != ?', whereArgs: [HomeworkStatus.completed.index]);
    final studyMins = await getTodayStudyMinutes();
    final allSR = await getAllSRItems();
    final dueCount = allSR.where((i) => i.isDueToday).length;
    // streak
    int streak = 0;
    final today = DateTime.now();
    for (int i = 0; i < 60; i++) {
      final d = today.subtract(Duration(days: i));
      final dStr = DateTime(d.year, d.month, d.day).toIso8601String();
      final nStr = DateTime(d.year, d.month, d.day + 1).toIso8601String();
      final rows = await db.query('study_sessions',
          where: 'startTime >= ? AND startTime < ? AND completed = 1',
          whereArgs: [dStr, nStr]);
      if (rows.isNotEmpty) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }
    return {
      'pendingHomework': pendingHw.length,
      'studyMinutesToday': studyMins,
      'dueReviewItems': dueCount,
      'streak': streak,
    };
  }
}
