import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  String id;
  String name;
  String category;
  String address;
  String contactNumber;
  String description;
  double latitude;
  double longitude;
  String createdBy;
  Timestamp timestamp;

  Listing({
    this.id = '',
    required this.name,
    required this.category,
    required this.address,
    required this.contactNumber,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'address': address,
      'contactNumber': contactNumber,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'timestamp': timestamp,
    };
  }

  factory Listing.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Listing(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      address: data['address'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      description: data['description'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      createdBy: data['createdBy'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
