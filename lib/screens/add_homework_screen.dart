import 'package:flutter/material.dart';
import '../models/app_models.dart';

class AddHomeworkScreen extends StatefulWidget {
  const AddHomeworkScreen({super.key});

  @override
  State<AddHomeworkScreen> createState() => _AddHomeworkScreenState();
}

class _AddHomeworkScreenState extends State<AddHomeworkScreen> {
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  final _deadlineController = TextEditingController(text: 'Yarın 18:00');
  String _selectedSubject = 'Matematik';
  String _priority = 'Normal';

  final List<String> _subjects = [
    'Matematik',
    'Geometri',
    'Fizik',
    'Kimya',
    'Biyoloji',
    'Türkçe & Edebiyat',
    'Tarih',
    'Coğrafya',
    'İngilizce'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.surface,
      appBar: AppBar(
        backgroundColor: ThemeColors.surface,
        elevation: 0,
        title: const Text('Yeni Ödev Ekle', style: TextStyle(color: ThemeColors.onSurface, fontWeight: FontWeight.bold)),
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
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ders', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ThemeColors.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedSubject,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedSubject = val);
                    },
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Ödev / Görev Başlığı',
                      hintText: 'Örn: Sayfa 120-125 Test 3 ve 4',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.assignment_outlined, color: ThemeColors.primary),
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _deadlineController,
                    decoration: const InputDecoration(
                      labelText: 'Teslim Tarihi & Saati',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.alarm, color: ThemeColors.secondary),
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _detailController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Ödev Detayı & Öğretmen Notu',
                      hintText: 'Çözümler deftere yapılacak, grafikler çizilecek...',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('Öncelik Seviyesi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ThemeColors.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Row(
                    children: ['Düşük', 'Normal', 'Acil 🔥'].map((p) {
                      final selected = _priority == p;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(p),
                          selected: selected,
                          onSelected: (_) => setState(() => _priority = p),
                          selectedColor: p.contains('Acil') ? ThemeColors.errorContainer : ThemeColors.primary.withOpacity(0.15),
                          labelStyle: TextStyle(
                            color: p.contains('Acil') ? ThemeColors.onErrorContainer : (selected ? ThemeColors.primary : ThemeColors.onSurfaceVariant),
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
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
                      content: Text('Ödev listeye kaydedildi!'),
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
                icon: const Icon(Icons.check),
                label: const Text('Ödevi Kaydet', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
