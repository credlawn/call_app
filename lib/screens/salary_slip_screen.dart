import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:call_log_app/custom/custom_text_field.dart';
import 'package:call_log_app/helper/helper.dart';
import 'package:call_log_app/network/api_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../custom/custom_color.dart';

class SalarySlipScreen extends StatefulWidget {
  const SalarySlipScreen({super.key});

  @override
  State<SalarySlipScreen> createState() => _SalarySlipScreenState();
}

class _SalarySlipScreenState extends State<SalarySlipScreen> {
  String selectMonth = 'Select Month';
  String month = '';
  String year = '';
  bool isSearching = false;
  final TextEditingController _calendarController = TextEditingController();

  Uint8List? salaryImage;

  void getStoragePermission() async {
    // Request storage permission
    PermissionStatus status = await Permission.storage.request();

    // Handle the permission status
    if (status == PermissionStatus.granted) {
      // Permission granted, proceed with file operations
      writeToFile();
    } else if (status == PermissionStatus.permanentlyDenied) {
      // Permission permanently denied
      print('Permission permanently denied. Prompting user to change settings.');
      openAppSettings();
    } else {
      // Permission denied or other scenarios
      print('Permission denied or limited');
    }
  }

  void writeToFile() async {
    try {
      // Use the Downloads directory from the external storage
      Directory? downloadsDir = await Directory.current;

      // Check if the directory is available
      if (downloadsDir != null) {
        // Define the file path
        String filePath = '${downloadsDir.path}/test.pdf';

        // Create the file instance
        File file = File(filePath);

        // Write data to the file
        await file.writeAsString('Hello, world!');
        print('File written successfully to $filePath');
      } else {
        print('Downloads directory not available');
      }
    } catch (e) {
      // Handle any exceptions that occur during file writing
      print('Error while writing to file: $e');
    }
  }

 //  void getStoragePermission() async {
 //    await Permission.storage.onDeniedCallback(() {
 //    }).onGrantedCallback(() {
 //      // Your code
 //      writeToFile();
 //    }).onPermanentlyDeniedCallback(() {
 //      // Your code
 //    }).onRestrictedCallback(() {
 //      // Your code
 //    }).onLimitedCallback(() {
 //      // Your code
 //    }).onProvisionalCallback(() {
 //      // Your code
 //    }).request();
 //  }
 //
 //  void writeToFile() async {
 //    String path = await AndroidPathProvider.downloadsPath;
 //    final buffer = salaryImage!.buffer;
 // File file =  File('$path/test.pdf');
 //    final result = await file.writeAsBytes(salaryImage!.toList());
 // // .writeAsBytes(buffer.asUint8List(
 // //        salaryImage!.offsetInBytes, salaryImage!.lengthInBytes));
 // print("PATH::${result.path}");
 //  }

  void _selectDate(BuildContext context) async {
    final DateTime? selectedDate =
        await SimpleMonthYearPicker.showMonthYearPickerDialog(
            context: context,
            titleTextStyle: TextStyle(),
            monthTextStyle: TextStyle(),
            yearTextStyle: TextStyle(),
            disableFuture: true
            );

    if (selectedDate != null) {
      final DateFormat dateFormatter = DateFormat('MM-yyyy');

      selectMonth = dateFormatter.format(selectedDate);
      List<String> splitDate = selectMonth.split('-');
      month = splitDate.first;
      year = splitDate.last;
      _calendarController.text = selectMonth;
      print("Month::$month");
      print("Year::$year");

      print('Formatted date: $selectMonth');
      setState(() {});
    } else {
      print('No date was selected.');
    }
  }

