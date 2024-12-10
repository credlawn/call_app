import 'dart:io';
import 'package:call_log_app/custom/custom_color.dart';
import 'package:call_log_app/helper/dbhelper.dart';
import 'package:call_log_app/helper/helper.dart';
import 'package:call_log_app/model/offline_form.dart';
import 'package:call_log_app/screens/home_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../custom/custom_text_field.dart';
import '../model/add_lead_bank_model.dart';
import '../network/api_helper.dart';
import 'package:file_picker/file_picker.dart';

enum HouseRadio { own, rented }

enum GenderRadio { Male, Female, Other }

enum SurrogateRadio { Salary, C4C, Cibil, BajajEMI, Floater, ITR }

enum AccHolderRadio { yes, no }

class LeadsFormScreen extends StatefulWidget {
  const LeadsFormScreen(
      {super.key, required this.bankServices, required this.bankName});

  final Services bankServices;
  final String bankName;

  @override
  State<LeadsFormScreen> createState() => _LeadsFormScreenState();
}

class _LeadsFormScreenState extends State<LeadsFormScreen> {
  File? _panCardImg;
  File? _frontAadhar;
  File? _backAadhar;
  File? _salarySlipImg1;
  File? _salarySlipImg2;
  File? _salarySlipImg3;
  File? _customerImg;
  File? _cardStatementImg;
  File? _cardImg;
  File? _ITRImg;
  File? _cibilReportImg;
  File? _bankStatementImg;
  String? imgType = '';
  HouseRadio? _houseRadio = HouseRadio.own;
  GenderRadio? _genderRadio = GenderRadio.Male;
  SurrogateRadio? _surrogateRadio = SurrogateRadio.Salary;
  AccHolderRadio? _accHolderRadio = AccHolderRadio.yes;
  bool _isLoading = false;
  String emailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';

/*  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? _salarySlipImgList = [];*/

  /* void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _salarySlipImgList!.clear(); // Clear the existing images
        _salarySlipImgList!
            .addAll(selectedImages); // Add the newly selected images
      });
    }
    print("Image list length:" + _salarySlipImgList!.length.toString());
  }*/

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _spouseNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _altMobileController = TextEditingController();
  final TextEditingController _qualificationController =
      TextEditingController();
  final TextEditingController _currentAddressController =
      TextEditingController();
  final TextEditingController _parmanentAddressController =
      TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _officeNameController = TextEditingController();
  final TextEditingController _accountNumController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _officeAddressController =
      TextEditingController();
  final TextEditingController _officeLandmarkController =
      TextEditingController();
  final TextEditingController _officeCityController = TextEditingController();
  final TextEditingController _officePinController = TextEditingController();
  final TextEditingController _officeDesignationController =
      TextEditingController();
  final TextEditingController _officeMailController = TextEditingController();
  final TextEditingController _cardLimitController = TextEditingController();
  final TextEditingController _activeLoanAmountController = TextEditingController();
  final TextEditingController _netSalaryController = TextEditingController();
  final TextEditingController _panCardController = TextEditingController();
  final TextEditingController _aadharCardController = TextEditingController();

