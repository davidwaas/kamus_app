import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:kamus_app/database_helper.dart';

class percakapanPage extends StatefulWidget {
  @override
  State<percakapanPage> createState() => _percakapanPageState();
}

class _percakapanPageState extends State<percakapanPage> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;

  bool _isListening = false;
  String _translatedText = "Hasil Terjemahan";

  final List<String> languages = ['meher', 'oirata', 'indonesia', 'inggris'];
  String sourceLang = 'indonesia';
  String targetLang = 'meher';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);

        await _speech.listen(
          localeId: sourceLang == 'inggris' ? 'en_US' : 'id_ID',
          onResult: (val) async {
            await _searchWord(val.recognizedWords);
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _speak() async {
    await _flutterTts.setLanguage(
      targetLang == 'inggris'
          ? 'en-US'
          : targetLang == 'indonesia'
          ? 'id-ID'
          : 'id-ID', // fallback untuk bahasa lokal
    );
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(_translatedText);
  }

  Future<void> _searchWord(String input) async {
    final db = DatabaseHelper();

    final wordRegExp = RegExp(r"[\w']+|[.,!?;]");
    final tokens =
        wordRegExp.allMatches(input).map((m) => m.group(0)!).toList();
    List<String> translatedTokens = [];

    for (String token in tokens) {
      if (RegExp(r'[.,!?;]').hasMatch(token)) {
        translatedTokens.add(token);
      } else {
        final results = await db.searchByLanguage(
          keyword: token,
          language: sourceLang,
        );
        if (results.isNotEmpty) {
          translatedTokens.add(results.first[targetLang] ?? '');
        } else {
          translatedTokens.add('[?]');
        }
      }
    }

    setState(() {
      _translatedText = _combineTokens(translatedTokens);
    });
  }

  String _combineTokens(List<String> tokens) {
    final buffer = StringBuffer();
    for (int i = 0; i < tokens.length; i++) {
      final token = tokens[i];
      if (i > 0 && !RegExp(r'[.,!?;]').hasMatch(token)) {
        buffer.write(' ');
      }
      buffer.write(token);
    }
    return buffer.toString();
  }

  Widget languageSelector(String selected, ValueChanged<String?> onChanged) {
    return DropdownButton2<String>(
      value: selected,
      items:
          languages.map((lang) {
            return DropdownMenuItem<String>(
              value: lang,
              child: Text(lang.toUpperCase()),
            );
          }).toList(),
      onChanged: onChanged,
      buttonStyleData: ButtonStyleData(
        height: 40,
        width: 130,
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      dropdownStyleData: DropdownStyleData(maxHeight: 120),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Percakapan',
          style: TextStyle(fontSize: screenWidth * 0.055),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: screenWidth * 0.07),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.orange.shade100,
        elevation: 0,
      ),
      backgroundColor: Colors.orange.shade50,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.06),
          child: Column(
            children: [
              Text(
                'PERCAKAPAN',
                style: GoogleFonts.lilitaOne(
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  languageSelector(sourceLang, (val) {
                    if (val != null) setState(() => sourceLang = val);
                  }),
                  SizedBox(width: screenWidth * 0.02),
                  Icon(Icons.compare_arrows, size: screenWidth * 0.07),
                  SizedBox(width: screenWidth * 0.02),
                  languageSelector(targetLang, (val) {
                    if (val != null) setState(() => targetLang = val);
                  }),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              IconButton(
                icon: Icon(
                  Icons.mic,
                  color: Colors.orange,
                  size: screenWidth * 0.13,
                ),
                onPressed: _listen,
              ),
              Text('Ucapkan', style: TextStyle(fontSize: screenWidth * 0.045)),
              SizedBox(height: screenHeight * 0.03),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        _translatedText,
                        style: GoogleFonts.lilitaOne(
                          color: Colors.brown,
                          fontSize: screenWidth * 0.05,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.volume_up,
                        color: Colors.orange,
                        size: screenWidth * 0.08,
                      ),
                      onPressed: () async {
                        await _speak();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
