import 'package:flutter/material.dart';

class SavedItemsProvider extends ChangeNotifier {
  List<Object> savedItems = []; // Initialize with an empty list

  void addToSavedItems(Object item) {
    savedItems.add(item);
    notifyListeners(); // Notify listeners when the list changes
  }

  // Add other methods to manipulate the savedItems list if needed
}
