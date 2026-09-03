import 'package:flutter/material.dart';
import '../models/app_models.dart';

class WrittenExamScreen extends StatefulWidget {
  const WrittenExamScreen({super.key});

  @override
  State<WrittenExamScreen> createState() => _WrittenExamScreenState();
}

class _WrittenExamScreenState extends State<WrittenExamScreen> {
  final _subjectController = TextEditingController(text: 'Matematik 1. Dönem 1. Yazılı');
  final _dateController = TextEditingController(text: '22 Kasım 2026');
  final _topicController = TextEditingController(text: 'Fonksiyonlar, Polinomlar, İkinci Dereceden Denklemler');
  final _targetScoreController = TextEditingController(text: '90');

  String _selectedDifficulty = 'Orta';
  bool _enableReminder = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.surface,
      appBar: AppBar(
        backgroundColor: ThemeColors.surface,
        elevation: 0,
        title: const Text('Yazılı Sınavı Ekle', style: TextStyle(color: ThemeColors.onSurface, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ThemeColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Ders ve Sınav Adı',
                      hintText: 'Örn: Fizik 1. Yazılı',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school, color: ThemeColors.primary),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Sınav Tarihi',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.event, color: ThemeColors.secondary),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _targetScoreController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Hedef Not (100 üzerinden)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.star, color: Colors.amber),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _topicController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Dahil Olan Konular',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Beklenen Zorluk', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ThemeColors.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Row(
                    children: ['Kolay', 'Orta', 'Zor', 'Çok Zor'].map((diff) {
                      final selected = _selectedDifficulty == diff;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(diff),
                          selected: selected,
                          onSelected: (val) {
                            setState(() => _selectedDifficulty = diff);
                          },
                          selectedColor: ThemeColors.primary.withOpacity(0.15),
                          labelStyle: TextStyle(
                            color: selected ? ThemeColors.primary : ThemeColors.onSurfaceVariant,
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  SwitchListTile(
                    value: _enableReminder,
                    onChanged: (val) => setState(() => _enableReminder = val),
                    title: const Text('Akıllı Tekrar Hatırlatıcısı', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Sınavdan 7, 3 ve 1 gün önce bildirim gönder', style: TextStyle(fontSize: 12)),
                    activeColor: ThemeColors.primary,
                    contentPadding: EdgeInsets.zero,
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Yazılı sınav takvime eklendi ve hatırlatıcılar kuruldu!'),
                      backgroundColor: Colors.teal,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add_task),
                label: const Text('Yazılı Sınavı Ajandaya Ekle', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
