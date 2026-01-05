import 'package:flutter/material.dart';
import 'package:alp_ml/model/user_input.dart';
import 'package:alp_ml/utils/classifier.dart'; 

class CalculatorViewModel extends ChangeNotifier {
  String _result = "Enter details";
  Color _resultColor = Colors.black;

  String get result => _result;
  Color get resultColor => _resultColor;

  final List<double> mean = [
    0.5065165876777251,  // Gender
    24.310221728672985,  // Age
    1.701758366706161,   // Height
    86.54980778554503,   // Weight
    0.8216824644549763,  // Family History
    0.879739336492891,   // FAVC
    2.3696682464454977   // MTRANS 
  ];
  
  final List<double> scale = [
    0.49995753228153134, // Gender
    6.39074936544153,    // Age
    0.09385622108437008, // Height
    26.045600815498524,  // Weight
    0.38277982191094256, // Family History
    0.325266100785094,   // FAVC
    1.2594023196484065   // MTRANS 
  ];

  void predict(UserInput input) {
    List<double> rawData = input.toList();
    List<double> scaledData = [];

    // Scale
    for (int i = 0; i < rawData.length; i++) {
      double val = (rawData[i] - mean[i]) / scale[i];
      scaledData.add(val);
    }

    // Predict
    List<double> probabilities = score(scaledData);

    // Find Winner
    int winnerIndex = 0;
    double maxVal = -999.0;
    for (int i = 0; i < probabilities.length; i++) {
      if (probabilities[i] > maxVal) {
        maxVal = probabilities[i];
        winnerIndex = i;
      }
    }

    // Labels (Alphabetical Order - Do not change!)
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

    // Colors
    if (finalLabel == "Obesity Type III") {
      _resultColor = Colors.red.shade900;
    } else if (finalLabel.contains("Obesity")) {
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