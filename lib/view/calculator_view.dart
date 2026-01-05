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
  final Color primaryColor = Color(0xFF2D3142); 
  final Color highlightColor = Color(0xFFEF8354);
  final Color bgColor = Color(0xFFF5F7FA);     

  // --- CONTROLLERS ---
  final _ageController = TextEditingController(text: "25");
  final _heightController = TextEditingController(text : "1.70");
  final _weightController = TextEditingController(text: "70");

  // --- STATE VARIABLES ---
  double _gender = 1.0; 
  double _familyHistory = 1.0; 
  double _favc = 1.0; 
  int _transport = 3; // ✅ Tetap INT agar Dropdown tidak error

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
              Text("HealthBuddy", style: TextStyle(color: primaryColor, fontSize: 32, fontWeight: FontWeight.bold)),
              Text("Obesity Check", style: TextStyle(color: Colors.grey, fontSize: 16)),
              SizedBox(height: 30),

              Row(
                children: [
                  _buildGenderCard("Male", Icons.male, 1.0),
                  SizedBox(width: 15),
                  _buildGenderCard("Female", Icons.female, 0.0),
                ],
              ),
              SizedBox(height: 25),

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
                  child: DropdownButton<int>( // ✅ Gunakan INT
                    value: _transport,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(value: 0, child: Text("Automobile")),
                      DropdownMenuItem(value: 1, child: Text("Bike")),
                      DropdownMenuItem(value: 2, child: Text("Motorbike")),
                      DropdownMenuItem(value: 3, child: Text("Public Transport")),
                      DropdownMenuItem(value: 4, child: Text("Walking")),
                    ],
                    onChanged: (v) => setState(() => _transport = v!),
                  ),
                ),
              ),

              SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    double age = double.tryParse(_ageController.text) ?? 25;
                    double height = double.tryParse(_heightController.text) ?? 1.70;
                    double weight = double.tryParse(_weightController.text) ?? 70;

                    // Error Handling: Jika input terlalu ekstrim, beri peringatan atau batasi
                    if (weight <= 0 || height <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter valid height and weight")),
                      );
                      return;
                    }
                    
                    UserInput input = UserInput(
                      gender: _gender,
                      age: age,
                      height: height,
                      weight: weight,
                      familyHistory: _familyHistory,
                      favc: _favc,
                      mtrans: _transport.toDouble()
                    );;
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

  // --- HELPER WIDGETS ---
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
    double weight = double.tryParse(_weightController.text) ?? 0;
    double height = double.tryParse(_heightController.text) ?? 1.7;
    double bmi = height > 0 ? weight / (height * height) : 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: SingleChildScrollView( // ✅ Hindari overflow
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 50, height: 5, margin: EdgeInsets.only(bottom: 30, top: 10), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                Text(vm.result, textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: vm.resultColor)),
                SizedBox(height: 20),
                
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[200]!)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Your BMI", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)), Text("kg/m²", style: TextStyle(color: Colors.grey[400], fontSize: 12))]),
                      Text(bmi.toStringAsFixed(1), style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(color: vm.resultColor.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Icon(Icons.info_outline, color: vm.resultColor, size: 20), SizedBox(width: 8), Text("Health Tip", style: TextStyle(fontWeight: FontWeight.bold, color: vm.resultColor))]),
                      SizedBox(height: 10),
                      Text(_getAdvice(vm.result), style: TextStyle(color: Colors.black87, fontSize: 15, height: 1.4)),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.psychology_outlined, color: Colors.white),
                    style: ElevatedButton.styleFrom(backgroundColor: highlightColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    onPressed: () {
                      Navigator.pop(context);
                      _showSimulationModal(context, vm, weight, height, _gender, _familyHistory, _favc, _transport, double.tryParse(_ageController.text) ?? 25);
                    },
                    label: Text("WHAT-IF SIMULATION", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    onPressed: () => Navigator.pop(context),
                    child: Text("CLOSE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getAdvice(String label) {
    if (label.contains("Insufficient")) return "Focus on nutrient-dense foods and strength training.";
    if (label.contains("Normal")) return "Great job! Keep up the balanced diet and activity.";
    if (label.contains("Overweight")) return "Try increasing daily activity and monitoring portions.";
    if (label.contains("Obesity")) return "Consult a healthcare provider for a personalized plan.";
    return "Maintain a healthy lifestyle.";
  }

  // --- SIMULATION MODAL ---
  void _showSimulationModal(BuildContext context, CalculatorViewModel vm, double initialWeight, double height, double gender, double famHist, double favc, int trans, double age) {
    double sliderMin = initialWeight < 30 ? initialWeight - 10 : 30;
    double sliderMax = initialWeight > 180 ? initialWeight + 20 : 180;
    
    // Pastikan sliderMin tidak negatif
    if (sliderMin < 5) sliderMin = 0;

    double simWeight = initialWeight;
    double simFavc = favc;
    int simTrans = trans; // ✅ Gunakan INT

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final simInput = UserInput(
              gender: gender, age: age, height: height, 
              weight: simWeight, familyHistory: famHist, 
              favc: simFavc, mtrans: simTrans.toDouble() // ✅ Ubah ke double untuk AI
            );
            final prediction = vm.predictOnly(simInput);

            return Container(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                  SizedBox(height: 20),
                  Text("What-If Simulation", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor)),
                  SizedBox(height: 20),
                  
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: prediction['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: prediction['color'], width: 2),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.auto_awesome, color: prediction['color']),
                        SizedBox(width: 15),
                        Expanded(child: Text(prediction['label'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: prediction['color']))),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),
                  Text("Weight: ${simWeight.toStringAsFixed(1)} Kg", style: TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: simWeight,
                    min: sliderMin,
                    max: sliderMax,
                    activeColor: highlightColor,
                    onChanged: (val) => setModalState(() => simWeight = val),
                  ),

                  _buildSwitchTile("Eat High Calorie Food?", simFavc == 1.0, (val) => setModalState(() => simFavc = val ? 1.0 : 0.0)),

                  SizedBox(height: 10),
                  Text("Transportation", style: TextStyle(color: Colors.grey)),
                  DropdownButton<int>( // ✅ Gunakan INT
                    value: simTrans,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(value: 0, child: Text("Automobile")),
                      DropdownMenuItem(value: 1, child: Text("Bike")),
                      DropdownMenuItem(value: 2, child: Text("Motorbike")),
                      DropdownMenuItem(value: 3, child: Text("Public Transport")),
                      DropdownMenuItem(value: 4, child: Text("Walking")),
                    ],
                    onChanged: (v) => setModalState(() => simTrans = v!),
                  ),

                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      onPressed: () => Navigator.pop(context),
                      child: Text("DONE", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}