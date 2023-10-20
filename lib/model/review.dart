class Review {
  final String senderUuid;
  final String receiverUuid;
  final String review;
  final double rating;

  Review({
    required this.senderUuid,
    required this.receiverUuid,
    required this.review,
    required this.rating,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      senderUuid: map['senderUuid'],
      receiverUuid: map['receiverUuid'],
      review: map['review'],
      rating: (map['rating'] as num).toDouble(),
    );
  }

   Map<String, dynamic> toMap() {
    return {
      'senderUuid': senderUuid,
      'receiverUuid':receiverUuid,
      'review':review,
      'rating': rating
    };
  }
}
