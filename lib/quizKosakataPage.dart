import 'package:flutter/material.dart';

class QuizKosakataPage extends StatefulWidget {
  @override
  _QuizKosakataPageState createState() => _QuizKosakataPageState();
}

class _QuizKosakataPageState extends State<QuizKosakataPage> {
  final List<Map<String, Object>> _questions = [
    {
      'image':
          'assets/1.png', // Ganti dengan path gambar yang sesuai di assets Anda
      'question':
          'Pada gambar diatas, terlihat anak kecil sedang tidur. Tidur dalam bahasa Meher adalah?',
      'options': ['Namkuru', 'Ma’ak', 'Wakuku', 'Maroho'],
      'answer': 'Namkuru',
    },

    {
      'image':
          'assets/2.png', // Ganti dengan path gambar yang sesuai di assets Anda
      'question': 'Apa nama hewan di atas dalam bahasa Oirata?',
      'options': ['Mau-mau', 'Hihiyotowa', 'Nana', 'Asa'],
      'answer': 'Asa',
    },
    {
      'image':
          'assets/3.jpg', // Ganti dengan path gambar yang sesuai di assets Anda
      'question':
          'Gambar di atas menunjukkan musim hujan. Hujan dalam bahasa Meher adalah?',
      'options': ['Manha', 'Ler alam', 'Okon', 'Aya Utan'],
      'answer': 'Okon',
    },
    {
      'image': 'assets/4.png',
      'question': "Sebutkan buah diatas dalam bahasa Oirata...",
      'options': ['Mu’uwoi ', 'Maplana', 'Haiya', 'Mumlay'],
      'answer': 'Haiya',
    },
    {
      'image': 'assets/5.png',
      'question':
          "Gambar diatas menunjukkan orang yang sedang makan. Apa kata makan dalam bahasa Meher ",
      'options': ['Namkuru', 'Ma’ak', 'Wakuku', 'Maroho'],
      'answer': 'Ma’ak',
    },
    // Tambahkan soal berikutnya sesuai format di atas
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
      appBar: AppBar(title: Text('Kuis Kosakata')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    // Petunjuk mengerjakan soal
                    Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Petunjuk:\nPilih jawaban yang paling tepat sesuai dengan gambar dan pertanyaan yang diberikan. Tekan salah satu pilihan untuk melanjutkan ke soal berikutnya.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      'Soal ${_currentQuestion + 1} dari ${_questions.length}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    if (_questions[_currentQuestion]['image'] != null)
                      Image.asset(
                        _questions[_currentQuestion]['image'] as String,
                        height: 150,
                      ),
                    SizedBox(height: 20),
                    Text(
                      _questions[_currentQuestion]['question'] as String,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    ...(_questions[_currentQuestion]['options'] as List<String>)
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
    );
  }
}
