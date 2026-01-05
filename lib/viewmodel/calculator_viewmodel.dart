import 'package:flutter/material.dart';
import 'package:alp_ml/model/user_input.dart';
import 'package:alp_ml/utils/classifier.dart'; // ✅ UNCOMMENTED THIS so your AI works

// 1. History Model
class HistoryItem {
  final DateTime date;
  final String result;
  final double bmi;
  final Color color;

  HistoryItem({required this.date, required this.result, required this.bmi, required this.color});
}

class CalculatorViewModel extends ChangeNotifier {
  String _result = "Enter details";
  Color _resultColor = Colors.black;

  String get result => _result;
  Color get resultColor => _resultColor;

  // --- HISTORY STATE ---
  List<HistoryItem> _history = [];
  List<HistoryItem> get history => _history;

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

    // Predict - ✅ Uses the real function from classifier.dart
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

    // --- SAVE TO HISTORY ---
    double calculatedBMI = 0;
    if (input.height > 0) {
      calculatedBMI = input.weight / (input.height * input.height);
    }

    _history.insert(0, HistoryItem(
      date: DateTime.now(),
      result: _result,
      bmi: calculatedBMI,
      color: _resultColor
    ));

    notifyListeners();
  }

  Map<String, dynamic> predictOnly(UserInput input) {
    List<double> rawData = input.toList();
    List<double> scaledData = [];

    for (int i = 0; i < rawData.length; i++) {
      double val = (rawData[i] - mean[i]) / scale[i];
      scaledData.add(val);
    }

    List<double> probabilities = score(scaledData);
    int winnerIndex = 0;
    double maxVal = -999.0;
    for (int i = 0; i < probabilities.length; i++) {
      if (probabilities[i] > maxVal) {
        maxVal = probabilities[i];
        winnerIndex = i;
      }
    }

    List<String> labels = ["Insufficient Weight", "Normal Weight", "Obesity Type I", "Obesity Type II", "Obesity Type III", "Overweight Level I", "Overweight Level II"];
    String label = labels[winnerIndex];
    
    Color color;
    if (label == "Obesity Type III") color = Colors.red.shade900;
    else if (label.contains("Obesity")) color = Colors.red;
    else if (label.contains("Overweight")) color = Colors.orange;
    else if (label.contains("Insufficient")) color = Colors.blue;
    else color = Colors.green;

    return {'label': label, 'color': color};
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}