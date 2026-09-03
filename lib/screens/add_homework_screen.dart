import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../providers/homework_provider.dart';

class AddHomeworkScreen extends StatefulWidget {
  const AddHomeworkScreen({super.key});

  @override
  State<AddHomeworkScreen> createState() => _AddHomeworkScreenState();
}

class _AddHomeworkScreenState extends State<AddHomeworkScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedSubject = 'Matematik';
  HomeworkPriority _priority = HomeworkPriority.medium;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  bool _isSaving = false;

  final List<String> _subjects = [
    'Matematik', 'Türkçe', 'Fizik', 'Kimya',
    'Biyoloji', 'Tarih', 'Coğrafya', 'Felsefe',
    'İngilizce', 'Din Kültürü', 'Diğer'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final hw = HomeworkItem(
      title: _titleController.text.trim(),
      subject: _selectedSubject,
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      dueDate: _dueDate,
      priority: _priority,
    );
    await context.read<HomeworkProvider>().addHomework(hw);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Yeni Ödev Ekle',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Ödev Başlığı *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.assignment),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Başlık gerekli' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                decoration: const InputDecoration(
                  labelText: 'Ders',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book),
                ),
                items: _subjects
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedSubject = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Açıklama (isteğe bağlı)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes),
                ),
              ),
              const SizedBox(height: 12),
              // Priority
              const Text('Öncelik:',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final p in HomeworkPriority.values)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(_priorityLabel(p)),
                          selected: _priority == p,
                          selectedColor: _priorityColor(p).withOpacity(0.2),
                          onSelected: (_) => setState(() => _priority = p),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Due date
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _dueDate = picked);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        'Teslim Tarihi: ${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Kaydet',
                          style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _priorityLabel(HomeworkPriority p) {
    switch (p) {
      case HomeworkPriority.low: return 'Düşük';
      case HomeworkPriority.medium: return 'Orta';
      case HomeworkPriority.high: return 'Yüksek';
    }
  }

  Color _priorityColor(HomeworkPriority p) {
    switch (p) {
      case HomeworkPriority.low: return Colors.green;
      case HomeworkPriority.medium: return Colors.orange;
      case HomeworkPriority.high: return Colors.red;
    }
  }
}
