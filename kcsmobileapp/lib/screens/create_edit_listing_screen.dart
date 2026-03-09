import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/listing_model.dart';
import '../providers/auth_provider.dart';
import '../providers/listing_provider.dart';

class CreateEditListingScreen extends StatefulWidget {
  final Listing? listing;

  const CreateEditListingScreen({super.key, this.listing});

  @override
  State<CreateEditListingScreen> createState() =>
      _CreateEditListingScreenState();
}

class _CreateEditListingScreenState extends State<CreateEditListingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _addressController;
  late TextEditingController _contactController;
  late TextEditingController _descriptionController;

  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    final l = widget.listing;
    _nameController = TextEditingController(text: l?.name);
    _categoryController = TextEditingController(text: l?.category);
    _addressController = TextEditingController(text: l?.address);
    _contactController = TextEditingController(text: l?.contactNumber);
    _descriptionController = TextEditingController(text: l?.description);
    _latitude = l?.latitude;
    _longitude = l?.longitude;
  }

  Future<void> _fetchLocation() async {
    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _latitude = pos.latitude;
      _longitude = pos.longitude;
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final listing = Listing(
      id: widget.listing?.id ?? '',
      name: _nameController.text,
      category: _categoryController.text,
      address: _addressController.text,
      contactNumber: _contactController.text,
      description: _descriptionController.text,
      latitude: _latitude ?? 0,
      longitude: _longitude ?? 0,
      createdBy: auth.uid ?? '',
      timestamp: widget.listing?.timestamp ?? Timestamp.now(),
    );
    final provider = Provider.of<ListingProvider>(context, listen: false);
    if (widget.listing == null) {
      provider.createListing(listing);
    } else {
      provider.updateListing(listing);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listing == null ? 'New Listing' : 'Edit Listing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact Number'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _latitude != null && _longitude != null
                          ? 'Lat: $_latitude, Lon: $_longitude'
                          : 'Location not set',
                    ),
                  ),
                  TextButton(
                    onPressed: _fetchLocation,
                    child: const Text('Use current location'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
