import 'package:flutter/material.dart';
import '../../core/models/document.dart';

class ClausesScreen extends StatefulWidget {
  final ClausesResponse clausesData;

  const ClausesScreen({
    Key? key,
    required this.clausesData,
  }) : super(key: key);

  @override
  State<ClausesScreen> createState() => _ClausesScreenState();
}

class _ClausesScreenState extends State<ClausesScreen>
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
      widget.clausesData.clauses.length,
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
      widget.clausesData.clauses.length,
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
              'Key Clauses',
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
                    'Key Clauses',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Important terms and conditions that define your agreement',
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
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final clause = widget.clausesData.clauses[index];
                  return SlideTransition(
                    position: _slideAnimations[index],
                    child: FadeTransition(
                      opacity: _fadeAnimations[index],
                      child: _buildClauseCard(clause, index),
                    ),
                  );
                },
                childCount: widget.clausesData.clauses.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClauseCard(clause, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
                    _getImportanceColor(clause.importance).withOpacity(0.1),
                    _getImportanceColor(clause.importance).withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getImportanceColor(clause.importance),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          clause.importance.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Icon(
                        _getImportanceIcon(clause.importance),
                        color: _getImportanceColor(clause.importance),
                        size: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    clause.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    clause.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSection('Benefits', clause.benefits, Colors.green),
                  const SizedBox(height: 16),
                  _buildSection('Risks', clause.risks, Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  title == 'Benefits' ? Icons.check_circle : Icons.warning,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Color _getImportanceColor(String importance) {
    switch (importance.toLowerCase()) {
      case 'high':
        return const Color(0xFFEF4444);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'low':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getImportanceIcon(String importance) {
    switch (importance.toLowerCase()) {
      case 'high':
        return Icons.priority_high;
      case 'medium':
        return Icons.warning_amber;
      case 'low':
        return Icons.info_outline;
      default:
        return Icons.help_outline;
    }
  }
}