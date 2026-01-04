import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alp_ml/viewmodel/calculator_viewmodel.dart';
import 'package:alp_ml/model/user_input.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // --- COLORS ---
  final Color primaryColor = Color(0xFF2D3142); // Dark Blue
  final Color accentColor = Color(0xFF4F5D75);  // Grey Blue
  final Color highlightColor = Color(0xFFEF8354); // Soft Orange
  final Color bgColor = Color(0xFFF5F7FA);      // Light Grey

  // --- CONTROLLERS ---
  final _ageController = TextEditingController(text: "25");
  final _heightController = TextEditingController(text: "1.70");
  final _weightController = TextEditingController(text: "70");

  // --- STATE VARIABLES ---
  double _gender = 1.0; // 1=Male, 0=Female
  double _familyHistory = 1.0; 
  double _transport = 3.0; 
  double _favc = 1.0; 

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
              // HEADER
              Text("Health Check", style: TextStyle(color: Colors.grey, fontSize: 16)),
              Text("Obesity Predictor", style: TextStyle(color: primaryColor, fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),

              // GENDER SELECTOR (Visual Cards)
              Row(
                children: [
                  _buildGenderCard("Male", Icons.male, 1.0),
                  SizedBox(width: 15),
                  _buildGenderCard("Female", Icons.female, 0.0),
                ],
              ),
              SizedBox(height: 25),

              // BODY METRICS CARD
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
                    _buildInputRow("Height", "Meters", _heightController, Icons.height),
                    Divider(height: 30),
                    _buildInputRow("Weight", "Kg", _weightController, Icons.monitor_weight),
                  ],
                ),
              ),
              SizedBox(height: 25),

              // LIFESTYLE SECTION
              Text("Lifestyle & Habits", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
              SizedBox(height: 15),
              
              _buildSwitchTile("Family History of Overweight?", _familyHistory == 1.0, (val) {
                setState(() => _familyHistory = val ? 1.0 : 0.0);
              }),
              _buildSwitchTile("Frequent High Calorie Food?", _favc == 1.0, (val) {
                setState(() => _favc = val ? 1.0 : 0.0);
              }),
              
              SizedBox(height: 15),
              Text("Main Transportation", style: TextStyle(color: Colors.grey[600])),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<double>(
                    value: _transport,
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down, color: highlightColor),
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

              // CALCULATE BUTTON
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
                    // Gather inputs (using defaults for hidden fields)
                    UserInput input = UserInput(
                      gender: _gender,
                      age: double.tryParse(_ageController.text) ?? 25,
                      height: double.tryParse(_heightController.text) ?? 1.70,
                      weight: double.tryParse(_weightController.text) ?? 70,
                      familyHistory: _familyHistory,
                      favc: _favc,
                      fcvc: 2.0, ncp: 3.0, caec: 2.0, smoke: 0.0,
                      ch2o: 2.0, scc: 0.0, faf: 1.0, tue: 1.0, calc: 3.0, mtrans: _transport
                    );
                    viewModel.predict(input);
                    _showResultModal(context, viewModel);
                  },
                  child: Text("ANALYZE HEALTH", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
            boxShadow: [
              if(isSelected) BoxShadow(color: highlightColor.withOpacity(0.4), blurRadius: 10, offset: Offset(0,5))
            ],
            border: isSelected ? null : Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Icon(icon, size: 40, color: isSelected ? Colors.white : Colors.grey),
              SizedBox(height: 10),
              Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow(String label, String suffix, TextEditingController controller, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: accentColor, size: 24),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: "0",
                ),
              ),
            ],
          ),
        ),
        Text(suffix, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w500))),
          Switch(
            value: value, 
            onChanged: onChanged,
            activeColor: highlightColor,
          ),
        ],
      ),
    );
  }

  // RESULT MODAL (Pop up)
  void _showResultModal(BuildContext context, CalculatorViewModel vm) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(30),
          height: 350,
          child: Column(
            children: [
              Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              SizedBox(height: 30),
              Text("Your Result", style: TextStyle(color: Colors.grey, fontSize: 16)),
              SizedBox(height: 15),
              Text(
                vm.result, 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: vm.resultColor)
              ),
              SizedBox(height: 30),
              // Simple BMI Calc for extra info
              Text("BMI Estimate: ${(double.parse(_weightController.text) / (double.parse(_heightController.text) * double.parse(_heightController.text))).toStringAsFixed(1)}",
                style: TextStyle(fontSize: 18, color: primaryColor)
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                  child: Text("CLOSE"),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}