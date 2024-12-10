import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../custom/custom_color.dart';
import '../custom/custom_text_field.dart';
import '../model/add_lead_bank_model.dart';
import '../model/checklist_model.dart';
import '../model/lead_status_model.dart';
import '../network/api_helper.dart';
import 'home_screen.dart';

enum HouseRadio { own, rented }

enum GenderRadio { Male, Female, Other }

enum SurrogateRadio { Salary, C4C, Cibil, DD19, RC, ITR }

enum AccHolderRadio { yes, no }

class ApplyAnotherBank extends StatefulWidget {
  const ApplyAnotherBank({
    super.key,
    required this.bankServices,
    required this.bankName,
    this.leadStatusData, required this.leadId,
  });

  final LeadStatusData? leadStatusData;
  final Services bankServices;
  final String bankName;
  final String leadId;

  @override
  State<ApplyAnotherBank> createState() => _ApplyAnotherBankState();
}

class _ApplyAnotherBankState extends State<ApplyAnotherBank> {
  File? _panCardImg;
  File? _frontAadhar;
  File? _backAadhar;
  String? imgType = '';
  HouseRadio? _houseRadio = HouseRadio.own;
  GenderRadio? _genderRadio = GenderRadio.Male;
  SurrogateRadio? _surrogateRadio = SurrogateRadio.Salary;
  AccHolderRadio? _accHolderRadio = AccHolderRadio.yes;
  bool _isLoading = false;
  String emailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';

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
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _officeNameController = TextEditingController();
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
  final TextEditingController _netSalaryController = TextEditingController();
  final TextEditingController _panCardController = TextEditingController();
  final TextEditingController _aadharCardController = TextEditingController();

