import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../core/services/file_picker.dart';
import 'analysis_screen_view.dart';

class UploadScreen extends StatefulWidget {
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen>
    with TickerProviderStateMixin {
  String? selectedFilePath;
  String? selectedFileName;
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _buttonAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

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
      // Navigate immediately to analysis screen
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              AnalysisScreen(
            fileName: selectedFileName!,
            filePath: selectedFilePath!,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            
            var fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ));
            
            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: fadeAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
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
                    _buttonController.forward().then((_) {
                      _buttonController.reverse();
                    });
                    await _uploadPDF();
                  },
                  child: AnimatedBuilder(
                    animation: _buttonAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _buttonAnimation.value,
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
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

class _FilePickerBox extends StatefulWidget {
  final VoidCallback onTap;
  final String? selectedFileName;

  const _FilePickerBox({required this.onTap, this.selectedFileName});

  @override
  State<_FilePickerBox> createState() => _FilePickerBoxState();
}

class _FilePickerBoxState extends State<_FilePickerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _colorAnimation = ColorTween(
      begin: Colors.grey[50],
      end: const Color(0xFF3B82F6).withOpacity(0.05),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Color(0xFF3B82F6);
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              height: 225,
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: borderColor, width: 2),
                boxShadow: widget.selectedFileName != null
                    ? [
                        BoxShadow(
                          color: borderColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Image.asset(
                        "assets/images/upload-icon.png",
                        height: 100,
                      ),
                    ),

                    const SizedBox(height: 8),

                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],

                      ),
                      child: Text(
                        widget.selectedFileName ?? 'Tap to select PDF',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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

class _CameraButton extends StatefulWidget {
  @override
  State<_CameraButton> createState() => _CameraButtonState();
}

class _CameraButtonState extends State<_CameraButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lightGreen = Color(0xFFDBEAFE);
    final green = Color(0xFF3B82F6);
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
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
          },
        ),
      ),
    );
  }
}
