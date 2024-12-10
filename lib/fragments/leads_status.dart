import 'package:call_log_app/custom/custom_color.dart';
import 'package:call_log_app/network/api_helper.dart';
import 'package:call_log_app/screens/add_bank_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/lead_status_model.dart';

class LeadStatusScreen extends StatefulWidget {
  const LeadStatusScreen({super.key});

  @override
  State<LeadStatusScreen> createState() => _LeadStatusScreenState();
}

class _LeadStatusScreenState extends State<LeadStatusScreen> {
  late Future<LeadStatusModel> _futureLeadStatus;

  Future<LeadStatusModel> getLeadStatus() {
    return ApiHelper.leadStatus();
  }

  @override
  void initState() {
    _futureLeadStatus = getLeadStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.lightBackgroundGray,
      body: FutureBuilder<LeadStatusModel>(
        future: _futureLeadStatus,
        builder: (context, response) {
          if (response.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitWaveSpinner(
                  color: CustomColor.MainColor,
                  waveColor: CustomColor.MainColor),
            );
          }
          if (response.data!.status != 1) {
            return const Center(
              child: Text('No Data Found'),
            );
          }
          List<LeadStatusData> leadStatusList = response.data!.leadlist!.data!
              .where((element) => element.submitType == '1')
              .toList();

          if (leadStatusList.isEmpty) {
            return const Center(
              child: Text('Leads List is Empty'),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: leadStatusList.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 3,
                        color: Colors.grey.shade400,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            "${leadStatusList[index].name?.toUpperCase()} ${leadStatusList[index].middleName?.toUpperCase()} ${leadStatusList[index].lastName?.toUpperCase()}",
                            style: GoogleFonts.poppins(
                                fontSize: 15, color: CustomColor.MainColor),
                          )),
                          Text(
                            leadStatusList[index].status!,
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.green,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          leadStatusList[index].mobile!,
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bank',
                                  style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600),
                                ),
                                if (leadStatusList[index].bank != null)
                                  Text(
                                    leadStatusList[index]
                                        .bank!
                                        .name!
                                        .toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.w600),
                                  ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  backgroundColor: CustomColor.MainColor),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SelectBankScreen(
                                          leadStatusData:
                                              leadStatusList[index]),
                                    ));
                              },
                              child: Text(
                                'Apply Another',
                                style: GoogleFonts.poppins(fontSize: 12),
                              ))
                        ],
                      ),
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

  Future<void> _refresh() async {
    setState(() {
      _futureLeadStatus = getLeadStatus();
    });
    return;
  }
}
