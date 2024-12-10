import 'package:call_log_app/custom/custom_color.dart';
import 'package:call_log_app/helper/helper.dart';
import 'package:call_log_app/screens/feedback_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/call_log_model.dart';
import '../network/api_helper.dart';

class BackendData extends StatefulWidget {
  const BackendData({super.key});

  @override
  State<BackendData> createState() => _BackendDataState();
}

class _BackendDataState extends State<BackendData> with WidgetsBindingObserver {
  late Future<CallLogModel> _callLogFuture;

  bool isCallDone = false;
  Contacts? selectedCall;

  Future<CallLogModel> getCallLogs() async {
    return ApiHelper.callLog();
  }

  @override
  void initState() {
    _callLogFuture = getCallLogs();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.greenAccent.shade700,
                borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Text(
                  'Name',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                )),
                Expanded(
                    child: Text(
                  'Contact',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                )),
                Text(
                  'Call',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<CallLogModel>(
              future: _callLogFuture,
              builder: (context, response) {
                if (response.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitWaveSpinner(
                        color: CustomColor.MainColor,
                        waveColor: CustomColor.MainColor),
                  );
                }
                if (response.data!.status != 1) {
                  return const Center(child: Text('No Call logs found'));
                }
                List<Contacts> contactsList =
                    response.data!.contacts!;
                if (contactsList.isEmpty) {
                  return const Center(
                    child: Text('No List Found'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: contactsList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 10, top: 1.0),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 0.5,
                                blurRadius: 0.5,
                                color: Colors.grey.shade400,
                              ),
                            ],
                            color: contactsList[index].contact!.callStatus ==
                                    'NOT CONNECTED'
                                ? Colors.red.shade50
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 15),
                        child: Row(children: [
                          Expanded(
                            child: Text(
                              contactsList[index].contact!.name ?? '',
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: CustomColor.MainColor),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              contactsList[index].contact!.mobile!,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                contactsList[index].contact!.mobile;

                                selectedCall = contactsList[index];
                                FlutterPhoneDirectCaller.callNumber(
                                    contactsList[index].contact!.mobile!);
                                isCallDone = true;

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FeedbackScreen(
                                              contactList:
                                              contactsList[
                                              index]),
                                    ));
                              },
                              icon: Icon(
                                CupertinoIcons.phone_circle_fill,
                                size: 30,
                                color: CustomColor.MainColor,
                              ))
                        ]),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _callLogFuture = getCallLogs();
    });
    return;
  }

  @override
  void dispose() {
    // Unregister the observer to avoid memory leaks
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (isCallDone) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15)),
                      color: CustomColor.MainColor),
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.crop_sharp, color: CustomColor.MainColor),
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.center,
                          'Feedback',
                          style: GoogleFonts.poppins(
                              fontSize: 18, color: Colors.white),
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
                /// TODO:- FeedBack Buttons
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    navigateToFeedback();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: CustomColor.MainColor,
                      minimumSize: const Size(160, 45)),
                  child: Text(
                    'Interested',
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    navigateToFeedback();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: CustomColor.MainColor,
                      minimumSize: const Size(160, 45)),
                  child: Text(
                    'Not Interested',
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    updateStatus();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: CustomColor.MainColor,
                      minimumSize: const Size(160, 45)),
                  child: Text(
                    'Not Connected',
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    updateStatus();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: CustomColor.MainColor,
                      minimumSize: const Size(160, 45)),
                  child: Text(
                    'Invalid Number',
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        );
      }
    }


  }
  void updateStatus(){
    Helper.showLoaderDialog(context,message: 'Updating...');
    ApiHelper.updateCallStatus(selectedCall!.contactsId!.toString(), 'NOT CONNECTED').then((value) {

      Navigator.pop(context);
      if(value.status == 1){

        Helper.showSnackBar(context, 'Updated', Colors.green);
        setState(() {
          isCallDone = false;
          _callLogFuture = getCallLogs();
        });
      }else{
        Helper.showSnackBar(context, 'Failed', Colors.red);
      }
    });
  }

  void navigateToFeedback() async {
    final data = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeedbackScreen(contactList: selectedCall!),
        ));

    if (data != null) {
      print('DATA $data');
      setState(() {
        isCallDone = false;
        _callLogFuture = getCallLogs();
      });
    }
  }
}

/*
 IconButton(
                                onPressed: () {
                                  FlutterPhoneDirectCaller.callNumber(
                                          contactsList[index].contact!.mobile!)
                                      .then((value) {});
                                  //print(value);
                                  Future.delayed(
                                    const Duration(seconds: 3),
                                    () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    15),
                                                            topLeft:
                                                                Radius.circular(
                                                                    15)),
                                                    color:
                                                        CustomColor.MainColor),
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.crop_sharp,
                                                        color: CustomColor
                                                            .MainColor),
                                                    Expanded(
                                                      child: Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        'Feedback',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: const Icon(
                                                          Icons.cancel_rounded,
                                                          color: Colors.red,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            FeedbackScreen(
                                                                contactList:
                                                                    contactsList[
                                                                        index]),
                                                      ));
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                    backgroundColor:
                                                        CustomColor.MainColor,
                                                    minimumSize:
                                                        const Size(160, 45)),
                                                child: Text(
                                                  'Interested',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 15),
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                    backgroundColor:
                                                        CustomColor.MainColor,
                                                    minimumSize:
                                                        const Size(160, 45)),
                                                child: Text(
                                                  'Not Connected',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 15),
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
 */
