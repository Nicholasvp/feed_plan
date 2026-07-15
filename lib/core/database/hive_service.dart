import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  HiveService._();

  static const String profilesBoxName = 'profiles';
  static const String carouselsBoxName = 'carousels';
  static const String pagesBoxName = 'pages';
  static const String canvasItemsBoxName = 'canvas_items';
  static const String instagramPostsBoxName = 'instagram_posts';

  static Future<void> initialize() async {
    String hivePath;

    if (Platform.isMacOS) {
      final home = Platform.environment['HOME'];
      if (home != null) {
        hivePath = '$home/Library/Application Support/feedplan';
      } else {
        final dir = await getApplicationSupportDirectory();
        hivePath = dir.path;
      }
    } else {
      final dir = await getApplicationSupportDirectory();
      hivePath = dir.path;
    }

    Hive.init(hivePath);
  }

  static Future<Box> openProfilesBox() async {
    return Hive.openBox(profilesBoxName);
  }

  static Future<Box> openCarouselsBox() async {
    return Hive.openBox(carouselsBoxName);
  }

  static Future<Box> openPagesBox() async {
    return Hive.openBox(pagesBoxName);
  }

  static Future<Box> openCanvasItemsBox() async {
    return Hive.openBox(canvasItemsBoxName);
  }

  static Future<Box> openInstagramPostsBox() async {
    return Hive.openBox(instagramPostsBoxName);
  }
}
