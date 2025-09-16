import 'package:flutter/material.dart';

import '../../../core/models/document.dart';

class SummaryScreen extends StatefulWidget {
  final DocumentSummaryResponse summaryData;

  const SummaryScreen({
    Key? key,
    required this.summaryData,
  }) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimations = List.generate(
      4,
      (index) => Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.6 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      )),
    );

    _fadeAnimations = List.generate(
      4,
      (index) => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.6 + (index * 0.1),
          curve: Curves.easeInOut,
        ),
      )),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Document Summary',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Document Summary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Executive overview and key details of your document',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SlideTransition(
                  position: _slideAnimations[0],
                  child: FadeTransition(
                    opacity: _fadeAnimations[0],
                    child: _buildSummaryCard(
                      'Overview',
                      widget.summaryData.summary.overview,
                      Icons.description,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SlideTransition(
                  position: _slideAnimations[1],
                  child: FadeTransition(
                    opacity: _fadeAnimations[1],
                    child: _buildSummaryCard(
                      'Document Type',
                      widget.summaryData.summary.documentType,
                      Icons.article,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SlideTransition(
                  position: _slideAnimations[2],
                  child: FadeTransition(
                    opacity: _fadeAnimations[2],
                    child: _buildSummaryCard(
                      'Parties Involved',
                      widget.summaryData.summary.parties,
                      Icons.people,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SlideTransition(
                  position: _slideAnimations[3],
                  child: FadeTransition(
                    opacity: _fadeAnimations[3],
                    child: _buildSummaryCard(
                      'Purpose',
                      widget.summaryData.summary.purpose,
                      Icons.flag,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String content, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF3B82F6).withOpacity(0.1),
                    const Color(0xFF3B82F6).withOpacity(0.05),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
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