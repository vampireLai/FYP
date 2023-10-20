import 'package:kiddie_care_app/model/childcare_centre.dart';

class ChildcareCentreListData {
  static List<ChildcareCentre> listOfChildcareCentre = [
    ChildcareCentre(
        name: 'Happylamb Care Centre',
        uuid: '',
        email: 'happylamb@gmail.com',
        phoneNumber: '053234576',
        childcareID: 'HappyLamb123',
        role: 'childcare centre',
        about:
            "喜羊羊托儿成长园HappyLamb Childcare Learning Garden是一间把童年美好留给孩子的托儿成长园， 以关心儿童为己任，创造一间充满创意教育和欢乐气氛的托儿中心",
        imagePath: 'images/parentpicture.jpg',
        rate: 120,
        area: 'Johor',
        address:
            "NO 45,JALAN INDAH 19/3A,TAMAN BUKIT INDAH, 81200, JOHOR BAHRU, MALAYSIA",
        language: ['English', 'Mandarin', 'Malay'],
        daysOfChildcare: ['Weekdays', 'Weekend'],
        yearOfOperating: 5,
        experienceOfage: ['Baby', 'Toddler', 'Preschooler'],
        childcareProgramme: [
          'Homework',
          'Revision',
          'Nap',
          'Food',
          'Games',
          'Story Time'
        ]),
    ChildcareCentre(
        name: 'JorneyKidz Care Centre',
         uuid: '',
        email: 'JorneyKidz@gmail.com',
        phoneNumber: '053232758',
        childcareID: 'Journey123',
        role: 'childcare centre',
        about:
            "喜羊羊托儿成长园HappyLamb Childcare Learning Garden是一间把童年美好留给孩子的托儿成长园， 以关心儿童为己任，创造一间充满创意教育和欢乐气氛的托儿中心",
        imagePath: 'images/parentpicture.jpg',
        rate: 140,
        area: 'Kuala Lumpur',
        address:
            "522-1，522-2 Jalan E3/8 Taman Ehsan Kepong 52100 KL, Kepong, Malaysia",
        language: ['English', 'Mandarin', 'Malay'],
        daysOfChildcare: ['Weekdays'],
        yearOfOperating: 10,
        experienceOfage: ['Baby', 'Toddler', 'Preschooler'],
        childcareProgramme: ['Homework', 'Revision', 'Nap', 'Food']),
    ChildcareCentre(
        name: 'TreeDolphin Care Centre',
         uuid: '',
        email: 'TreeDolphin@gmail.com',
        phoneNumber: '053230987',
        childcareID: 'Tree123',
        role: 'childcare centre',
        about:
            "喜羊羊托儿成长园HappyLamb Childcare Learning Garden是一间把童年美好留给孩子的托儿成长园， 以关心儿童为己任，创造一间充满创意教育和欢乐气氛的托儿中心",
        imagePath: 'images/parentpicture.jpg',
        rate: 160,
        area: 'Kuala Lumpur',
        address:
            "522-1，522-2 Jalan E3/8 Taman Ehsan Kepong 52100 Ipoh, Perak, Malaysia",
        language: ['English', 'Mandarin', 'Malay'],
        daysOfChildcare: ['Weekdays', 'Weekends'],
        yearOfOperating: 8,
        experienceOfage: ['Baby', 'Toddler', 'Preschooler'],
        childcareProgramme: [
          'Homework',
          'Revision',
          'Nap',
          'Food',
          'Story Time'
        ]),
  ];
}
