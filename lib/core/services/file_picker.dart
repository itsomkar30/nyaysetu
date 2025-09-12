import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import '../models/document.dart';


String? documentId;

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

    final Map<String, dynamic> decoded = json.decode(responseData);

    documentId = decoded['documentId'];
    print("Document ID : $documentId");

    return json.decode(responseData);
  } catch (e) {
    print('Upload error: $e');
    rethrow;
  }
}

Future<DocumentSummaryResponse> fetchDocumentSummary(String documentId) async {
  try {
    final uri = Uri.parse('https://docs-verify.onrender.com/api/document/$documentId/summary');
    print('Fetching summary for document ID: $documentId');
    
    final response = await http.get(uri);
    print('Summary API Response Status: ${response.statusCode}');
    print('Summary API Response Body: ${response.body}');
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return DocumentSummaryResponse.fromJson(data);
    } else {
      throw Exception('Failed to fetch summary: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching document summary: $e');
    rethrow;
  }
}

Future<RiskAssessmentResponse> fetchDocumentRisks(String documentId) async {
  try {
    final uri = Uri.parse('https://docs-verify.onrender.com/api/document/$documentId/risks');
    print('Fetching risks for document ID: $documentId');
    
    final response = await http.get(uri);
    print('Risk API Response Status: ${response.statusCode}');
    print('Risk API Response Body: ${response.body}');
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return RiskAssessmentResponse.fromJson(data);
    } else {
      throw Exception('Failed to fetch risks: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching document risks: $e');
    rethrow;
  }
}

Future<ClausesResponse> fetchDocumentClauses(String documentId) async {
  try {
    final uri = Uri.parse('https://docs-verify.onrender.com/api/document/$documentId/clauses');
    print('Fetching clauses for document ID: $documentId');
    
    final response = await http.get(uri);
    print('Clauses API Response Status: ${response.statusCode}');
    print('Clauses API Response Body: ${response.body}');
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ClausesResponse.fromJson(data);
    } else {
      throw Exception('Failed to fetch clauses: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching document clauses: $e');
    rethrow;
  }
}

Future<KeyTermsResponse> fetchDocumentTerms(String documentId) async {
  try {
    final uri = Uri.parse('https://docs-verify.onrender.com/api/document/$documentId/terms');
    print('Fetching terms for document ID: $documentId');
    
    final response = await http.get(uri);
    print('Terms API Response Status: ${response.statusCode}');
    print('Terms API Response Body: ${response.body}');
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return KeyTermsResponse.fromJson(data);
    } else {
      throw Exception('Failed to fetch terms: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching document terms: $e');
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
