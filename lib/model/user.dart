class Parent {
  final String name;
  final String parentID;
  final String uuid;
  final String role;
  final String email;
  final String phoneNumber;
  final String about;
  final String? imagePath;
  final String gender;
  final String area;
  final String typeOfCare;
  final String location;
  final int numOfChild;
  final int rate;
  final List<String> language;
  final List<String> ageOfChild;
  final List<String> daysOfChildcare;
  final List<String> timeOfChildcare;

  Parent(
      {required this.name,
      required this.parentID,
      required this.uuid,
      required this.role,
      required this.email,
      required this.phoneNumber,
      required this.about,
      this.imagePath,
      required this.gender,
      required this.area,
      required this.typeOfCare,
      required this.location,
      required this.numOfChild,
      required this.rate,
      required this.language,
      required this.ageOfChild,
      required this.daysOfChildcare,
      required this.timeOfChildcare});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'parentID': parentID,
      'imagePath': imagePath,
      'role': role,
      'uuid': uuid,
      'email': email,
      'phoneNumber': phoneNumber,
      'about': about,
      'gender': gender,
      'area': area,
      'typeOfCare': typeOfCare,
      'location': location,
      'numOfChild': numOfChild,
      'rate': rate,
      'language': language,
      'ageOfChild': ageOfChild,
      'daysOfChildcare': daysOfChildcare,
      'timeOfChildcare': timeOfChildcare,
    };
  }

  factory Parent.fromMap(Map<String, dynamic> map) {
     final List<dynamic>? daysOfChildcareList =
        map['daysOfChildcare'] as List<dynamic>?;
    final List<String> daysOfChildcare =
        daysOfChildcareList?.map((dynamic item) => item.toString()).toList() ??
            [];
    final List<dynamic>? languageList = map['language'] as List<dynamic>?;
    final List<String> language =
        languageList?.map((dynamic item) => item.toString()).toList() ?? [];
    final List<dynamic>? timeOfChildcareList =
        map['timeOfChildcare'] as List<dynamic>?;
    final List<String> timeOfChildcare =
        timeOfChildcareList?.map((dynamic item) => item.toString()).toList() ??
            [];
    final List<dynamic>? ageOfChildList =
        map['ageOfChild'] as List<dynamic>?;
    final List<String> ageOfChild =
        ageOfChildList?.map((dynamic item) => item.toString()).toList() ??
            [];

    return Parent(
      name: map['name'],
      uuid: map['uuid'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      about: map['about'],
      gender: map['gender'],
      rate: map['rate'] as int,
      area: map['area'],
      parentID: map['parentID'],
      role: map['role'],
      typeOfCare: map['typeOfCare'],
      imagePath: map['imagePath'],
      location: map['location'],
      daysOfChildcare: daysOfChildcare,
      language: language,
      timeOfChildcare: timeOfChildcare,
      ageOfChild: ageOfChild, 
      numOfChild: map['numOfChild'] as int,
    );
  }
}
