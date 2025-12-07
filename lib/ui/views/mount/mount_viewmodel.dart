import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:revanced_manager/app/app.locator.dart';
import 'package:revanced_manager/services/patcher_api.dart';
import 'package:revanced_manager/services/toast.dart';
import 'package:stacked/stacked.dart';

class MountViewModel extends BaseViewModel {
  final PatcherAPI _patcherAPI = locator<PatcherAPI>();
  final Toast _toast = locator<Toast>();
  final List<ApplicationWithIcon> apps = [];
  bool noApps = false;

  Future<void> initialize() async {
    apps.addAll(await _patcherAPI.getInstalledApps());
    noApps = apps.isEmpty;
    notifyListeners();
  }

  Future<void> selectInstalledApp(
    BuildContext context,
    String packageName,
  ) async {
    final String? result = await FlutterFileDialog.pickFile(
      params: const OpenFileDialogParams(
        mimeTypesFilter: ['application/vnd.android.package-archive'],
      ),
    );
    if (result != null) {
      final bool success = await _patcherAPI.mountApk(
        packageName,
        result,
      );
      if (success) {
        _toast.showBottom("APK mounted successfully");
      } else {
        _toast.showBottom("Failed to mount APK");
      }
    }
  }

  List<ApplicationWithIcon> getFilteredApps(String query) {
    return apps
        .where(
          (app) =>
              query.isEmpty ||
              query.length < 2 ||
              app.appName.toLowerCase().contains(query.toLowerCase()) ||
              app.packageName.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
