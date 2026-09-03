import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/database_service.dart';

class ExamProvider extends ChangeNotifier {
  List<ExamEntry> _examEntries = [];
  List<WrittenExam> _writtenExams = [];
  bool _isLoading = false;

  List<ExamEntry> get examEntries => _examEntries;
  List<WrittenExam> get writtenExams => _writtenExams;
  bool get isLoading => _isLoading;

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();
    _examEntries = await DatabaseService.getAllExamEntries();
    _writtenExams = await DatabaseService.getAllWrittenExams();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExamEntry(ExamEntry entry) async {
    await DatabaseService.insertExamEntry(entry);
    await loadAll();
  }

  Future<void> deleteExamEntry(int id) async {
    await DatabaseService.deleteExamEntry(id);
    await loadAll();
  }

  Future<void> addWrittenExam(WrittenExam exam) async {
    await DatabaseService.insertWrittenExam(exam);
    await loadAll();
  }

  Future<void> updateWrittenExamScore(int id, double score) async {
    await DatabaseService.updateWrittenExamScore(id, score);
    await loadAll();
  }

  Future<void> deleteWrittenExam(int id) async {
    await DatabaseService.deleteWrittenExam(id);
    await loadAll();
  }
}
