import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_ui/responsive_ui.dart';

import 'courseModal.dart';
import 'medicalDetailModal.dart';
import 'modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<UserModal> userList = [];
  final List<CourseModal> courseList = [];
  final List<MedicalModal> medicalList = [];
  int? selectedUser;
  bool isDataFetched = false; 

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text("Student Filter"),
                  children: [
                    Responsive(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 16,
                      alignment: WrapAlignment.spaceEvenly,
                      children: [
                        Div(
                          divison: const Division(
                            colL: 4,
                            colM: 6,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 250),
                              child: DropdownButton<int>(
                                
                                hint: const Text("Student Name"),
                                value: selectedUser,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: const TextStyle(color: Colors.deepPurple),
                                // underline: Container(
                                //   height: 2,
                                //   color: Colors.deepPurpleAccent,
                                // ),
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedUser = value;
                                  });
                                },
                                items: userList
                                    .map<DropdownMenuItem<int>>((UserModal value) {
                                  return DropdownMenuItem(
                                    value: value.id,
                                    child: Text(value.roll),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Div(
                          divison: const Division(
                            colL: 4,
                            colM: 6,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<int>(
                              hint: const Text("Student Roll No "),
                              value: selectedUser,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              // underline: Container(
                              //   height: 2,
                              //   color: Colors.deepPurpleAccent,
                              // ),
                              onChanged: (int? value) {
                                setState(() {
                                  selectedUser = value;
                                });
                              },
                              items: userList
                                  .map<DropdownMenuItem<int>>((UserModal value) {
                                return DropdownMenuItem(
                                  value: value.id,
                                  child: Text(value.name),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Div(
                          divison: const Division(
                            colS: 6,
                            colM: 5,
                          ),
                          child: TextButton.icon(
                            onPressed: () {
                              getUserCourseInformation();
                            },
                            icon: const Icon(Icons.send),
                            label: const Text("Submit"),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            if (isDataFetched) 
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: const Text("Course Details"),
                    children: courseList.isEmpty
                        ? [const Padding(padding: EdgeInsets.all(8.0), child: Text("No courses available."))]
                        : courseList.map((course) {
                            return ListTile(
                              title: Text(course.course),
                              trailing: Text(course.status == 1 ? 'Completed' : 'Pending'),
                            );
                          }).toList(),
                  ),
                ),
              ),
            const SizedBox(height: 50),
            if (isDataFetched) 
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: const Text("Medical History"),
                    children: medicalList.isEmpty
                        ? [const Padding(padding: EdgeInsets.all(8.0), child: Text("No medical records available."))]
                        : medicalList.map((medical) {
                            return ListTile(
                              title: Text(medical.reason),
                              subtitle: Text(medical.visitedDate),
                            );
                          }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }


//   **** API CALLS **** 


  Future<void> load() async {
    var dio = Dio();
    var response = await dio.get("http://localhost/test/all/");
    userList.clear();
    if (response.data["ok"]) {
      for (var d in response.data["data"]) {
        userList.add(UserModal.fromJson(d));
      }
    }
    setState(() {});
  }



  Future<void> getUserCourseInformation() async {
    if (selectedUser == null) {
      Get.showSnackbar(const GetSnackBar(
        isDismissible: true,
        message: "Select a Valid Student",
        icon: Icon(Icons.error),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ));
      return;
    }

    var dio = Dio();
    var response = await dio.get("http://localhost/test/course/?student_id=$selectedUser");

    courseList.clear();
    if (response.data["ok"]) {
      for (var d in response.data["data"]) {
        courseList.add(CourseModal.fromJson(d));
      }
      if (courseList.isEmpty) {
        Get.showSnackbar(const GetSnackBar(
          isDismissible: true,
          message: "No course data found",
          icon: Icon(Icons.info),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 3),
        ));
      }
    } else {
      Get.showSnackbar(const GetSnackBar(
        isDismissible: true,
        message: "Error fetching course data",
        icon: Icon(Icons.error),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ));
    }

    getMedicalInformation();
  }



  Future<void> getMedicalInformation() async {
    if (selectedUser == null) {
      return; 
    }

    var dio = Dio();
    var response = await dio.get("http://localhost/test/medical/?student_id=$selectedUser");

    medicalList.clear();
    if (response.data["ok"]) {
      for (var d in response.data["data"]) {
        medicalList.add(MedicalModal.fromJson(d));
      }
      if (medicalList.isEmpty) {
        Get.showSnackbar(const GetSnackBar(
          isDismissible: true,
          message: "No medical records found",
          icon: Icon(Icons.info),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 3),
        ));
      }
    } else {
      Get.showSnackbar(const GetSnackBar(
        isDismissible: true,
        message: "Error fetching medical data",
        icon: Icon(Icons.error),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ));
    }

    setState(() {
      isDataFetched = true; 
    });
  }



}
