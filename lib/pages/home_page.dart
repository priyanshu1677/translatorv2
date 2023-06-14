import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:translator/api_constants.dart';
import 'package:translator/components/my_textfield.dart';
import 'package:translator/routes/app_route_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _inputController = TextEditingController();

  String inputLanguage = 'English';
  String langCode = 'en';
  String outputLangCode = 'en';
  String translatedText = '';

  void dispose() {
    _inputController.dispose();

    super.dispose();
  }

  Future<void> detectLang(String input) async {
    final Map<String, String> apiParams = {'q': langCode};
    http
        .post(ParsedUri.postDetect,
            headers: ApiHeaders.postHeaders, body: apiParams)
        .then((response) {
      final json1 = jsonDecode(response.body);
      langCode = json1['data']['detections'][0][0]['language'];
      getLang(langCode);
    }).catchError((error) {
      print(error);
    });
  }

  Future<void> getLang(String code) async {
    http.Response response = await http.get(
      ParsedUri.getLang,
      headers: ApiHeaders.getHeaders,
    );

    if (response.statusCode == 200) {
      final json2 = jsonDecode(response.body);
      final allLanguages = json2.data.languages;
      for (var lang in allLanguages) {
        if (lang['language'] == code) {
          inputLanguage = lang['name'];
        } else {
          inputLanguage = 'Unknown';
        }
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> getLangCode(String outputLanguage) async {
    http.Response response = await http.get(
      ParsedUri.getLang,
      headers: ApiHeaders.getHeaders,
    );

    if (response.statusCode == 200) {
      final json2 = jsonDecode(response.body);
      final allLanguages = json2.data.languages;
      for (var lang in allLanguages) {
        if (lang['name'] == outputLanguage) {
          outputLangCode = lang['name'];
        } else {
          outputLangCode = 'Unknown';
        }
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> postTranslate(String input, String targetLang) async {
    getLangCode(targetLang);

    var params = {
      'q': input,
      'target': outputLangCode,
    };
    var response = await http.post(
      ParsedUri.postTranslate,
      headers: ApiHeaders.postHeaders,
      body: params,
    );
    if (response.statusCode == 200) {
      final json3 = jsonDecode(response.body);
      translatedText = json3['data']['translations'][0]['translatedText'];
      print(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              MyTextField(
                controller: _inputController,
                hintText: 'Input Text',
                obscureText: false,
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 60,
                    width: 30,
                    color: const Color.fromARGB(255, 255, 209, 69),
                    child: const Text('',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(color: Colors.white,),
                  
                  ),
                  child: const Text('',style: TextStyle(color: Colors.black, fontSize: 30, ),textAlign: TextAlign.center,),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 60,
                    width: 30,
                    color: Colors.lightBlue,
                    child: const Text('',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],

              ),
              const SizedBox(
                height: 60,
              ),
              ElevatedButton(onPressed: (){

              }, child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
