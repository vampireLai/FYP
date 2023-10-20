class ChildcareCentre {
  final String name;
  final String uuid;
  final String email;
  final String phoneNumber;
  final String childcareID;
  final String role;
  final int rate;
  final int yearOfOperating;
  final String about;
  final String? imagePath;
  final String area;
  final String address;
  final List<String> language;
  final List<String> daysOfChildcare;
  final List<String> experienceOfage;
  final List<String> childcareProgramme;

  ChildcareCentre({
    required this.name,
    required this.uuid,
    required this.email,
    required this.phoneNumber,
    required this.yearOfOperating,
    required this.rate,
    required this.childcareID,
    required this.role,
    this.imagePath,
    required this.about,
    required this.area,
    required this.address,
    required this.language,
    required this.daysOfChildcare,
    required this.experienceOfage,
    required this.childcareProgramme,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'childcareID': childcareID,
      'role': role,
      'uuid': uuid,
      'email': email,
      'phoneNumber': phoneNumber,
      'about': about,
      'area': area,
      'rate': rate,
      'address' : address,
      'yearOfOperating' :yearOfOperating,
      'language': language,
      'daysOfChildcare': daysOfChildcare,
      'experienceOfage': experienceOfage,
      'childcareProgramme': childcareProgramme
    };
  }

  factory ChildcareCentre.fromMap(Map<String, dynamic> map) {
    final List<dynamic>? experienceOfageList =
        map['experienceOfage'] as List<dynamic>?;
    final List<String> experienceOfage =
        experienceOfageList?.map((dynamic item) => item.toString()).toList() ??
            [];
    final List<dynamic>? daysOfChildcareList =
        map['daysOfChildcare'] as List<dynamic>?;
    final List<String> daysOfChildcare =
        daysOfChildcareList?.map((dynamic item) => item.toString()).toList() ??
            [];
    final List<dynamic>? languageList = map['language'] as List<dynamic>?;
    final List<String> language =
        languageList?.map((dynamic item) => item.toString()).toList() ?? [];
    final List<dynamic>? childcareProgrammeList =
        map['childcareProgramme'] as List<dynamic>?;
    final List<String> childcareProgramme = childcareProgrammeList
            ?.map((dynamic item) => item.toString())
            .toList() ??
        [];

    return ChildcareCentre(
      name: map['name'],
      uuid: map['uuid'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      imagePath: map['imagePath'],
      about: map['about'],
      childcareID: map['childcareID'],
      role: map['role'],
      rate: map['rate'] as int,
      area: map['area'],
      address: map['address'],
      yearOfOperating: map['yearOfOperating'] as int,
      daysOfChildcare: daysOfChildcare,
      experienceOfage: experienceOfage,
      language: language,
      childcareProgramme: childcareProgramme,
    );
  }
}
