class LanguageModel {
  final String id;
  final String name;
  final String? nativeName;
  final String code;
  final String? i18nPath;

  LanguageModel({
    required this.id,
    required this.name,
    this.nativeName,
    required this.code,
    this.i18nPath,
  });

  // JSON -> Model
  factory LanguageModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LanguageModel(
      id: json["id"],
      name: json["name"],
      nativeName: json["nativeName"],
      code: json["code"],
      i18nPath: json["i18nPath"],
    );
  }
}
