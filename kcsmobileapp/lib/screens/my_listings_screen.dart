import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/listing_provider.dart';
import '../providers/auth_provider.dart';
import 'create_edit_listing_screen.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.uid != null) {
      Provider.of<ListingProvider>(
        context,
        listen: false,
      ).loadMyListings(auth.uid!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ListingProvider>(context);
    final listings = provider.myListings;

    return Scaffold(
      body: listings.isEmpty
          ? const Center(child: Text('No listings yet'))
          : ListView.builder(
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final item = listings[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.category),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CreateEditListingScreen(listing: item),
                          ),
                        );
                      } else if (value == 'delete') {
                        provider.deleteListing(item.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateEditListingScreen()),
          );
        },
      ),
    );
  }
}
