import 'dart:convert';
import 'package:auto_location_picker/auto_location_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class LocationPicker extends StatefulWidget {
  final String assetPath;

  final void Function(CountryDetailModel?, StateData?, String?)? onChanged;

  const LocationPicker({
    super.key,
    this.assetPath = 'assets/countries.json',
    this.onChanged,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  List<CountryDetailModel> countries = [];
  CountryDetailModel? selectedCountry;
  StateData? selectedState;
  String? selectedCity;

  bool showCountryDropdown = false;
  bool showStateDropdown = false;
  bool showCityDropdown = false;

  final TextEditingController countrySearchController = TextEditingController();
  final TextEditingController stateSearchController = TextEditingController();
  final TextEditingController citySearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadJson();
  }

  Future<void> _loadJson() async {
    try {
      String path = widget.assetPath;

      // If user passed "assets/countries.json", convert to package path
      if (!path.startsWith('packages/')) {
        path = 'packages/auto_location_picker/$path';
      }

      final response = await rootBundle.loadString(path);

      final List<dynamic> jsonList = jsonDecode(response) as List<dynamic>;
      countries = jsonList
          .map((e) => CountryDetailModel.fromJson(e as Map<String, dynamic>))
          .toList();

      setState(() {});
    } catch (e) {
      print(
          'auto_location_picker: failed to load asset ${widget.assetPath}: $e\n'
              'The asset does not exist or is empty.');
    }
  }


  @override
  void dispose() {
    countrySearchController.dispose();
    stateSearchController.dispose();
    citySearchController.dispose();
    super.dispose();
  }

  Widget _buildField({
    required String hint,
    required String? value,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 16,
                  color: value == null ? Colors.grey.shade600 : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade700),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineDropdown<T>({
    required TextEditingController controller,
    required List<T> items,
    required String Function(T) display,
    required void Function(T) onSelected,
  }) {
    final filtered = items
        .where((it) => display(it).toLowerCase().contains(controller.text.toLowerCase()))
        .toList();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // search
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controller,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                hintText: 'Search',
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: filtered.length > 6 ? 220 : filtered.length * 52.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final item = filtered[i];
                return InkWell(
                  onTap: () => onSelected(item),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 20, color: Colors.deepPurple),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            display(item),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _notify() {
    widget.onChanged?.call(selectedCountry, selectedState, selectedCity);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country field (always visible)
        _buildField(
          hint: 'Select Country',
          value: selectedCountry?.name,
          onTap: () {
            setState(() {
              showCountryDropdown = !showCountryDropdown;
              showStateDropdown = false;
              showCityDropdown = false;
            });
          },
        ),
        if (showCountryDropdown)
          _buildInlineDropdown<CountryDetailModel>(
            controller: countrySearchController,
            items: countries,
            display: (c) => c.name,
            onSelected: (c) {
              setState(() {
                selectedCountry = c;
                selectedState = null;
                selectedCity = null;
                showCountryDropdown = false;
                countrySearchController.clear();
                _notify();
              });
            },
          ),
        const SizedBox(height: 12),

        // State field (always visible)
        _buildField(
          hint: 'Select State',
          value: selectedState?.name,
          onTap: () {
            if (selectedCountry == null) return;
            setState(() {
              showStateDropdown = !showStateDropdown;
              showCountryDropdown = false;
              showCityDropdown = false;
            });
          },
        ),
        if (showStateDropdown && selectedCountry != null)
          _buildInlineDropdown<StateData>(
            controller: stateSearchController,
            items: selectedCountry!.states,
            display: (s) => s.name,
            onSelected: (s) {
              setState(() {
                selectedState = s;
                selectedCity = null;
                showStateDropdown = false;
                stateSearchController.clear();
                _notify();
              });
            },
          ),
        const SizedBox(height: 12),

        // City field (always visible)
        _buildField(
          hint: 'Select City',
          value: selectedCity,
          onTap: () {
            if (selectedState == null) return;
            setState(() {
              showCityDropdown = !showCityDropdown;
              showCountryDropdown = false;
              showStateDropdown = false;
            });
          },
        ),
        if (showCityDropdown && selectedState != null)
          _buildInlineDropdown<String>(
            controller: citySearchController,
            items: selectedState!.cities,
            display: (c) => c,
            onSelected: (c) {
              setState(() {
                selectedCity = c;
                showCityDropdown = false;
                citySearchController.clear();
                _notify();
              });
            },
          ),
      ],
    );
  }
}
