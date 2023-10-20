class FilterParentParameters {
  int? rate;
  int? numOfChild;
  String? selectedArea;
  String? location;
  String? typeOfCare;
  List<String>? selectedAgeOfChild;
  List<String>? selectedDayOfChildcare;
  List<String>? selectedTimeOfChildcare;

  FilterParentParameters(
      {this.rate,
      this.numOfChild,
      this.selectedArea,
      this.location,
      this.selectedTimeOfChildcare,
      this.selectedDayOfChildcare,
      this.selectedAgeOfChild,
      this.typeOfCare});
}
