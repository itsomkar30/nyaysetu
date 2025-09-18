import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

Future<File> generatePdfFromImage(String imagePath) async {
  final pdf = pw.Document();


  final imageBytes = await File(imagePath).readAsBytes();
  final image = pw.MemoryImage(imageBytes);


  final pageFormat = PdfPageFormat(
    595,
    1056,
    marginAll: 0,
  );

  pdf.addPage(
    pw.Page(
      pageFormat: pageFormat,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(image, fit: pw.BoxFit.cover),
        );
      },
    ),
  );

  // Save PDF in temporary directory
  final dir = await getTemporaryDirectory();
  final file = File("${dir.path}/captured_image.pdf");
  await file.writeAsBytes(await pdf.save());
  return file;
}
