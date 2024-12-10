import 'package:call_log_app/helper/helper.dart';
import 'package:call_log_app/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../custom/custom_color.dart';

class ResignationScreen extends StatefulWidget {
  const ResignationScreen({super.key});

  @override
  State<ResignationScreen> createState() => _ResignationScreenState();
}

class _ResignationScreenState extends State<ResignationScreen> {
  String _startDate = "";
  String _endDate = "";

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _startDate = DateFormat('yyyy-MM-dd').format(args.value.startDate);
        _endDate = DateFormat('yyyy-MM-dd')
            .format(args.value.endDate ?? args.value.startDate);
      }
    });
  }

  int _calculateDayDifference(String startDateString, String endDateString) {
    print(_startDate);
    print(_endDate);
    DateTime startDate = DateTime.parse(startDateString);
    DateTime endDate = DateTime.parse(endDateString);

    Duration difference = endDate.difference(startDate);
    return difference.inDays.abs() +
        1; // Add 1 to include both start and end dates
  }

  @override
  void initState() {
    super.initState();
    _startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      appBar: AppBar(
        title: Text('Resignation', style: GoogleFonts.poppins(fontSize: 18)),
        elevation: 0.5,
        backgroundColor: CustomColor.MainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text("Please select Resignation date To Last Working Date:-"),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 0.5),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: SfDateRangePicker(
                      enablePastDates: false,
                      onSelectionChanged: _onSelectionChanged,
                      selectionMode: DateRangePickerSelectionMode.range,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Total Notice Period Of:- ${_calculateDayDifference(_startDate, _endDate)} Days',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 50),
                    backgroundColor: CustomColor.MainColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                onPressed: () {
                  if (_calculateDayDifference != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ));
                  } else {
                    Helper.showSnackBar(
                        context, "PLease Select Dates", Colors.red);
                  }
                },
                child: Text('Submit',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                    )))
          ],
        ),
      ),
    );
  }
}
