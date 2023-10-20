import 'package:flutter/material.dart';
import 'package:kiddie_care_app/pages/Book/pending_card.dart';

class DisplayAcceptedBookingWidget extends StatefulWidget {
  final List<String> uuid; //receiver uuid

  const DisplayAcceptedBookingWidget({super.key, required this.uuid});

  @override
  State<DisplayAcceptedBookingWidget> createState() =>
      _DisplayAcceptedBookingWidgetState();
}

class _DisplayAcceptedBookingWidgetState
    extends State<DisplayAcceptedBookingWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Accepted Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Text('Accepted Booking List',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 15.0),
            if (widget.uuid.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: widget.uuid.length,
                  itemBuilder: (context, index) {
                    final uuid = widget.uuid[index];
                    return PendingCardWidget(uuid: uuid);
                  },
                ),
              )
            else
              const Center(child: Text('No accepted bookings available.')),
          ],
        ),
      ),
    );
  }
}
