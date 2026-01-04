import 'package:flutter/material.dart';
import 'package:alp_ml/model/user_input.dart';
import 'package:alp_ml/utils/classifier.dart'; 

class CalculatorViewModel extends ChangeNotifier {
  String _result = "Enter details to calculate";
  Color _resultColor = Colors.black;

  String get result => _result;
  Color get resultColor => _resultColor;

  final List<double> mean = [ 0.5065165876777251, 24.310221728672985, 1.701758366706161, 86.54980778554503, 0.8216824644549763, 0.879739336492891, 2.4284002079383886, 2.6881334283175353, 1.8613744075829384, 0.021919431279620854, 2.0179650515402847, 0.0462085308056872, 1.0205538560426541, 0.6538996469194313, 2.270734597156398, 2.3696682464454977 ]; 
  final List<double> scale = [ 0.49995753228153134, 6.39074936544153, 0.09385622108437008, 26.045600815498524, 0.38277982191094256, 0.325266100785094, 0.529160066496957, 0.7751064195907824, 0.464090617794761, 0.14642052387557844, 0.6130336509401529, 0.20993642486826117, 0.8473241658283308, 0.6003956142616235, 0.5159047918035656, 1.2594023196484065 ];

  void predict(UserInput input) {
    if (mean.isEmpty || scale.isEmpty) {
      _result = "Error: Scaling lists are empty!";
      notifyListeners();
      return;
    }

    List<double> rawData = input.toList();
    List<double> scaledData = [];

    for (int i = 0; i < rawData.length; i++) {
      double val = (rawData[i] - mean[i]) / scale[i];
      scaledData.add(val);
    }

    // Get Score from Classifier
    List<double> probabilities = score(scaledData);

    // Find the Winner (Highest Probability)
    int winnerIndex = 0;
    double maxVal = -999.0;
    
    for (int i = 0; i < probabilities.length; i++) {
      if (probabilities[i] > maxVal) {
        maxVal = probabilities[i];
        winnerIndex = i;
      }
    }

    // Decode the Result
    List<String> labels = [
      "Insufficient Weight", 
      "Normal Weight", 
      "Obesity Type I", 
      "Obesity Type II", 
      "Obesity Type III", 
      "Overweight Level I", 
      "Overweight Level II"
    ];

    String finalLabel = labels[winnerIndex];
    _result = finalLabel;

    // Set Color based on severity
    if (finalLabel.contains("Obesity")) {
      _resultColor = Colors.red;
    } else if (finalLabel.contains("Overweight")) {
      _resultColor = Colors.orange;
    } else if (finalLabel.contains("Insufficient")) {
      _resultColor = Colors.blue;
    } else {
      _resultColor = Colors.green;
    }

    notifyListeners();
  }
}