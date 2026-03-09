import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get listingsRef => _db.collection('listings');
  CollectionReference get usersRef => _db.collection('users');

  Future<void> createUserProfile(String uid, Map<String, dynamic> data) {
    return usersRef.doc(uid).set(data);
  }

  Stream<List<Listing>> getAllListings() {
    return listingsRef.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => Listing.fromDoc(doc)).toList(),
    );
  }

  Stream<List<Listing>> getListingsByUser(String uid) {
    return listingsRef
        .where('createdBy', isEqualTo: uid)
        .snapshots()
        .map((sn) => sn.docs.map((d) => Listing.fromDoc(d)).toList());
  }

  Future<void> addListing(Listing listing) {
    return listingsRef.add(listing.toMap());
  }

  Future<void> updateListing(Listing listing) {
    return listingsRef.doc(listing.id).update(listing.toMap());
  }

  Future<void> deleteListing(String id) {
    return listingsRef.doc(id).delete();
  }
}
