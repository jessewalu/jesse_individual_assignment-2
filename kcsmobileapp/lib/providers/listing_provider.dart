import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../services/firestore_service.dart';

class ListingProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();

  List<Listing> _allListings = [];
  List<Listing> _myListings = [];
  bool isLoading = false;
  String? error;

  ListingProvider() {
    _firestore.getAllListings().listen((list) {
      _allListings = list;
      notifyListeners();
    });
  }

  List<Listing> get allListings => _allListings;
  List<Listing> get myListings => _myListings;

  void loadMyListings(String uid) {
    _firestore.getListingsByUser(uid).listen((list) {
      _myListings = list;
      notifyListeners();
    });
  }

  Future<void> createListing(Listing listing) async {
    isLoading = true;
    notifyListeners();
    try {
      await _firestore.addListing(listing);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateListing(Listing listing) async {
    isLoading = true;
    notifyListeners();
    try {
      await _firestore.updateListing(listing);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteListing(String id) async {
    isLoading = true;
    notifyListeners();
    try {
      await _firestore.deleteListing(id);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
