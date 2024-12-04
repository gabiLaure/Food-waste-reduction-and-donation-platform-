import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GlobalData {
  static Map<String, dynamic>? orphanageData;
  static Map<String, dynamic>? userData;

  // Méthode pour mettre à jour et stocker orphanageData
  static Future<void> updateOrphanageData(newData) async {
    orphanageData = newData;
    await _saveToLocalStorage('orphanageData', newData);
  }

  // Méthode pour mettre à jour et stocker userData
  static Future<void> updateUserData(newData) async {
    userData = newData;
    await _saveToLocalStorage('userData', newData);
  }

  // Sauvegarde des données dans le local storage
  static Future<void> _saveToLocalStorage(
      String key, Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = jsonEncode(data);
    await prefs.setString(key, jsonData);
  }

  static Future<void> loadFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? orphanageDataString = prefs.getString('orphanageData');
    if (orphanageDataString != null) {
      try {
        orphanageData = jsonDecode(orphanageDataString);
      } catch (e) {
        print('Erreur de décodage de orphanageData : $e');
        orphanageData = null; // Nettoie les données invalides
      }
    }

    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      try {
        userData = jsonDecode(userDataString);
      } catch (e) {
        print('Erreur de décodage de userData : $e');
        userData = null; // Nettoie les données invalides
      }
    }
  }

  // Clear user data
  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData'); // Remove specific user data
    userData = null; // Clear in-memory data
  }

// Clear all data (if needed)
  static Future<void> clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data
    orphanageData = null;
    userData = null;
  }
}
