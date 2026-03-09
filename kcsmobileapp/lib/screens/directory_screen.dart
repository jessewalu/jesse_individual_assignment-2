import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/listing_provider.dart';
import 'listing_detail_screen.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  String _search = '';
  String _categoryFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ListingProvider>(context);
    final listings = provider.allListings.where((l) {
      final matchesSearch = l.name.toLowerCase().contains(
        _search.toLowerCase(),
      );
      final matchesCategory =
          _categoryFilter == 'All' || l.category == _categoryFilter;
      return matchesSearch && matchesCategory;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search for service',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                [
                      'All',
                      'Hospital',
                      'Police',
                      'Library',
                      'Restaurant',
                      'Cafe',
                      'Park',
                      'Tourist',
                    ]
                    .map(
                      (cat) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: _categoryFilter == cat,
                          onSelected: (_) =>
                              setState(() => _categoryFilter = cat),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: listings.length,
            itemBuilder: (context, index) {
              final item = listings[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('${item.category} • ${item.address}'),
                trailing: Text(item.latitude.toString()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ListingDetailScreen(listing: item),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
