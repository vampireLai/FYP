import '../model/babysitter.dart';

class BabysitterListData {
  static List<Babysitter> listOfBabysitter = [
    Babysitter(
      imagePath: 'images/parentpicture.jpg',
      uuid: '',
      babysitterID: 'qwe123',
      role: 'babysitter',
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
    ),
    Babysitter(
      imagePath: 'images/babysitterpicture.jpg',
      uuid: '',
      babysitterID: 'qwe123',
      role: 'babysitter',
      name: 'Jessie Heng',
      email: 'JessieHeng@gmail.com',
      phoneNumber: '0123346789',
      about:
          'People use social media to stay in touch and interact with friends, family and various communities. Businesses use social applications to market and promote their products and track customer concerns.',
      gender: 'female',
      rate: 10,
      area: 'Perak',
      language: ["English", "Mandarin"],
      location: "At the childcare's",
      daysOfChildcare: ["Weekdays"],
      timeOfChildcare: ["Morning", "Afternoon"],
      age: 25,
      experience: 1,
      experienceOfage: ["Baby", "Toddler"],
    ),
    Babysitter(
      imagePath: 'images/parentpicture.jpg',
      uuid: '',
      babysitterID: 'qwe123',
      role: 'babysitter',
      name: 'Mike Ler',
      email: 'MikeLer@gmail.com',
      phoneNumber: '0128631265',
      about:
          'People use social media to stay in touch and interact with friends, family and various communities. Businesses use social applications to market and promote their products and track customer concerns.',
      gender: 'male',
      rate: 20,
      area: 'Johor',
      language: ["English"],
      location: "At the family",
      daysOfChildcare: ["Weekends"],
      timeOfChildcare: ["Morning", "Evening"],
      age: 30,
      experience: 5,
      experienceOfage: ["Baby"],
    ),
    // Add more reviews here as needed
  ];
}
