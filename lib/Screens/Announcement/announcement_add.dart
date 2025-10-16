import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/announcement_controller.dart';
import '../../Helper/colors.dart';

class AnnouncementAddScreen extends StatefulWidget {
  final int facultyId;

  const AnnouncementAddScreen({super.key, required this.facultyId});

  @override
  State<AnnouncementAddScreen> createState() => _AnnouncementAddScreenState();
}

class _AnnouncementAddScreenState extends State<AnnouncementAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final AnnouncementController _controller = Get.find<AnnouncementController>();

  bool _isSubmitting = false;
  int? _selectedBatchId;
  int? _selectedTypeId;

  @override
  void initState() {
    super.initState();
    _loadBatchesAndTypes();
  }

  Future<void> _loadBatchesAndTypes() async {
    await _controller.fetchBatchesAndTypes();

    setState(() {
      if (_controller.batches.isNotEmpty) {
        _selectedBatchId = _controller.batches[0]['id'];
      } else {
        _selectedBatchId = null;
      }

      if (_controller.announcementTypes.isNotEmpty) {
        _selectedTypeId = _controller.announcementTypes[0]['Announcement_type_id'];
      } else {
        _selectedTypeId = null;
      }
    });
  }

  Future<void> _submitAnnouncement() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedBatchId == null || _selectedTypeId == null) {
      Get.snackbar("Warning", "Please select batch and type!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.shade600,
          colorText: Colors.white);
      return;
    }

    setState(() => _isSubmitting = true);

    final today = DateTime.now();
    final formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final success = await _controller.addAnnouncement(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      facultyId: widget.facultyId,
      batchId: _selectedBatchId!,
      announcementTypeId: _selectedTypeId!,
      announcementDate: formattedDate,
    );

    setState(() => _isSubmitting = false);

    if (success) {
      Get.snackbar("✅ Success", "Announcement added successfully!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white);

      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedBatchId = _controller.batches.isNotEmpty ? _controller.batches[0]['id'] : null;
        _selectedTypeId = _controller.announcementTypes.isNotEmpty ? _controller.announcementTypes[0]['Announcement_type_id'] : null;
      });
    } else {
      Get.snackbar("❌ Error", "Failed to add announcement. Try again later.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Announcement"),
        centerTitle: true,
        backgroundColor: muColor,
      ),
      body: Obx(() {
        final batches = _controller.batches;
        final types = _controller.announcementTypes;

        if (batches.isEmpty || types.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_selectedBatchId == null || !batches.any((b) => b['id'] == _selectedBatchId)) {
          _selectedBatchId = batches[0]['id'];
        }
        if (_selectedTypeId == null || !types.any((t) => t['Announcement_type_id'] == _selectedTypeId)) {
          _selectedTypeId = types[0]['Announcement_type_id'];
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  value: _selectedBatchId,
                  decoration: const InputDecoration(
                    labelText: "Select Batch",
                    border: OutlineInputBorder(),
                  ),
                  items: batches
                      .map((b) => DropdownMenuItem<int>(
                    value: b['id'],
                    child: Text(b['batch_name']),
                  ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedBatchId = v),
                  validator: (v) => v == null ? "Select a batch" : null,
                ),
                const SizedBox(height: 15),

                DropdownButtonFormField<int>(
                  value: _selectedTypeId,
                  decoration: const InputDecoration(
                    labelText: "Select Type",
                    border: OutlineInputBorder(),
                  ),
                  items: types
                      .map((t) => DropdownMenuItem<int>(
                    value: t['Announcement_type_id'],
                    child: Text(t['Announcement_type']),
                  ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedTypeId = v),
                  validator: (v) => v == null ? "Select a type" : null,
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? "Enter a title" : null,
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? "Enter a description" : null,
                ),
                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitAnnouncement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: muColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Add Announcement",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}