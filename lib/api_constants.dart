const String apiKey = 'cebad9f75fmshfab88a880803ebep1453e4jsn0f53a4c64d4b';

class ApiHeaders {
  static const Map<String, String> postHeaders = {
    'content-type': 'application/x-www-form-urlencoded',
    'Accept-Encoding': 'application/gzip',
    'X-RapidAPI-Key': apiKey,
    'X-RapidAPI-Host': 'google-translate1.p.rapidapi.com'
  };
  static const Map<String, String> getHeaders = {
    'Accept-Encoding': 'application/gzip',
    'X-RapidAPI-Key': apiKey,
    'X-RapidAPI-Host': 'google-translate1.p.rapidapi.com'
  };
}

class ParsedUri {
  static Uri getLang = Uri.parse(
      'https://google-translate1.p.rapidapi.com/language/translate/v2/languages');
  static Uri postDetect = Uri.parse(
      'https://google-translate1.p.rapidapi.com/language/translate/v2/detect');
  static Uri postTranslate = Uri.parse(
      'https://google-translate1.p.rapidapi.com/language/translate/v2');
}
