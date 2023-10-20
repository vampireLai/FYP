import 'package:kiddie_care_app/model/user.dart';

class UserData {
  static Parent myUser = Parent(
    imagePath: 'images/parentpicture.jpg',
    name: 'Lily Ng', 
    email: 'LilyNg@gmail.com',
    parentID: '',
    role: 'parent',
    uuid: '',
    phoneNumber: '0123456789',
    about:
        'People use social media to stay in touch and interact with friends, family and various communities. Businesses use social applications to market and promote their products and track customer concerns.',
    gender: 'female',
    numOfChild: 1,
    ageOfChild: ['Baby','Toddler','Preschooler'],
    rate: 15,
    area: 'Kuala Lumpur',
    typeOfCare: 'babysitter',
    language: ['English','Mandarin','Malay'],
    location: "At the childcare's",
    daysOfChildcare: ['Weekdays','Weekend'],
    timeOfChildcare: ['Morning','Afternoon','Evening']
  );
}
