import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mutex/mutex.dart';
import 'package:app_settings/app_settings.dart';

class PermissionWrapper {
  Future<bool> checkIsPermenantlyDenied() async {
    await Future.delayed(Duration(milliseconds: 500));
    final perms = await this._requestPermissions();
    final permenantlyDenied =
        perms[0].isPermanentlyDenied || perms[1].isPermanentlyDenied;
    return permenantlyDenied;
  }

  Future<bool> checkIsGranted() async {
    final perms = await this._requestPermissions();
    final isGranted = perms[0].isGranted && perms[1].isGranted;
    return isGranted;
  }

  final m = Mutex();
  Future<List<PermissionStatus>> _requestPermissions() async {
    await m.acquire();
    final perms0 = await Permission.storage.request();
    final perms1 = await Permission.photos.request();
    m.release();
    return [perms0, perms1];
  }

  Future<bool> askPermissions(BuildContext c) async {
    // print('ask permissions');
    final perms = await this._requestPermissions();
    if (perms[0].isDenied) {
      await Permission.storage.shouldShowRequestRationale;
    }
    if (perms[1].isDenied) {
      await Permission.photos.shouldShowRequestRationale;
    }
    final isGranted = await this.checkIsGranted();
    if (c == null) {
      return isGranted;
    }
    if (!isGranted) {
      await showAlertDialog(c);
      // print('About to open settings');
      await AppSettings.openAppSettings();
    }
    final isGrantedYet = await this.checkIsGranted();
    return isGrantedYet;
  }
}

Future<void> showAlertDialog(BuildContext context) async {
  Widget understoodButton = TextButton(
    child: Text("Ok I understand"),
    onPressed:  () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Photo Permissions"),
    content: Text("On the next screen please give Zoomore to access to read photos"),
    actions: [
      understoodButton,
    ],
  );

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}