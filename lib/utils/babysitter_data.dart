import 'package:kiddie_care_app/model/babysitter.dart';
class BabysitterData {
  static Babysitter myBabysitter = Babysitter(
    babysitterID: 'qwe123',
    uuid: '',
    role: 'babysitter',
    imagePath: 'images/parentpicture.jpg',
    name: 'Mary Lee',
    email: 'MaryLee@gmail.com',
    phoneNumber: '0123125678',
    about:
        'People use social media to stay in touch and interact with friends, family and various communities. Businesses use social applications to market and promote their products and track customer concerns.',
    gender: 'female',
    rate: 15,
    area: 'Kuala Lumpur',
    language: ["English", "Mandarin", "Malay"],
    location: "At the childcare's",
    daysOfChildcare: ["Weekdays", "Weekend"],
    timeOfChildcare: ["Morning", "Afternoon", "Evening"],
    age: 29,
    experience: 2,
    experienceOfage: ["Baby", "Toddler", "Preschooler"],
    
  );
}
