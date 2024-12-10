import 'package:call_log_app/custom/custom_color.dart';
import 'package:call_log_app/model/lead_status_model.dart';
import 'package:call_log_app/network/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/add_lead_bank_model.dart';
import 'apply_another_bank.dart';
import 'leads_form.dart';

class SelectBankScreen extends StatefulWidget {
  const SelectBankScreen({super.key, this.leadStatusData, this.leadId});

  final LeadStatusData? leadStatusData;
  final String? leadId;

  @override
  State<SelectBankScreen> createState() => _SelectBankScreenState();
}

class _SelectBankScreenState extends State<SelectBankScreen> {
  late Future<AddLeadBankModel> _addLeadBankFuture;
  static const List<String> serviceType = <String>[
    'Personal Loan',
    'Credit Card'
  ];

  String dropDownService = serviceType.first;

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
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
              margin:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey)),
              child: DropdownButton<String>(
                underline: Container(color: Colors.transparent),
                style: GoogleFonts.poppins(
                    color: CustomColor.MainColor, fontSize: 18),
                value: dropDownService,
                onChanged: (newValue) {
                  setState(() {
                    dropDownService = newValue!;
                  });
                },
                items: serviceType.map((item) {
                  return DropdownMenuItem<String>(
                    alignment: Alignment.center,
                    value: item,
                    child: Text(item,),
                  );
                }).toList(),
              ),
            ),
            FutureBuilder<AddLeadBankModel>(
              future: _addLeadBankFuture,
              builder: (context, response) {
                if (response.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (response.data!.status != 1) {
                  return const Center(
                    child: Text('No Data Found'),
                  );
                }
                List<AddlLeadBankData> addLeadBankList =
                    response.data!.bankList!.data!;

                List<AddlLeadBankData> personalLoanList = [];

                var i = 0;
                while (i < addLeadBankList.length) {
                  var x = 0;
                  while (x < addLeadBankList[i].services!.length) {
                    if (addLeadBankList[i].services![x].type == "Credit Card" &&
                        dropDownService == 'Credit Card') {
                      personalLoanList.add(addLeadBankList[i]);
                    }
                    if (addLeadBankList[i].services![x].type == "Loan" &&
                        dropDownService == 'Personal Loan') {
                      personalLoanList.add(addLeadBankList[i]);
                    }
                    print(addLeadBankList[i].services![x].type);
                    x++;
                  }
                  i++;
                }
                if (addLeadBankList.isEmpty) {
                  return const Center(
                    child: Text('No Bank Found'),
                  );
                }
                if (personalLoanList.isEmpty) {
                  return const Center(
                    child: Text('No Bank Found'),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: personalLoanList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        var x = 0;
                        Services personal =
                            personalLoanList[index].services![0];
                        Services credit = personalLoanList[index].services![0];

                        while (x < personalLoanList[index].services!.length) {
                          if (personalLoanList[index].services![x].type ==
                              "Credit Card") {
                            credit = personalLoanList[index].services![x];
                          }
                          if (personalLoanList[index].services![x].type ==
                              "Loan") {
                            personal = personalLoanList[index].services![x];
                          }
                          x++;
                        }
                        if (dropDownService == "Credit Card" &&
                            widget.leadStatusData == null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LeadsFormScreen(
                                  bankServices: credit,
                                  bankName: addLeadBankList[index].name ?? '',
                                ),
                              ));
                        }
                        if (dropDownService == "Credit Card" &&
                            widget.leadStatusData != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ApplyAnotherBank(
                                    leadId: widget.leadId??'',
                                      bankServices: credit,
                                      leadStatusData: widget.leadStatusData,
                                      bankName:
                                          addLeadBankList[index].name ?? '')));
                        }
                        if (dropDownService == "Personal Loan" &&
                            widget.leadStatusData == null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LeadsFormScreen(
                                  bankServices: personal,
                                  bankName: addLeadBankList[index].name ?? '',
                                ),
                              ));
                        }
                        if (dropDownService == "Personal Loan" &&
                            widget.leadStatusData != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ApplyAnotherBank(
                                    leadId: widget.leadId??'',
                                      bankServices: personal,
                                      leadStatusData: widget.leadStatusData,
                                      bankName:
                                          addLeadBankList[index].name ?? '')));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin:
                            const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300)),
                        alignment: Alignment.center,
                        child: Text(personalLoanList[index].name ?? '',
                            style: GoogleFonts.poppins(
                                fontSize: 16, color: Colors.green)),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ));
  }
}
