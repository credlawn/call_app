import 'dart:io';

import 'package:call_log_app/custom/custom_text_field.dart';
import 'package:call_log_app/helper/helper.dart';
import 'package:call_log_app/network/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../custom/custom_color.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  File? _expImg;
  bool _isLoading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String? SelectExpenseType;  // Declare the selected expense type
  List<String> ExpenseType = [  // List of expense types
    'Pending Expense',
    'Total Expense',
    'Vehicle Expense',
    'Travel Expense',
    // Add more leave reasons here
  ];

  // Permission functions for picking images
  Future<void> getImageGallery() async {
    PermissionStatus status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      final imagePicker = ImagePicker();
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _expImg = File(pickedFile.path);
          print(_expImg!.path);
        } else {
          print('No image selected.');
        }
      });
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> getImageCamera() async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      final imagePicker = ImagePicker();
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.camera);

      setState(() {
        if (pickedFile != null) {
          _expImg = File(pickedFile.path);
        } else {
          print('No image Selected');
        }
      });
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: CustomColor.MainColor,
        title: Text('Travel Expense', style: GoogleFonts.poppins()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dropdown for expense type
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: CustomColor.MainColor),
                ),
                child: DropdownButton<String>(
                  underline: SizedBox(),
                  isExpanded: true,
                  value: SelectExpenseType,
                  hint: Text(
                    'Select Expense Type',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      SelectExpenseType = newValue;
                    });
                  },
                  items: ExpenseType.map((String reason) {
                    return DropdownMenuItem<String>(
                      value: reason,
                      child: Text(
                        reason,
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 40.0),
              CustomTextField(label: 'Title', controller: _titleController, enable: true),
              SizedBox(height: 15.0),
              CustomTextField(label: 'Amount', controller: _amountController, keyboardType: TextInputType.number, enable: true),
              const SizedBox(height: 20),
              
              // Upload Bill Section
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: CustomColor.MainColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Upload Bill',
                          style: GoogleFonts.poppins(fontSize: 15, color: CustomColor.MainColor)),
                    ),
                    InkWell(
                      onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: CustomColor.MainColor,
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      topLeft: Radius.circular(25)),
                                ),
                                width: double.infinity,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'Upload Bill',
                                  style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: () {
                                  getImageCamera();
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: CustomColor.MainColor,
                                ),
                                child: Text(
                                  'Open Camera',
                                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: () {
                                  getImageGallery();
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: CustomColor.MainColor,
                                ),
                                child: Text(
                                  'Open Gallery',
                                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                      child: _expImg != null
                          ? Image.file(
                              _expImg!,
                              height: 50,
                            )
                          : Icon(
                              Icons.file_upload_outlined,
                              size: 30,
                              color: CustomColor.MainColor,
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // Submit Button
              _isLoading
                  ? SpinKitWaveSpinner(color: CustomColor.MainColor, waveColor: CustomColor.MainColor)
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 50),
                        backgroundColor: CustomColor.MainColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: () {
                        if (SelectExpenseType != null) {
                          submit();
                        } else {
                          Helper.showSnackBar(context, "Please Select Expense Type", Colors.red);
                        }
                      },
                      child: Text(
                        'Submit',
                        style: GoogleFonts.poppins(fontSize: 20),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Submit Expense Data
  void submit() async {
    String title = _titleController.text.trim();
    String amount = _amountController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter title'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter amount'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_expImg == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Upload Image'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String imgSub = _expImg!.path;

    ApiHelper.addExpense(title, imgSub, amount).then((value) {
      setState(() {
        _isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: value.status == 0 ? Colors.red : Colors.green,
            content: Text(
                value.status == 0 ? 'Not Submitted' : 'Submitted Successfully'),
          ),
        );
      });

      if (value.status == 1) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Not submitted'),
          ),
        );
      }
    });
  }
}
