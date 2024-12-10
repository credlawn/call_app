import 'package:call_log_app/helper/dbhelper.dart';
import 'package:call_log_app/provider/app_controller.dart';
import 'package:call_log_app/screens/saved_lead_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom/custom_color.dart';
import '../model/offline_form.dart';

class SavedFormScreen extends StatefulWidget {
  const SavedFormScreen({super.key});

  @override
  State<SavedFormScreen> createState() => _SavedFormScreenState();
}

class _SavedFormScreenState extends State<SavedFormScreen> {
  // late Future<List<OfflineForm>> _future;
  //
  // Future<List<OfflineForm>> getForms() async {
  //   return DBHelper.getForms();
  // }

  late Future _future;

  Future<void> getForms()async{
    return Provider.of<AppController>(context,listen: false).getSavedForms();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = getForms();
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppController>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.MainColor,
          elevation: 0.5,
          title: const Text('Saved Form'),
        ),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (appData.leadStatusList.isEmpty) {
              return const Center(
                child: Text(
                  'No saved forms',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              itemCount: appData.leadStatusList.length,
              itemBuilder: (context, index) {
                final data = appData.leadStatusList[index];
                return Container(
                    margin:
                        const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Colors.grey, width: 0.6),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data.name} ${data.lastName}',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text('Mobile no: ${data.mobile}'),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SavedLeadFormScreen(offlineForm: data),
                                    ));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            /*const SizedBox(height: 10.0),
                            InkWell(
                              onTap: () {
                                delete(data.id!);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),*/
                          ],
                        ),
                      ],
                    ));
              },
            );
          },
        ));
  }

  void delete(int id) {
    DBHelper.deleteFormById(id).then((value) {
      setState(() {
        _future = getForms();
      });
    });
  }
}
