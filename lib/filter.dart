import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:http/http.dart' as http;

class Filters extends StatefulWidget {
  const Filters({super.key});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  final TextEditingController _controller = TextEditingController();
  String? filters;
  List<dynamic> _students = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isMedical = false;
  bool _isCourse = false;


    Future<void> _searchStudent(String name) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse('http://localhost/test/index.php?name=$name'));

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


  @override
  Widget build(BuildContext context) {
    return Responsive(
      children: [
        Div(
          divison: const Division(
            colL: 4,
            colM: 6,
            colS: 12,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Enter student name',
                  border: OutlineInputBorder(),
                ),
              ),
          ),
        ),
        Div(
          divison: const Division(
            colL: 4,
            colM: 6,
            colS: 12,
          ),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildDropdown(
                'Select Filter',
                filters,
                (value){
                  setState(() {
                    filters = value;
                  });
                },
                ['Get Student Details', 'Get Student Course Details', 'Get Student Medical Details']
              ),
            ),
        ),
         Div(
          divison: const Division(
            colL: 4,
            colM: 6,
            colS: 12
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _searchStudent(_controller.text);
              },
              style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1E88E5),
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
              child: const Text('SEARCH', style: TextStyle(color: Colors.white),)
              ),
          ),
        )

      ],
    );
  }
  Widget _buildDropdown(String hint, String? value, ValueChanged<String?> onChanged, List<String> options,
      {bool isEnabled = true}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: hint,
        border: const OutlineInputBorder(),
      ),
      value: value,
      onChanged: isEnabled ? onChanged : null,
      items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
    );
  }
}