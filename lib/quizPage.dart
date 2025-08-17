import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, Object>> _allQuestions = [
    // Kosakata
    {
      'type': 'kosakata',
      'image': 'assets/1.png',
      'question':
          'Pada gambar diatas, anak kecil sedang tidur. Tidur dalam bahasa Meher adalah?',
      'options': ['Namkuru', 'Ma’ak', 'Wakuku', 'Maroho'],
      'answer': 'Namkuru',
    },
    {
      'type': 'kosakata',
      'image': 'assets/2.png',
      'question': 'Apa nama hewan di atas dalam bahasa Oirata?',
      'options': ['Mau-mau', 'Hihiyotowa', 'Nana', 'Asa'],
      'answer': 'Asa',
    },
    {
      'type': 'kosakata',
      'image': 'assets/3.jpg',
      'question':
          'Gambar di atas menunjukkan musim hujan. Hujan dalam bahasa Meher adalah?',
      'options': ['Manha', 'Ler alam', 'Okon', 'Aya Utan'],
      'answer': 'Okon',
    },
    {
      'type': 'kosakata',
      'image': 'assets/4.png',
      'question': "Sebutkan buah diatas dalam bahasa Oirata...",
      'options': ["Mu’uwoi", 'Maplana', 'Haiya', 'Mumlay'],
      'answer': 'Haiya',
    },
    {
      'type': 'kosakata',
      'image': 'assets/5.png',
      'question':
          "Gambar diatas menunjukkan orang yang sedang makan. Apa kata makan dalam bahasa Meher ",
      'options': ['Namkuru', 'Ma’ak', 'Wakuku', 'Maroho'],
      'answer': 'Ma’ak',
    },
    {
      'type': 'kosakata',
      'image': 'assets/6.png',
      'question': "Sebutkan nama hewan diatas menggunakan bahasa Meher.",
      'options': ['Pipduma', 'Wawi', 'Ahu', 'Pipi'],
      'answer': 'Ahu',
    },
    {
      'type': 'kosakata',
      'image': 'assets/7.png',
      'question':
          "Gambar di atas adalah buah jagung. Jagung dalam bahasa Oirata adalah..",
      'options': ['Dele', 'Limu', 'Mumlai', 'Wata'],
      'answer': 'Dele',
    },
    {
      'type': 'kosakata',
      'image': 'assets/8.png',
      'question': "Sebutkan bagian tubuh diatas menggunakkan bahasa Oirata.",
      'options': ['Murwana', "O'o", 'Wali', "Ina'modo"],
      'answer': "Ina'modo",
    },
    {
      'type': 'kosakata',
      'image': 'assets/9.png',
      'question':
          "Sebutkan kegiatan apa yang sedang dilakukan pada gambar diatas menggunakan bahasa Oirata.",
      'options': ["I'nahanawe", 'Seselana ', "Ta'ya", 'Namkuru'],
      'answer': 'Saselena',
    },
    // Kalimat
    {
      'type': 'kalimat',
      'question': "Maya'u ..... ke iskol akilere.",
      'options': ['mala\'a', 'mai', 'wilu', 'rakan'],
      'answer': 'mala\'a',
    },
    {
      'type': 'kalimat',
      'question': "ai ..... horok on'ne oirawi",
      'options': ['đerne', "po'on", 'lese', 'wakunu'],
      'answer': 'lese',
    },
    {
      'type': 'kalimat',
      'question': "Maya'u ..... ke iskol akilere.",
      'options': ["mala'a", 'mai', 'wilu', 'rakan'],
      'answer': "mala'a",
    },
    {
      'type': 'kalimat',
      'question': "Lor mara..... le ail-ume",
      'options': ['nisaun', 'Ira tai', "Rat’aun", 'Teteana'],
      'answer': 'Ira tai',
    },
    {
      'type': 'kalimat',
      'question': "ethain ka-se api(ap), apre, apri, apta, apte .... ira",
      'options': ['mara', 'tutu', 'saholo', 'api'],
      'answer': 'tutu',
    },
    {
      'type': 'kalimat',
      'question':
          "Noho Yotowawa nin wanakunu....., wanakunu Meher noro wanakunu Oiraka ",
      'options': ["woro'o", 'wokelu', "wo'aka", 'wolima'],
      'answer': "woro'o",
    },
    {
      'type': 'kalimat',
      'question': "A'i .... adi mo'oyane woro'o",
      'options': ['nin', 'mawekan', "nu'u", 'raram'],
      'answer': "nu'u",
    },
    {
      'type': 'kalimat',
      'question': "Santi mehen .... ha aile dapure",
      'options': ["kere'i", 'nakar', 'napali', 'lernala'],
      'answer': 'napali',
    },
    {
      'type': 'kalimat',
      'question': "lere .... hiheni, kaan nordu'ul",
      'options': ['yaka', 'manha', 'ri', 'manha'],
      'answer': 'manha',
    },
    {
      'type': 'kalimat',
      'question': "A'am .... wake'e lere manha",
      'options': ["nu'u", 'adi', 'aile', 'Kuku'],
      'answer': 'Kuku',
    },
    // Percakapan
    {
      'type': 'percakapan',
      'context': [
        {'label': 'Audio', 'audio': '1.MP3'},
      ],
      'question': "Kapal taan pitu riaan pitu tie ina na halsee?",
      'options': ["tai'wee", 'Hala', 'Natara', 'Bandara'],
      'answer': "tai'wee",
    },
    {
      'type': 'percakapan',
      'context': [
        {'label': 'Audio', 'audio': '2.MP3'},
      ],
      'question': "Inhawa rimooni one hii?",
      'options': ['wakuku', 'naroho', 'namkuru', 'Maak'],
      'answer': 'Maak',
    },
    {
      'type': 'percakapan',
      'context': [
        {'label': 'Audio', 'audio': '3.MP3'},
      ],
      'question': "Tuhur te ina nama pe?",
      'options': ["T'dele Horana", 'kokis', 'Atasia', 'Ahi'],
      'answer': "T'dele Horana",
    },

    {
      'type': 'percakapan',
      'context': [
        {'label': 'Audio', 'audio': '4.MP3'},
      ],
      'question': "Min ewi mimwakunu ?",
      'options': ['iskol', "kira'am", 'kerei', 'lala'],
      'answer': 'iskol',
    },
    {
      'type': 'percakapan',
      'context': [
        {'label': 'Audio', 'audio': '5.MP3'},
      ],
      'question': "Namrai te ira tutu pe ?",
      'options': ['anggur', "pee'na", 'kopi', 'mimraka'],
      'answer': "pee'na",
    },
    {
      'type': 'percakapan',
      'context': [
        {'label': 'Audio', 'audio': '6.MP3'},
      ],
      'question': "Hi' rala'a ewi pe?",
      'options': ['iskol', "kira'am", 'kerei', 'lala'],
      'answer': 'kerei',
    },
    {
      'type': 'percakapan',
      'context': [
        {'label': 'Audio', 'audio': '7.MP3'},
      ],
      'question': "ewi ki'o mala'a lere eni ?",
      'options': ['ya\'u po\'on kirna lo\'o nala\'a', 'kerei', 'lala', 'iskol'],
      'answer': 'ya\'u po\'on kirna lo\'o nala\'a',
    },
    // Tambahkan soal lain sesuai kebutuhan...
  ];

  List<Map<String, Object>> _questions = [];

  @override
  void initState() {
    super.initState();
    _questions = _getLimitedQuestions();
  }

  List<Map<String, Object>> _getLimitedQuestions() {
    List<Map<String, Object>> kosakata = [];
    List<Map<String, Object>> kalimat = [];
    List<Map<String, Object>> percakapan = [];

    // Kumpulkan semua soal per tipe
    for (var q in _allQuestions) {
      if (q['type'] == 'kosakata') {
        kosakata.add(q);
      } else if (q['type'] == 'kalimat') {
        kalimat.add(q);
      } else if (q['type'] == 'percakapan') {
        percakapan.add(q);
      }
    }

    // Acak urutan soal tiap tipe
    kosakata.shuffle();
    kalimat.shuffle();
    percakapan.shuffle();

    // Ambil 5 soal pertama dari tiap tipe
    List<Map<String, Object>> selectedKosakata = kosakata.take(5).toList();
    List<Map<String, Object>> selectedKalimat = kalimat.take(5).toList();
    List<Map<String, Object>> selectedPercakapan = percakapan.take(5).toList();

    // Gabungkan dan acak urutan keseluruhan soal
    List<Map<String, Object>> combined = [
      ...selectedKosakata,
      ...selectedKalimat,
      ...selectedPercakapan,
    ];
    combined.shuffle();

    return combined;
  }

  final AudioPlayer _audioPlayer = AudioPlayer();

  int _currentQuestion = 0;
  int _score = 0;
  bool _quizFinished = false;

  // Tambahkan variabel untuk menandai pilihan yang sedang ditekan
  int? _pressedOptionIndex;

  Future<void> _playAudio(String path) async {
    await _audioPlayer.stop(); // stop jika ada audio lain yang sedang main
    await _audioPlayer.play(AssetSource(path));
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

  String _getInstruction(String? type) {
    switch (type) {
      case 'kosakata':
        return 'Petunjuk:\nLihat gambar, lalu pilih jawaban yang benar sesuai dengan gambar tersebut.';
      case 'kalimat':
        return 'Petunjuk:\nLengkapi kalimat dengan pilihan jawaban yang paling tepat.';
      case 'percakapan':
        return 'Petunjuk:\nDengarkan audio (jika ada), lalu pilih jawaban yang sesuai dengan percakapan.';
      default:
        return 'Petunjuk:\nPilih jawaban yang paling tepat.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final question = _questions[_currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kuis Gabungan',
          style: GoogleFonts.josefinSans(
            fontSize: screenWidth * 0.055,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange.shade100,
        elevation: 0,
      ),
      backgroundColor: Colors.orange.shade50,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Center(
          child:
              _quizFinished
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Kuis Selesai!',
                        style: GoogleFonts.josefinSans(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Text(
                        'SELAMAT !!!',
                        style: GoogleFonts.josefinSans(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Skor Anda: $_score dari ${_questions.length}',
                        style: GoogleFonts.josefinSans(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        width: screenWidth * 0.5,
                        height: screenHeight * 0.07,
                        child: ElevatedButton(
                          onPressed: _resetQuiz,
                          child: Text(
                            'Ulangi Kuis',
                            style: GoogleFonts.josefinSans(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Petunjuk pengerjaan soal
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getInstruction(question['type'] as String?),
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),
                      Text(
                        'Soal ${_currentQuestion + 1} dari ${_questions.length}',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      if (question['type'] == 'kosakata' &&
                          question['image'] != null)
                        Image.asset(
                          question['image'] as String,
                          height: screenHeight * 0.22,
                        ),
                      if (question['type'] == 'percakapan' &&
                          question['context'] != null)
                        ...((question['context'] as List)
                            .map(
                              (dialog) => Row(
                                children: [
                                  if (dialog is Map && dialog['audio'] != null)
                                    IconButton(
                                      icon: Icon(
                                        Icons.play_arrow,
                                        size: screenWidth * 0.13,
                                        color: Colors.deepPurple,
                                      ),
                                      onPressed:
                                          () => _playAudio(
                                            dialog['audio'] as String,
                                          ),
                                    ),
                                  if (dialog is Map && dialog['label'] != null)
                                    Text(
                                      dialog['label'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.05,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  if (dialog is Map && dialog['text'] != null)
                                    Text(
                                      dialog['text'],
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                      ),
                                    ),
                                ],
                              ),
                            )
                            .toList()),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        question['question'] as String,
                        style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      ...(question['options'] as List<String>)
                          .asMap()
                          .entries
                          .map((entry) {
                            int idx = entry.key;
                            String option = entry.value;
                            bool isPressed = _pressedOptionIndex == idx;
                            return Container(
                              margin: EdgeInsets.only(
                                bottom: screenHeight * 0.012,
                              ),
                              child: GestureDetector(
                                onTap: () => _answerQuestion(option),
                                onTapDown: (_) {
                                  setState(() {
                                    _pressedOptionIndex = idx;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    _pressedOptionIndex = null;
                                  });
                                },
                                onTapCancel: () {
                                  setState(() {
                                    _pressedOptionIndex = null;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 100),
                                  decoration: BoxDecoration(
                                    color:
                                        isPressed
                                            ? Colors.deepPurple.shade100
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.deepPurple.shade100,
                                    ),
                                  ),
                                  height: screenHeight * 0.06,
                                  alignment: Alignment.center,
                                  child: Text(
                                    option,
                                    style: GoogleFonts.josefinSans(
                                      fontSize: screenWidth * 0.05,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
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
