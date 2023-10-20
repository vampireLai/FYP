class SavedPerson {
  final String senderUuid;
  final List<String>? savedBabysitter;
  final List<String>? savedChildcareCentre;
  final List<String>? savedParent;

  SavedPerson(
      {required this.senderUuid,
       this.savedBabysitter,
       this.savedChildcareCentre,
       this.savedParent});

  factory SavedPerson.fromMap(Map<String, dynamic> map) {
    final List<dynamic>? savedBabysitterList =
        map['savedBabysitter'] as List<dynamic>?;
    final List<String> savedBabysitter =
        savedBabysitterList?.map((dynamic item) => item.toString()).toList() ??
            [];
    final List<dynamic>? savedChildcareCentreList =
        map['savedChildcareCentre'] as List<dynamic>?;
    final List<String> savedChildcareCentre = savedChildcareCentreList
            ?.map((dynamic item) => item.toString())
            .toList() ??
        [];
    final List<dynamic>? savedParentList =
        map['savedParent'] as List<dynamic>?;
    final List<String> savedParent =
        savedParentList?.map((dynamic item) => item.toString()).toList() ??
            [];

    return SavedPerson(
        senderUuid: map['senderUuid'],
        savedBabysitter: savedBabysitter,
        savedChildcareCentre: savedChildcareCentre,
        savedParent: savedParent
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderUuid': senderUuid,
      'savedBabysitter': savedBabysitter,
      'savedChildcareCentre': savedChildcareCentre,
      'savedParent' : savedParent
    };
  }
}
