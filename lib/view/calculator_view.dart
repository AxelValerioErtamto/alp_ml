import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; 
import 'package:alp_ml/viewmodel/calculator_viewmodel.dart';
import 'package:alp_ml/model/user_input.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // --- COLORS ---
  final Color primaryColor = Color(0xFF2D3142); 
  final Color highlightColor = Color(0xFFEF8354);
  final Color bgColor = Color(0xFFF5F7FA);     

  // --- CONTROLLERS ---
  final _ageController = TextEditingController(text: "25");
  final _heightController = TextEditingController(text: "1.70");
  final _weightController = TextEditingController(text: "70");

  // --- STATE VARIABLES  ---
  double _gender = 1.0; // 1=Male, 0=Female
  double _familyHistory = 1.0; // 1=Yes
  double _favc = 1.0; // 1=Yes (High Calorie Food)
  double _transport = 3.0; // 3=Public Transport

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CalculatorViewModel>(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER (Fixed branding) ---
              Text("HealthBuddy", style: TextStyle(color: primaryColor, fontSize: 32, fontWeight: FontWeight.bold)),
              Text("Obesity Check", style: TextStyle(color: Colors.grey, fontSize: 16)),
              SizedBox(height: 30),

              // GENDER
              Row(
                children: [
                  _buildGenderCard("Male", Icons.male, 1.0),
                  SizedBox(width: 15),
                  _buildGenderCard("Female", Icons.female, 0.0),
                ],
              ),
              SizedBox(height: 25),

              // PHYSICAL INFO
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: Column(
                  children: [
                    _buildInputRow("Age", "Years", _ageController, Icons.calendar_today),
                    Divider(height: 30),
                    // ⚠️ NOTE TO USER: Input METERS here (e.g. 1.75), NOT CM!
                    _buildInputRow("Height", "Meters", _heightController, Icons.height),
                    Divider(height: 30),
                    _buildInputRow("Weight", "Kg", _weightController, Icons.monitor_weight),
                  ],
                ),
              ),
              SizedBox(height: 25),

              // HABITS
              Text("Key Habits", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
              SizedBox(height: 15),
              
              _buildSwitchTile("Family History of Overweight?", _familyHistory == 1.0, (val) => setState(() => _familyHistory = val ? 1.0 : 0.0)),
              _buildSwitchTile("Eat High Calorie Food Often?", _favc == 1.0, (val) => setState(() => _favc = val ? 1.0 : 0.0)),
              
              SizedBox(height: 15),
              Text("Transportation", style: TextStyle(color: Colors.grey[600])),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<double>(
                    value: _transport,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(value: 0.0, child: Text("Automobile")),
                      DropdownMenuItem(value: 1.0, child: Text("Bike")),
                      DropdownMenuItem(value: 2.0, child: Text("Motorbike")),
                      DropdownMenuItem(value: 3.0, child: Text("Public Transport")),
                      DropdownMenuItem(value: 4.0, child: Text("Walking")),
                    ],
                    onChanged: (v) => setState(() => _transport = v!),
                  ),
                ),
              ),

              SizedBox(height: 40),

              // BUTTON
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                  ),
                  onPressed: () {
                    // Create Input
                    UserInput input = UserInput(
                      gender: _gender,
                      age: double.tryParse(_ageController.text) ?? 25,
                      height: double.tryParse(_heightController.text) ?? 1.70,
                      weight: double.tryParse(_weightController.text) ?? 70,
                      familyHistory: _familyHistory,
                      favc: _favc,
                      mtrans: _transport
                    );
                    viewModel.predict(input);
                    _showResultModal(context, viewModel);
                  },
                  child: Text("ANALYZE", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard(String label, IconData icon, double value) {
     bool isSelected = _gender == value;
     return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _gender = value),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected ? highlightColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? null : Border.all(color: Colors.grey.shade200),
          ),
          child: Column(children: [Icon(icon, color: isSelected ? Colors.white : Colors.grey), Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey))]),
        ),
      ),
    );
  }

  Widget _buildInputRow(String label, String suffix, TextEditingController controller, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 24),
        SizedBox(width: 15),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)), TextField(controller: controller, keyboardType: TextInputType.number, decoration: InputDecoration(isDense: true, border: InputBorder.none))])),
        Text(suffix, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title), Switch(value: value, onChanged: onChanged, activeColor: highlightColor)]),
    );
  }

  // --- RESULT MODAL ---
  void _showResultModal(BuildContext context, CalculatorViewModel vm) {
    // 1. Calculate BMI for display
    double weight = double.tryParse(_weightController.text) ?? 0;
    double height = double.tryParse(_heightController.text) ?? 1;
    double bmi = 0;
    if (height > 0) {
      bmi = weight / (height * height);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the modal to take up more space
      backgroundColor: Colors.transparent, // Transparent to show rounded corners
      builder: (context) {
        return Container(
          height: 600, // Taller for better visibility
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)],
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              // Handle Bar
              Container(
                width: 50, height: 5,
                margin: EdgeInsets.only(bottom: 30, top: 10),
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ),

              // AI Prediction Result
              SizedBox(height: 10),
              Text(
                vm.result,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.w800, 
                  color: vm.resultColor
                ),
              ),
              SizedBox(height: 30),

              // BMI Info Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Your BMI", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                        Text("kg/m²", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                      ],
                    ),
                    Text(
                      bmi.toStringAsFixed(1), 
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Brief Advice Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: vm.resultColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: vm.resultColor, size: 20),
                        SizedBox(width: 8),
                        Text("Health Tip", style: TextStyle(fontWeight: FontWeight.bold, color: vm.resultColor)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      _getAdvice(vm.result),
                      style: TextStyle(color: Colors.black87, fontSize: 15, height: 1.4),
                    ),
                  ],
                ),
              ),

              Spacer(),

              // NEW BUTTON: View Tips 
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close modal
                    context.go('/tips'); // Navigate to Tips tab
                  },
                  child: Text("VIEW HEALTH LIBRARY", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 10),

              // Close Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text("CLOSE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  String _getAdvice(String label) {
    if (label.contains("Insufficient")) return "You may be underweight. Focus on nutrient-dense foods and strength training to build muscle mass.";
    if (label.contains("Normal")) return "Great job! Your weight is in a healthy range. Keep up the balanced diet and regular activity.";
    if (label.contains("Overweight")) return "You are slightly above the ideal range. Increasing daily activity and monitoring portion sizes can help.";
    if (label.contains("Obesity")) return "Your health may be at risk. It is highly recommended to consult a healthcare provider for a personalized plan.";
    return "Maintain a healthy lifestyle with balanced nutrition and exercise.";
  }
}