  List<CheckListModel> checkListModel = [
    CheckListModel(
        title: "Pan card Sign & PAN no. match with all forms & KYC's",
        isCheck: false),
    CheckListModel(
        title: 'KYC  Annexure Check (with Aadhar Last 4 digit)',
        isCheck: false),
    CheckListModel(title: 'Address match with Aadhar card', isCheck: false),
    CheckListModel(
        title: 'Residential & office Address should be different',
        isCheck: false),
    CheckListModel(title: 'Designation check', isCheck: false),
    CheckListModel(
        title: 'Promo code Match with all forms & KYC', isCheck: false),
    CheckListModel(title: 'Salary Slip & Bank statement check', isCheck: false),
    CheckListModel(title: 'Aadhar Card Quality check', isCheck: false),
    CheckListModel(title: 'Pan card quality check', isCheck: false),
    CheckListModel(
        title: 'CC Statement/ CC Photocopy/ CIBIL Report', isCheck: false),
    CheckListModel(
        title: 'Active Loan details (In case active loan required in CIBIL)',
        isCheck: false),
    CheckListModel(
        title: 'Sarrogate check (correct card source)', isCheck: false),
  ];

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
          }
        } else {
          print('No image selected.');
        }
      });
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
  bool isValidEmail(String email) {
    return RegExp(emailPattern).hasMatch(email);
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

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.leadStatusData!.name ?? '';
    _middleNameController.text = widget.leadStatusData!.middleName ?? '';
    _lastNameController.text = widget.leadStatusData!.lastName ?? '';
    if (widget.leadStatusData!.gender == 'Male') {
      _genderRadio = GenderRadio.Male;
    }
    if (widget.leadStatusData!.gender == 'Female') {
      _genderRadio = GenderRadio.Female;
    }
    _motherNameController.text = widget.leadStatusData!.motherName ?? '';
    _spouseNameController.text = widget.leadStatusData!.spouseName ?? '';
    _fatherNameController.text = widget.leadStatusData!.fatherName ?? '';
    _mobileController.text = widget.leadStatusData!.mobile ?? '';
    _altMobileController.text = widget.leadStatusData!.alternateMobile ?? '';
    _qualificationController.text = widget.leadStatusData!.qualifcation ?? '';
    _panCardController.text = widget.leadStatusData!.documents!.panCard ?? '';
    _currentAddressController.text =
        widget.leadStatusData!.address!.currentAddress ?? '';
    _landmarkController.text = widget.leadStatusData!.address!.landMark ?? '';
    _cityController.text = widget.leadStatusData!.address!.city ?? '';
    _pinController.text = widget.leadStatusData!.address!.pincode ?? '';
    if (widget.leadStatusData!.address!.house == 'OWN') {
      _houseRadio = HouseRadio.own;
    }
    if (widget.leadStatusData!.address!.house == 'RENTED') {
      _houseRadio = HouseRadio.rented;
    }
    _emailController.text = widget.leadStatusData!.email ?? '';
    _officeNameController.text =
        widget.leadStatusData!.officeDetails!.officeName ?? '';
    _officeAddressController.text =
        widget.leadStatusData!.officeDetails!.officeEmail ?? '';
    _officeLandmarkController.text =
        widget.leadStatusData!.officeDetails!.officeLandMark ?? '';
    _officeCityController.text =
        widget.leadStatusData!.officeDetails!.officeCity ?? '';
    _officePinController.text =
        widget.leadStatusData!.officeDetails!.officePincode ?? '';
    _officeDesignationController.text =
        widget.leadStatusData!.officeDetails!.officeDesignation ?? '';
    _officeMailController.text =
        widget.leadStatusData!.officeDetails!.officeEmail ?? '';
    if (widget.leadStatusData!.officeDetails!.surrogate == 'Salary') {
      _surrogateRadio = SurrogateRadio.Salary;
    }
    if (widget.leadStatusData!.officeDetails!.surrogate == 'C4C') {
      _surrogateRadio = SurrogateRadio.C4C;
    }
    if (widget.leadStatusData!.officeDetails!.surrogate == 'Cibil') {
      _surrogateRadio = SurrogateRadio.Cibil;
    }
    if (widget.leadStatusData!.officeDetails!.surrogate == 'DD19') {
      _surrogateRadio = SurrogateRadio.DD19;
    }
    if (widget.leadStatusData!.officeDetails!.surrogate == 'RC') {
      _surrogateRadio = SurrogateRadio.RC;
    }
    if (widget.leadStatusData!.officeDetails!.surrogate == 'ITR') {
      _surrogateRadio = SurrogateRadio.ITR;
    }
    _cardLimitController.text =
        widget.leadStatusData!.officeDetails!.cardLimit ?? '';
    _netSalaryController.text =
        widget.leadStatusData!.officeDetails!.netSalary ?? '';
    if (widget.leadStatusData!.hdfcAccountHolder == 'Yes') {
      _accHolderRadio = AccHolderRadio.yes;
    } else {
      _accHolderRadio = AccHolderRadio.no;
    }
    _aadharCardController.text = widget.leadStatusData!.documents!.adharNumber??'';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('${widget.bankName}(${widget.bankServices.name})'),
        backgroundColor: CustomColor.MainColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: CustomTextField(
                        keyboardType: TextInputType.text,
                        controller: _firstNameController,
                        label: 'First Name')),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: CustomTextField(
                        controller: _middleNameController,
                        label: 'Middle Name')),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
                controller: _lastNameController, label: 'Last Name'),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text('Gender :',
                  style: GoogleFonts.poppins(
                      fontSize: 18, color: CustomColor.MainColor)),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ListTile(
                    horizontalTitleGap: 2,
                    title: Text(
                      'Male',
                      style: GoogleFonts.poppins(
                          fontSize: 18, color: CustomColor.MainColor),
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
                    horizontalTitleGap: 2,
                    title: Text(
                      'Female',
                      style: GoogleFonts.poppins(
                          fontSize: 18, color: CustomColor.MainColor),
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
              height: 15,
            ),
            CustomTextField(
                controller: _motherNameController, label: 'Mother Name'),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
                controller: _spouseNameController, label: 'Spouse Name'),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
                controller: _fatherNameController, label: 'Father Name'),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: _mobileController,
                label: 'Contact no.',
                prefixIcon: const Icon(CupertinoIcons.phone)),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: _altMobileController,
                label: 'Alternate no.',
                prefixIcon: const Icon(CupertinoIcons.phone)),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              controller: _qualificationController,
              label: 'Qualification',
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
                maxLength: 10,
                controller: _panCardController,
                label: 'Pan Card no.'),
            const SizedBox(
              height: 15,
            ),
            DottedBorder(
              dashPattern: const [7, 2],
              borderType: BorderType.RRect,
              radius: const Radius.circular(15),
              color: CustomColor.MainColor,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                            : Image.asset('assets/img/upload.png', height: 60)),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Upload Pan Card',
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
            CustomTextField(
              label: 'Current Address',
              controller: _currentAddressController,
              prefixIcon: const Icon(CupertinoIcons.location_solid),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              controller: _landmarkController,
              label: 'Land Mark',
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              controller: _cityController,
              label: 'City',
              prefixIcon: const Icon(Icons.location_city),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              maxLength: 6,
              controller: _pinController,
              label: 'Pin Code',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text('House :',
                  style: GoogleFonts.poppins(
                      fontSize: 18, color: CustomColor.MainColor)),
            ),
            Row(
              //mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(
                      'Own',
                      style: GoogleFonts.poppins(
                          fontSize: 18, color: CustomColor.MainColor),
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
                          fontSize: 18, color: CustomColor.MainColor),
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
              height: 15,
            ),
            CustomTextField(
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
                controller: _officeNameController, label: 'Office Name'),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              controller: _officeAddressController,
              label: 'Office Address',
              prefixIcon: const Icon(CupertinoIcons.location_solid),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              controller: _officeLandmarkController,
              label: 'Office Land Mark',
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              controller: _officeCityController,
              label: 'Office City',
              prefixIcon: const Icon(Icons.location_city),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              maxLength: 6,
              controller: _officePinController,
              keyboardType: TextInputType.number,
              label: 'Office Pin Code',
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
                controller: _officeDesignationController, label: 'Designation'),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              controller: _officeMailController,
              label: 'Official Mail Id',
              prefixIcon: const Icon(Icons.email_outlined),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text('Surrogate :',
                  style: GoogleFonts.poppins(
                      fontSize: 18, color: CustomColor.MainColor)),
            ),
            Container(
              child: Column(
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
                                fontSize: 18, color: CustomColor.MainColor),
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
                                fontSize: 18, color: CustomColor.MainColor),
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
                                fontSize: 18, color: CustomColor.MainColor),
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
                            'DD-19',
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: CustomColor.MainColor),
                          ),
                          leading: Radio<SurrogateRadio>(
                            value: SurrogateRadio.DD19,
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
                            'RC',
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: CustomColor.MainColor),
                          ),
                          leading: Radio<SurrogateRadio>(
                            value: SurrogateRadio.RC,
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
                                fontSize: 18, color: CustomColor.MainColor),
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
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
                keyboardType: TextInputType.number,
                controller: _cardLimitController,
                label: 'Card Limit'),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
                keyboardType: TextInputType.number,
                controller: _netSalaryController,
                label: 'Net Salary'),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text('HDFC Salary account holder :',
                  style: GoogleFonts.poppins(
                      fontSize: 18, color: CustomColor.MainColor)),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(
                      'Yes',
                      style: GoogleFonts.poppins(
                          fontSize: 18, color: CustomColor.MainColor),
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
                          fontSize: 18, color: CustomColor.MainColor),
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
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
                maxLength: 12,
                keyboardType: TextInputType.number,
                controller: _aadharCardController,
                label: 'Aadhar no.'),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 15,
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
                      'Upload Aadhar Card',
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              InkWell(
                                child: _frontAadhar != null
                                    ? Image.file(_frontAadhar!, height: 60)
                                    : Image.asset(
                                        'assets/img/upload.png',
                                        height: 60,
                                      ),
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
                                              imgType = 'aadharFront';
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
                                              imgType = 'aadharFront';
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
                                              imgType = 'aadharBack';
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
                                              imgType = 'aadharBack';
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
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: checkListModel.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(child: Text(checkListModel[index].title!)),
                      Checkbox(
                        checkColor: Colors.white,
                        value: checkListModel[index].isCheck,
                        onChanged: (bool? value) {
                          setState(() {
                            checkListModel[index].isCheck =
                                !checkListModel[index].isCheck!;
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: _isLoading
                  ? const SpinKitWaveSpinner(
                      color: Colors.blue, // Customize color
                      size: 50.0, // Customize size
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColor.MainColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        submit();
                      },
                      child: Text(
                        'Submit',
                        style: GoogleFonts.openSans(
                          fontSize: 22,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> submit() async {
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

    File? panImage = _panCardImg;
    File? aadharFront = _frontAadhar;
    File? aadharBack = _backAadhar;

    String? check0;
    String? check1;
    String? check2;
    String? check3;
    String? check4;
    String? check5;
    String? check6;
    String? check7;
    String? check8;
    String? check9;
    String? check10;
    String? check11;
    String check12 = 'Yes';

    if (checkListModel[0].isCheck!) {
      check0 = 'Yes';
    } else {
      check0 = 'No';
    }

    if (checkListModel[1].isCheck!) {
      check1 = 'Yes';
    } else {
      check1 = 'No';
    }

    if (checkListModel[2].isCheck!) {
      check2 = 'Yes';
    } else {
      check2 = 'No';
    }

    if (checkListModel[3].isCheck!) {
      check3 = 'Yes';
    } else {
      check3 = 'No';
    }

    if (checkListModel[4].isCheck!) {
      check4 = 'Yes';
    } else {
      check4 = 'No';
    }

    if (checkListModel[5].isCheck!) {
      check5 = 'Yes';
    } else {
      check5 = 'No';
    }

    if (checkListModel[6].isCheck!) {
      check6 = 'Yes';
    } else {
      check6 = 'No';
    }

    if (checkListModel[7].isCheck!) {
      check7 = 'Yes';
    } else {
      check7 = 'No';
    }

    if (checkListModel[8].isCheck!) {
      check8 = 'Yes';
    } else {
      check8 = 'No';
    }

    if (checkListModel[9].isCheck!) {
      check9 = 'Yes';
    } else {
      check9 = 'No';
    }

    if (checkListModel[10].isCheck!) {
      check10 = 'Yes';
    } else {
      check10 = 'No';
    }

    if (checkListModel[11].isCheck!) {
      check11 = 'Yes';
    } else {
      check11 = 'No';
    }
    if (firstName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Enter First Name',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    if (middeleName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Enter Middle Name',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    if (lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Enter Last Name',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
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
    if (isValidEmail(email)!=true) {
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
    if (officeEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Enter Office Email',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    if (isValidEmail(officeEmail)!=true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Invalid Office Email Address',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    if (cardLimit.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Enter Card Limit',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    if (netSalary.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Enter Net Salary',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    if (aadharNo.isEmpty) {
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
    if(_frontAadhar==null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Upload Aadhar Front Side',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    if(_backAadhar==null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Upload Aadhar Back Side',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    if(_panCardImg==null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Upload Pan Image',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
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
      'mother_name': motherName,
      'spouse_name': spouseName,
      'father_name': fatherName,
      'email': email,
      'mobile': mobile,
      'gender': gender??'Male',
      'qualifcation': qualification,
      'hdfc_account_holder': hdfcCardHolder??'No',
      'address[current_address]': currentAddress,
      'address[land_mark]': landMark,
      'address[city]': city,
      'address[pincode]': pincode,
      'address[house]': house??'OWN',
      'office_details[office_name]': officeName,
      'office_details[office_email]': email,
      'office_details[office_address]': officeAddress,
      'office_details[office_land_mark]': officeAddress,
      'office_details[office_city]': officeAddress,
      'office_details[office_pincode]': officePin,
      'office_details[office_designation]': officeDesignation,
      'office_details[surrogate]': surrogate??'Salary',
      'office_details[card_limit]': cardLimit,
      'office_details[net_salary]': netSalary,
      'documents[pan_card]': panCard,
      'documents[adhar_number]': aadharNo,
      'checklists[is_pan_card_sign_and_kyc]': check0,
      'checklists[is_kyc_annexure]': check1,
      'checklists[is_address_match_aadhar]': check2,
      'checklists[is_resident_and_office_address_diffrent]': check3,
      'checklists[is_designation_check]': check4,
      'checklists[is_promo_code_and_kyc_check]': check5,
      'checklists[is_salary_slip_and_bank_statement_check]': check6,
      'checklists[is_aadhar_quality_check]': check7,
      'checklists[is_pan_quality_check]': check8,
      'checklists[is_ccstatement_and_ccphotocopy_and_cibilreport_check]': check9,
      'checklists[is_active_loan_check]': check10,
      'checklists[is_sarrogate_check]': check11,
      'checklists[is_signature_check]': check12,
      'lead_id': widget.leadId
    };
    String pan = panImage!.path;
    String aadharFrontImg = aadharFront!.path;
    String aadharBackImg = aadharBack!.path;
    ApiHelper.applyAnotherLead(body, pan, aadharFrontImg, aadharBackImg).then((value) {
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
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Details of ${value.data!.name}\nSubmitted Successfully',
                      style: GoogleFonts.poppins(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColor.MainColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false);
                      },
                      child: Text(
                        'Okay',
                        style: GoogleFonts.poppins(fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    )
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
}
