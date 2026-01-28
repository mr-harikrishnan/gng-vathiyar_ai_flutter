import '../../core/services/api_client.dart';
import '../../core/constants/api_constants.dart';

class LanguageApi {
  final ApiClient _client = ApiClient();

  // GET /languages
  Future<dynamic> getLanguagesRaw() {
    return _client.get(
      ApiConstants.languages,
      query: {
        "sortingDirection": "asc",
        "isPaginated": "false",
      },
    );
  }
}
