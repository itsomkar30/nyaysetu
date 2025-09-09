import 'package:flutter/material.dart';

class UploadScreen extends StatelessWidget {
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
                    _FilePickerBox(),
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
                  onPressed: () {
                    // TODO: continue action
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
  @override
  Widget build(BuildContext context) {
    final borderColor = Color(0xFF3B82F6);
    return GestureDetector(
      onTap: () {
        // TODO: open file picker
      },
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
                'Tap to select PDF',
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
