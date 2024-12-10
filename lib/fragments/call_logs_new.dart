import 'package:call_log/call_log.dart';
import 'package:call_log_app/custom/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../screens/drawer_home_screen.dart';


enum FilterItems {viewAll, sec5, sec10, sec30, sec60}

class CallLogNewScreen extends StatefulWidget {
  const CallLogNewScreen({super.key});

  @override
  State<CallLogNewScreen> createState() => _CallLogNewScreenState();
}

class _CallLogNewScreenState extends State<CallLogNewScreen> {
  List<CallLogEntry> _callLogEntries = <CallLogEntry>[];

  bool filterBool = false;
  FilterItems? selectedfilter;

  @override
  void initState() {
    super.initState();
    loadList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerHomeScreen(),
      appBar: AppBar(
        backgroundColor: CustomColor.MainColor,
        title: Text(
          'Phone Call Logs',
          style: GoogleFonts.crimsonPro(
            fontSize: 25,
          ),
        ),
        actions: [
          PopupMenuButton<FilterItems>(
            icon: Icon(Icons.filter_alt_outlined),
            initialValue: selectedfilter,
              onSelected: (FilterItems item) {
                setState(() {
                  selectedfilter = item;
                  if(selectedfilter==FilterItems.viewAll){
                    loadList();
                  }
                  if(selectedfilter==FilterItems.sec5){
                    filteredList5();
                  }
                  if(selectedfilter==FilterItems.sec10){
                    filteredList10();
                  }
                  if(selectedfilter==FilterItems.sec30){
                    filteredList30();
                  }
                  if(selectedfilter==FilterItems.sec60){
                    filteredList60();
                  }
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterItems>>[
                const PopupMenuItem <FilterItems>(
                  value: FilterItems.viewAll,
                  child: Text('View All')
                ),
                const PopupMenuItem <FilterItems>(
                  value: FilterItems.sec5,
                  child: Text('5 Sec')
                ),
                const PopupMenuItem <FilterItems>(
                  value: FilterItems.sec10,
                  child: Text('10 Sec')
                ),
                const PopupMenuItem <FilterItems>(
                  value: FilterItems.sec30,
                  child: Text('30 Sec')
                ),
                const PopupMenuItem <FilterItems>(
                  value: FilterItems.sec60,
                  child: Text('1 min')
                ),
              ] ,
          )
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _callLogEntries.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffd9e6f2))),
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 10
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              _callLogEntries[index].name ?? 'Unknown',
                              style: TextStyle(
                                fontSize: 18,
                                color: CustomColor.MainColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                _callLogEntries[index].number ?? '',
                                style:  TextStyle(
                                  color: CustomColor.MainColor,
                                  fontSize: 18,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              FlutterPhoneDirectCaller.callNumber(
                                  _callLogEntries[index].number.toString());
                              print(_callLogEntries[index].number.toString());
                              print(_callLogEntries[index].duration?.toInt());
                              Navigator.popAndPushNamed(context, '/feedback');
                            });
                          },
                          child: Icon(
                            Icons.call,
                            color: CustomColor.SecondaryColor,size: 30,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    Expanded(
                      child: Text(formatTime(
                          DateTime.fromMillisecondsSinceEpoch(
                              _callLogEntries[index].timestamp!.toInt()))),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(_callLogEntries[index].duration!.toInt() > 100
                        ? '${(_callLogEntries[index].duration! / 60).round()} min'
                        : '${_callLogEntries[index].duration} sec')
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> loadList() async {
    PermissionStatus phoneStatus = await Permission.phone.request();
    if (phoneStatus.isGranted) {
      final Iterable<CallLogEntry> result = await CallLog.query();
      setState(() {
        _callLogEntries = result.toList();
      });
    } else if (phoneStatus.isPermanentlyDenied) {
      // Permission permanently denied
      // You can open the app settings to let the user manually enable the camera permission
      openAppSettings();
    }
  }
  // filtered list 5 seconds
  Future<void> filteredList5() async {
    // PermissionStatus contactStatus = await Permission.contacts.request();
    PermissionStatus phoneStatus = await Permission.phone.request();

    if (phoneStatus.isGranted) {
      final Iterable<CallLogEntry> result = await CallLog.query();
      setState(() {
        _callLogEntries =
            result.where((element) => element.duration! >= 5).toList();
      });
    } else if (phoneStatus.isPermanentlyDenied) {
      // Permission permanently denied
      // You can open the app settings to let the user manually enable the camera permission
      openAppSettings();
    }
  }
  //filtered list 10 seconds
  Future<void> filteredList10() async {
    // PermissionStatus contactStatus = await Permission.contacts.request();
    PermissionStatus phoneStatus = await Permission.phone.request();

    if (phoneStatus.isGranted) {
      final Iterable<CallLogEntry> result = await CallLog.query();
      setState(() {
        _callLogEntries =
            result.where((element) => element.duration! >= 30).toList();
      });
    } else if (phoneStatus.isPermanentlyDenied) {
      // Permission permanently denied
      // You can open the app settings to let the user manually enable the camera permission
      openAppSettings();
    }
  }
  //filtered list 30 seconds
  Future<void> filteredList30() async {
    // PermissionStatus contactStatus = await Permission.contacts.request();
    PermissionStatus phoneStatus = await Permission.phone.request();

    if (phoneStatus.isGranted) {
      final Iterable<CallLogEntry> result = await CallLog.query();
      setState(() {
        _callLogEntries =
            result.where((element) => element.duration! >= 30).toList();
      });
    } else if (phoneStatus.isPermanentlyDenied) {
      // Permission permanently denied
      // You can open the app settings to let the user manually enable the camera permission
      openAppSettings();
    }
  }
  //filtered list 60 seconds
  Future<void> filteredList60() async {
    // PermissionStatus contactStatus = await Permission.contacts.request();
    PermissionStatus phoneStatus = await Permission.phone.request();

    if (phoneStatus.isGranted) {
      final Iterable<CallLogEntry> result = await CallLog.query();
      setState(() {
        _callLogEntries =
            result.where((element) => element.duration! >= 60).toList();
      });
    } else if (phoneStatus.isPermanentlyDenied) {
      // Permission permanently denied
      // You can open the app settings to let the user manually enable the camera permission
      openAppSettings();
    }
  }

  String formatTime(DateTime dateTime) {
    return DateFormat.yMEd().add_jms().format(dateTime);
  }
}
