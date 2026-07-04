class LoanApplicationRequest {
  LoanApplicationRequest({
    required this.userId,
    required this.fullName,
    required this.dob,
    required this.address,
    required this.panNumber,
    required this.employmentType,
    required this.employerName,
    required this.monthlyIncome,
    required this.workExperience,
    required this.loanType,
    required this.amountRequested,
    required this.tenure,
    required this.purpose,
  });

  final String userId;
  final String fullName;
  final String dob;
  final String address;
  final String panNumber;
  final String employmentType;
  final String employerName;
  final int monthlyIncome;
  final int workExperience;
  final String loanType;
  final int amountRequested;
  final int tenure;
  final String purpose;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'dob': dob,
      'address': address,
      'panNumber': panNumber,
      'employmentType': employmentType,
      'employerName': employerName,
      'monthlyIncome': monthlyIncome,
      'workExperience': workExperience,
      'loanType': loanType,
      'amountRequested': amountRequested,
      'tenure': tenure,
      'purpose': purpose,
    };
  }
}


