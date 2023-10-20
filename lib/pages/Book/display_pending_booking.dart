import 'package:flutter/material.dart';
import 'package:kiddie_care_app/pages/Book/pending_card.dart';

class DisplayPendingBookingWidget extends StatefulWidget {
  final List<String> uuid; //receiver uuid

  const DisplayPendingBookingWidget({super.key, required this.uuid});

  @override
  State<DisplayPendingBookingWidget> createState() =>
      _DisplayPendingBookingWidgetState();
}

class _DisplayPendingBookingWidgetState
    extends State<DisplayPendingBookingWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Pending Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Text('Pending Booking List',
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
              const Center(child: Text('No pending bookings available.')),
          ],
        ),
      ),
    );
  }
}
