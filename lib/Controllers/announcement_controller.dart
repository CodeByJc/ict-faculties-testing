import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Models/announcement_model.dart';
import '../Network/API.dart';

class AnnouncementController extends GetxController {
  var isLoading = false.obs;
  var announcements = <AnnouncementModel>[].obs;
  var announcementTypes = <Map<String, dynamic>>[].obs;
  var batches = <Map<String, dynamic>>[].obs;

  // ---------- FETCH ALL ANNOUNCEMENTS ----------
  Future<void> fetchAnnouncements({int? batchId}) async {
    try {
      isLoading(true);
      print('🔄 fetchAnnouncements called. batchId: $batchId');

      // Build URL dynamically
      String urlStr = announcementListAPI;
      print('🔹 Base URL: $urlStr');

      if (batchId != null) {
        urlStr += '?batch_id=$batchId'; // use batchId here
        print('🔹 URL with batchId: $urlStr');
      } else {
        print('🔹 No batchId provided. Fetching all announcements.');
      }

      final url = Uri.parse(urlStr);
      print('🔹 Final parsed URL: $url');

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': validApiKey,
      });
      print('🔹 HTTP GET request sent.');

      print('🔹 Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        print('🔹 Response body decoded: $body');

        if (body['status'] == true && body['data'] != null) {
          announcements.value = List<AnnouncementModel>.from(
            body['data'].map((x) => AnnouncementModel.fromJson(x)),
          );
          print('✅ Announcements fetched: ${announcements.length}');
          for (var i = 0; i < announcements.length; i++) {
            print('📌 Announcement ${i + 1}: ${announcements[i].title}');
          }
        } else {
          announcements.clear();
          print('ℹ️ No announcements found in response.');
        }
      } else {
        announcements.clear();
        print('❌ Failed to fetch announcements. Status code: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
      }
    } catch (e, stackTrace) {
      print("❌ Error fetching announcements: $e");
      print(stackTrace);
      announcements.clear();
    } finally {
      isLoading(false);
      print('🔹 fetchAnnouncements completed. isLoading set to false.');
    }
  }

  // ---------- FETCH BATCHES AND TYPES ----------
  Future<void> fetchBatchesAndTypes() async {
    try {
      print('🔄 fetchBatchesAndTypes() called...');
      final url = Uri.parse(getAnnouncementFieldAPI);
      print('🌐 API URL parsed: $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
      );
      print('📡 GET request sent to $url');
      print('📨 Response received with status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Status 200 OK — decoded JSON: $data');

        if (data['status'] == true && data['data'] != null) {
          // Fetch batches
          if (data['data']['batches'] != null) {
            batches.value = List<Map<String, dynamic>>.from(data['data']['batches']);
            print('📦 Batches fetched: ${batches.length}');
            for (var batch in batches) {
              print('➡️ Batch: ${batch['batch_name']} (ID: ${batch['id']})');
            }
          } else {
            print('⚠️ No batches found in response.');
            batches.clear();
          }

          // Fetch announcement types
          if (data['data']['announcement_types'] != null) {
            announcementTypes.value = List<Map<String, dynamic>>.from(data['data']['announcement_types']);
            print('📦 Announcement types fetched: ${announcementTypes.length}');
            for (var type in announcementTypes) {
              print('➡️ Type: ${type['Announcement_type']} (ID: ${type['Announcement_type_id']})');
            }
          } else {
            print('⚠️ No announcement types found in response.');
            announcementTypes.clear();
          }
        } else {
          print('⚠️ Invalid data structure or status false.');
          batches.clear();
          announcementTypes.clear();
        }
      } else {
        print('❌ Failed to fetch data. HTTP ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        batches.clear();
        announcementTypes.clear();
      }
    } catch (e, stackTrace) {
      print('💥 Exception occurred while fetching batches and types: $e');
      print(stackTrace);
      batches.clear();
      announcementTypes.clear();
    } finally {
      print('🔚 fetchBatchesAndTypes() completed.');
    }
  }

  // ---------- GET SINGLE ANNOUNCEMENT ----------
  Future<AnnouncementModel?> getAnnouncementById(int faculty_id) async {
    try {
      final url = Uri.parse('$announcementGetAPI?faculty_id=$faculty_id');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': validApiKey,
      });

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['status'] == true && body['data'] != null) {
          return AnnouncementModel.fromJson(body['data']);
        }
      }
    } catch (e) {
      print("Error fetching single announcement: $e");
    }
    return null;
  }

  // ---------- ADD NEW ANNOUNCEMENT ----------
  Future<bool> addAnnouncement({
    required String title,
    required String description,
    required int facultyId,
    required int batchId,
    required int announcementTypeId,
    String? announcementDate, // <-- now supported
  }) async {
    try {
      final url = Uri.parse(announcementAddAPI);
      // Use backend required keys, and add Announcement_date if provided
      final body = jsonEncode({
        'faculty_id': facultyId,
        'Announcement_title': title,
        'announcement_description': description,
        'batch_id': batchId,
        'Announcement_type_id': announcementTypeId,
        if (announcementDate != null) 'Announcement_date': announcementDate,
      });
      print('📦 POST Body: $body');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: body,
      );

      print('📨 Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('✅ Decoded response: $jsonResponse');
        return jsonResponse['status'] == true;
      } else {
        print('❌ Failed to add announcement. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('💥 Exception in addAnnouncement: $e');
      print(stackTrace);
    }
    return false;
  }

  // ---------- DELETE ANNOUNCEMENT ----------
  Future<bool> deleteAnnouncement(int id) async {
    try {
      print('🗑️ deleteAnnouncement() called with ID: $id');

      final url = Uri.parse(announcementDeleteAPI);
      print('🌐 API URL parsed: $url');

      final body = jsonEncode({'id': id});
      print('📦 Request body encoded: $body');

      print('📡 Sending DELETE request to server...');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: body,
      );

      print('📨 Response received with status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Status 200 OK — decoding response...');
        final jsonResponse = json.decode(response.body);
        print('📦 Decoded response: $jsonResponse');

        final success = jsonResponse['status'] == true;
        if (success) {
          print('🗑️✅ Announcement ID $id successfully deleted.');
        } else {
          print('⚠️ Delete failed — server returned status: false');
        }
        return success;
      } else {
        print('❌ Failed to delete announcement. HTTP ${response.statusCode}');
        print('❌ Response body: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('💥 Exception occurred while deleting announcement: $e');
      print(stackTrace);
    } finally {
      print('🔚 deleteAnnouncement() completed.');
    }
    return false;
  }

  Future<void> fetchAnnouncementsByFaculty(int facultyId) async {
    try {
      isLoading(true);
      print('🔄 Fetching announcements for faculty ID: $facultyId');
      final url = Uri.parse('$announcementListAPI?faculty_id=$facultyId');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': validApiKey,
      });
      print('🔹 HTTP GET: $url');
      print('🔹 Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        print('🔹 Response: $body');
        if (body['status'] == true && body['data'] != null) {
          announcements.value = List<AnnouncementModel>.from(
              body['data'].map((x) => AnnouncementModel.fromJson(x)));
          print('✅ Announcements loaded: ${announcements.length}');
        } else {
          announcements.clear();
          print('ℹ️ No announcements found for faculty.');
        }
      } else {
        announcements.clear();
        print('❌ Failed to fetch. Code: ${response.statusCode}');
      }
    } catch (e) {
      announcements.clear();
      print('❌ Exception: $e');
    } finally {
      isLoading(false);
    }
  }

}