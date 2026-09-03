import 'dart:async';
import 'package:flutter/material.dart';
import '../models/app_models.dart';

class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({super.key});

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> {
  int _secondsRemaining = 25 * 60;
  bool _isActive = false;
  Timer? _timer;
  String _selectedMode = 'Pomodoro (25 dk)';
  String _selectedSubject = 'Matematik';

  void _startPauseTimer() {
    if (_isActive) {
      _timer?.cancel();
      setState(() => _isActive = false);
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          _timer?.cancel();
          setState(() => _isActive = false);
        }
      });
      setState(() => _isActive = true);
    }
  }

  void _resetTimer(int minutes) {
    _timer?.cancel();
    setState(() {
      _isActive = false;
      _secondsRemaining = minutes * 60;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timeString {
    final m = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return m + ':' + s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.surface,
      appBar: AppBar(
        backgroundColor: ThemeColors.surface,
        elevation: 0,
        title: const Text('Ders Çalışma & Odak Seansı', style: TextStyle(color: ThemeColors.onSurface, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ThemeColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildModeBtn('Pomodoro (25 dk)', 25),
                const SizedBox(width: 8),
                _buildModeBtn('Kısa Mola (5 dk)', 5),
                const SizedBox(width: 8),
                _buildModeBtn('Derin Odak (50 dk)', 50),
              ],
            ),
            const SizedBox(height: 36),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ThemeColors.surfaceContainerLowest,
                boxShadow: [
                  BoxShadow(
                    color: ThemeColors.primary.withOpacity(0.12),
                    blurRadius: 30,
                    spreadRadius: 4,
                  )
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      value: _secondsRemaining / (25 * 60),
                      strokeWidth: 8,
                      backgroundColor: ThemeColors.surfaceContainer,
                      valueColor: const AlwaysStoppedAnimation<Color>(ThemeColors.primary),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _timeString,
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: ThemeColors.onSurface, letterSpacing: -1),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedSubject,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ThemeColors.primary),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Odaklanma Seansı',
                        style: TextStyle(fontSize: 11, color: ThemeColors.onSurfaceVariant),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: () => _resetTimer(25),
                  icon: const Icon(Icons.refresh),
                  iconSize: 28,
                  style: IconButton.styleFrom(
                    backgroundColor: ThemeColors.surfaceContainer,
                    foregroundColor: ThemeColors.onSurfaceVariant,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _startPauseTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.primary,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(24),
                    elevation: 6,
                  ),
                  child: Icon(_isActive ? Icons.pause : Icons.play_arrow, size: 36),
                ),
                const SizedBox(width: 20),
                IconButton.filledTonal(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Seans başarıyla kaydedildi! +25 dk')),
                    );
                  },
                  icon: const Icon(Icons.check),
                  iconSize: 28,
                  style: IconButton.styleFrom(
                    backgroundColor: ThemeColors.surfaceContainer,
                    foregroundColor: ThemeColors.secondary,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.headphones, color: ThemeColors.primary, size: 20),
                          SizedBox(width: 8),
                          Text('Arka Plan Odak Sesi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      DropdownButton<String>(
                        value: 'Yağmur & Fırtına',
                        underline: const SizedBox(),
                        items: ['Sessiz', 'Yağmur & Fırtına', 'Beyaz Gürültü', 'Kütüphane'].map((s) {
                          return DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12)));
                        }).toList(),
                        onChanged: (_) {},
                      )
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.menu_book, color: ThemeColors.secondary, size: 20),
                          SizedBox(width: 8),
                          Text('Çalışılan Ders', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      DropdownButton<String>(
                        value: _selectedSubject,
                        underline: const SizedBox(),
                        items: ['Matematik', 'Fizik', 'Kimya', 'Biyoloji', 'Geometri', 'Edebiyat'].map((s) {
                          return DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12)));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedSubject = val);
                        },
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildModeBtn(String title, int minutes) {
    final selected = _selectedMode == title;
    return InkWell(
      onTap: () {
        setState(() => _selectedMode = title);
        _resetTimer(minutes);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? ThemeColors.primary : ThemeColors.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : ThemeColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
