import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class ListingDetailScreen extends StatelessWidget {
  final Listing listing;

  const ListingDetailScreen({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    final LatLng position = LatLng(listing.latitude, listing.longitude);

    return Scaffold(
      appBar: AppBar(title: Text(listing.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              listing.category,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(listing.address),
            Text('Contact: ${listing.contactNumber}'),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: position,
                  zoom: 14,
                ),
                markers: {
                  Marker(markerId: MarkerId(listing.id), position: position),
                },
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final url =
                    'https://www.google.com/maps/dir/?api=1&destination=${listing.latitude},${listing.longitude}';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  if (kDebugMode) print('Could not launch $url');
                }
              },
              child: const Text('Navigate'),
            ),
            const SizedBox(height: 16),
            Text(listing.description),
          ],
        ),
      ),
    );
  }
}
