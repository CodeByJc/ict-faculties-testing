import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/announcement_controller.dart';
import '../../Models/announcement_model.dart';
import '../../Helper/colors.dart';

class AnnouncementDeleteScreen extends StatefulWidget {
  final int facultyId;

  const AnnouncementDeleteScreen({Key? key, required this.facultyId}) : super(key: key);

  @override
  State<AnnouncementDeleteScreen> createState() => _AnnouncementDeleteScreenState();
}

class _AnnouncementDeleteScreenState extends State<AnnouncementDeleteScreen> {
  final AnnouncementController _controller = Get.find<AnnouncementController>();

  @override
  void initState() {
    super.initState();
    print('📲 AnnouncementDeleteScreen initialized for Faculty ID: ${widget.facultyId}');

    // Delay until first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchFacultyAnnouncements();
    });
  }
  Future<void> _fetchFacultyAnnouncements() async {
    print('🔄 Fetching announcements for faculty ID: ${widget.facultyId}');
    await _controller.fetchAnnouncementsByFaculty(widget.facultyId);
    print('✅ Fetched announcements. Total count: ${_controller.announcements.length}');
  }

  Future<void> _confirmDelete(AnnouncementModel announcement) async {
    print('⚠️ Attempting to delete announcement ID: ${announcement.id}, Title: ${announcement.title}');
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Announcement"),
        content: Text(
            "Are you sure you want to delete \"${announcement.title}\"? This action cannot be undone."),
        actions: [
          TextButton(
              onPressed: () {
                print('❌ Delete cancelled by user.');
                Navigator.pop(context, false);
              },
              child: const Text("Cancel")),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                print('✅ Delete confirmed by user.');
                Navigator.pop(context, true);
              },
              child: const Text("Delete")),
        ],
      ),
    );

    if (confirm == true) {
      print('🗑️ Deleting announcement ID: ${announcement.id}...');
      bool success = await _controller.deleteAnnouncement(announcement.id);
      print('📩 Delete announcement response: $success');

      if (success) {
        print('🔄 Refreshing announcements after deletion...');
        await _fetchFacultyAnnouncements();
        print('✅ Announcements refreshed. Total: ${_controller.announcements.length}');
        Get.snackbar("Deleted", "Announcement removed successfully!",
            backgroundColor: Colors.green.shade400,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      } else {
        print('❌ Failed to delete announcement ID: ${announcement.id}');
        Get.snackbar("Error", "Failed to delete announcement.",
            backgroundColor: Colors.red.shade400,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      }
    } else {
      print('ℹ️ Delete action cancelled by user.');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🧱 Building AnnouncementDeleteScreen UI...');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Announcements"),
        backgroundColor: muColor,
      ),
      body: Obx(() {
        print('🌀 Observing announcements list. Count: ${_controller.announcements.length}');
        if (_controller.isLoading.value) {
          print('⏳ Loading indicator shown.');
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.announcements.isEmpty) {
          print('🚫 No announcements found.');
          return const Center(child: Text("No announcements found."));
        }

        return RefreshIndicator(
          onRefresh: () async {
            print('🔄 Pull-to-refresh triggered.');
            await _fetchFacultyAnnouncements();
            print('✅ Refresh complete.');
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: _controller.announcements.length,
            itemBuilder: (context, index) {
              final ann = _controller.announcements[index];
              print('📌 Rendering announcement index $index: ${ann.title}');
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: ListTile(
                  leading: const Icon(Icons.campaign, color: Colors.blue),
                  title: Text(
                    ann.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  subtitle: Text(
                    "${ann.facultyName}\n${ann.date}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(ann),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
