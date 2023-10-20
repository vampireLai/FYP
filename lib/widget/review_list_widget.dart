import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../model/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewListWidget extends StatefulWidget {
  final String uuid; //current babysitter

  const ReviewListWidget({super.key, required this.uuid});

  @override
  State<ReviewListWidget> createState() => _ReviewListWidgetState();
}

class _ReviewListWidgetState extends State<ReviewListWidget> {
  Review? review;
  List<Review> reviewList = [];

  @override
  void initState() {
    super.initState();
    // Add a listener to fetch and listen for reviews in real-time
    fetchReviewInfo();
  }

  void fetchReviewInfo() {
    final reviewsRef = FirebaseFirestore.instance
        .collection('reviews')
        .where('receiverUuid', isEqualTo: widget.uuid);

    reviewsRef.snapshots().listen((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final reviews = snapshot.docs.map((doc) {
          final item = doc.data() as Map<String, dynamic>;
          return Review.fromMap(item);
        }).toList();
        setState(() {
          reviewList = reviews;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addReview(Review newReview) {
    setState(() {
      reviewList.add(newReview);
    });
  }

  Future<Map<String, dynamic>> _getSenderInfo(String senderUuid) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {}; // Return empty map if no user is logged in
      }
      String role = ''; // Initialize role
      // Get the role of the current logged-in user
      QuerySnapshot roleSnapshot = await FirebaseFirestore.instance
          .collection('Authentication') // Modify to your authentication table
          .where('uuid', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (roleSnapshot.docs.isNotEmpty) {
        role = (roleSnapshot.docs[0].data() as Map<String, dynamic>?)?['role']
                as String? ??
            '';
      } else {
        return {}; // Return empty map if role not found
      }

      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(role) // Use the role to select the collection
          .where('uuid', isEqualTo: senderUuid)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final item = snapshot.docs[0].data() as Map<String, dynamic>;
        return item;
      } else {
        return {}; // Return empty map if sender info not found
      }
    } catch (e) {
      debugPrint("Error retrieving sender information: $e");
      return {}; // Return empty map in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (reviewList.isEmpty) {
      return const Center(
        child: Text('No reviews'),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: reviewList.map((review) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: FutureBuilder(
                      future: _getSenderInfo(review.senderUuid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text('Error');
                        } else if (snapshot.hasData) {
                          final senderInfo = snapshot.data;
                          // Check if the sender's image URL is available
                          if (senderInfo!.containsKey('imagePath')) {
                            final imageUrl = senderInfo['imagePath'];
                            return CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  imageUrl), // Use NetworkImage here
                            );
                          } else {
                            return Text(senderInfo['name']);
                          }
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    title: FutureBuilder(
                      future: _getSenderInfo(review.senderUuid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text('Error');
                        } else if (snapshot.hasData) {
                          final senderInfo = snapshot.data;
                          return Text(senderInfo?['name']);
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15.0),
                        Row(
                          children: [
                            SmoothStarRating(
                              starCount: 5,
                              rating: review.rating.toDouble(),
                              color: Colors.yellow,
                            ),
                            Text(' ${review.rating}'),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        Text(review.review),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.orange,
                    thickness: 0.8,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
