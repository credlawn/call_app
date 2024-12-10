import 'package:call_log_app/custom/custom_color.dart';
import 'package:call_log_app/model/reminder_list_model.dart';
import 'package:call_log_app/network/api_helper.dart';
import 'package:call_log_app/screens/feedback_screen_reminder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({super.key});

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  late Future<ReminderListModel> _reminderFuture;

  Future<ReminderListModel> getReminderList() {
    return ApiHelper.reminderList();
  }

  @override
  void initState() {
    _reminderFuture = getReminderList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      appBar: AppBar(
        title: Text('Reminders', style: GoogleFonts.poppins(fontSize: 18)),
        elevation: 0.5,
        backgroundColor: CustomColor.MainColor,
      ),
      body: FutureBuilder<ReminderListModel>(
        future: _reminderFuture,
        builder: (context, res) {
          if (res.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitWaveSpinner(color: CustomColor.MainColor),
            );
          }
          if (res.data!.status != 1) {
            return Center(
              child: Text('No Data Found'),
            );
          }
          ReminderListModel reminderListModel = res.data!;
          print(reminderListModel.reminderdata!.data!.length);
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: reminderListModel.reminderdata!.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 7),
                  margin: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 3,
                          color: Colors.grey.shade400,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              reminderListModel
                                      .reminderdata!.data![index].contact!.name ??
                                  '',
                              style: GoogleFonts.poppins(
                                  fontSize: 15, color: CustomColor.MainColor),
                            ),
                            Text(
                              reminderListModel.reminderdata!.data![index]
                                      .contact!.mobile ??
                                  '',
                              style: GoogleFonts.poppins(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Reminder :',
                              style: GoogleFonts.poppins(fontSize: 15),
                            ),
                            Text(
                              '${reminderListModel.reminderdata!.data![index].date?.substring(0, 10)},${reminderListModel.reminderdata!.data![index].time?.substring(0, 5)}',
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.greenAccent.shade700),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            FlutterPhoneDirectCaller.callNumber(reminderListModel
                                    .reminderdata!.data![index].contact!.mobile ??
                                '');
                            Future.delayed(
                              const Duration(seconds: 3),
                              () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(15),
                                                  topLeft: Radius.circular(15)),
                                              color: CustomColor.MainColor),
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.crop_sharp,
                                                  color: CustomColor.MainColor),
                                              Expanded(
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  'Feedback',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: const Icon(
                                                    Icons.cancel_rounded,
                                                    color: Colors.red,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FeedbackReminderScreen(
                                                          reminderContact:
                                                              reminderListModel
                                                                  .reminderdata!
                                                                  .data![index]
                                                                  .contact!),
                                                ));
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15)),
                                              backgroundColor:
                                                  CustomColor.MainColor,
                                              minimumSize: const Size(160, 45)),
                                          child: Text(
                                            'Interested',
                                            style:
                                                GoogleFonts.poppins(fontSize: 15),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15)),
                                              backgroundColor:
                                                  CustomColor.MainColor,
                                              minimumSize: const Size(160, 45)),
                                          child: Text(
                                            'Not Connected',
                                            style:
                                                GoogleFonts.poppins(fontSize: 15),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.call,
                            color: CustomColor.MainColor,
                          ))
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
  Future<void> _refresh() async{
    setState(() {
      _reminderFuture = getReminderList();
    });
    return;
  }
}
