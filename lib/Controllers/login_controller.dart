import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ict_faculties/Models/faculty.dart';
import 'package:ict_faculties/Network/API.dart';


class LoginController extends GetxController {
  final box = GetStorage();

  Future<bool> login(String username, String password) async {
    try {
      Map<String, String> body = {'username': username, 'password': password};

      // DEBUG: print request body
      print("Sending login request to API:");
      print(json.encode(body));
      print("API URL: $validateLoginAPI");

      final client = http.Client();
      final response = await client.post(
        Uri.parse(validateLoginAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      // DEBUG: print response
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // DEBUG: print parsed response
        print("Parsed Response: $responseData");

        if (responseData != null && responseData['faculties_details'] != null) {
          // Accessing the nested faculties_details
          Faculty userData =
              Faculty.fromJson(responseData['faculties_details']);

          // Writing data to storage
          box.write('userdata', userData.toJson());
          box.write('loggedin', true);

          return true;
        } else {
          print("Login failed: server returned error");
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print("Login Exception: $e");
      return false;
    }
  }
}
