import 'package:flutter/material.dart';

class QuizKalimatPage extends StatefulWidget {
  @override
  QuizKalimatPageState createState() => QuizKalimatPageState();
}

class QuizKalimatPageState extends State<QuizKalimatPage> {
  final List<Map<String, Object>> _questions = [
    {
      'question': "Maya'u ..... ke iskol akilere.",
      'options': ['mala\'a', 'mai', 'wilu', 'rakan'],
      'answer': 'mala\'a',
    },
    {
      'question': "ai ..... horok on'ne oirawi",
      'options': ['đerne', "po'on", 'lese', 'wakunu'],
      'answer': 'lese',
    },
    {
      'question': "na .... saholo yang robek",
      'options': ['rain', "aya ‘utan", 'natara, hinan', "u'utana pai"],
      'answer': "u'utana pai",
    },
    {
      'question': "Lor mara..... le ail-ume",
      'options': ['nisaun', 'Ira tai', "Rat’aun", 'Teteana'],
      'answer': 'Ira tai',
    },
    {
      'question': "ethain ka-se api(ap), apre, apri, apta, apte .... ira",
      'options': ['mara', 'tutu', 'saholo', 'api'],
      'answer': 'tutu',
    },
    {
      'question': "Noho Yotowawa nin wanakunu....., wanakunu Meher noro wanakunu Oiraka ",
      'options': ["woro'o", 'wokelu', "wo'aka", 'wolima'],
      'answer': "woro'o",
    },
    {
      'question': "A'i .... adi mo'oyane woro'o",
      'options': ['nin', 'mawekan', "nu'u", 'raram'],
      'answer': "nu'u",
    },
    {
      'question': "Santi mehen .... ha aile dapure",
      'options': ["kere'i", 'nakar', 'napali', 'lernala'],
      'answer': 'napali',
    },
    {
      'question': "lere .... hiheni, kaan nordu'ul",
      'options': ['yaka', 'manha', 'ri', 'manha'],
      'answer': 'manha',
    },
    {
      'question': "A'am .... wake'e lere manha",
      'options': ["nu'u", 'adi', 'aile', 'Kuku'],
      'answer': 'Kuku',
    },
  ];

  int _currentQuestion = 0;
  int _score = 0;
  bool _quizFinished = false;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kuis Kalimat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _quizFinished
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Kuis Selesai!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'SELAMAT !!!',
                      style: TextStyle(fontSize: 20),
                    ),
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
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Soal ${_currentQuestion + 1} dari ${_questions.length}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Text(
                      _questions[_currentQuestion]['question'] as String,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    ...(_questions[_currentQuestion]['options'] as List<String>).map((option) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 48),
                            shape: StadiumBorder(),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepPurple,
                            elevation: 2,
                            side: BorderSide(color: Colors.deepPurple.shade100),
                          ),
                          onPressed: () => _answerQuestion(option),
                          child: Text(option, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                        ),
                      );
                    }).toList(),
                  ],
                ),
        ),
      ),
    );
  }
}
