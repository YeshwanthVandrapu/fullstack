import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:trail/redesigned.dart';
import 'package:dio/dio.dart';
import 'package:trail/test/version2.dart';


void main() {
  runApp( const GetMaterialApp(
    home: HomePage(),
  ));
}
