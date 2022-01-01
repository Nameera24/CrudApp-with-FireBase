import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_application_1/screens/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  var taskcollections = FirebaseFirestore.instance.collection('users');
  late String task;
  TextEditingController taskTitle = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  bool isLoading = false;
  addData() async {
    await FirebaseFirestore.instance.collection('task').add({
      "taskName": taskTitle.text,
      "taskDescription": taskDescription.text,
      "date":
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252041),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Add Info",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(padding: EdgeInsets.all(15)),
          Container(
            height: 55,
            width: MediaQuery.of(context).size.width - 70,
            child: TextFormField(
              controller: taskTitle,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: "Title",
                hintText: "Enter Title Here",
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    width: 1.5,
                    color: Colors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(15)),
          Container(
            height: 55,
            width: MediaQuery.of(context).size.width - 70,
            child: TextFormField(
              controller: taskDescription,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: "Description",
                hintText: "Enter description Here",
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    width: 1.5,
                    color: Colors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(20)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color(0xff1d1e26),
                ),
              ),
              onPressed: () {
                addData();
                taskTitle.clear();
                taskDescription.clear();
              },
              child: Text("Add Task",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('task').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went Wrong");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return ListTile(
                          title: Text(data['name']),
                          subtitle: Text(data['date']),
                          trailing: Wrap(
                            spacing: 1,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    document.reference.delete();
                                  },
                                  icon: Icon(Icons.delete)),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Update task"),
                                            content: Column(
                                              children: [
                                                TextField(
                                                  controller:
                                                      taskEditController,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    document.reference.update({
                                                      'name': taskEditController
                                                          .text
                                                    });
                                                    Navigator.pop(context);
                                                    taskEditController.clear();
                                                  },
                                                  child: Text("Update"),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  icon: Icon(Icons.update)),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),
            ),
          ]),
        ]),
      ),
    );
  }

  TextEditingController taskEditController = TextEditingController();
}
