import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/database_service.dart';

class StudyProvider extends ChangeNotifier {
  List<SpacedRepetitionItem> _srItems = [];
  List<StudySession> _todaySessions = [];
  int? _activeSessionId;
  bool _isLoading = false;

  List<SpacedRepetitionItem> get srItems => _srItems;
  List<SpacedRepetitionItem> get dueItems =>
      _srItems.where((i) => i.isDueToday).toList();
  List<StudySession> get todaySessions => _todaySessions;
  int? get activeSessionId => _activeSessionId;
  bool get isLoading => _isLoading;

  int get todayStudyMinutes => _todaySessions
      .where((s) => s.completed)
      .fold(0, (sum, s) => sum + s.durationMinutes);

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();
    _srItems = await DatabaseService.getAllSRItems();
    _todaySessions = await DatabaseService.getTodaySessions();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addSRItem(SpacedRepetitionItem item) async {
    await DatabaseService.insertSpacedRepetitionItem(item);
    await loadAll();
  }

  Future<void> reviewItem(SpacedRepetitionItem item, int quality) async {
    final updated = item.copyWithNextReview(quality);
    await DatabaseService.updateSRItem(updated);
    await loadAll();
  }

  Future<void> deleteSRItem(int id) async {
    await DatabaseService.deleteSRItem(id);
    await loadAll();
  }

  Future<int> startStudySession(
      String subject, int durationMinutes, String mode) async {
    final session = StudySession(
      subject: subject,
      durationMinutes: durationMinutes,
      mode: mode,
      startTime: DateTime.now(),
    );
    final id = await DatabaseService.insertStudySession(session);
    _activeSessionId = id;
    notifyListeners();
    return id;
  }

  Future<void> completeStudySession() async {
    if (_activeSessionId != null) {
      await DatabaseService.completeStudySession(_activeSessionId!);
      _activeSessionId = null;
      await loadAll();
    }
  }

  void clearActiveSession() {
    _activeSessionId = null;
    notifyListeners();
  }
}
