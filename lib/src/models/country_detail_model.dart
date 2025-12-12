import 'dart:convert';

class CountryDetailModel {
  final String name;
  final String iso3;
  final String iso2;
  final String phoneCode;
  final String capital;
  final String currency;
  final String currencyName;
  final String currencySymbol;
  final String emoji;
  final String emojiU;
  final Translations translations;
  final List<StateData> states;

  CountryDetailModel({
    required this.name,
    required this.iso3,
    required this.iso2,
    required this.phoneCode,
    required this.capital,
    required this.currency,
    required this.currencyName,
    required this.currencySymbol,
    required this.emoji,
    required this.emojiU,
    required this.translations,
    required this.states,
  });

  factory CountryDetailModel.fromRawJson(String str) =>
      CountryDetailModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CountryDetailModel.fromJson(Map<String, dynamic> json) =>
      CountryDetailModel(
        name: json["name"],
        iso3: json["iso3"],
        iso2: json["iso2"],
        phoneCode: json["phone_code"],
        capital: json["capital"],
        currency: json["currency"],
        currencyName: json["currency_name"],
        currencySymbol: json["currency_symbol"],
        emoji: json["emoji"],
        emojiU: json["emojiU"],
        translations: Translations.fromJson(json["translations"]),
        states: List<StateData>.from(
            json["states"].map((x) => StateData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "iso3": iso3,
    "iso2": iso2,
    "phone_code": phoneCode,
    "capital": capital,
    "currency": currency,
    "currency_name": currencyName,
    "currency_symbol": currencySymbol,
    "emoji": emoji,
    "emojiU": emojiU,
    "translations": translations.toJson(),
    "states": List<dynamic>.from(states.map((x) => x.toJson())),
  };
}

class StateData {
  final String name;
  final String stateCode;
  final List<String> cities;

  StateData({
    required this.name,
    required this.stateCode,
    required this.cities,
  });

  factory StateData.fromRawJson(String str) =>
      StateData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StateData.fromJson(Map<String, dynamic> json) => StateData(
    name: json["name"],
    stateCode: json["state_code"],
    cities: List<String>.from(json["cities"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "state_code": stateCode,
    "cities": List<dynamic>.from(cities.map((x) => x)),
  };
}

class Translations {
  final String? kr;
  final String? br;
  final String? pt;
  final String? nl;
  final String? hr;
  final String? fa;
  final String? de;
  final String? es;
  final String? fr;
  final String? ja;
  final String? it;
  final String? cn;
  final String? tr;

  Translations({
    this.kr,
    this.br,
    this.pt,
    this.nl,
    this.hr,
    this.fa,
    this.de,
    this.es,
    this.fr,
    this.ja,
    this.it,
    this.cn,
    this.tr,
  });

  factory Translations.fromJson(Map<String, dynamic> json) {
    return Translations(
      kr: json['kr'],
      br: json['br'],
      pt: json['pt'],
      nl: json['nl'],
      hr: json['hr'],
      fa: json['fa'],
      de: json['de'],
      es: json['es'],
      fr: json['fr'],
      ja: json['ja'],
      it: json['it'],
      cn: json['cn'],
      tr: json['tr'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kr': kr,
      'br': br,
      'pt': pt,
      'nl': nl,
      'hr': hr,
      'fa': fa,
      'de': de,
      'es': es,
      'fr': fr,
      'ja': ja,
      'it': it,
      'cn': cn,
      'tr': tr,
    };
  }
}
