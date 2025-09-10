import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../core/services/file_picker.dart';

class UploadScreen extends StatefulWidget {
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? selectedFilePath;
  String? selectedFileName;

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final file = result.files.single;
      if (file.size > 10 * 1024 * 1024) {
        // 10MB limit
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File too large. Please select a file under 10MB.'),
          ),
        );
        return;
      }
      setState(() {
        selectedFilePath = file.path!;
        selectedFileName = file.name;
      });
    }
  }

  Future<void> _uploadPDF() async {
    if (selectedFilePath != null) {
      print('Uploading file: $selectedFilePath');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Uploading $selectedFileName...')));
      try {
        final response = await uploadPDF(selectedFilePath!);
        print('Analysis Response: $response');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Upload successful! Document ID: ${response['documentId']}',
            ),
          ),
        );
      } catch (e) {
        print('Upload error: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select a file first')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload agreements, contracts, legal docs',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Get useful insights and spot potential risks '
                      'Don\'t worry, your data stays safe and private.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _FilePickerBox(
                      onTap: pickPDF,
                      selectedFileName: selectedFileName,
                    ),
                    const SizedBox(height: 24),
                    _OrDivider(),
                    const SizedBox(height: 24),
                    _CameraButton(),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () async {
                    // TODO: continue action
                    await _uploadPDF();
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilePickerBox extends StatelessWidget {
  final VoidCallback onTap;
  final String? selectedFileName;

  const _FilePickerBox({required this.onTap, this.selectedFileName});

  @override
  Widget build(BuildContext context) {
    final borderColor = Color(0xFF3B82F6);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 225,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/upload-icon.png", height: 100),
              const SizedBox(height: 8),
              Text(
                selectedFileName ?? 'Tap to select PDF',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
      ],
    );
  }
}

class _CameraButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lightGreen = Color(0xFFDBEAFE);
    final green = Color(0xFF3B82F6);
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: lightGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          // TODO: open camera
        },
        icon: Icon(Icons.camera_alt, color: green),
        label: Text(
          'Open Camera & Take Photo',
          style: TextStyle(
            color: green,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
