class Complaint {
  final String senderUuid;
  final String receiverUuid;
  final String complaint;
  final List<String> issueCategory;

  Complaint({
    required this.senderUuid,
    required this.receiverUuid,
    required this.complaint,
    required this.issueCategory
  });

  factory Complaint.fromMap(Map<String, dynamic> map) {
    final List<dynamic>? issueCategoryList =
        map['issueCategory'] as List<dynamic>?;
    final List<String> issueCategory =
        issueCategoryList?.map((dynamic item) => item.toString()).toList() ??
            [];

    return Complaint(
      senderUuid: map['senderUuid'],
      receiverUuid: map['receiverUuid'],
      complaint: map['complaint'],
      issueCategory:issueCategory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderUuid': senderUuid,
      'receiverUuid': receiverUuid,
      'complaint': complaint,
      'issueCategory': issueCategory
    };
  }
}
