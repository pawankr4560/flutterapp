class DocumentUploadRequest {
  DocumentUploadRequest({
    required this.applicationId,
    required this.documents,
  });

  final String applicationId;
  final List<LoanDocument> documents;

  Map<String, dynamic> toJson() {
    return {
      'applicationId': applicationId,
      'documents': documents.map((document) => document.toJson()).toList(),
    };
  }
}

class LoanDocument {
  LoanDocument({
    required this.type,
    required this.url,
  });

  final String type;
  final String url;

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'url': url,
    };
  }
}
