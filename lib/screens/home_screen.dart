import 'package:call_log_app/custom/custom_color.dart';
import 'package:call_log_app/fragments/call_logs_backend.dart';
import 'package:call_log_app/fragments/dashboard_fragment.dart';
import 'package:call_log_app/fragments/leads_status.dart';
import 'package:call_log_app/screens/add_bank_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'drawer_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navBar = 0;
  final _fragment = [
    const DashboardFragment(),
    const BackendData(),
    const LeadStatusScreen()
  ];

  String title = 'Dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.lightBackgroundGray,
      appBar: AppBar(
        elevation: 0.5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(0),
                bottomLeft: Radius.circular(0))),
        actions: [
          _navBar == 1
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          // builder: (context) => const AddLeadBankScreen(),
                          builder: (context) => const SelectBankScreen(),
                        ));
                  },
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.plus_circle),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Add Lead',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                )
              : const Text(''),
          const SizedBox(
            width: 10,
          ),
        ],
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
          ),
        ),
        backgroundColor: CustomColor.MainColor,
      ),
      drawer: const DrawerHomeScreen(),
      body: _fragment[_navBar],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.poppins(),
        selectedItemColor: CustomColor.MainColor,
        // unselectedItemColor: Colors.greenAccent.shade700,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: _navBar == 0
                  ? const Icon(CupertinoIcons.home)
                  : const Icon(
                      CupertinoIcons.home,
                    ),
              label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: _navBar == 1
                  ? const Icon(CupertinoIcons.phone_fill)
                  : const Icon(
                      CupertinoIcons.phone,
                    ),
              label: 'Call Logs'),
          BottomNavigationBarItem(
              icon: _navBar == 2
                  ? const Icon(CupertinoIcons.doc_chart_fill)
                  : const Icon(CupertinoIcons.doc_chart),
              label: 'Leads'),
        ],
        currentIndex: _navBar,
        onTap: (value) {
          setState(() {
            _navBar = value;
            if (value == 0) {
              title = 'Dashboard';
            } else if (value == 1) {
              title = 'Call Logs';
            } else if (value == 2) {
              title = 'Leads';
            }
          });
        },
      ),
    );
  }
}
