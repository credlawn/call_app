import 'package:call_log/call_log.dart';
import 'package:call_log_app/network/api_helper.dart';
import 'package:call_log_app/screens/home_screen.dart';
import 'package:call_log_app/screens/set_reminder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../custom/custom_color.dart';
import '../model/call_log_model.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({
    super.key,
    required this.contactList,
  });

  final Contacts contactList;

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with WidgetsBindingObserver {
  bool _isLoading = false;

  final TextEditingController _remark = TextEditingController();

  int durationInSec = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchCallLog();

    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> fetchCallLog() async {
    Iterable<CallLogEntry> entries = await CallLog.query(
      number: widget.contactList.contact!.mobile,
      type: CallType.outgoing,
    );
    setState(() {
      durationInSec = entries.first.duration ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        title: Text('Call Feedback', style: GoogleFonts.poppins(fontSize: 20)),
        backgroundColor: CustomColor.MainColor,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
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
                'Name : ${widget.contactList.contact!.name ?? ''}',
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.w600),
              ),
              Text(
                'Mobile : ${widget.contactList.contact!.mobile ?? ''}',
                style: GoogleFonts.poppins(fontSize: 15),
              ),
              SizedBox(height: 5.0),
              Text(
                'Call Duration(Sec.) : ${durationInSec ?? ''}',
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _remark,
                decoration: InputDecoration(
                  hintText: 'Enter remark',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
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
                          backgroundColor: Colors.green,
                          minimumSize: const Size(70, 40)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SetReminder(
                                contactList: widget.contactList,
                              ),
                            ));
                      },
                      child: const Text(
                        'Set Reminder',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
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
      'interest_id': widget.contactList.id,
      'remark': remark,
      'duration': durationInSec,
    };

    print(body);
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
                      /*Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false);*/

                      Navigator.pop(context);
                      Navigator.pop(context, true);
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

  @override
  void dispose() {
    // Unregister the observer to avoid memory leaks
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
