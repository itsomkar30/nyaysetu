import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> uploadPDF(String filePath) async {
  try {
    print('Starting upload for file: $filePath');
    var uri = Uri.parse("https://docs-verify.onrender.com/upload");

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = await http.MultipartFile.fromPath(
      'file',
      filePath,
      contentType: MediaType('application', 'pdf'),
    );
    request.files.add(multipartFile);

    print('Sending request to: $uri');
    print('File field name: file');
    print('File path: $filePath');
    print('File size: ${multipartFile.length} bytes');
    print('Content type: ${multipartFile.contentType}');
    var response = await request.send();
    print('Response status code: ${response.statusCode}');
    print('Response headers: ${response.headers}');

    var responseData = await response.stream.bytesToString();
    print('Full API Response:');
    print(responseData);

    if (response.statusCode != 200) {
      throw Exception('Upload failed with status ${response.statusCode}: $responseData');
    }

    return json.decode(responseData);
  } catch (e) {
    print('Upload error: $e');
    rethrow;
  }
}

Future<Map<String, dynamic>?> pickAndUploadPDF() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null && result.files.single.path != null) {
    String filePath = result.files.single.path!;
    return await uploadPDF(filePath);
  } else {
    print("No file selected");
    return null;
  }
}
