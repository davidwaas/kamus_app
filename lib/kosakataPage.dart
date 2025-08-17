import 'package:flutter/material.dart';
import 'package:kamus_app/database_helper.dart';

class kosakataPage extends StatefulWidget {
  const kosakataPage({super.key});

  @override
  State<kosakataPage> createState() => _kosakataPageState();
}

class _kosakataPageState extends State<kosakataPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _words = [];
  String? _activeLetter; // Tambahkan variabel untuk menandai tombol aktif

  Future<void> _searchWords(String keyword) async {
    final db = DatabaseHelper();
    final result = await db.searchByLanguage(
      keyword: keyword,
      language: 'indonesia',
    );
    setState(() {
      _words = result;
      _activeLetter = null; // Reset highlight jika search manual
    });
  }

  Future<void> _filterByLetter(String letter) async {
    final db = DatabaseHelper();
    final result = await db.searchByLanguage(
      keyword: '$letter',
      language: 'indonesia',
    );
    setState(() {
      _words =
          result
              .where(
                (word) => (word['indonesia'] as String)
                    .toLowerCase()
                    .startsWith(letter.toLowerCase()),
              )
              .toList();
      _activeLetter = letter; // Set tombol aktif
    });
  }

  @override
  void initState() {
    super.initState();
    _searchWords('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kosakata'),
        backgroundColor: Colors.orange.shade100, // opsional: warna appbar
        elevation: 0,
      ),
      backgroundColor: Colors.orange.shade50, // Ganti warna background di sini
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input dan tombol cari
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(labelText: 'Cari kata...'),
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

            // Abjad A-Z
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(26, (i) {
                String letter = String.fromCharCode(65 + i); // ASCII A-Z
                bool isActive = _activeLetter == letter;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isActive ? Colors.orange : null, // warna highlight
                  ),
                  onPressed: () => _filterByLetter(letter),
                  child: Text(letter),
                );
              }),
            ),

            SizedBox(height: 10),

            // Hasil pencarian
            Expanded(
              child: ListView.builder(
                itemCount: _words.length,
                itemBuilder: (context, index) {
                  final word = _words[index];
                  return ListTile(
                    title: Text(word['indonesia']),
                    subtitle: Text(
                      'Inggris: ${word['inggris']} | Meher: ${word['meher']} | oirata: ${word['oirata']}',
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
