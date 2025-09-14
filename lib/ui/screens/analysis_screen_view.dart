import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/services/file_picker.dart';
import '../../core/models/document.dart';
import 'clauses_screen_view.dart';
import 'risk_screen_view.dart' as risk_screen;
import 'terms_screen_view.dart' as terms_screen;
import 'summary_screen_view.dart' as summary_screen;
import 'chat_screen_view.dart';

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
  DocumentSummaryResponse? summaryData;
  String? currentDocumentId;

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
      // Upload PDF and get document ID
      final uploadResponse = await uploadPDF(widget.filePath);
      final docId = uploadResponse['documentId'] as String?;
      
      if (docId != null) {
        currentDocumentId = docId;
        // Fetch document summary
        summaryData = await fetchDocumentSummary(docId);
      }
      
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => terms_screen.TermsScreen(
                                termsData: terms_screen.KeyTermsResponse(
                                  success: true,
                                  documentId: '1757849820526',
                                  keyTerms: [
                                    terms_screen.KeyTerm(
                                      term: 'Scheduled Land',
                                      explanation: 'The land where the apartment building is being constructed.',
                                      impact: 'Defines the location and extent of the property being sold.',
                                    ),
                                    terms_screen.KeyTerm(
                                      term: 'Scheduled Apartment',
                                      explanation: 'The specific apartment unit being sold to the buyer.',
                                      impact: 'Specifies the exact subject matter of the sale.',
                                    ),
                                    terms_screen.KeyTerm(
                                      term: 'Super built-up area',
                                      explanation: 'The total area of the apartment, including common areas.',
                                      impact: 'Determines the price and size of the apartment.',
                                    ),
                                    terms_screen.KeyTerm(
                                      term: 'Undivided share in land',
                                      explanation: 'A proportionate ownership interest in the land on which the building sits.',
                                      impact: 'Grants the buyer a partial ownership of the land.',
                                    ),
                                    terms_screen.KeyTerm(
                                      term: 'Force Majeure',
                                      explanation: 'Unforeseeable circumstances beyond the control of either party, such as war or natural disasters.',
                                      impact: 'Can excuse delays in construction.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: _buildAnalysisCard(
                          'Key Terms',
                          'Important clauses and conditions identified',
                          Icons.article_outlined,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => risk_screen.RiskScreen(
                                riskData: risk_screen.RiskAssessmentResponse(
                                  overallRisk: 'Medium',
                                  criticalPoints: [
                                    'Buyer defaulting on payments.',
                                    'Construction delays beyond the grace period.',
                                    'Disputes over the quality of construction.',
                                    'Lack of clarity regarding certain aspects of the agreement.',
                                  ],
                                  recommendations: [
                                    'Both parties should seek independent legal advice before signing.',
                                    'The payment schedule and penalty clauses should be carefully reviewed.',
                                    'A detailed construction contract should be prepared and executed separately.',
                                    'The agreement should be registered promptly to provide legal protection.',
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: _buildAnalysisCard(
                          'Risk Assessment',
                          'Potential legal risks and concerns',
                          Icons.warning_amber_outlined,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () async {
                          if (currentDocumentId != null) {
                            try {
                              final clausesData = await fetchDocumentClauses(currentDocumentId!);
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => 
                                      ClausesScreen(clausesData: clausesData),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;
                                    var tween = Tween(begin: begin, end: end).chain(
                                      CurveTween(curve: curve),
                                    );
                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            } catch (e) {
                              print('Error fetching clauses: $e');
                            }
                          }
                        },
                        child: _buildAnalysisCard(
                          'Compliance Check',
                          'Regulatory compliance verification',
                          Icons.verified_outlined,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => summary_screen.SummaryScreen(
                                summaryData: summary_screen.DocumentSummaryResponse(
                                  success: true,
                                  documentId: '1757849820526',
                                  summary: summary_screen.Summary(
                                    overview: 'This is an Agreement of Sale for a residential apartment in a multi-unit building named \'Mayflower Heights\' under construction. The vendor, M/s. Alpine Estates, a registered partnership firm, agrees to sell, and the buyer agrees to purchase, a specific apartment along with a proportionate undivided share in the land and a parking space.',
                                    documentType: 'Agreement of Sale',
                                    parties: 'M/s. Alpine Estates (Vendor) and Mr. [Buyer\'s Name] (Buyer)',
                                    purpose: 'To legally document the sale of a residential apartment and associated land share and parking space in an under-construction building.',
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: _buildAnalysisCard(
                          'Summary',
                          'Executive summary of the document',
                          Icons.summarize_outlined,
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        documentId: currentDocumentId ?? '1757849820526',
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Have any questions for your document? Ask in chat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
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