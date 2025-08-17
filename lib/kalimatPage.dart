import 'package:flutter/material.dart';
import 'package:kamus_app/database_helper.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class kalimatPage extends StatefulWidget {
  const kalimatPage({super.key});

  @override
  State<kalimatPage> createState() => _kalimatPageState();
}

class _kalimatPageState extends State<kalimatPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = '';
  late final DatabaseHelper db;

  List<String> languages = ['meher', 'oirata', 'indonesia', 'inggris'];
  String _sourceLang = 'indonesia'; // bahasa asal
  String _targetLang = 'meher'; // bahasa tujuan

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    db = DatabaseHelper();
  }

  void _startListening() async {
    bool available = await _speech.initialize();

    if (available) {
      setState(() => _isListening = true);

      // Tentukan localeId berdasarkan _sourceLang
      String localeId;
      switch (_sourceLang) {
        case 'indonesia':
          localeId = 'id_ID';
          break;
        case 'inggris':
          localeId = 'en_US';
          break;
        // Tambahkan locale lain jika ada
        default:
          localeId = 'id_ID'; // fallback
      }

      await _speech.listen(
        localeId: localeId,
        onResult: (result) {
          setState(() {
            _spokenText = result.recognizedWords;
            _controller.text = _spokenText; // Isi kotak input otomatis
          });
        },
      );
    }
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final TextEditingController _controller = TextEditingController();
  String? _result;
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

  void _searchWord() async {
    final db = DatabaseHelper();
    final input = _controller.text.trim();

    // Pisahkan kata dan tanda baca, contoh: ["Maya'u", ",", "ma'ak", "."]
    final wordRegExp = RegExp(r"[\w']+|[.,!?;]");

    final tokens =
        wordRegExp.allMatches(input).map((m) => m.group(0)!).toList();

    List<String> translatedTokens = [];

    for (String token in tokens) {
      // Jika token adalah tanda baca, langsung tambahkan
      if (RegExp(r'[.,!?;]').hasMatch(token)) {
        translatedTokens.add(token);
      } else {
        final results = await db.searchByLanguage(
          keyword: token.toLowerCase(),
          language: _sourceLang,
        );

        if (results.isNotEmpty) {
          translatedTokens.add(results.first[_targetLang] ?? '');
        } else {
          translatedTokens.add('[?]');
        }
      }
    }

    setState(() {
      _result = _combineTokens(translatedTokens);
    });
  }

  final FlutterTts flutterTts = FlutterTts();
  Future<void> _speak(String text) async {
    await flutterTts.setLanguage(
      _targetLang == 'inggris'
          ? 'en-US'
          : _targetLang == 'indonesia'
          ? 'id-ID'
          : 'id-ID',
    ); // fallback untuk bahasa lokal

    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Kalimat', style: TextStyle(fontSize: screenWidth * 0.055)),
        backgroundColor: Colors.orange.shade100,
        elevation: 0,
      ),
      backgroundColor: Colors.orange.shade50,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown Bahasa Masukan dan Tujuan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _sourceLang,
                    onChanged: (value) {
                      setState(() {
                        _sourceLang = value!;
                        if (_sourceLang == _targetLang) {
                          _targetLang = languages.firstWhere(
                            (lang) => lang != _sourceLang,
                          );
                        }
                      });
                    },
                    items:
                        languages.map((lang) {
                          return DropdownMenuItem(
                            value: lang,
                            child: Text(
                              'Dari: ${lang.toUpperCase()}',
                              style: TextStyle(fontSize: screenWidth * 0.045),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                SizedBox(width: screenWidth * 0.06),
                Expanded(
                  child: DropdownButton<String>(
                    value: _targetLang,
                    onChanged: (value) {
                      setState(() {
                        _targetLang = value!;
                      });
                    },
                    items:
                        languages.map((lang) {
                          return DropdownMenuItem(
                            value: lang,
                            child: Text(
                              'Ke: ${lang.toUpperCase()}',
                              style: TextStyle(fontSize: screenWidth * 0.045),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.02),

            // Kotak input
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Masukkan kata atau kalimat',
                hintText: "Saya Makan",
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontSize: screenWidth * 0.045),
                hintStyle: TextStyle(fontSize: screenWidth * 0.045),
              ),
              style: TextStyle(fontSize: screenWidth * 0.045),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Tombol rekam
            Center(
              child: SizedBox(
                width: screenWidth * 0.55,
                height: screenHeight * 0.06,
                child: ElevatedButton.icon(
                  onPressed: _isListening ? _stopListening : _startListening,
                  icon: Icon(
                    _isListening ? Icons.stop : Icons.mic,
                    size: screenWidth * 0.07,
                  ),
                  label: Text(
                    _isListening ? 'Berhenti' : 'Rekam',
                    style: TextStyle(fontSize: screenWidth * 0.045),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.012),

            // Tombol terjemahkan
            Center(
              child: SizedBox(
                width: screenWidth * 0.55,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: _searchWord,
                  child: Text(
                    'Terjemahkan',
                    style: TextStyle(fontSize: screenWidth * 0.045),
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Hasil terjemahan
            if (_result != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _result!,
                      style: TextStyle(fontSize: screenWidth * 0.048),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.012),
                  SizedBox(
                    width: screenWidth * 0.55,
                    height: screenHeight * 0.06,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _speak(_result!);
                      },
                      icon: Icon(Icons.volume_up, size: screenWidth * 0.07),
                      label: Text(
                        'Dengarkan',
                        style: TextStyle(fontSize: screenWidth * 0.045),
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
