// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';

class SearchFilter extends StatefulWidget {
  const SearchFilter({super.key});

  @override
  _SearchFilterState createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  RangeValues _priceRangeValues = const RangeValues(0, 100);
  bool isChecked = false;
  bool _isFreeShippingEnabled = false;
  final List<String> _selectedColors = [];

  void _onPriceRangeChanged(RangeValues values) {
    setState(() {
      _priceRangeValues = values;
    });
  }

  void _onFreeShippingChanged(bool value) {
    setState(() {
      _isFreeShippingEnabled = value;
    });
  }

  void _onColorChanged(String value, bool isChecked) {
    setState(() {
      if (isChecked) {
        _selectedColors.add(value);
      } else {
        _selectedColors.remove(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Filter'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Price Range'),
            subtitle: Text('\$${_priceRangeValues.start.toInt()} - \$${_priceRangeValues.end.toInt()}'),
          ),

          RangeSlider(
            values: _priceRangeValues,
            min: 0,
            max: 100,
            onChanged: _onPriceRangeChanged,
          ),
          ListTile(
            title: const Text('Free Shipping'),
            trailing: Switch(
              value: _isFreeShippingEnabled,
              onChanged: _onFreeShippingChanged,
            ),
          ),
          const ListTile(
            title: Text('Color'),
          ),
          /*
          CheckboxListTile(
            title: Text('Red'),
            value: _selectedColors.contains('Red'),
            onChanged: (isChecked) => _onColorChanged('Red', isChecked!),
          ),
          CheckboxListTile(
            title: Text('Blue'),
            value: _selectedColors.contains('Blue'),
            onChanged: (isChecked) => _onColorChanged('Blue', isChecked!),
          ),
          CheckboxListTile(
            title: Text('Green'),
            value: _selectedColors.contains('Green'),
            onChanged: (isChecked) => _onColorChanged('Green', isChecked!),
          ),
          */
          Expanded(
            child: DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.1,
              maxChildSize: 0.8,
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  color: Colors.amber,
                  child: ListView(
                    controller: scrollController,
                    children: const [
                      ListTile(
                        title: Text('Brand'),
                        subtitle: Text('Apple, Samsung, LG'),
                      ),
                      ListTile(
                        title: Text('Rating'),
                        subtitle: Text('4 stars and up'),
                      ),
                      ListTile(
                        title: Text('Sort by'),
                        subtitle: Text('Price: low to high'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void showFilterSheet(BuildContext context) {
  double viewHeight = MediaQuery.of(context).size.height * 0.85;
  showModalBottomSheet(
    context: context,
    enableDrag: true,
    isScrollControlled: true,
    useRootNavigator: false,
    isDismissible: true,
    builder: (BuildContext context) {
      return SizedBox(
        height: viewHeight,
        child: DraggableScrollableSheet(
          initialChildSize: 1.0,
          minChildSize: 0.2,
          maxChildSize: 1.0,
          expand: true,
          builder: (BuildContext context, ScrollController scrollController) {
            return const SearchFilter(
              // onFilterApplied: (bool applied) {
              //   setState(() {
              //     _filterApplied = applied;
              //   });
              //  Navigator.pop(context);
              //},
            );
          },
        ),
      );
    },
  );
}

