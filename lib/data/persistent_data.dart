/*
import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  //singleton
  AppData._sharedInstance();
  static late final AppData _shared = AppData._sharedInstance();
  factory AppData.instance() => _shared;

  static Future<void> addBookmark(String routeId) async {
    print("addBookmark to data");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('bookmarks') ?? [];
    if(bookmarks.length > 100){
      bookmarks.removeAt(0);
    }
    if (!bookmarks.contains(routeId)) {
      bookmarks.add(routeId);
      prefs.setStringList('bookmarks', bookmarks);
    }
  }

  static Future<void> removeBookmark(String routeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('bookmarks') ?? [];
    if (bookmarks.contains(routeId)) {
      bookmarks.remove(routeId);
      prefs.setStringList('bookmarks', bookmarks);
    }
  }

  static Future<List<String>> getBookmarks() async {
    print("getBookmarks from data");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //if empty return example list
    return prefs.getStringList('bookmarks') ??
        [32000, 31999].map((e) => e.toString()).toList();
  }

  static Future<void> addHistory(String routeId) async {
    print("addHistory to data");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('history') ?? [];
    if(history.length > 20){
      history.removeAt(0);
    }
    if (!history.contains(routeId)) {
      history.add(routeId);
      prefs.setStringList('history', history);
    }
  }

  static Future<List<String>> getHistory() async {
    print("getHistory from data");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('history') ?? [];
  }

  static Future<void> removeFromHistory(String routeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('history') ?? [];
    if (history.contains(routeId)) {
      history.remove(routeId);
      prefs.setStringList('history', history);
    }
  }
}
*/
