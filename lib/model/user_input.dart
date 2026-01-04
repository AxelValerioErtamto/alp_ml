class UserInput {
  double gender; // 0=Female, 1=Male
  double age;
  double height;
  double weight;
  double familyHistory; // 0=No, 1=Yes
  double favc; 
  double fcvc; 
  double ncp;
  double caec;
  double smoke;
  double ch2o;
  double scc;
  double faf;
  double tue;
  double calc;
  double mtrans;

  UserInput({
    required this.gender, required this.age, required this.height,
    required this.weight, required this.familyHistory, required this.favc,
    required this.fcvc, required this.ncp, required this.caec,
    required this.smoke, required this.ch2o, required this.scc,
    required this.faf, required this.tue, required this.calc,
    required this.mtrans
  });

  List<double> toList() {
    return [
      gender, age, height, weight, familyHistory, favc, fcvc, ncp,
      caec, smoke, ch2o, scc, faf, tue, calc, mtrans
    ];
  }
}