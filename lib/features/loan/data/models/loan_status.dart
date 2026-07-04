class LoanStatusStage {
  LoanStatusStage({
    required this.title,
    required this.status,
    this.date,
  });

  final String title;
  final String status;
  final DateTime? date;

  factory LoanStatusStage.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    final rawDate = json['date'];
    if (rawDate is String && rawDate.isNotEmpty) {
      parsedDate = DateTime.tryParse(rawDate);
    }

    return LoanStatusStage(
      title: json['title']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      date: parsedDate,
    );
  }
}

class LoanStatus {
  LoanStatus({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.stepsCompleted,
    required this.stages,
  });

  final String id;
  final String type;
  final double amount;
  final String status;
  final int stepsCompleted;
  final List<LoanStatusStage> stages;

  factory LoanStatus.fromJson(Map<String, dynamic> json) {
    final amountValue = json['amount'];
    final amount = amountValue is num
        ? amountValue.toDouble()
        : double.tryParse('$amountValue') ?? 0.0;

    final stagesJson = json['stages'] as List<dynamic>?;
    final stages = stagesJson == null
        ? <LoanStatusStage>[]
        : stagesJson
            .map((stage) => LoanStatusStage.fromJson(stage as Map<String, dynamic>))
            .toList();

    return LoanStatus(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      amount: amount,
      status: json['status']?.toString() ?? '',
      stepsCompleted: json['stepsCompleted'] is int
          ? json['stepsCompleted'] as int
          : int.tryParse('${json['stepsCompleted']}') ?? 0,
      stages: stages,
    );
  }
}


