class DocumentSummaryResponse {
  final bool success;
  final String documentId;
  final Summary summary;

  DocumentSummaryResponse({
    required this.success,
    required this.documentId,
    required this.summary,
  });

  factory DocumentSummaryResponse.fromJson(Map<String, dynamic> json) {
    return DocumentSummaryResponse(
      success: json['success'] ?? false,
      documentId: json['documentId'] ?? '',
      summary: Summary.fromJson(json['summary']),
    );
  }
}

class Document {
  final String documentId;
  final String fileName;
  final String uploadedAt;
  final Summary summary;

  Document({
    required this.documentId,
    required this.fileName,
    required this.uploadedAt,
    required this.summary,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      documentId: json['documentId'] ?? '',
      fileName: json['fileName'] ?? '',
      uploadedAt: json['uploadedAt'] ?? '',
      summary: Summary.fromJson(json['analysis']['summary']),
    );
  }
}

class RiskAssessmentResponse {
  final bool success;
  final String documentId;
  final RiskAssessment riskAssessment;

  RiskAssessmentResponse({
    required this.success,
    required this.documentId,
    required this.riskAssessment,
  });

  factory RiskAssessmentResponse.fromJson(Map<String, dynamic> json) {
    return RiskAssessmentResponse(
      success: json['success'] ?? false,
      documentId: json['documentId'] ?? '',
      riskAssessment: RiskAssessment.fromJson(json['riskAssessment']),
    );
  }
}

class ClausesResponse {
  final bool success;
  final String documentId;
  final List<Clause> clauses;

  ClausesResponse({
    required this.success,
    required this.documentId,
    required this.clauses,
  });

  factory ClausesResponse.fromJson(Map<String, dynamic> json) {
    return ClausesResponse(
      success: json['success'] ?? false,
      documentId: json['documentId'] ?? '',
      clauses: (json['clauses'] as List? ?? [])
          .map((clause) => Clause.fromJson(clause))
          .toList(),
    );
  }
}

class KeyTermsResponse {
  final bool success;
  final String documentId;
  final List<KeyTerm> keyTerms;

  KeyTermsResponse({
    required this.success,
    required this.documentId,
    required this.keyTerms,
  });

  factory KeyTermsResponse.fromJson(Map<String, dynamic> json) {
    return KeyTermsResponse(
      success: json['success'] ?? false,
      documentId: json['documentId'] ?? '',
      keyTerms: (json['keyTerms'] as List? ?? [])
          .map((term) => KeyTerm.fromJson(term))
          .toList(),
    );
  }
}

class KeyTerm {
  final String term;
  final String explanation;
  final String impact;

  KeyTerm({
    required this.term,
    required this.explanation,
    required this.impact,
  });

  factory KeyTerm.fromJson(Map<String, dynamic> json) {
    return KeyTerm(
      term: json['term'] ?? '',
      explanation: json['explanation'] ?? '',
      impact: json['impact'] ?? '',
    );
  }
}

class Clause {
  final String title;
  final String description;
  final List<String> benefits;
  final List<String> risks;
  final String importance;

  Clause({
    required this.title,
    required this.description,
    required this.benefits,
    required this.risks,
    required this.importance,
  });

  factory Clause.fromJson(Map<String, dynamic> json) {
    return Clause(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      benefits: List<String>.from(json['benefits'] ?? []),
      risks: List<String>.from(json['risks'] ?? []),
      importance: json['importance'] ?? '',
    );
  }
}

class RiskAssessment {
  final String overallRisk;
  final List<String> criticalPoints;
  final List<String> recommendations;

  RiskAssessment({
    required this.overallRisk,
    required this.criticalPoints,
    required this.recommendations,
  });

  factory RiskAssessment.fromJson(Map<String, dynamic> json) {
    return RiskAssessment(
      overallRisk: json['overallRisk'] ?? '',
      criticalPoints: List<String>.from(json['criticalPoints'] ?? []),
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }
}

class Summary {
  final String overview;
  final String documentType;
  final String parties;
  final String purpose;

  Summary({
    required this.overview,
    required this.documentType,
    required this.parties,
    required this.purpose,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      overview: json['overview'] ?? '',
      documentType: json['documentType'] ?? '',
      parties: json['parties'] ?? '',
      purpose: json['purpose'] ?? '',
    );
  }
}
