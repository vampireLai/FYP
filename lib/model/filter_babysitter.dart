//gender,age start,age end,area,year start,year end,experience of age,rate,location,
//language,day,time

//year start,area,rate,language,day,age of child

//rate,number of child,age of child,area,location,day,time

class FilterBabysitterParameters {
  int? rate;
  int? ageStart;
  int? yearStart;
  String? gender;
  String? selectedArea;
  String? location;
  List<String>? selectedExperienceOfage;
  List<String>? selectedDayOfChildcare;
  List<String>? selectedTimeOfChildcare;
  List<String>? selectedLanguages;

  FilterBabysitterParameters({
    this.rate,
    this.ageStart,
    this.yearStart,
    this.gender,
    this.selectedArea,
    this.location,
    this.selectedTimeOfChildcare,
    this.selectedDayOfChildcare,
    this.selectedLanguages,
    this.selectedExperienceOfage
  });
}
