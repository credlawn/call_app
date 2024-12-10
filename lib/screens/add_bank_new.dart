import 'package:call_log_app/custom/custom_color.dart';
import 'package:call_log_app/model/lead_status_model.dart';
import 'package:call_log_app/network/api_helper.dart';
import 'package:call_log_app/screens/apply_another_bank.dart';
import 'package:call_log_app/screens/leads_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/add_lead_bank_model.dart';

class AddLeadBankScreen extends StatefulWidget {
  const AddLeadBankScreen({super.key, this.leadStatusData});

  final LeadStatusData? leadStatusData;

  @override
  State<AddLeadBankScreen> createState() => _AddLeadBankScreenState();
}

class _AddLeadBankScreenState extends State<AddLeadBankScreen> {
  late Future<AddLeadBankModel> _addLeadBankFuture;

  Future<AddLeadBankModel> getAddLeadBank() async {
    return ApiHelper.addLeadBank();
  }

  @override
  void initState() {
    _addLeadBankFuture = getAddLeadBank();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.MainColor,
          elevation: 0.5,
          title: Text('Select Bank', style: GoogleFonts.poppins()),
        ),
        body: FutureBuilder<AddLeadBankModel>(
          future: _addLeadBankFuture,
          builder: (context, response) {
            if (response.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (response.data!.status != 1) {
              return Center(
                child: Text('No Data Found'),
              );
            }
            List<AddlLeadBankData> addLeadBankList =
                response.data!.bankList!.data!;
            if (addLeadBankList.isEmpty) {
              return Center(
                child: Text('No Bank Found'),
              );
            }
            return ListView.builder(
              itemCount: addLeadBankList.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.grey, width: 0.5)),
                  child: ExpansionTile(
                    title: Text(
                      addLeadBankList[index].name ?? '',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    children: List.generate(
                        addLeadBankList[index].services!.length,
                        (subIndex) => InkWell(
                              onTap: () {
                                if (widget.leadStatusData == null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LeadsFormScreen(
                                          bankServices: addLeadBankList[index]
                                              .services![subIndex],
                                          bankName:
                                              addLeadBankList[index].name ?? '',
                                        ),
                                      ));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ApplyAnotherBank(
                                          leadId: addLeadBankList[index].id.toString()??'',
                                          leadStatusData: widget.leadStatusData,
                                          bankServices: addLeadBankList[index]
                                              .services![subIndex],
                                          bankName:
                                              addLeadBankList[index].name ?? '',
                                        ),
                                      ));
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        addLeadBankList[index]
                                                .services?[subIndex]
                                                .name ??
                                            '',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    Icon(Icons.navigate_next)
                                  ],
                                ),
                              ),
                            )),
                  ),
                );
              },
            );
          },
        ));
  }
}
