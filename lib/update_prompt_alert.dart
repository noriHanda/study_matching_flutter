import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:package_info/package_info.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class UpdatePromptAlert {
  static Future<bool> shouldUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appVersionStr = packageInfo.version;
    final appVersion = Version.parse(appVersionStr); // 現在のアプリのバージョン

    // remoteConfigの初期化
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    // 何らかの事情でRemoteConfigから最新の値を取ってこれなかった場合のフォールバック
    final defaultValues = <String, dynamic>{
      'android_required_semver': appVersionStr,
      'ios_required_semver': appVersionStr
    };
    await remoteConfig.setDefaults(defaultValues);

    await remoteConfig.fetch(); // デフォルトで12時間キャッシュされる
    await remoteConfig.activateFetched();

    final remoteConfigAppVersionKey = Platform.isIOS
        ? 'ios_required_semver'
        : 'android_required_semver'; // iOSとAndroid以外のデバイスが存在しない前提

    final requiredVersion =
        Version.parse(remoteConfig.getString(remoteConfigAppVersionKey));
    return appVersion.compareTo(requiredVersion).isNegative;
  }
}

showUpdatePromptAlert(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Platform.isAndroid
          ? AlertDialog(
              title: Text('バージョンアップデートのお願い'),
              content: Text(
                  '最新バージョンがリリースされました。引き続きスタマチをご利用いただくために、アプリのアップデートをお願いします'),
              actions: <Widget>[
                  FlatButton(
                      child: Text(
                        "アップデートする",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () => launchURL(
                            "https://play.google.com/store/apps/details?id=com.hufurima.study_matching&hl=ja",
                          ))
                ])
          : AlertDialog(
              title: Text('バージョンアップデートのお願い'),
              content: Text(
                  '最新バージョンがリリースされました。引き続きスタマチをご利用いただくために、アプリのアップデートをお願いします'),
              actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "アップデートする",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () => launchURL(
                        "https://apps.apple.com/jp/app/%E3%82%B9%E3%82%BF%E3%83%9E%E3%83%81-%E5%A4%A7%E5%AD%A6%E7%94%9F%E9%99%90%E5%AE%9A%E3%81%AE%E5%AD%A6%E7%BF%92%E7%94%A8%E3%83%9E%E3%83%83%E3%83%81%E3%83%B3%E3%82%B0%E3%82%A2%E3%83%97%E3%83%AA/id1480122846"),
                  )
                ]));
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw '$url を起動できませんでした';
  }
}
