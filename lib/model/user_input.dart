class UserInput {
  double gender; // 0=Female, 1=Male
  double age;
  double height; // In Meters (e.g. 1.75)
  double weight; // In Kg (e.g. 70)
  double familyHistory; // 0=No, 1=Yes
  double favc; // 0=No, 1=Yes
  double mtrans; // 0=Auto, 1=Bike, 2=Motorbike, 3=Public, 4=Walk

  UserInput({
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.familyHistory,
    required this.favc,
    required this.mtrans,
  });

  // ['Gender', 'Age', 'Height', 'Weight', 'family_history_with_overweight', 'FAVC', 'MTRANS']
  List<double> toList() {
    return [gender, age, height, weight, familyHistory, favc, mtrans];
  }
}