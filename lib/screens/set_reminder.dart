import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../custom/custom_color.dart';
import '../model/call_log_model.dart';
import '../network/api_helper.dart';
import '../notificationservice.dart';

class SetReminder extends StatefulWidget {
  const SetReminder({super.key, required this.contactList});

  // final String id;
  // final String name;

  final Contacts contactList;

  @override
  State<SetReminder> createState() => _SetReminderState();
}

class _SetReminderState extends State<SetReminder> {
  final TextEditingController _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  bool _isLoading = false;

  DateTime _selectedDate = DateTime.now();

  // Set the initial date to the current date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(), // Change this to your desired starting date
      lastDate: DateTime(2101), // Change this to your desired ending date
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    String selectedTime =
        '${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Set Reminder', style: GoogleFonts.poppins(fontSize: 20)),
        elevation: 0.5,
        backgroundColor: CustomColor.MainColor,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(15),
            color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Text('Date :',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                      )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      _showDateTimePicker(context);
                    },
                    child: Text(formattedDate,
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: CustomColor.MainColor)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Text('Time :',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    _showDateTimePicker(context);
                  },
                  child: Text(DateFormat.jm().format(_selectedDate),
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: CustomColor.MainColor)),
                )),
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _remarkController,
              decoration: InputDecoration(
                hintText: 'Enter remark',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                label: Text(
                  'Remark',
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _isLoading
                ? const Center(
                    child: SpinKitWaveSpinner(
                      color: Colors.blue, // Customize color
                      size: 50.0, // Customize size
                    ),
                  )
                : Center(
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
          ],
        ),
      ),
    );
  }

  void submit() {
    String selectedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    String selectedtime =
        '${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}';

    String remark = _remarkController.text.trim();

    Map<String, String> body = {
      'contact_id': widget.contactList.contactsId.toString(),
      'date': selectedDate,
      'time': selectedtime,
      'interest_id': widget.contactList.userId.toString(),
      'remark': remark,
    };
    print(body);
    setState(() {
      _isLoading = true;
    });
    ApiHelper.addReminder(body).then((value) {
      setState(() {
        _isLoading = false;
        if (value.status == 1) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                textAlign: TextAlign.center,
                'Reminder Set',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              )));
          NotificationService().showNotification(
              int.parse(widget.contactList.contactsId.toString()),
              'Call Reminder',
              widget.contactList.contact!.name!,
              _selectedDate);
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                textAlign: TextAlign.center,
                'Try Again',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              )));
        }
      });
    });
  }

  void _showDateTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 250,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                _selectedDate = newDateTime;
              });
            },
          ),
        );
      },
    );
  }
}
