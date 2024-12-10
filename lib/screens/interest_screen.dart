import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../custom/custom_color.dart';
import '../model/interest_model.dart';
import '../network/api_helper.dart';

class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {

  late Future<InterestModel> _interestModel;

  Future<InterestModel> getDataList() async {
    return ApiHelper.interest();
  }
  static whatsapp(String mobile) async {
    var contact = mobile;
    var androidUrl = "whatsapp://send?phone=$contact&text=Hello";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hello')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {}
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _interestModel = getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.MainColor,
          elevation: 0.5,
          title: Text('Interest'),
        ),
        body: FutureBuilder(
          future: _interestModel,
          builder: (context, response) {
            if (response.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Column(
                children: [
                  Text(
                    "Finding Data",
                  ),
                  SizedBox(height: 5),
                  CircularProgressIndicator(),
                ],
              ));
            }
            if (response.data == null) {
              return Center(
                child: Icon(Icons.error_outline),
              );
            }
            List<Data>? detail = response.data!.data;

            if(detail!.isEmpty){
              return Center(child: Text("No Data Found"),);
            }
            return ListView.builder(
              itemCount: detail!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(180),
                          blurRadius: 1.5,
                          spreadRadius: 1.5,
                        )
                      ]),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name :- ${detail[index].contact!.name}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Number :-${detail[index].contact!.mobile}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(onTap:() {
                       return whatsapp(detail[index].contact!.mobile??"");
                      },child: Image.asset("assets/img/whatsapp.png", height: 35)),
                    ],
                  ),
                );
              },
            );
          },
        ));
  }
}
