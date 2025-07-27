import 'package:flutter/material.dart';
import 'database_helper.dart';

class QuizKosakataPage extends StatefulWidget {
  @override
  _QuizKosakataPageState createState() => _QuizKosakataPageState();
}

class _QuizKosakataPageState extends State<QuizKosakataPage> {
  List<Map<String, dynamic>> _words = [];
  List<Map<String, String>> _questionModes = []; // [{from: 'indonesia', to: 'inggris'}, ...]
  int _currentQuestion = 0;
  int _score = 0;
  bool _quizFinished = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final words = await DatabaseHelper().getAllWords();
    final selectedWords = words.take(10).toList();
    // Deteksi semua field bahasa dari data
    final langs = <String>[];
    if (selectedWords.isNotEmpty) {
      selectedWords.first.keys.forEach((k) {
        if (k != 'id') langs.add(k);
      });
    }
    // Acak mode soal untuk setiap pertanyaan
    final List<Map<String, String>> modes = [];
    final random = langs.length > 1;
    for (int i = 0; i < selectedWords.length; i++) {
      if (random) {
        final from = (langs.toList()..shuffle()).first;
        String to;
        do {
          to = (langs.toList()..shuffle()).first;
        } while (to == from);
        modes.add({'from': from, 'to': to});
      } else {
        modes.add({'from': langs[0], 'to': langs[0]});
      }
    }
    setState(() {
      _words = selectedWords;
      _questionModes = modes;
      _isLoading = false;
    });
  }

  void _answerQuestion(String selectedOption) {
    final mode = _questionModes[_currentQuestion];
    String correctAnswer = _words[_currentQuestion][mode['to']];
    if (selectedOption == correctAnswer) {
      _score++;
    }
    if (_currentQuestion < _words.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      setState(() {
        _quizFinished = true;
      });
    }
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _quizFinished = false;
      _isLoading = true;
    });
    _loadWords();
  }

  List<String> _generateOptions(int index) {
    if (_words.isEmpty) return [];
    final mode = _questionModes[index];
    String correctAnswer = _words[index][mode['to']];
    List<String> options = [correctAnswer];
    // Ambil 3 jawaban acak lain dari data
    final otherWords = List<Map<String, dynamic>>.from(_words)..removeAt(index);
    otherWords.shuffle();
    for (var i = 0; i < 3 && i < otherWords.length; i++) {
      String option = otherWords[i][mode['to']];
      options.add(option);
    }
    options.shuffle();
    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kuis Kosakata')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _words.isEmpty
              ? Center(child: Text('Tidak ada data kosakata.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _quizFinished
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Kuis Selesai!',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Skor Anda: $_score dari ${_words.length}',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _resetQuiz,
                                child: Text('Ulangi Kuis'),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Soal ${_currentQuestion + 1} dari ${_words.length}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Apa arti kata "${_words[_currentQuestion][_questionModes[_currentQuestion]['from']]}" dalam bahasa '
                              + (_questionModes[_currentQuestion]['to'] != null
                                  ? _questionModes[_currentQuestion]['to']!.substring(0, 1).toUpperCase() + _questionModes[_currentQuestion]['to']!.substring(1)
                                  : ''
                                ) + '?',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 30),
                            ..._generateOptions(_currentQuestion).map(
                              (option) => Container(
                                margin: EdgeInsets.only(bottom: 12),
                                child: ElevatedButton(
                                  onPressed: () => _answerQuestion(option),
                                  child: Text(option, style: TextStyle(fontSize: 18)),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
    );
  }
}
