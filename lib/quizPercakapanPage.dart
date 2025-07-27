import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class QuizPercakapanPage extends StatefulWidget {
  @override
  QuizPercakapanPageState createState() => QuizPercakapanPageState();
}

class QuizPercakapanPageState extends State<QuizPercakapanPage> {
  final FlutterTts _flutterTts = FlutterTts();
  final List<Map<String, Object>> _questions = [
    {
      'context': [
        {'speaker': 'P', 'text': "Ate ina meden ana ye?"},
        {'speaker': 'L', 'text': "Ante dele horana nawa pee'na"},
      ],

      'question': "Kapal taan pitu riaan pitu tie ina na halsee?",
      'options': ["tai'wee", 'Hala', 'Natara', 'Bandara'],
      'answer': "tai'wee",
    },
    {
      'context': [
        {'speaker': 'P', 'text': "O ma'ak me'e kaun?"},
        {'speaker': 'L', 'text': "Ya'u mehe a'ak ke"},
      ],
      'question': "Inhawa rimooni one hii?",
      'options': ['wakuku', 'naroho', 'namkuru', 'Maak'],
      'answer': 'Maak',
    },
    {
      'context': [
        {'speaker': 'L', 'text': "Ate ina meden ana ye?"},
        {'speaker': 'P', 'text': "Ante dele horana nawa pee'na"},
      ],
      'question': "Tuhur te ina nama pe?",
      'options': ["T'dele Horana", 'kokis', 'Atasia', 'Ahi'],
      'answer': "T'dele Horana",
    },
    {
      'context': [
        {'speaker': 'P', 'text': "Marjo, ki'o a'i ewi?"},
        {'speaker': 'L', 'text': "Marjo aile kelas raram"},
      ],
      'question': "Min ewi mimwakunu ?",
      'options': ['iskol', "kira'am", 'kerei', 'lala'],
      'answer': 'iskol',
    },
    {
      'context': [
        {'speaker': 'P', 'text': "Ate ina tutu'pe?"},
        {'speaker': 'L', 'text': "Ante ira tutu pee'na"},
      ],
      'question': "Namrai te ira tutu pe ?",
      'options': ['anggur', "pee'na", 'kopi', 'mimraka'],
      'answer': "pee'na",
    },
    {
      'context': [
        {'speaker': 'P', 'text': "Domeku e maya'i la kere'i ye"},
        {'speaker': 'L', 'text': "Ika kala'a wewerre"},
      ],
      'question': "Hi' rala'a ewi pe?",
      'options': ['iskol', "kira'am", 'kerei', 'lala'],
      'answer': 'kerei',
    },
    {
      'context': [
        {'speaker': 'L', 'text': "ewi ki'o mala'a lere eni ?"},
        {'speaker': 'P', 'text': "ya'u po'on kirna lo'o nala'a"},
      ],
      'question': "ewi maweke on'ne lo'o nala'a ?",
      'options': ['kirna', 'iskol', 'kerei', 'nakar'],
      'answer': 'kirna',
    },
  ];

  int _currentQuestion = 0;
  int _score = 0;
  bool _quizFinished = false;

  Future<void> _speak(String text, String speaker) async {
    // Pilih suara berbeda untuk A dan B jika tersedia
    if (speaker == 'A' || speaker == 'P') {
      await _flutterTts.setPitch(1.1);
      await _flutterTts.setSpeechRate(0.45);
      await _flutterTts.setVoice({
        'name': 'id-id-x-idc-local',
        'locale': 'id-ID',
      });
    } else {
      await _flutterTts.setPitch(0.9);
      await _flutterTts.setSpeechRate(0.45);
      await _flutterTts.setVoice({
        'name': 'id-id-x-idd-local',
        'locale': 'id-ID',
      });
    }
    await _flutterTts.speak(text);
  }

  void _answerQuestion(String selectedOption) {
    if (selectedOption == _questions[_currentQuestion]['answer']) {
      _score++;
    }
    if (_currentQuestion < _questions.length - 1) {
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
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kuis Percakapan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child:
              _quizFinished
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Kuis Selesai!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text('SELAMAT !!!', style: TextStyle(fontSize: 20)),
                        Text(
                          'Skor Anda: $_score dari ${_questions.length}',
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
                        'Soal ${_currentQuestion + 1} dari ${_questions.length}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      ...((_questions[_currentQuestion]['context'] as List)
                          .map(
                            (dialog) => Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.play_arrow,
                                    color: Colors.deepPurple,
                                  ),
                                  onPressed:
                                      () => _speak(
                                        dialog['text'],
                                        dialog['speaker'],
                                      ),
                                ),
                                Text(
                                  dialog['speaker'] + ': Audio',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList()),
                      SizedBox(height: 10),
                      Text(
                        _questions[_currentQuestion]['question'] as String,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      ...(_questions[_currentQuestion]['options']
                              as List<String>)
                          .map((option) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              child: ElevatedButton(
                                onPressed: () => _answerQuestion(option),
                                child: Text(
                                  option,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            );
                          })
                          .toList(),
                    ],
                  ),
        ),
      ),
    );
  }
}
