import 'language_api.dart';
import 'language_model.dart';

class LanguageService {
  final LanguageApi _api = LanguageApi();

  // UI will call this
  Future<List<LanguageModel>> getLanguages() async {
    final data = await _api.getLanguagesRaw();

    final List items = data["items"];

    return items
        .map((e) => LanguageModel.fromJson(e))
        .toList();
  }
}
