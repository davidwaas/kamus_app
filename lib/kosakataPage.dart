import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class kosakataPage extends StatefulWidget {
  const kosakataPage({super.key});

  @override
  State<kosakataPage> createState() => _kosakataPageState();
}

class _kosakataPageState extends State<kosakataPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _words = [];
  List<Map<String, dynamic>> _allWords = [];
  String? _activeLetter;

  Future<void> _loadWords() async {
    final String jsonString = await rootBundle.loadString(
      'assets/kosakata.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      _allWords = jsonData.cast<Map<String, dynamic>>();
      _words = _allWords;
    });
  }

  void _searchWords(String keyword) {
    setState(() {
      _words =
          _allWords
              .where(
                (word) => (word['indonesia'] as String).toLowerCase().contains(
                  keyword.toLowerCase(),
                ),
              )
              .toList();
      _activeLetter = null;
    });
  }

  void _filterByLetter(String letter) {
    setState(() {
      _words =
          _allWords
              .where(
                (word) => (word['indonesia'] as String)
                    .toLowerCase()
                    .startsWith(letter.toLowerCase()),
              )
              .toList();
      _activeLetter = letter;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kosakata'),
        backgroundColor: Colors.orange.shade100,
        elevation: 0,
      ),
      backgroundColor: Colors.orange.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daftar hasil di kiri
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Cari kata...',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          _searchWords(_searchController.text);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _words.length,
                      itemBuilder: (context, index) {
                        final word = _words[index];
                        return ListTile(
                          title: Text(word['indonesia']),
                          subtitle: Text(
                            'Inggris: ${word['english']} | Oirata: ${word['oirata']} | Meher: ${word['meher']}',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            // Filter huruf di kanan dengan font kecil
            SizedBox(
              width: 32,
              child: ListView.builder(
                itemCount: 26,
                itemBuilder: (context, i) {
                  String letter = String.fromCharCode(65 + i);
                  bool isActive = _activeLetter == letter;
                  return GestureDetector(
                    onTap: () => _filterByLetter(letter),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.orange : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isActive ? Colors.white : Colors.black,
                            fontSize:
                                13, // Ukuran font kecil agar muat semua huruf
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
