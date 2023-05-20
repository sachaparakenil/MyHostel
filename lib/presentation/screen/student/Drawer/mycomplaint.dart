// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostelapplication/logic/modules/complaint_model.dart';
import 'package:hostelapplication/logic/provider/complaint_provider.dart';
import 'package:provider/provider.dart';

class Mycomplaints extends StatelessWidget {
  Mycomplaints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    List<Complaint> complaintList = [];
    final complaintProvider = Provider.of<ComplaintProvider>(context);
    final complaintListRaw = Provider.of<List<Complaint>?>(context);
    complaintListRaw?.forEach((element) {
      if (auth.currentUser?.uid == element.studentUid && element.status == 0) {
        complaintList.add(element);
      }
      ;
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text("My Complaints Request"),
        ),
        body: complaintList != []
            ? Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: complaintList.length,
                  itemBuilder: (context, index) {
                    return MycomplaintsListModel(
                      Compiantdesc: complaintList[index].complaint,
                      Complainttype: complaintList[index].complaintTitle,
                      Complaintdate: complaintList[index].time,
                      deletecomplaint: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            content: Text("Are you sure you want to delete ?"),
                            actions: [
                              TextButton(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  complaintProvider
                                      .deleteComplaint(complaintList[index].id);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class MycomplaintsListModel extends StatelessWidget {
  MycomplaintsListModel(
      {required this.Complaintdate,
      required this.Complainttype,
      required this.Compiantdesc,
      required this.deletecomplaint});
  DateTime Complaintdate;
  String Complainttype;
  String Compiantdesc;
  Function deletecomplaint;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 5, right: 5, bottom: 10),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: const Color.fromARGB(157, 241, 241, 241),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 18.0, left: 18, right: 18, bottom: 5),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 2, color: Colors.grey),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Date ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(":"),
                              Text(
                                Complaintdate.day.toString() +
                                    '/' +
                                    Complaintdate.month.toString() +
                                    '/' +
                                    Complaintdate.year.toString(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Complaint ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(":"),
                          Text(
                            Complainttype,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 2,
                              color: Color.fromARGB(157, 158, 158, 158)),
                        ),
                        child: Text(Compiantdesc),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                deletecomplaint();
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 1, right: 1, bottom: 2),
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.red[400],
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Remove',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.only(
                    top: 5, left: 5, right: 5, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Please wait atleast two days to resolve the problems by Management.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
