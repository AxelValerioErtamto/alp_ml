import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:alp_ml/viewmodel/calculator_viewmodel.dart';

class HistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final history = context.watch<CalculatorViewModel>().history;

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        // --- HEADER UPDATE ---
        title: Text("HealthBuddy", style: TextStyle(color: Color(0xFF2D3142), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: () => context.read<CalculatorViewModel>().clearHistory(),
          )
        ],
      ),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[300]),
                  SizedBox(height: 10),
                  Text("No history yet", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(20),
              itemCount: history.length,
              separatorBuilder: (_, __) => SizedBox(height: 15),
              itemBuilder: (context, index) {
                final item = history[index];
                return Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 5, height: 50,
                        decoration: BoxDecoration(color: item.color, borderRadius: BorderRadius.circular(5)),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.result, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(DateFormat('MMM dd, hh:mm a').format(item.date), style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text("BMI", style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text(item.bmi.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF2D3142))),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}