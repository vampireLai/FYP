class FilterChildcareParameters {
  int? rate;
  int? yearStart;
  String? selectedArea;
  List<String>? selectedExperienceOfage;
  List<String>? selectedDayOfChildcare;
  List<String>? selectedLanguages;

  FilterChildcareParameters({
    this.rate,
    this.yearStart,
    this.selectedArea,
    this.selectedDayOfChildcare,
    this.selectedLanguages,
    this.selectedExperienceOfage
  });
}