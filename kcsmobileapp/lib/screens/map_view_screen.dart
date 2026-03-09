import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
            point: LatLng(l.latitude, l.longitude),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${l.name} - ${l.category}')),
                );
              },
              child: const Icon(Icons.location_on, color: Colors.red, size: 40),
            ),
          ),
        )
        .toList();

    return Scaffold(
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(1.95, 30.05),
          initialZoom: 12,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }
}
