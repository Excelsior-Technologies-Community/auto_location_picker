# AutoLocationPicker
A beautiful, lightweight, and dependency-free **Country → State → City Picker** for Flutter.  
Loads hierarchical location data from a JSON file and provides a smooth, inline dropdown UI.

Perfect for signup forms, address sections, and location-based apps.

---

## ✨ Features

- 🌍 Country → State → City auto-linked selection  
- 🔍 Built-in search for all dropdowns  
- 🎨 Modern, attractive UI (no third-party UI packages)  
- 📦 Works with **JSON from your package assets**  
- ⚡ Fully customizable callbacks  
- ❌ No third-party dependencies — pure Flutter
---
## ✨ Preview
![screen-20251212-1722092](https://github.com/user-attachments/assets/d699c848-df81-44ee-94f6-f0ba0ee5b557)

---
## ✨ Installation
Add this to your package's pubspec.yaml file:
```
dependencies:
  auto_location_picker:
    path: ../auto_location_picker  # For local development
```
from git:
```
dependencies:
  auto_location_picker:
    git:
      url: https://github.com/yourusername/auto_location_picker.git  # Your github path
```
Then run:
```
flutter pub get
```
---
## 📁Add JSON File
Your package already includes the file:
```
assets/countries.json
```
---
## Example JSON structure:
```
json
[
  {
    "name": "India",
    "states": [
      {
        "name": "Gujarat",
        "cities": ["Ahmedabad", "Surat", "Vadodara"]
      }
    ]
  }
]
```
---
## 📁 Folder Structure
```
auto_location_picker/
│
├── assets/
│   └── countries.json
│
├── lib/
│   ├── auto_location_picker.dart
│   └── src/
│       ├── location_picker.dart
│       └── models/
│           └── country_detail_model.dart
│
└── README.md

```
---
## 📥 How It Loads Assets
Assets inside the package are auto-loaded from:
```
bash
packages/auto_location_picker/assets/countries.json
```
You can override the asset path:
```
dart
LocationPicker(assetPath: 'assets/my_custom_file.json')

```
---
## 🚀 Usage
```
dart
import 'package:flutter/material.dart';
import 'package:auto_location_picker/auto_location_picker.dart';

class ExampleHome extends StatefulWidget {
  const ExampleHome({super.key});
  @override
  State<ExampleHome> createState() => _ExampleHomeState();
}

class _ExampleHomeState extends State<ExampleHome> {
  CountryDetailModel? country;
  StateData? state;
  String? city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Picker Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LocationPicker(
              assetPath: 'assets/countries.json',
              onChanged: (c, s, ci) {
                setState(() {
                  country = c;
                  state = s;
                  city = ci;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Selected: ${country?.name ?? '-'} / ${state?.name ?? '-'} / ${city ?? '-'}",
            ),
          ],
        ),
      ),
    );
  }
}
```
---
## 📜 License
MIT License
```
Copyright (c) 2025 Excelsior Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED **"AS IS"**, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
