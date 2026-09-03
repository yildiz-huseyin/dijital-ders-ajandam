import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/database_service.dart';

class SubjectProvider extends ChangeNotifier {
  List<Subject> _subjects = [];
  bool _isLoading = false;

  List<Subject> get subjects => _subjects;
  bool get isLoading => _isLoading;

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();
    _subjects = await DatabaseService.getAllSubjects();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTopic(int subjectId, String name) async {
    final topic = Topic(subjectId: subjectId, name: name);
    await DatabaseService.insertTopic(topic);
    await loadAll();
  }

  Future<void> toggleTopicCompletion(int topicId, bool isCompleted) async {
    await DatabaseService.updateTopicCompletion(topicId, isCompleted);
    await loadAll();
  }

  Future<void> deleteTopic(int topicId) async {
    await DatabaseService.deleteTopic(topicId);
    await loadAll();
  }
}
