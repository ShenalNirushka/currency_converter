import 'dart:convert';

class Currency {
  String code;
  String value;

  Currency({required this.code, required this.value});
  

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'value': value,
    };
  }

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      code: map['code'] ?? '',
      value: map['value'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Currency.fromJson(String source) => Currency.fromMap(json.decode(source));
}
