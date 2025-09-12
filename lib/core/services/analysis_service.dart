import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

String? documentId;

Future<void> uploadPdf(File file) async {
  final request = http.MultipartRequest(
    'POST',
    Uri.parse("https://docs-verify.onrender.com/upload"),
  );

  request.files.add(await http.MultipartFile.fromPath('file', file.path));
  final response = await request.send();

  if (response.statusCode == 200) {
    final responseBody = await response.stream.bytesToString();
    final data = jsonDecode(responseBody);

    documentId = data['documentId'];
    print("Saved Document ID: $documentId");
  } else {
    print("Upload failed: ${response.statusCode}");
  }
}
