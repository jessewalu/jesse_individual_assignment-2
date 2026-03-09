import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/listing_provider.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listings = Provider.of<ListingProvider>(context).allListings;
    final markers = listings
        .map(
          (l) => Marker(
            markerId: MarkerId(l.id),
            position: LatLng(l.latitude, l.longitude),
            infoWindow: InfoWindow(title: l.name, snippet: l.category),
          ),
        )
        .toSet();

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(1.95, 30.05),
          zoom: 12,
        ),
        markers: markers,
      ),
    );
  }
}
