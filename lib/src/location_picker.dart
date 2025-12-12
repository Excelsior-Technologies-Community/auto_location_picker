import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/country_detail_model.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});

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

  TextEditingController countrySearchController = TextEditingController();
  TextEditingController stateSearchController = TextEditingController();
  TextEditingController citySearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    String response = await rootBundle.loadString("assets/data/countries.json");
    List<dynamic> jsonList = jsonDecode(response);
    countries = jsonList.map((e) => CountryDetailModel.fromJson(e)).toList();
    setState(() {});
  }

  // 🔥 Stylish Dropdown Field
  Widget buildDropdownField({
    required String hint,
    required String? value,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: value == null ? Colors.grey.shade500 : Colors.black,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, size: 28, color: Colors.grey.shade700),
          ],
        ),
      ),
    );
  }


  // 🔥 Modern Searchable Dropdown
  Widget buildInlineDropdown<T>({
    required TextEditingController controller,
    required List<T> items,
    required String Function(T) itemToString,
    required void Function(T) onSelected,
  }) {
    List<T> filtered = items
        .where((item) => itemToString(item)
        .toLowerCase()
        .contains(controller.text.toLowerCase()))
        .toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          // Search Field
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                hintText: "Search...",
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // List
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: filtered.length > 6 ? 220 : filtered.length * 55,
            ),
            child: ListView.builder(
              itemCount: filtered.length,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final item = filtered[index];
                return InkWell(
                  onTap: () => onSelected(item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    child:Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 20, color: Colors.deepPurple),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            itemToString(item),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        title: const Text("Location Picker"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: countries.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildDropdownField(
              hint: "Select Country",
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
              buildInlineDropdown<CountryDetailModel>(
                controller: countrySearchController,
                items: countries,
                itemToString: (c) => c.name,
                onSelected: (c) {
                  setState(() {
                    selectedCountry = c;
                    selectedState = null;
                    selectedCity = null;
                    showCountryDropdown = false;
                    countrySearchController.clear();
                  });
                },
              ),

            const SizedBox(height: 20),

            buildDropdownField(
              hint: "Select State",
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
              buildInlineDropdown<StateData>(
                controller: stateSearchController,
                items: selectedCountry!.states,
                itemToString: (s) => s.name,
                onSelected: (s) {
                  setState(() {
                    selectedState = s;
                    selectedCity = null;
                    showStateDropdown = false;
                    stateSearchController.clear();
                  });
                },
              ),

            const SizedBox(height: 20),

            buildDropdownField(
              hint: "Select City",
              value: selectedCity,
              onTap: () {
                if (selectedState == null) return;
                setState(() {
                  showCityDropdown = !showCityDropdown;
                  showStateDropdown = false;
                  showCountryDropdown = false;
                });
              },
            ),

            if (showCityDropdown && selectedState != null)
              buildInlineDropdown<String>(
                controller: citySearchController,
                items: selectedState!.cities,
                itemToString: (c) => c,
                onSelected: (c) {
                  setState(() {
                    selectedCity = c;
                    showCityDropdown = false;
                    citySearchController.clear();
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
