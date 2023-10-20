class Babysitter {
  final String babysitterID;
  final String uuid;
  final String role;
  final String name;
  final String email;
  final String phoneNumber;
  final String about;
  final String? imagePath; // Nullable for the image path
  final String gender;
  final String area;
  final String location;
  final int rate;
  final int age;
  final int experience;
  final List<String> language;
  final List<String> daysOfChildcare;
  final List<String> timeOfChildcare;
  final List<String> experienceOfage;

  Babysitter({
    required this.name,
    required this.uuid,
    required this.email,
    required this.phoneNumber,
    required this.about,
    required this.gender,
    required this.rate,
    required this.age,
    required this.babysitterID,
    required this.role,
    this.imagePath,
    required this.area,
    required this.language,
    required this.location,
    required this.daysOfChildcare,
    required this.timeOfChildcare,
    required this.experience,
    required this.experienceOfage,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'babysitterID': babysitterID,
      'role': role,
      'uuid': uuid,
      'email': email,
      'phoneNumber': phoneNumber,
      'about': about,
      'gender': gender,
      'area': area,
      'location': location,
      'rate': rate,
      'age' :age,
      'experience': experience,
      'language': language,
      'daysOfChildcare': daysOfChildcare,
      'timeOfChildcare': timeOfChildcare,
      'experienceOfage': experienceOfage
    };
  }

  // Add a factory method to create a Babysitter object from a Map
  factory Babysitter.fromMap(Map<String, dynamic> map) {
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
    final List<dynamic>? timeOfChildcareList =
        map['timeOfChildcare'] as List<dynamic>?;
    final List<String> timeOfChildcare =
        timeOfChildcareList?.map((dynamic item) => item.toString()).toList() ??
            [];

    return Babysitter(
      name: map['name'],
      uuid: map['uuid'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      about: map['about'],
      gender: map['gender'],
      age: map['age'] as int,
      rate: map['rate'] as int,
      area: map['area'],
      babysitterID: map['babysitterID'],
      experience: map['experience'] as int,
      role: map['role'],
      imagePath: map['imagePath'],
      location: map['location'],
      daysOfChildcare: daysOfChildcare,
      experienceOfage: experienceOfage,
      language: language,
      timeOfChildcare: timeOfChildcare,
    );
  }
}
