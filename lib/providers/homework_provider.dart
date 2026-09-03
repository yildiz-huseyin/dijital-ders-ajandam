import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/database_service.dart';

class HomeworkProvider extends ChangeNotifier {
  List<HomeworkItem> _items = [];
  bool _isLoading = false;

  List<HomeworkItem> get items => _items;
  bool get isLoading => _isLoading;
  List<HomeworkItem> get pendingItems =>
      _items.where((i) => i.status == HomeworkStatus.pending).toList();
  List<HomeworkItem> get inProgressItems =>
      _items.where((i) => i.status == HomeworkStatus.inProgress).toList();
  List<HomeworkItem> get completedItems =>
      _items.where((i) => i.status == HomeworkStatus.completed).toList();

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();
    _items = await DatabaseService.getAllHomework();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addHomework(HomeworkItem item) async {
    await DatabaseService.insertHomework(item);
    await loadAll();
  }

  Future<void> updateStatus(int id, HomeworkStatus status) async {
    await DatabaseService.updateHomeworkStatus(id, status);
    await loadAll();
  }

  Future<void> deleteHomework(int id) async {
    await DatabaseService.deleteHomework(id);
    await loadAll();
  }
}
