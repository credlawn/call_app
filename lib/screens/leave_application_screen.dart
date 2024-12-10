import 'package:call_log_app/helper/helper.dart';
import 'package:call_log_app/network/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../custom/custom_color.dart';

class LeaveApplicationScreen extends StatefulWidget {
  const LeaveApplicationScreen({super.key});

  @override
  State<LeaveApplicationScreen> createState() => _LeaveApplicationScreenState();
}

class _LeaveApplicationScreenState extends State<LeaveApplicationScreen> {
  bool _isLoading = false;
  DateTime selectedDate =
      DateTime.now(); // Set the initial date to the current date

  String selectedDates = '';

  final TextEditingController _messageController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(), // Change this to your desired starting date
      lastDate: DateTime(2101), // Change this to your desired ending date
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  List<DateTime> _selectedDates = [];
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _selectedDates = args.value.cast<DateTime>();
    });
    selectedDates = args.value.toString().replaceAll('00:00:00.000', '');
    print(selectedDate);
  }

  String? selectedLeaveReason;

  List<String> leaveReasons = [
    'Sick Leave',
    'Vacation Leave',
    'Personal Leave',
    'Paid Leave',

  ];

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEE, MMM d').format(selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Apply Leave',
          style: GoogleFonts.poppins(fontSize: 18),
        ),
        elevation: 0.5,
        backgroundColor: CustomColor.MainColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            /*Row(
              children: [
                Text('Select Date :', style: GoogleFonts.poppins(fontSize: 15)),
                const SizedBox(width: 10.0),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        side: const BorderSide(color: Colors.black)),
                    onPressed: () => _selectDate(context),
                    child: Text(formattedDate,
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: CustomColor.MainColor))),
              ],
            ),
            */
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 0.5),
                  borderRadius: BorderRadius.circular(8.0)),
              child: SfDateRangePicker(
                enablePastDates: false,
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.multiple,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  underline: SizedBox(),
                  value: selectedLeaveReason,
                  hint: Text('Select Leave Type'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLeaveReason = newValue;
                    });
                  },
                  items: leaveReasons.map((String reason) {
                    return DropdownMenuItem<String>(
                      value: reason,
                      child: Text(reason),
                    );
                  }).toList(),
                ),
                Text(
                  'Leave For :- ${_selectedDates.length} Days',
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Reason for Leave',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20.0),
            _isLoading
                ? const SpinKitWaveSpinner(
                    color: Colors.blue, // Customize color
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColor.MainColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      if (selectedLeaveReason != null) {
                        leaveApplication();
                      } else {
                        Helper.showSnackBar(
                            context, "Please select a leave Type", Colors.red);
                      }
                    },
                    child: Text(
                      'Submit',
                      style: GoogleFonts.poppins(fontSize: 18),
                    )),
            const SizedBox(height: 15.0),
            // ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //         backgroundColor: CustomColor.MainColor,
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10))),
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => LeaveApplicationListScreen(),
            //           ));
            //     },
            //     child: Text(
            //       'Applications Status',
            //       style: GoogleFonts.poppins(
            //         fontSize: 18,
            //       ),
            //     )),
          ],
        ),
      ),
    );
  }

  Future<void> leaveApplication() async {
    String date = DateFormat('dd-MM-yyyy').format(selectedDate);
    print(date);
    String reason = _messageController.text;
    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Reason can't be blank",
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    if (date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Select Date',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    if (reason.length < 15) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Reasons should be atleast 15 letters',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    setState(() {
      _isLoading = true;
    });
    Map<String, String> body = {'date': selectedDates, 'reason': reason};
    print(body);

    ApiHelper.leaveApplication(body).then((value) {
      setState(() {
        _isLoading = false;
      });
      // print(value.data!.date);
      if (value.status == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Application Submitted Successfully!'),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Application Not Submitted'),
          ),
        );
      }
    });
  }
}