  Future getImageGallery() async {
    PermissionStatus status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      final imagePicker = ImagePicker();
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          if (imgType == 'pan') {
            _panCardImg = File(pickedFile.path);
          } else if (imgType == 'aadharFront') {
            _frontAadhar = File(pickedFile.path);
          } else if (imgType == 'aadharBack') {
            _backAadhar = File(pickedFile.path);
          } else if (imgType == 'Salary Slip1') {
            _salarySlipImg1 = File(pickedFile.path);

            print('Salary 1 ${_salarySlipImg1!.path}');
          } else if (imgType == 'Salary Slip2') {
            _salarySlipImg2 = File(pickedFile.path);
          } else if (imgType == 'Salary Slip3') {
            _salarySlipImg3 = File(pickedFile.path);
          } else if (imgType == 'customerPhoto') {
            _customerImg = File(pickedFile.path);
          } else if (imgType == 'Bank Statement') {
            _bankStatementImg = File(pickedFile.path);
          } else if (imgType == 'Card Statement') {
            _cardStatementImg = File(pickedFile.path);
          } else if (imgType == 'Card Photo') {
            _cardImg = File(pickedFile.path);
          } else if (imgType == 'Cibil Report') {
            _cibilReportImg = File(pickedFile.path);
          } else if (imgType == 'ITR Upload') {
            _ITRImg = File(pickedFile.path);
          }
        } else {
          print('No image selected.');
        }
      });
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  List<String> selectedFiles = [];

  Future<void> openFilePicker() async {
    List<String> filePaths = [];

    try {
      filePaths = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
      ).then((result) => result!.files.map((e) => e.path!).toList());
    } catch (e) {
      print("Error picking files: $e");
    }

    if (filePaths != null && filePaths.isNotEmpty) {
      setState(() {
        selectedFiles = filePaths;
      });
    } else {
      print("File picking canceled");
    }
  }

  bool isValidEmail(String email) {
    print("email----${email}");
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(email);
    //return RegExp(emailPattern).hasMatch(email);
  }

  Future<void> getImageCamera() async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      final imagePicker = ImagePicker();
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.camera);

      setState(() {
        if (pickedFile != null) {
          if (imgType == 'pan') {
            _panCardImg = File(pickedFile.path);
          } else if (imgType == 'aadharFront') {
            _frontAadhar = File(pickedFile.path);
          } else if (imgType == 'aadharBack') {
            _backAadhar = File(pickedFile.path);
          } else if (imgType == 'Salary Slip1') {
            _salarySlipImg1 = File(pickedFile.path);
          } else if (imgType == 'Salary Slip2') {
            _salarySlipImg2 = File(pickedFile.path);
          } else if (imgType == 'Salary Slip3') {
            _salarySlipImg3 = File(pickedFile.path);
          } else if (imgType == 'customerPhoto') {
            _customerImg = File(pickedFile.path);
          } else if (imgType == 'Bank Statement') {
            _bankStatementImg = File(pickedFile.path);
          } else if (imgType == 'Card Statement') {
            _cardStatementImg = File(pickedFile.path);
          } else if (imgType == 'Card Photo') {
            _cardImg = File(pickedFile.path);
          } else if (imgType == 'Cibil Report') {
            _cibilReportImg = File(pickedFile.path);
          } else if (imgType == 'ITR Upload') {
            _ITRImg = File(pickedFile.path);
          }
        } else {
          print('No image Selected');
        }
      });
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied
      // You can open the app settings to let the user manually enable the camera permission
      openAppSettings();
    }
  }

  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          '${widget.bankName} Lead Form (${widget.bankServices.name})',
          style: TextStyle(fontSize: 14.0),
        ),
        backgroundColor: CustomColor.MainColor,
        actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      submit(0);
                    },
                    child: Text('Save Form'),
                  ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                      child: CustomTextField(
                          keyboardType: TextInputType.text,
                          controller: _firstNameController,
                          label: 'First Name')),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      child: CustomTextField(
                          controller: _middleNameController,
                          label: 'Middle Name')),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  controller: _lastNameController, label: 'Last Name'),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text('Gender :-',
                    style:
                        GoogleFonts.poppins(fontSize: 18, color: Colors.black)),
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      horizontalTitleGap: 0,
                      title: Text(
                        'Male',
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.black),
                      ),
                      leading: Radio<GenderRadio>(
                        value: GenderRadio.Male,
                        groupValue: _genderRadio,
                        onChanged: (GenderRadio? value) {
                          setState(() {
                            _genderRadio = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      horizontalTitleGap: 0,
                      title: Text(
                        'Female',
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.black),
                      ),
                      leading: Radio<GenderRadio>(
                        value: GenderRadio.Female,
                        groupValue: _genderRadio,
                        onChanged: (GenderRadio? value) {
                          setState(() {
                            _genderRadio = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  maxLength: 10,
                  controller: _panCardController,
                  label: 'Pan Card no.'),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: _mobileController,
                label: 'Contact no.',
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: _altMobileController,
                label: 'Alternate no.',
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  controller: _motherNameController, label: 'Mother Name'),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  controller: _spouseNameController, label: 'Spouse Name'),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  controller: _fatherNameController, label: 'Father Name'),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: _qualificationController,
                label: 'Qualification',
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                label: 'Current Address',
                controller: _currentAddressController,
              ),
              const SizedBox(
                height: 10,
              ),
              CheckboxListTile(
                value: checkedValue,
                onChanged: (newValue) {
                  setState(() {
                    checkedValue = newValue!;
                    if (newValue) {
                      _parmanentAddressController.text =
                          _currentAddressController.text;
                    } else {
                      _parmanentAddressController.clear();
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.trailing,
                title:
                    const Text("If current address same as permanent address"),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                label: 'Permanent Address',
                controller: _parmanentAddressController,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: _landmarkController,
                label: 'Land Mark',
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: _cityController,
                label: 'City',
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                maxLength: 6,
                controller: _pinController,
                label: 'Pin Code',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text('House :-',
                    style:
                        GoogleFonts.poppins(fontSize: 18, color: Colors.black)),
              ),
              Row(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                        'Own',
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.black),
                      ),
                      leading: Radio<HouseRadio>(
                        value: HouseRadio.own,
                        groupValue: _houseRadio,
                        onChanged: (HouseRadio? value) {
                          setState(() {
                            _houseRadio = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        'Rented',
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.black),
                      ),
                      leading: Radio<HouseRadio>(
                        value: HouseRadio.rented,
                        groupValue: _houseRadio,
                        onChanged: (HouseRadio? value) {
                          setState(() {
                            _houseRadio = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: _emailController,
                label: 'Personal Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  controller: _officeNameController, label: 'Office Name'),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: _officeAddressController,
                label: 'Office Address',
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: _officeLandmarkController,
                label: 'Office Land Mark',
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: _officeCityController,
                label: 'Office City',
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                maxLength: 6,
                controller: _officePinController,
                keyboardType: TextInputType.number,
                label: 'Office Pin Code',
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  controller: _officeDesignationController,
                  label: 'Designation'),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: _officeMailController,
                label: 'Official Mail Id',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text('Surrogate :-',
                    style:
                        GoogleFonts.poppins(fontSize: 18, color: Colors.black)),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          horizontalTitleGap: 2,
                          title: Text(
                            'Salary',
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.black),
                          ),
                          leading: Radio<SurrogateRadio>(
                            value: SurrogateRadio.Salary,
                            groupValue: _surrogateRadio,
                            onChanged: (SurrogateRadio? value) {
                              setState(() {
                                _surrogateRadio = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          horizontalTitleGap: 2,
                          title: Text(
                            'C4C',
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.black),
                          ),
                          leading: Radio<SurrogateRadio>(
                            value: SurrogateRadio.C4C,
                            groupValue: _surrogateRadio,
                            onChanged: (SurrogateRadio? value) {
                              setState(() {
                                _surrogateRadio = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          horizontalTitleGap: 2,
                          title: Text(
                            'CIBIL',
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.black),
                          ),
                          leading: Radio<SurrogateRadio>(
                            value: SurrogateRadio.Cibil,
                            groupValue: _surrogateRadio,
                            onChanged: (SurrogateRadio? value) {
                              setState(() {
                                _surrogateRadio = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          horizontalTitleGap: 2,
                          title: Text(
                            'Bajaj EMI',
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.black),
                          ),
                          leading: Radio<SurrogateRadio>(
                            value: SurrogateRadio.BajajEMI,
                            groupValue: _surrogateRadio,
                            onChanged: (SurrogateRadio? value) {
                              setState(() {
                                _surrogateRadio = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          horizontalTitleGap: 2,
                          title: Text(
                            'Floater',
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.black),
                          ),
                          leading: Radio<SurrogateRadio>(
                            value: SurrogateRadio.Floater,
                            groupValue: _surrogateRadio,
                            onChanged: (SurrogateRadio? value) {
                              setState(() {
                                _surrogateRadio = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          horizontalTitleGap: 2,
                          title: Text(
                            'ITR',
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.black),
                          ),
                          leading: Radio<SurrogateRadio>(
                            value: SurrogateRadio.ITR,
                            groupValue: _surrogateRadio,
                            onChanged: (SurrogateRadio? value) {
                              setState(() {
                                _surrogateRadio = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Visibility(
                visible: _surrogateRadio != SurrogateRadio.Salary &&
                    _surrogateRadio != SurrogateRadio.Cibil && _surrogateRadio != SurrogateRadio.ITR,
                child: CustomTextField(
                    keyboardType: TextInputType.number,
                    controller: _cardLimitController,
                    label: 'Card Limit'),
              ),
              Visibility(
                visible: _surrogateRadio == SurrogateRadio.Cibil,
                child: CustomTextField(
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    controller: _cardLimitController,
                    label: 'Cibil Score'),
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: _surrogateRadio == SurrogateRadio.ITR,
                child: CustomTextField(
                    keyboardType: TextInputType.number,
                    controller: _cardLimitController,
                    label: 'ITR Value'),
              ),
              Visibility(
                visible: _surrogateRadio != SurrogateRadio.C4C && _surrogateRadio != SurrogateRadio.ITR,
                child: CustomTextField(
                    keyboardType: TextInputType.number,
                    controller: _netSalaryController,
                    label: 'Net Salary'),
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: _surrogateRadio == SurrogateRadio.Cibil,
                child: CustomTextField(
                    keyboardType: TextInputType.number,
                    controller: _activeLoanAmountController,
                    label: 'Active Loan Amount'),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text('HDFC Salary account holder :',
                    style:
                        GoogleFonts.poppins(fontSize: 18, color: Colors.black)),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                        'Yes',
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.black),
                      ),
                      leading: Radio<AccHolderRadio>(
                        value: AccHolderRadio.yes,
                        groupValue: _accHolderRadio,
                        onChanged: (AccHolderRadio? value) {
                          setState(() {
                            _accHolderRadio = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        'No',
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.black),
                      ),
                      leading: Radio<AccHolderRadio>(
                        value: AccHolderRadio.no,
                        groupValue: _accHolderRadio,
                        onChanged: (AccHolderRadio? value) {
                          setState(() {
                            _accHolderRadio = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _accHolderRadio == AccHolderRadio.yes,
                child: Column(
                  children: [
                    CustomTextField(
                        maxLength: 12,
                        keyboardType: TextInputType.number,
                        controller: _accountNumController,
                        label: 'Account no.'),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        maxLength: 12,
                        keyboardType: TextInputType.number,
                        controller: _ifscCodeController,
                        label: 'Ifsc Code'),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //todo: Aadhar card/pan/salary slip/bank statement
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: _surrogateRadio == SurrogateRadio.Salary ||
                        _surrogateRadio == SurrogateRadio.Cibil ||
                        _surrogateRadio == SurrogateRadio.BajajEMI ||
                        _surrogateRadio == SurrogateRadio.Floater ||
                        _surrogateRadio == SurrogateRadio.C4C ||
                        _surrogateRadio == SurrogateRadio.ITR,
                    child: Container(
                      child: Column(children: [
                        ///Pan Card
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Upload PanCard :-',
                              style: GoogleFonts.poppins(
                                  fontSize: 18, color: Colors.black)),
                        ),
                        DottedBorder(
                          dashPattern: const [7, 2],
                          color: CustomColor.MainColor,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(15),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                InkWell(
                                    onTap: () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              Dialog(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      imgType = 'pan';
                                                      getImageCamera();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .MainColor),
                                                    child: const Text(
                                                        'Open Camera'),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      imgType = 'pan';
                                                      getImageGallery();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .MainColor),
                                                    child: const Text(
                                                        'Open Gallery'),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    child: _panCardImg != null
                                        ? Image.file(
                                            _panCardImg!,
                                            height: 60,
                                          )
                                        : Image.asset('assets/img/upload.png',
                                            height: 60)),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Upload Pan Card\nonly pdf, jpeg format \nmax size 5mb',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        Visibility(
                          visible: _surrogateRadio != SurrogateRadio.C4C,
                          child: Column(children: [///Aadhar Card
                            CustomTextField(
                                maxLength: 12,
                                keyboardType: TextInputType.number,
                                controller: _aadharCardController,
                                label: 'Aadhar no.'),
                            const SizedBox(
                              height: 10,
                            ),
                            DottedBorder(
                              dashPattern: const [7, 2],
                              color: CustomColor.MainColor,
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(15),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Text(
                                      'Upload Aadhar Card\nonly pdf, jpeg format \nmax size 5mb',
                                      textAlign: TextAlign.center,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              InkWell(
                                                child: _frontAadhar != null
                                                    ? Image.file(_frontAadhar!,
                                                    height: 60)
                                                    : Image.asset(
                                                  'assets/img/upload.png',
                                                  height: 60,
                                                ),
                                                onTap: () => showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) =>
                                                      Dialog(
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                            MainAxisSize.min,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  imgType =
                                                                  'aadharFront';
                                                                  getImageCamera();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                    backgroundColor:
                                                                    CustomColor
                                                                        .MainColor),
                                                                child: const Text(
                                                                    'Open Camera'),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  imgType =
                                                                  'aadharFront';
                                                                  getImageGallery();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                    backgroundColor:
                                                                    CustomColor
                                                                        .MainColor),
                                                                child: const Text(
                                                                    'Open Gallery'),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                ),
                                              ),
                                              const Text('Front Side')
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              InkWell(
                                                child: _backAadhar != null
                                                    ? Image.file(
                                                  _backAadhar!,
                                                  height: 60,
                                                )
                                                    : Image.asset(
                                                  'assets/img/upload.png',
                                                  height: 60,
                                                ),
                                                onTap: () => showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) =>
                                                      Dialog(
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                            MainAxisSize.min,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  imgType =
                                                                  'aadharBack';
                                                                  getImageCamera();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                    backgroundColor:
                                                                    CustomColor
                                                                        .MainColor),
                                                                child: const Text(
                                                                    'Open Camera'),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  imgType =
                                                                  'aadharBack';
                                                                  getImageGallery();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                    backgroundColor:
                                                                    CustomColor
                                                                        .MainColor),
                                                                child: const Text(
                                                                    'Open Gallery'),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                ),
                                              ),
                                              const Text('Back Side'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),],),
                        ),

                        ///Coustomer Photo
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Upload Customer Photo :-',
                              style: GoogleFonts.poppins(
                                  fontSize: 18, color: Colors.black)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DottedBorder(
                          dashPattern: const [7, 2],
                          color: CustomColor.MainColor,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(15),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                InkWell(
                                    onTap: () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              Dialog(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      imgType = 'customerPhoto';
                                                      getImageCamera();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .MainColor),
                                                    child: const Text(
                                                        'Open Camera'),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      imgType = 'customerPhoto';
                                                      getImageGallery();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .MainColor),
                                                    child: const Text(
                                                        'Open Gallery'),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    child: _customerImg != null
                                        ? Image.file(
                                            _customerImg!,
                                            height: 60,
                                          )
                                        : Image.asset('assets/img/upload.png',
                                            height: 60)),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Upload Photo\nonly pdf, jpeg format \nmax size 5mb',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                    ),
                  ),
                  Visibility(
                    visible: _surrogateRadio == SurrogateRadio.Salary,
                    child: Container(
                      child: Column(children: [
                        ///Salary Slip
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Salary Slip Last 2 Months :-',
                              style: GoogleFonts.poppins(
                                  fontSize: 18, color: Colors.black)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: DottedBorder(
                                dashPattern: const [7, 2],
                                color: CustomColor.MainColor,
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(15),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      InkWell(
                                          onTap: () => showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        Dialog(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            imgType =
                                                                'Salary Slip1';
                                                            getImageCamera();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      CustomColor
                                                                          .MainColor),
                                                          child: const Text(
                                                              'Open Camera'),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            imgType =
                                                                'Salary Slip1';
                                                            getImageGallery();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      CustomColor
                                                                          .MainColor),
                                                          child: const Text(
                                                              'Open Gallery'),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          child: _salarySlipImg1 != null
                                              ? Image.file(
                                                  _salarySlipImg1!,
                                                  height: 60,
                                                )
                                              : Image.asset(
                                                  'assets/img/upload.png',
                                                  height: 60)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            'Upload Salary Slip 1\nonly pdf, jpeg format \nmax size 5mb',
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: DottedBorder(
                                dashPattern: const [7, 2],
                                color: CustomColor.MainColor,
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(15),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      InkWell(
                                          onTap: () => showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        Dialog(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            imgType =
                                                                'Salary Slip2';
                                                            getImageCamera();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      CustomColor
                                                                          .MainColor),
                                                          child: const Text(
                                                              'Open Camera'),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            imgType =
                                                                'Salary Slip2';
                                                            getImageGallery();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      CustomColor
                                                                          .MainColor),
                                                          child: const Text(
                                                              'Open Gallery'),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          child: _salarySlipImg2 != null
                                              ? Image.file(
                                                  _salarySlipImg2!,
                                                  height: 60,
                                                )
                                              : Image.asset(
                                                  'assets/img/upload.png',
                                                  height: 60)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            'Upload Salary Slip 2\nonly pdf, jpeg format \nmax size 5mb',
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: DottedBorder(
                                dashPattern: const [7, 2],
                                color: CustomColor.MainColor,
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(15),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      InkWell(
                                          onTap: () => showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        Dialog(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            imgType =
                                                                'Salary Slip3';
                                                            getImageCamera();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      CustomColor
                                                                          .MainColor),
                                                          child: const Text(
                                                              'Open Camera'),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            imgType =
                                                                'Salary Slip3';
                                                            getImageGallery();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      CustomColor
                                                                          .MainColor),
                                                          child: const Text(
                                                              'Open Gallery'),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          child: _salarySlipImg3 != null
                                              ? Image.file(
                                                  _salarySlipImg3!,
                                                  height: 60,
                                                )
                                              : Image.asset(
                                                  'assets/img/upload.png',
                                                  height: 60)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            'Upload Salary Slip 3\nonly pdf, jpeg format \nmax size 5mb',
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                    ),
                  ),
                  Visibility(
                    visible: _surrogateRadio == SurrogateRadio.Salary,
                    child: Container(
                      child: Column(children: [
                        ///Bank Statement
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Bank Statement :-',
                              style: GoogleFonts.poppins(
                                  fontSize: 18, color: Colors.black)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DottedBorder(
                          dashPattern: const [7, 2],
                          color: CustomColor.MainColor,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(15),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                InkWell(
                                    onTap: () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              Dialog(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      imgType =
                                                          'Bank Statement';
                                                      getImageCamera();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .MainColor),
                                                    child: const Text(
                                                        'Open Camera'),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      imgType =
                                                          'Bank Statement';
                                                      getImageGallery();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .MainColor),
                                                    child: const Text(
                                                        'Open Gallery'),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    child: _bankStatementImg != null
                                        ? Image.file(
                                            _bankStatementImg!,
                                            height: 60,
                                          )
                                        : Image.asset('assets/img/upload.png',
                                            height: 60)),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Upload Bank Statement\nonly pdf, jpeg format \nmax size 5mb',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              //todo: net Salary Remove/card Statement/Card/photo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* Align(
                    alignment: Alignment.topLeft,
                    child: Text('Upload PanCard :-',
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.black)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DottedBorder(
                    dashPattern: const [7, 2],
                    color: CustomColor.MainColor,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(15),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                              onTap: () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                imgType = 'pan';
                                                getImageCamera();
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      CustomColor.MainColor),
                                              child: const Text('Open Camera'),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                imgType = 'pan';
                                                getImageGallery();
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      CustomColor.MainColor),
                                              child: const Text('Open Gallery'),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              child: _panCardImg != null
                                  ? Image.file(
                                      _panCardImg!,
                                      height: 60,
                                    )
                                  : Image.asset('assets/img/upload.png',
                                      height: 60)),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Upload Pan Card\nonly pdf, jpeg format \nmax size 5mb',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text('Upload Photo :-',
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.black)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DottedBorder(
                    dashPattern: const [7, 2],
                    color: CustomColor.MainColor,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(15),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                              onTap: () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                imgType = 'customerPhoto';
                                                getImageCamera();
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      CustomColor.MainColor),
                                              child: const Text('Open Camera'),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                imgType = 'customerPhoto';
                                                getImageGallery();
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      CustomColor.MainColor),
                                              child: const Text('Open Gallery'),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              child: _customerImg != null
                                  ? Image.file(
                                      _customerImg!,
                                      height: 60,
                                    )
                                  : Image.asset('assets/img/upload.png',
                                      height: 60)),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Upload Photo\nonly pdf, jpeg format \nmax size 5mb',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),*/
                  Visibility(
                    visible: _surrogateRadio == SurrogateRadio.C4C ||
                        _surrogateRadio == SurrogateRadio.BajajEMI ||
                        _surrogateRadio == SurrogateRadio.Floater,
                    child: Container(
                      child: Column(children: [
                        ///Card Statement
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Card Statement :-',
                              style: GoogleFonts.poppins(
                                  fontSize: 18, color: Colors.black)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DottedBorder(
                          dashPattern: const [7, 2],
                          color: CustomColor.MainColor,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(15),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                InkWell(
                                    onTap: () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              Dialog(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      imgType =
                                                          'Card Statement';
                                                      getImageCamera();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .MainColor),
                                                    child: const Text(
                                                        'Open Camera'),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      imgType =
                                                          'Card Statement';
                                                      getImageGallery();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .MainColor),
                                                    child: const Text(
                                                        'Open Gallery'),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    child: _cardStatementImg != null
                                        ? Image.file(
                                            _cardStatementImg!,
                                            height: 60,
                                          )
                                        : Image.asset('assets/img/upload.png',
                                            height: 60)),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Upload Card Statement\nonly pdf, jpeg format \nmax size 5mb',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              //todo: card photo/cibil report photo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: _surrogateRadio == SurrogateRadio.BajajEMI ||
                        _surrogateRadio == SurrogateRadio.Floater,
                    child: Container(
                      child: Column(children: [
                        ///Card Photo
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Card Photo :-',
                              style: GoogleFonts.poppins(
                                  fontSize: 18, color: Colors.black)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DottedBorder(
                          dashPattern: const [7, 2],
                          color: CustomColor.MainColor,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(15),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                InkWell(
                                    onTap: () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              Dialog(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      imgType = 'Card Photo';
                                                      getImageCamera();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .MainColor),
                                                    child: const Text(
                                                        'Open Camera'),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      imgType = 'Card Photo';
                                                      getImageGallery();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .MainColor),
                                                    child: const Text(
                                                        'Open Gallery'),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    child: _cardImg != null
                                        ? Image.file(
                                            _cardImg!,
                                            height: 60,
                                          )
                                        : Image.asset('assets/img/upload.png',
                                            height: 60)),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Upload Card Photo\nonly pdf, jpeg format \nmax size 5mb',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                    ),
                  ),
                  Visibility(
                    visible: _surrogateRadio == SurrogateRadio.Cibil,
                    child: Container(
                      child: Column(children: [
                        ///Cibil Report
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Cibil Report :-',
                              style: GoogleFonts.poppins(
                                  fontSize: 18, color: Colors.black)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DottedBorder(
                          dashPattern: const [7, 2],
                          color: CustomColor.MainColor,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(15),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                InkWell(
                                    onTap: () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              Dialog(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      imgType = 'Cibil Report';
                                                      getImageCamera();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .MainColor),
                                                    child: const Text(
                                                        'Open Camera'),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      imgType = 'Cibil Report';
                                                      getImageGallery();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .MainColor),
                                                    child: const Text(
                                                        'Open Gallery'),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    child: _cibilReportImg != null
                                        ? Image.file(
                                            _cibilReportImg!,
                                            height: 60,
                                          )
                                        : Image.asset('assets/img/upload.png',
                                            height: 60)),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Upload Cibil Report\nonly pdf, jpeg format \nmax size 5mb',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              //todo: ITR Upload/
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: _surrogateRadio == SurrogateRadio.ITR,
                    child: Container(
                      child: Column(children: [
                        ///ITR Upload
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('ITR Upload :-',
                              style: GoogleFonts.poppins(
                                  fontSize: 18, color: Colors.black)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DottedBorder(
                          dashPattern: const [7, 2],
                          color: CustomColor.MainColor,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(15),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                InkWell(
                                    onTap: () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              Dialog(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      imgType = 'ITR Upload';
                                                      getImageCamera();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .MainColor),
                                                    child: const Text(
                                                        'Open Camera'),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      imgType = 'ITR Upload';
                                                      getImageGallery();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .MainColor),
                                                    child: const Text(
                                                        'Open Gallery'),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    child: _ITRImg != null
                                        ? Image.file(
                                            _ITRImg!,
                                            height: 60,
                                          )
                                        : Image.asset('assets/img/upload.png',
                                            height: 60)),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Upload ITR Upload\nonly pdf, jpeg format \nmax size 5mb',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 10,
              ),
              _isLoading
                  ? const SpinKitWaveSpinner(
                      color: Colors.blue, // Customize color
                      size: 50.0, // Customize size
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(350, 30),
                          backgroundColor: CustomColor.MainColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        submit(1);
                      },
                      child: Text(
                        'Submit',
                        style: GoogleFonts.openSans(
                          fontSize: 20,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submit(int submitType) async {
    String serviceId = widget.bankServices.id.toString();
    String bankId = widget.bankServices.bankId.toString();
    String firstName = _firstNameController.text;
    String middeleName = _middleNameController.text;
    String lastName = _lastNameController.text;
    String motherName = _motherNameController.text;
    String fatherName = _fatherNameController.text;
    String spouseName = _spouseNameController.text;
    String email = _emailController.text;
    String mobile = _mobileController.text;
    String altMobile = _altMobileController.text;
    String? gender;
    if (_genderRadio.toString() == 'genderRadio.Male') {
      gender = 'Male';
    }
    if (_genderRadio.toString() == 'genderRadio.Female') {
      gender = 'Female';
    }
    String qualification = _qualificationController.text;
    String? hdfcCardHolder;

    if (_accHolderRadio.toString() == 'accHolderRadio.yes') {
      hdfcCardHolder = 'Yes';
    }
    if (_accHolderRadio.toString() == 'accHolderRadio.no') {
      hdfcCardHolder = 'No';
    }

    String currentAddress = _currentAddressController.text;
    String permanentAddress = _parmanentAddressController.text;
    String landMark = _landmarkController.text;
    String city = _cityController.text;
    String pincode = _pinController.text;
    String? house;
    if (_houseRadio.toString() == 'houseRadio.own') {
      house = 'OWN';
    }

    if (_houseRadio.toString() == 'houseRadio.rented') {
      house = 'RENTED';
    }
    String officeName = _officeNameController.text;
    String officeEmail = _officeMailController.text;
    String officeAddress = _officeAddressController.text;
    String officeLandmark = _officeLandmarkController.text;
    String officeCity = _officeCityController.text;
    String officePin = _officePinController.text;
    String officeDesignation = _officeDesignationController.text;
    String? surrogate;
    if (_surrogateRadio == SurrogateRadio.Salary) {
      surrogate = 'Salary';
    }
    if (_surrogateRadio == SurrogateRadio.C4C) {
      surrogate = 'C4C';
    }
    if (_surrogateRadio == SurrogateRadio.Cibil) {
      surrogate = 'Cibil';
    }
    if (_surrogateRadio == SurrogateRadio.BajajEMI) {
      surrogate = 'BajajEMI';
    }
    if (_surrogateRadio == SurrogateRadio.Floater) {
      surrogate = 'RC';
    }
    if (_surrogateRadio == SurrogateRadio.ITR) {
      surrogate = 'ITR';
    }
    String accountNUm = _accountNumController.text;
    String ifscCode = _ifscCodeController.text;
    String cardLimit = _cardLimitController.text;
    String netSalary = _netSalaryController.text;
    String panCard = _panCardController.text;
    String aadharNo = _aadharCardController.text;

    File? panImage = _panCardImg;
    File? aadharFront = _frontAadhar;
    File? aadharBack = _backAadhar;
    File? customerIMG = _customerImg;
    File? salarySlip1 = _salarySlipImg1;
    File? salarySlip2 = _salarySlipImg2;
    File? salarySlip3 = _salarySlipImg3;
    File? cardstatementIMG = _cardStatementImg;
    File? cardIMG = _cardImg;
    File? cibilreportIMG = _cibilReportImg;
    File? itrIMg = _ITRImg;
    File? bankstatementIMG = _bankStatementImg;

    String? check0 = "No";
    String? check1 = "No";
    String? check2 = "No";
    String? check3 = "No";
    String? check4 = "No";
    String? check5 = "No";
    String? check6 = "No";
    String? check7 = "No";
    String? check8 = "No";
    String? check9 = "No";
    String? check10 = "No";
    String? check11 = "No";
    String check12 = 'Yes';

    if (firstName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Enter First Name',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    /* if (middeleName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Enter Middle Name',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }*/
    if (lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Enter Last Name',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    if (mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Enter Mobile no.',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    if (mobile.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Incorrect Mobile Number',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    if (submitType == 1) {
      if (motherName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter Mother Name',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (spouseName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter Spouse Name',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (fatherName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter Father Name',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }

      if (altMobile.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter Alternate Mobile no.',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (altMobile.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Incorrect Alternate Mobile Number',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (qualification.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter Qualification',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (panCard.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter Pan no.',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (panCard.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Incorrect Pan Number',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (currentAddress.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter Current Address',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (landMark.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter landmark',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (city.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter City',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (pincode.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter PinCode',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (pincode.length != 6) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Incorrect Pincode',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter Email',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }

      if (isValidEmail(email) == false) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Invalid Email Address',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (officeName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter Office Name',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (officeAddress.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter Office Address',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (officeLandmark.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter Landmark',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (officeCity.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter Office city',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (officePin.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter Office Pincode',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (officePin.length != 6) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Incorrect Office Pincode',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (officeDesignation.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter Office Designation',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }

      /*   if (officeEmail.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter Office Email',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (isValidEmail(officeEmail) != true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Invalid Office Email Address',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }*/
      if (_surrogateRadio.toString() != 'SurrogateRadio.Salary') {
        print("data---${_surrogateRadio}");
        if (cardLimit.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Enter Card Limit',
            ),
            backgroundColor: Colors.redAccent,
          ));
          return;
        }
      }
      if (_surrogateRadio.toString() != 'SurrogateRadio.C4C') {
        if (netSalary.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Enter Net Salary',
            ),
            backgroundColor: Colors.redAccent,
          ));
          return;
        }
      }

      if (_surrogateRadio.toString() == 'SurrogateRadio.C4C') {
        if (_panCardImg == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Upload Pan Image',
            ),
            backgroundColor: Colors.redAccent,
          ));
          return;
        }
      }
      /*   if (aadharNo.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Enter Aadhar No.',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (aadharNo.length != 12) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Incorrect Aadhar Number',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }

      if (_frontAadhar == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Upload Aadhar Front Side',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }

      if (_backAadhar == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Upload Aadhar Back Side',
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }*/
    }
    setState(() {
      _isLoading = true;
    });
    Map<String, String> body = {
      'bank_id': bankId,
      'service_id': serviceId,
      'name': firstName,
      'middle_name': middeleName,
      'last_name': lastName,
      'mother_name': motherName.isEmpty ? '-' : motherName,
      'account_number': accountNUm,
      'ifsc_code': ifscCode,
      'spouse_name': spouseName.isEmpty ? '-' : spouseName,
      'father_name': fatherName.isEmpty ? '-' : AutofillHints.familyName,
      'email': email.isEmpty ? '-' : email,
      'mobile': mobile,
      'gender': gender ?? 'Male',
      'qualifcation': qualification.isEmpty ? '-' : qualification,
      'hdfc_account_holder': hdfcCardHolder ?? 'No',
      'address[current_address]': currentAddress.isEmpty ? '-' : currentAddress,
      'address[permanent_address]':
          permanentAddress.isEmpty ? '-' : permanentAddress,
      'address[land_mark]': landMark.isEmpty ? '-' : landMark,
      'address[city]': city.isEmpty ? '-' : city,
      'address[pincode]': pincode.isEmpty ? '-' : pincode,
      'address[house]': house ?? 'OWN',
      'office_details[office_name]': officeName.isEmpty ? '-' : officeName,
      'office_details[office_email]': officeEmail.isEmpty ? '-' : officeEmail,
      'office_details[office_address]':
          officeAddress.isEmpty ? '-' : officeAddress,
      'office_details[office_land_mark]':
          officeLandmark.isEmpty ? '-' : officeLandmark,
      'office_details[office_city]':
          officeAddress.isEmpty ? '-' : officeAddress,
      'office_details[office_pincode]': officePin.isEmpty ? '-' : officePin,
      'office_details[office_designation]':
          officeDesignation.isEmpty ? '-' : officeDesignation,
      'office_details[surrogate]': surrogate!,
      'office_details[card_limit]': cardLimit.isEmpty ? '-' : cardLimit,
      'office_details[net_salary]': netSalary.isEmpty ? '-' : netSalary,
      'documents[pan_card]': panCard.isEmpty ? '-' : panCard,
      'documents[adhar_number]': aadharNo.isEmpty ? '-' : aadharNo,
      'checklists[is_pan_card_sign_and_kyc]': check0,
      'checklists[is_kyc_annexure]': check1,
      'checklists[is_address_match_aadhar]': check2,
      'checklists[is_resident_and_office_address_diffrent]': check3,
      'checklists[is_designation_check]': check4,
      'checklists[is_promo_code_and_kyc_check]': check5,
      'checklists[is_salary_slip_and_bank_statement_check]': check6,
      'checklists[is_aadhar_quality_check]': check7,
      'checklists[is_pan_quality_check]': check8,
      'checklists[is_ccstatement_and_ccphotocopy_and_cibilreport_check]':
          check9,
      'checklists[is_active_loan_check]': check10,
      'checklists[is_sarrogate_check]': check11,
      'checklists[is_signature_check]': check12,
      'lead_id': '',
      'submit_type': submitType.toString(),
    };
    String pan = panImage == null ? '' : panImage.path;
    String aadharFrontImg = aadharFront == null ? '' : aadharFront.path;
    String aadharBackImg = aadharBack == null ? '' : aadharBack.path;
    String? customerphoto = customerIMG == null ? '' : _customerImg?.path;
    String? salaryslipIMG1 = salarySlip1 == null ? '' : _salarySlipImg1?.path;
    String? salaryslipIMG2 = salarySlip2 == null ? '' : _salarySlipImg2?.path;
    String? salaryslipIMG3 = salarySlip3 == null ? '' : _salarySlipImg3?.path;
    String? cardstatemenrimg =
        cardstatementIMG == null ? '' : _cardStatementImg?.path;
    String? cardimg = cardIMG == null ? '' : _cardImg?.path;
    String? cibilreportimg =
        cibilreportIMG == null ? '' : _cibilReportImg?.path;
    String? itrimg = itrIMg == null ? '' : _ITRImg?.path;
    String? bankstatementimg =
        bankstatementIMG == null ? '' : _bankStatementImg?.path;
    print("Salary Slippppppp = $salaryslipIMG1");
    ApiHelper.leadForm(
      body,
      pan,
      aadharFrontImg,
      aadharBackImg,
      customerphoto!,
      cardstatemenrimg!,
      cardimg!,
      cibilreportimg!,
      itrimg!,
      bankstatementimg!,
      salaryslipIMG1!,
      salaryslipIMG2!,
      salaryslipIMG3!,
    ).then((value) {
      if (value.status == 1) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
            context: context,
            builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          color: CustomColor.MainColor,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        child: Text(
                          textAlign: TextAlign.center,
                          'Attendance',
                          style: GoogleFonts.poppins(
                              fontSize: 20, color: Colors.white),
                        )),
                    const SizedBox(height: 20.0),
                    Text(
                      '${submitType == 0 ? 'Saved' : 'Submitted'} Successfully',
                      style: GoogleFonts.poppins(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColor.MainColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (route) => false);
                      },
                      child: Text(
                        'Okay',
                        style: GoogleFonts.poppins(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 15)
                  ],
                )));
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Not Submitted'),
          ),
        );
      }
    });
  }

  void saveForm() {
    String serviceId = widget.bankServices.id.toString();
    String bankId = widget.bankServices.bankId.toString();
    String firstName = _firstNameController.text;
    String middeleName = _middleNameController.text;
    String lastName = _lastNameController.text;
    String motherName = _motherNameController.text;
    String fatherName = _fatherNameController.text;
    String spouseName = _spouseNameController.text;
    String email = _emailController.text;
    String mobile = _mobileController.text;
    String altMobile = _altMobileController.text;
    String? gender = 'Male';
    if (_genderRadio.toString() == 'genderRadio.Male') {
      gender = 'Male';
    }
    if (_genderRadio.toString() == 'genderRadio.Female') {
      gender = 'Female';
    }
    String qualification = _qualificationController.text;
    String? hdfcCardHolder = "Yes";

    if (_accHolderRadio.toString() == 'accHolderRadio.yes') {
      hdfcCardHolder = 'Yes';
    }
    if (_accHolderRadio.toString() == 'accHolderRadio.no') {
      hdfcCardHolder = 'No';
    }

    String currentAddress = _currentAddressController.text;
    String landMark = _landmarkController.text;
    String city = _cityController.text;
    String pincode = _pinController.text;
    String? house = "OWN";
    if (_houseRadio.toString() == 'houseRadio.own') {
      house = 'OWN';
    }

    if (_houseRadio.toString() == 'houseRadio.rented') {
      house = 'RENTED';
    }
    String officeName = _officeNameController.text;
    String officeEmail = _officeMailController.text;
    String officeAddress = _officeAddressController.text;
    String officeLandmark = _officeLandmarkController.text;
    String officeCity = _officeCityController.text;
    String officePin = _officePinController.text;
    String officeDesignation = _officeDesignationController.text;
    String? surrogate = "Salary";
    if (_surrogateRadio.toString() == 'surrogateRadio.Salary') {
      surrogate = 'Salary';
    }
    if (_surrogateRadio.toString() == 'surrogateRadio.C4C') {
      surrogate = 'C4C';
    }
    if (_surrogateRadio.toString() == 'surrogateRadio.Cibil') {
      surrogate = 'Cibil';
    }
    if (_surrogateRadio.toString() == 'surrogateRadio.DD19') {
      surrogate = 'DD-19';
    }
    if (_surrogateRadio.toString() == 'surrogateRadio.RC') {
      surrogate = 'RC';
    }
    if (_surrogateRadio.toString() == 'surrogateRadio.ITR') {
      surrogate = 'ITR';
    }

    String cardLimit = _cardLimitController.text;
    String netSalary = _netSalaryController.text;
    String panCard = _panCardController.text;
    String aadharNo = _aadharCardController.text;

    if (firstName.isEmpty) {
      Helper.showSnackBar(context, 'Enter first name', Colors.red);
      return;
    }

    if (lastName.isEmpty) {
      Helper.showSnackBar(context, 'Enter last name', Colors.red);
      return;
    }

    if (mobile.length != 10) {
      Helper.showSnackBar(context, 'Enter mobile no', Colors.red);
      return;
    }
    OfflineForm offlineForm = OfflineForm(
        bankId: bankId,
        serviceId: serviceId,
        firstName: firstName.toString(),
        middleName: middeleName.toString(),
        lastName: lastName.toString(),
        motherName: motherName.toString(),
        mobile: mobile.toString(),
        spouseName: spouseName.toString(),
        fatherName: fatherName.toString(),
        email: email.toString(),
        gender: gender.toString(),
        qualification: qualification.toString(),
        accountHolder: hdfcCardHolder.toString(),
        currentAddress: currentAddress.toString(),
        landmark: landMark.toString(),
        pinCode: pincode.toString(),
        house: house.toString(),
        officeName: officeName.toString(),
        officeEmail: officeEmail.toString(),
        officeLandmark: officeLandmark.toString(),
        officePinCode: officePin.toString(),
        officeDesignation: officeDesignation.toString(),
        surrogate: surrogate.toString(),
        cardLimit: cardLimit.toString(),
        netSalary: netSalary.toString(),
        panCard: panCard.toString(),
        aadharNo: aadharNo.toString(),
        adharBackImage: _backAadhar == null ? '' : _backAadhar!.path.toString(),
        adharFrontImage:
            _frontAadhar == null ? '' : _frontAadhar!.path.toString(),
        panCardImage: _panCardImg == null ? '' : _panCardImg!.path.toString());

    DBHelper.insertCart(offlineForm).then((value) {
      if (value != -1) {
        Helper.showSnackBar(context, 'Saved', Colors.green);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false);
      } else {
        Helper.showSnackBar(context, 'Failed', Colors.red);
      }
    });
  }
}

///TODO:- Multiple Image Selection Code,
/*
class MultipleSelection extends StatefulWidget {
  const MultipleSelection({super.key});

  @override
  State<MultipleSelection> createState() => _MultipleSelectionState();
}
class _MultipleSelectionState extends State<MultipleSelection> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        imageFileList!.clear(); // Clear the existing images
        imageFileList!.addAll(selectedImages); // Add the newly selected images
      });
    }
    print("Image list length:" + imageFileList!.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              selectImages();
            },
            child: Text("Selected Image")),
        SizedBox(
          height: 500,
          child: GridView.builder(
            itemCount: imageFileList!.length,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              return Image.file(
                File(imageFileList![index].path),
                fit: BoxFit.cover,
              );
            },
          ),
        )
      ]),
    );
  }
}*/

///TODO:- Dailoge for image selection.
