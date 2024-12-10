import 'dart:async';
import 'package:call_log_app/network/api_helper.dart';
import 'package:call_log_app/screens/leave_application_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../custom/custom_color.dart';
import '../model/leave_application_list_model.dart';

class LeaveApplicationListScreen extends StatefulWidget {
  const LeaveApplicationListScreen({super.key});

  @override
  State<LeaveApplicationListScreen> createState() =>
      _LeaveApplicationListScreenState();
}

class _LeaveApplicationListScreenState
    extends State<LeaveApplicationListScreen> {
  late Future<LeaveApplicationListModel> _leaveListFuture;

  Future<LeaveApplicationListModel> getLeaveList() {
    return ApiHelper.leaveList();
  }

  @override
  void initState() {
    _leaveListFuture = getLeaveList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: CustomColor.MainColor,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeaveApplicationScreen(),
                    ));
              },
              child: Text('Apply Leave',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
            )
          ],
        ),
        body: FutureBuilder<LeaveApplicationListModel>(
          future: _leaveListFuture,
          builder: (context, response) {
            if (response.connectionState == ConnectionState.waiting) {
              return  Center(
                child: SpinKitWaveSpinner(color: CustomColor.MainColor,waveColor: CustomColor.MainColor),
              );
            }
            if (response.data!.status != 1) {
              return const Center(
                child: Text('Not Connected'),
              );
            }
            List<LeaveListData> leaveList = response.data!.leaveList!.data!;

            if (leaveList.isEmpty) {
              return const Center(
                child: Text('No Data in List'),
              );
            }
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                itemCount: leaveList.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 3,
                            color: Colors.grey.shade400,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 0:Inactive,2:Rejected, 1:Active,3:Pending Leave approval,4:Leave Approved
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                  leaveList[index].date?.substring(0, 10) ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                  )),
                            ),
                            Text(
                                leaveList[index].status == 0
                                    ? 'inactive'
                                    : leaveList[index].status == 1
                                        ? 'Active'
                                        : leaveList[index].status == 2
                                            ? 'Rejected'
                                            : leaveList[index].status == 3
                                                ? 'Pending'
                                                : leaveList[index].status == 4
                                                    ? 'Approved'
                                                    : '',
                                style: GoogleFonts.poppins(
                                    color: leaveList[index].status == 0
                                        ? Colors.red
                                        : leaveList[index].status == 1
                                            ? Colors.green
                                            : leaveList[index].status == 2
                                                ? Colors.red
                                                : leaveList[index].status == 3
                                                    ? const Color(0xffe6b800)
                                                    : leaveList[index].status == 4
                                                        ? Colors.green
                                                        : Colors.white,
                                    fontSize: 15,)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reason:',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                ),),
                            Text(
                              '${leaveList[index].reason}',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                ),),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ));
  }

  String myDate(DateTime formatDate) {
    return DateFormat('dd-MM-yyyy').format(formatDate);
  }
  Future<void> _refresh() async{
    setState(() {
      _leaveListFuture = getLeaveList();
    });
    return;
  }
}
