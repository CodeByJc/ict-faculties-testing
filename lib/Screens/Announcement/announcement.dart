import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../../Controllers/announcement_controller.dart';
import '../../Helper/Components.dart' hide Heading1;
import '../../Models/announcement_model.dart';
import '../../Helper/Style.dart';
import '../../Helper/colors.dart';
import 'package:ict_faculties/Models/faculty.dart';
import '../../Helper/size.dart';
import '../../Widgets/heading_2.dart';
import '../../Widgets/heading_1.dart';
import '../../Widgets/dashboard_icon.dart';
import '../Loading/adaptive_loading_screen.dart';
import '../../Animations/slide_zoom_in_animation.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final AnnouncementController _controller = Get.find<AnnouncementController>();
  final box = GetStorage();
  late Faculty userData;
  int batchId = 0;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> storedData = box.read('userdata');
    userData = Faculty.fromJson(storedData);
    final args = Get.arguments ?? {};
    batchId = args['batch_id'] ?? 0;
    _controller.fetchAnnouncements(batchId: batchId);
  }

  Future<void> _refreshAnnouncements() async {
    await _controller.fetchAnnouncements(batchId: batchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Announcements",
          style: appbarStyle(context),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        return Column(
          children: [
            // ======== TOP ACTIONS =========
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 5, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TapIcon2(
                    name: "Add Announcement",
                    iconData: HugeIcons.strokeRoundedAdd01,
                    route: "/addAnnouncement",
                    routeArg: {
                      'faculty_id': userData.id,
                    },
                  ),
                  TapIcon2(
                    name: "Delete Announcement",
                    iconData: HugeIcons.strokeRoundedDelete01,
                    route: "/deleteAnnouncement",
                    routeArg: {
                      'faculty_id': userData.id,
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
              child: Divider(indent: 20, endIndent: 20, color: Colors.grey),
            ),
            const Heading1(
              text: "Recent Announcements",
              fontSize: 2.5,
              leftPadding: 20,
            ),
            const SizedBox(height: 10),

            // ======== REFRESHABLE ANNOUNCEMENT LIST =========
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshAnnouncements,
                child: _controller.isLoading.value
                    ? const AdaptiveLoadingScreen()
                    : _controller.announcements.isEmpty
                    ? const Center(
                  child: Text(
                    "No announcements available.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  itemCount: _controller.announcements.length,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  itemBuilder: (context, index) {
                    AnnouncementModel ann = _controller.announcements[index];
                    return SlideZoomInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: muGrey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      HugeIcon(
                                          icon: HugeIcons.strokeRoundedMegaphone01,
                                          color: muColor),
                                      const SizedBox(width: 7),
                                      Flexible(
                                        child: Text(
                                          ann.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: getSize(context, 2.2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    ann.description,
                                    style: TextStyle(fontSize: getSize(context, 1.9)),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      HugeIcon(
                                          icon: HugeIcons.strokeRoundedUserCircle,
                                          color: muColor),
                                      const SizedBox(width: 7),
                                      Text(
                                        ann.facultyName.isNotEmpty
                                            ? ann.facultyName
                                            : "Unknown Faculty",
                                        style: TextStyle(
                                            fontSize: getSize(context, 1.8),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 100,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: muColor,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    (ann.date.isNotEmpty)
                                        ? DateFormat('dd-MM-yyyy').format(
                                        DateFormat('yyyy-MM-dd').parse(ann.date))
                                        : "",
                                    style: const TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}