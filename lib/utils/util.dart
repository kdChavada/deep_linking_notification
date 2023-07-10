import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showToast(String message, {int duration = 3}) async {
  Get.showSnackbar(
    GetSnackBar(
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: Duration(seconds: duration),
      borderRadius: 16,
      backgroundColor: Colors.black,
    ),
  );
}

/*Create Dynamic Link*/
createLink(int? id) async {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: "https://9brainzdemo.page.link",
    link: Uri.parse("https://9brainzdemo.page.link/id=$id"),
    androidParameters: const AndroidParameters(
      packageName: 'com.example.deep_linking_notification',
    ),
    iosParameters: const IOSParameters(
      bundleId: 'com.example.deep_linking_notification',
    ),
  );
  final ShortDynamicLink dynamicUrl =
  await dynamicLinks.buildShortLink(parameters);
  return dynamicUrl.shortUrl.toString();
}
