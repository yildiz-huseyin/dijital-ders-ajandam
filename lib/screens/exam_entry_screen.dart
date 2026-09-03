import 'package:flutter/material.dart';
import '../models/app_models.dart';

class ExamEntryScreen extends StatefulWidget {
  const ExamEntryScreen({super.key});

  @override
  State<ExamEntryScreen> createState() => _ExamEntryScreenState();
}

class _ExamEntryScreenState extends State<ExamEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: '3D TYT Simülasyon Denemesi - 4');
  final _dateController = TextEditingController(text: '14 Ekim 2026');

  // Controllers for correct and incorrect
  final _turkceD = TextEditingController(text: '34');
  final _turkceY = TextEditingController(text: '4');
  final _matD = TextEditingController(text: '28');
  final _matY = TextEditingController(text: '3');
  final _fenD = TextEditingController(text: '15');
  final _fenY = TextEditingController(text: '4');
  final _sosyalD = TextEditingController(text: '16');
  final _sosyalY = TextEditingController(text: '3');

  double _calcNet(TextEditingController d, TextEditingController y) {
    final double dogru = double.tryParse(d.text) ?? 0.0;
    final double yanlis = double.tryParse(y.text) ?? 0.0;
    return (dogru - (yanlis * 0.25)).clamp(0.0, 40.0);
  }

  double get _totalNet =>
      _calcNet(_turkceD, _turkceY) +
      _calcNet(_matD, _matY) +
      _calcNet(_fenD, _fenY) +
      _calcNet(_sosyalD, _sosyalY);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.surface,
      appBar: AppBar(
        backgroundColor: ThemeColors.surface,
        elevation: 0,
        title: const Text('Deneme Sınavı Girişi', style: TextStyle(color: ThemeColors.onSurface, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ThemeColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Total Net Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [ThemeColors.primary, ThemeColors.primaryContainer],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: ThemeColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  children: [
                    const Text('HESAPLANAN TOPLAM NET', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    const SizedBox(height: 6),
                    Text(
                      _totalNet.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    const Text('Hedef Net: 95.00 | Kalan: +8.25 Net', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Exam Meta Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThemeColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Deneme / Yayın Adı',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.assignment, color: ThemeColors.primary),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Sınav Tarihi',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today, color: ThemeColors.secondary),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              const Text('DERS NETLERİ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ThemeColors.onSurfaceVariant, letterSpacing: 1)),
              const SizedBox(height: 10),

              _buildSubjectRow('Türkçe (40 Soru)', _turkceD, _turkceY, ThemeColors.primary),
              const SizedBox(height: 10),
              _buildSubjectRow('Temel Matematik (40 Soru)', _matD, _matY, ThemeColors.secondary),
              const SizedBox(height: 10),
              _buildSubjectRow('Fen Bilimleri (20 Soru)', _fenD, _fenY, Colors.teal),
              const SizedBox(height: 10),
              _buildSubjectRow('Sosyal Bilimler (20 Soru)', _sosyalD, _sosyalY, ThemeColors.tertiaryContainer),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Deneme kaydedildi! Toplam Net: ' + _totalNet.toStringAsFixed(2)),
                        backgroundColor: Colors.green.shade700,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Deneme Sonucunu Kaydet', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectRow(String title, TextEditingController d, TextEditingController y, Color color) {
    final net = _calcNet(d, y);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ThemeColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ThemeColors.onSurface)),
              Text('Net: ' + net.toStringAsFixed(2), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: d,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Doğru',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: y,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Yanlış',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
