import 'package:call_log_app/screens/resignation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../custom/custom_color.dart';

class DocumentsDownloadScreen extends StatefulWidget {
  const DocumentsDownloadScreen({super.key});

  @override
  State<DocumentsDownloadScreen> createState() =>
      _DocumentsDownloadScreenState();
}

class _DocumentsDownloadScreenState extends State<DocumentsDownloadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      appBar: AppBar(
        title: Text('Documents', style: GoogleFonts.poppins(fontSize: 18)),
        elevation: 0.5,
        backgroundColor: CustomColor.MainColor,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Click to Download',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: CustomColor.MainColor,
                          minimumSize: Size(double.infinity, 45)),
                      onPressed: () {},
                      child: Text(
                        'Pay Slip',
                        style: GoogleFonts.poppins(fontSize: 15),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: CustomColor.MainColor,
                          minimumSize: Size(double.infinity, 45)),
                      onPressed: () {},
                      child: Text(
                        'Attendance Summary',
                        style: GoogleFonts.poppins(fontSize: 15),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: CustomColor.MainColor,
                          minimumSize: Size(double.infinity, 45)),
                      onPressed: () {},
                      child: Text(
                        'Offer Letter',
                        style: GoogleFonts.poppins(fontSize: 15),
                      )),
                ],
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.red.shade500,
                    minimumSize: Size(double.infinity, 45)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResignationScreen(),
                      ));
                },
                child: Text(
                  'Submit Resignation',
                  style: GoogleFonts.poppins(fontSize: 15),
                )),
          ],
        ),
      ),
    );
  }
}
