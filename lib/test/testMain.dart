import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:trail/redesigned.dart';
import 'package:dio/dio.dart';
import 'package:trail/test/version2.dart';


// void main() {
//   runApp( const GetMaterialApp(
//     home: HomePage(),
//   ));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SearchPage(),
//     );
//   }
// }


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Student Search'),
//         ),
//         body: Redesigned(),
//       ),
//     );
//   }
// }


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _students = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isMedical = false;
  bool _isCourse = false;


//   Future<void> _searchStudent(String name) async {
//   setState(() {
//     _isLoading = true;
//     _errorMessage = null;
//   });

//   final dio = Dio(); 

//   try {
//     final response = await dio.get(
//       'http://localhost/test/all/index.php',
//       queryParameters: {'name': name},
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         _students = response.data; 
//       });
//     } else {
//       throw Exception('Failed to load students');
//     }
//   } catch (e) {
//     setState(() {
//       _errorMessage = e.toString();
//     });
//   } finally {
//     setState(() {
//       _isLoading = false;
//       _isMedical = false;
//       _isCourse = false;
//     });
//   }
// }



  Future<void> _searchStudent(String name) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse('http://localhost/test/all'));

      if (response.statusCode == 200) {
        setState(() {
          _students = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load students');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
        _isMedical = false;
        _isCourse = false;
      });
    }
  }

  Future<void> _searchStudentMedicalDetails(String name) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse('http://localhost/test/medical/index.php?name=$name&medical=true'));

      if (response.statusCode == 200) {
        setState(() {
          _students = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load medical details');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        print(_errorMessage);
      });
    } finally {
      setState(() {
        _isLoading = false;
        _isMedical = true;
        _isCourse = false;
      });
    }
  }

  Future<void> _searchStudentCoursesDetails(String name) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse('http://localhost/test/course/index.php?name=$name&course=true'));

      if (response.statusCode == 200) {
        setState(() {
          _students = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load course details');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
        _isMedical = false;
        _isCourse = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter student name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _searchStudent(_controller.text);
              },
              child: const Text('Get Details'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _searchStudentMedicalDetails(_controller.text);
              },
              child: const Text('Get Medical Details'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _searchStudentCoursesDetails(_controller.text);
              },
              child: const Text('Get Course Details'),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : _errorMessage != null
                    ? Text('Error: $_errorMessage')
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _students.length,
                          itemBuilder: (context, index) {
                            final student = _students[index];
                            return ListTile(
                              title: Text(student['name']),
                              subtitle: _isMedical? Text('${student['reason']} visitedDate: ${student['visitedDate']}'):
                                         _isCourse?Text('${student['course']} status: ${student['status']}'): (Text('ID: ${student['id']} Mail: ${student['mail']}'))
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
