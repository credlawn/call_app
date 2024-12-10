import 'package:call_log_app/helper/session_manager.dart';
import 'package:call_log_app/screens/documents_download.dart';
import 'package:call_log_app/screens/interest_screen.dart';
import 'package:call_log_app/screens/leave_application_list_screen.dart';
import 'package:call_log_app/screens/profile.dart';
import 'package:call_log_app/screens/reminder_screen.dart';
import 'package:call_log_app/screens/salary_slip_screen.dart';
import 'package:call_log_app/screens/saved_form_screen.dart';
import 'package:call_log_app/screens/travel_expense_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../custom/custom_color.dart';
import 'attendance_screen.dart';

class DrawerHomeScreen extends StatelessWidget {
  const DrawerHomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), bottomRight: Radius.circular(25))),
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/img/bg_img2.jpg'),
                      fit: BoxFit.cover)),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 90,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Image.asset(
                            'assets/img/profileImage.png',
                            fit: BoxFit.fill,
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      SessionManager.getUserName() ?? "",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
            // Your drawer items go here
            ListTile(
              leading: Icon(CupertinoIcons.person,
                  color: CustomColor.MainColor, size: 30),
              title: Text('Profile',
                  style: GoogleFonts.poppins(
                    color: CustomColor.MainColor,
                    fontSize: 18,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.watch_later_outlined,
                  color: CustomColor.MainColor, size: 30),
              title: Text('Attendance',
                  style: GoogleFonts.poppins(
                    color: CustomColor.MainColor,
                    fontSize: 18,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AttendanceScreen(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.calendar,
                  color: CustomColor.MainColor, size: 30),
              title: Text('Leave Application',
                  style: GoogleFonts.poppins(
                      color: CustomColor.MainColor, fontSize: 18)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeaveApplicationListScreen(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.currency_rupee,
                  color: CustomColor.MainColor, size: 30),
              title: Text('Travel Expense',
                  style: GoogleFonts.poppins(
                      color: CustomColor.MainColor, fontSize: 18)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TravelExpenseScreen(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.featured_play_list_outlined,
                  color: CustomColor.MainColor, size: 30),
              title: Text('Salary Slip',
                  style: GoogleFonts.poppins(
                      color: CustomColor.MainColor, fontSize: 18)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalarySlipScreen(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.calendar,
                  color: CustomColor.MainColor, size: 30),
              title: Text('Reminders',
                  style: GoogleFonts.poppins(
                      color: CustomColor.MainColor, fontSize: 18)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReminderListScreen(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.file_download,
                  color: CustomColor.MainColor, size: 30),
              title: Text('Documents',
                  style: GoogleFonts.poppins(
                      color: CustomColor.MainColor, fontSize: 18)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocumentsDownloadScreen(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.find_in_page,
                  color: CustomColor.MainColor, size: 30),
              title: Text('Saved Forms',
                  style: GoogleFonts.poppins(
                      color: CustomColor.MainColor, fontSize: 18)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SavedFormScreen(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.person_pin,
                  color: CustomColor.MainColor, size: 30),
              title: Text('Interest',
                  style: GoogleFonts.poppins(
                      color: CustomColor.MainColor, fontSize: 18)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InterestScreen(),
                    ));
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: CustomColor.MainColor,
                    size: 30,
                  ),
                  title: Text('Logout',
                      style: GoogleFonts.poppins(
                          color: CustomColor.MainColor, fontSize: 18)),
                  onTap: () {
                    SessionManager.logout();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
