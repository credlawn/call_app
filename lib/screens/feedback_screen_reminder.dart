import 'package:call_log_app/model/reminder_list_model.dart';
import 'package:call_log_app/screens/set_reminder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../custom/custom_color.dart';
import '../network/api_helper.dart';

class FeedbackReminderScreen extends StatefulWidget {
  const FeedbackReminderScreen({super.key, required this.reminderContact});

  final ReminderContact reminderContact;

  @override
  State<FeedbackReminderScreen> createState() => _FeedbackReminderScreenState();
}

class _FeedbackReminderScreenState extends State<FeedbackReminderScreen> {
  bool _isLoading = false;
  @override
  final TextEditingController _remark = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.lightBackgroundGray,
      appBar: AppBar(
        title:
            Text('Reminder Feedback', style: GoogleFonts.poppins(fontSize: 20)),
        elevation: 0.5,
        backgroundColor: CustomColor.MainColor,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                'Name : ${widget.reminderContact.name ?? ''}',
                style: GoogleFonts.poppins(fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Mobile : ${widget.reminderContact.mobile ?? ''}',
                style: GoogleFonts.poppins(fontSize: 15),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _remark,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  label: Text(
                    'Remark',
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  _isLoading
                      ? const Expanded(
                          child: SpinKitWaveSpinner(
                            color: Colors.blue, // Customize color
                            size: 50.0, // Customize size
                          ),
                        )
                      : Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: CustomColor.MainColor,
                                minimumSize: const Size(70, 40)),
                            onPressed: () {
                              submit();
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                  const SizedBox(
                    width: 7,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: CustomColor.MainColor,
                          minimumSize: const Size(70, 40)),
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => SetReminder(
                        //           id: widget.reminderContact.id.toString(),name: widget.reminderContact.name??''),
                        //     ));
                      },
                      child: const Text(
                        'Set Reminder',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }

  Future<void> submit() async {
    String remark = _remark.text;
    if (remark.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Remark can't be empty",
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> body = {
      'interest_id': widget.reminderContact.id,
      'remark': remark
    };
    ApiHelper.feedback(body).then((value) {
      setState(() {
        _isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: value.status == 1 ? Colors.green : Colors.red,
            content: Text(
                value.status == 1 ? 'Feedback Submitted' : 'Not Submitted'),
          ),
        );
      });
      if (value.status == 1) {
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
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 3,
                            blurRadius: 3,
                            color: Colors.grey.shade400,
                          ),
                        ],
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        ),
                        color: value.status == 1
                            ? CustomColor.MainColor
                            : Colors.redAccent,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      child: Text(
                        textAlign: TextAlign.center,
                        'Feedback',
                        style: GoogleFonts.poppins(
                            fontSize: 20, color: Colors.white),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    value.status == 1
                        ? 'Feedback Submitted Successfully !!'
                        : 'Not Submitted',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: value.status == 1
                            ? CustomColor.MainColor
                            : Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      Navigator.pop(context);
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
      }
    });
  }
}
