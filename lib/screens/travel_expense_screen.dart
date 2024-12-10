import 'package:call_log_app/custom/custom_color.dart';
import 'package:call_log_app/model/expense_list_model.dart';
import 'package:call_log_app/network/api_helper.dart';
import 'package:call_log_app/screens/add_expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class TravelExpenseScreen extends StatefulWidget {
  const TravelExpenseScreen({super.key});

  @override
  State<TravelExpenseScreen> createState() => _TravelExpenseScreenState();
}

class _TravelExpenseScreenState extends State<TravelExpenseScreen> {
  late Future<ExpenseListModel> _expenseFuture;

  Future<ExpenseListModel> getExpenseList() {
    return ApiHelper.expenseList();
  }

  @override
  void initState() {
    _expenseFuture = getExpenseList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: CustomColor.MainColor,
        // title: Text('Travel Expense', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExpenseScreen(),
                  ));
            },
            child: Text('Add Expense',
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.white)),
          )
        ],
      ),
      body: FutureBuilder<ExpenseListModel>(
        future: _expenseFuture,
        builder: (context, response) {
          if (response.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitWaveSpinner(
                  color: CustomColor.MainColor,
                  waveColor: CustomColor.MainColor),
            );
          }

          if (response.data!.status != 1) {
            return const Center(
              child: Text('Not Connected'),
            );
          }
          List<ExpensePrintData> expenseList = response.data!.data!.data!;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: expenseList.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                        color: Colors.grey.shade400,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              expenseList[index].title ?? '',
                              style: GoogleFonts.poppins(fontSize: 15),
                            ),
                            Text(
                              '₹${expenseList[index].amount ?? ''}',
                              style: GoogleFonts.poppins(
                                  fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        expenseList[index].status ?? '',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: expenseList[index].status == 'Pending'
                                ? Colors.red
                                : Colors.green),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _expenseFuture = getExpenseList();
    });
    return;
  }
}
