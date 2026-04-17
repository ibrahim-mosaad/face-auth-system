import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  static Future<Map<String, dynamic>> recognizeFace(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/recognize'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', image.path),
    );

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    return jsonDecode(responseData);
  }
}
