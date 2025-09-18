import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class OCRService {
  static final TextRecognizer _textRecognizer = TextRecognizer();

  static Future<String> extractTextFromImage(String imagePath) async {
    try {
      print('Extracting text from image: $imagePath');
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      print('Total text blocks found: ${recognizedText.blocks.length}');
      print('Full extracted text: "${recognizedText.text}"');
      print('Text length: ${recognizedText.text.length}');
      

      if (recognizedText.text.trim().isEmpty) {
        print('No text detected by OCR, using fallback');
        return 'No readable text was detected in this image. Please ensure the image contains clear, readable text.';
      }
      
      return recognizedText.text;
    } catch (e) {
      print('Error extracting text: $e');
      throw Exception('Failed to extract text from image: $e');
    }
  }

  static Future<String> createPDFFromImageWithText(String imagePath) async {
    try {
      // Extract text from image
      final extractedText = await extractTextFromImage(imagePath);
      
      print('Extracted text for PDF: "$extractedText"');
      print('Text is empty: ${extractedText.trim().isEmpty}');

      print('Creating PDF with extracted text...');

      final pdf = pw.Document();
      
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Text(
                    extractedText.isNotEmpty ? extractedText : 'No text could be extracted from the image.',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ),
              ],
            );
          },
        ),
      );


      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final pdfPath = '${directory.path}/ocr_document_$timestamp.pdf';
      final file = File(pdfPath);
      final pdfBytes = await pdf.save();
      await file.writeAsBytes(pdfBytes);
      
      print('PDF created successfully at: $pdfPath');
      print('PDF file size: ${await file.length()} bytes');
      
      return pdfPath;
    } catch (e) {
      print('Error creating PDF: $e');
      rethrow;
    }
  }

  static void dispose() {
    _textRecognizer.close();
  }
}