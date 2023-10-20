class BookPerson {
  final String receiverUuid; // receive booking person uuid
  final String senderUuid;
  String? status; // booking status

  BookPerson({
    required this.receiverUuid,
    required this.senderUuid,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'receiverUuid': receiverUuid,
      'senderUuid': senderUuid,
      'status': status,
    };
  }

  factory BookPerson.fromMap(Map<String, dynamic> map) {
    return BookPerson(
      receiverUuid: map['receiverUuid'],
      senderUuid: map['senderUuid'],
      status: map['status'],
    );
  }
}
