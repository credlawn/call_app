import 'package:call_log_app/custom/custom_color.dart';
import 'package:call_log_app/helper/session_manager.dart';
import 'package:call_log_app/model/attendance.dart';
import 'package:call_log_app/network/api_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Future<Attendance> _attendanceFuture;

  Position? _currentPosition;
  bool _isLoadingCheckIn = false;
  bool _isPunchedIn = SessionManager.isPunchedIn() ?? true;
  String? type;

  Future<void> _checkLocationPermission() async {
    setState(() {
      _isLoadingCheckIn = true;
    });
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else {}
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      attendance();
    } catch (e) {
      print("Error: $e");
    }
  }

  // void _getLocation() {
  //   _getCurrentLocation();
  // }

  Future<Attendance> getAttendance() async {
    return ApiHelper.getAttendanceList();
  }

  @override
  void initState() {
    super.initState();

    _attendanceFuture = getAttendance();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEE, MMM d').format(DateTime.now());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.5,
          title: Text(formattedDate, style: GoogleFonts.poppins(fontSize: 18)),
          backgroundColor: CustomColor.MainColor,

        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15.0),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 1,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/img/profileImage.png',
                    height: 65,
                    width: 65,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          SessionManager.getUserName() ?? '',
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: CustomColor.MainColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          SessionManager.getUserEmail() ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: CustomColor.MainColor,
                          ),
                        ),
                        Text(
                          SessionManager.getMobile() ?? '',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: CustomColor.MainColor),
                        ),
                      ],
                    ),
                  ),
                  _isLoadingCheckIn
                      ? SpinKitWaveSpinner(
                          waveColor: CustomColor.MainColor,
                          color: CustomColor.MainColor,
                          size: 50.0, // Customize size
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _isPunchedIn ? Colors.green : Colors.red,
                            minimumSize: Size(80.0, 45),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          onPressed: () {
                            // attendance();
                            _checkLocationPermission();
                          },
                          child: Text(
                            _isPunchedIn ? 'Punch In' : 'Punch out',
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          )),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Last month attendance',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 15.0),
            Expanded(
                child: FutureBuilder<Attendance>(
              future: _attendanceFuture,
              builder: (context, response) {
                if (response.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (response.data!.status == 0) {
                  return Text(
                    'No history found',
                    style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  );
                }

                List<AttendanceDataList> attendanceList =
                    response.data!.leaveList!.data ?? [];

                if (attendanceList.isEmpty) {
                  return Text(
                    'No history found',
                    style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  );
                }

                return ListView.builder(
                  itemCount: attendanceList.length,
                  itemBuilder: (context, index) {
                    return AttendanceWidget(data: attendanceList[index]);
                  },
                );
              },
            ))
          ],
        ));
  }

  Future<void> attendance() async {
    if (_isPunchedIn) {
      type = 'Out';
      //_isPunchedIn=false;
      SessionManager.setUserPunchedIn(false);
    } else {
      type = 'In';
      // _isPunchedIn = true;
      SessionManager.setUserPunchedIn(true);
    }
    String lat = _currentPosition!.latitude.toString();
    String long = _currentPosition!.longitude.toString();
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

    if (lat.isEmpty || long.isEmpty || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Attendance not marked try again!",
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    Map<String, String> body = {
      'latitude': lat,
      'longitude': long,
      'date': date,
      'type': _isPunchedIn ? 'In' : 'Out'
    };

    ApiHelper.checkIn(body).then((value) {
      setState(() {
        _isLoadingCheckIn = false;
      });
      if (value.status == 1) {
        _isPunchedIn = !_isPunchedIn;
        SessionManager.setUserPunchedIn(_isPunchedIn);
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
                        color: _isPunchedIn
                            ? CustomColor.MainColor
                            : CustomColor.MainColor,
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
                    _isPunchedIn
                        ? 'Punched Out Successfully !!'
                        : 'Punched In Successfully',
                    style: GoogleFonts.poppins(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _isPunchedIn
                            ? CustomColor.MainColor
                            : CustomColor.MainColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _attendanceFuture = getAttendance();
                      });
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
              )),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Attendance Not Marked try Again!'),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

}

class AttendanceWidget extends StatelessWidget {
  const AttendanceWidget({super.key, required this.data});

  final AttendanceDataList data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Punch-In',
                    style: GoogleFonts.poppins(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    getFormattedTime(data.inDate ?? '0000-00-00 00:00:00'),
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    getFormattedDate(data.inDate ?? '0000-00-00 00:00:00'),
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Punch-Out',
                    style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    getFormattedTime(data.outDate ?? '0000-00-00 00:00:00'),
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    getFormattedDate(data.outDate ?? '0000-00-00 00:00:00'),
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String getFormattedTime(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    DateFormat format = DateFormat('hh:mm a');

    return DateFormat('hh:mm a').format(date);
  }

  static String getFormattedDate(String inputDate) {
    DateTime date = DateTime.parse(inputDate);

    return DateFormat('dd-MM-yyyy').format(date);
  }
}