  void getSalarySlip() {
    if (_calendarController.text.isEmpty) {
      Helper.showSnackBar(context, " PLease Select Month ", Colors.red);
      return;
    }
    setState(() {
      isSearching = true;
    });
    Map<String, dynamic> body = {
      'month': month,
      'year': year,
    };
    Helper.showLoaderDialog(context);
    ApiHelper.salarySlipDwnld(body).then((value) {
      Navigator.pop(context);
      setState(() {
        salaryImage = value;
      });
      print(salaryImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: CustomColor.MainColor,
          title: Text('Salary Slip', style: GoogleFonts.poppins()),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            const Text("Select Month & Year To Get Pay Slip",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 10),
            // Add spacing between sections
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: CustomTextField(
                        prefixIcon: Icon(CupertinoIcons.calendar),
                        enable: false,
                        controller: _calendarController,
                        hint: "Select Month",
                        label: "Select Month",
                      ),
                    ),
                  )),
                  ElevatedButton(
                    onPressed: () => getSalarySlip(),
                    child: const Text("Search"),
                  ),
                ],
              ),
            ),
            /*Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(selectMonth),
                ),
              ),
              ElevatedButton(
                onPressed: () => getSalarySlip(),
                child: const Text("Search"),
              ),
            ],
          ),*/
            const SizedBox(height: 30),
            const Divider(),
            //  if(salaryImage != null)
            salaryImage == null
                ? SizedBox()
                : Expanded(
                    child: SfPdfViewer.memory(
                    salaryImage!,
                  )),
          ],
        ),
        floatingActionButton: Visibility(
          visible: salaryImage != null,
          child: FloatingActionButton(backgroundColor: Colors.green,
            onPressed: () => getStoragePermission(),
            child: Icon(
              Icons.download,
              color: Colors.white,
            ),
          ),
        ));
  }
}

/*  children: [
            Text("Employee Details:-",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(color: Colors.lightBlue.shade50),
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Name:",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                    Text("Jameel Khan"),
                  ],
                ),
                Divider(thickness: 1, color: Colors.lightBlue.shade100),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Verticel:",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                    Text(""),
                  ],
                ),
                Divider(thickness: 1, color: Colors.lightBlue.shade100),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Date of Joining:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Text("20/04/2024"),
                  ],
                ),
                Divider(thickness: 1, color: Colors.lightBlue.shade100),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Gander:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Text("Male"),
                  ],
                ),
              ]),
            ),
            SizedBox(height: 10,),
            Text("Bank Details:-",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(color: Colors.lightBlue.shade50),
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Bank Name:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Text("State Bank Of India"),
                  ],
                ),
                Divider(thickness: 1, color: Colors.lightBlue.shade100),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Bank Account Number:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Text("52220255220025"),
                  ],
                ),
                Divider(thickness: 1, color: Colors.lightBlue.shade100),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Bank IFSC Code:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Text("SBIN00001234"),
                  ],
                ),
                Divider(thickness: 1, color: Colors.lightBlue.shade100),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "PAN Number:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Text("NSXPS0067N"),
                  ],
                ),
              ]),
            ),
            SizedBox(height: 10,),
            Text("Earnings:-",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(color: Colors.green.shade50),
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Basic Salary:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Text("₹50,000"),
                  ],
                ),
                Divider(thickness: 1, color: Colors.green.shade100),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Commission:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Text("₹5000"),
                  ],
                ),
                Divider(thickness: 1, color: Colors.green.shade100),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Allowance:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Text("₹1000"),
                  ],
                ),
                Divider(thickness: 1, color: Colors.green.shade100),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Special Allowance:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Text("₹3000"),
                  ],
                ),
                Divider(thickness: 1, color: Colors.green.shade100),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Total Earning:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Text("₹59,000"),
                  ],
                ),
              ]),
            ),
            SizedBox(height: 10,),
            Text("Deductions:-",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(color: Colors.red.shade50),
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Health Insurance Cover:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Text("₹10,000"),
                  ],
                ),
                Divider(thickness: 1, color: Colors.red.shade100),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Advance Tax:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Text("₹500"),
                  ],
                ),
                Divider(thickness: 1, color: Colors.red.shade100),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Gratuity:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Text("₹100"),
                  ],
                ),
                Divider(thickness: 1, color: Colors.red.shade100),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Paid Leaves:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Text("₹300"),
                  ],
                ),
                Divider(thickness: 1, color: Colors.red.shade100),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Deductions Total:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Text("₹10,900"),
                  ],
                ),
              ]),
            ),
          ]*/
