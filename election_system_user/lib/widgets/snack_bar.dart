import 'package:flutter/material.dart';
import 'package:get/get.dart';

GetSnackBar buildSnackBar({required String title,required Color color,String? message}) {
  return GetSnackBar(
    margin: const EdgeInsets.symmetric(horizontal: 10),
    backgroundColor: color,
    borderRadius: 10,
    duration: const Duration(milliseconds: 2000),
    title: title,
    snackPosition: SnackPosition.BOTTOM,
    message: message,
    icon: const Icon(
      Icons.info,
      color: Colors.white,
    ),
  );
}
