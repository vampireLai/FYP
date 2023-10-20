import 'bookperson.dart';

class BookingList {
  final String senderUuid; //send booking person uuid
  final List<BookPerson> bookedPersonList;

  BookingList({
    required this.senderUuid,
    required this.bookedPersonList
  });

  Map<String, dynamic> toMap() {
    return {
      'senderUuid': senderUuid,
      'bookedPersonList': bookedPersonList,
    };
  }
  
  factory BookingList.fromMap(Map<String, dynamic> map) {
    final List<dynamic> bookedPersonListData = map['bookedPersonList'];
    final List<BookPerson> bookedPersonList = bookedPersonListData
        .map((bookPersonData) => BookPerson.fromMap(bookPersonData))
        .toList();

    return BookingList(
      senderUuid: map['senderUuid'],
      bookedPersonList: bookedPersonList,
    );
  }

}
