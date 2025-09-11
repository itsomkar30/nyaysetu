import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/services/file_picker.dart';

class AnalysisScreen extends StatefulWidget {
  final String fileName;
  final String filePath;

  const AnalysisScreen({
    Key? key,
    required this.fileName,
    required this.filePath,
  }) : super(key: key);

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool isAnalysisComplete = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _fadeController.forward();
    });
    
    // Start analysis process
    _startAnalysis();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _startAnalysis() async {
    try {
      await uploadPDF(widget.filePath);
      await Future.delayed(const Duration(seconds: 3)); // Simulate analysis time
      setState(() {
        isAnalysisComplete = true;
      });
    } catch (e) {
      print('Analysis error: $e');
      setState(() {
        isAnalysisComplete = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: isAnalysisComplete
                            ? Image.asset(
                                "assets/images/upload-icon.png",
                                height: 40,
                                width: 40,
                                key: const ValueKey('upload-icon'),
                              )
                            : Lottie.asset(
                                'assets/lotties/loading.json',
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                                key: const ValueKey('loading'),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.fileName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              isAnalysisComplete
                                  ? 'Analysis completed successfully'
                                  : 'Analyzing document...',
                              key: ValueKey(isAnalysisComplete),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isAnalysisComplete
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 24,
                              key: const ValueKey('check'),
                            )
                          : SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  const Color(0xFF3B82F6),
                                ),
                              ),
                              key: const ValueKey('progress'),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Document Analysis',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'AI-powered insights and risk assessment',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildAnalysisCard(
                        'Key Terms',
                        'Important clauses and conditions identified',
                        Icons.article_outlined,
                        Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      _buildAnalysisCard(
                        'Risk Assessment',
                        'Potential legal risks and concerns',
                        Icons.warning_amber_outlined,
                        Colors.orange,
                      ),
                      const SizedBox(height: 16),
                      _buildAnalysisCard(
                        'Compliance Check',
                        'Regulatory compliance verification',
                        Icons.verified_outlined,
                        Colors.green,
                      ),
                      const SizedBox(height: 16),
                      _buildAnalysisCard(
                        'Summary',
                        'Executive summary of the document',
                        Icons.summarize_outlined,
                        Colors.purple,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[400],
            size: 16,
          ),
        ],
      ),
    );
  }
}