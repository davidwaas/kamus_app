import 'package:flutter/material.dart';
import 'package:kamus_app/kosakataPage.dart';
import 'package:kamus_app/kalimatPage.dart';
import 'package:kamus_app/percakapanPage.dart';
import 'package:kamus_app/quizPage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(KamusApp());
}

class KamusApp extends StatelessWidget {
  const KamusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yotowawa',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: KamusHomePage(),
    );
  }
}

class KamusHomePage extends StatefulWidget {
  const KamusHomePage({super.key});

  @override
  _KamusHomePageState createState() => _KamusHomePageState();
}

class _KamusHomePageState extends State<KamusHomePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kamus Bahasa Kisar',
          style: GoogleFonts.josefinSans(
            fontSize: screenWidth * 0.06, // Responsive font size
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.orange.shade100,
        elevation: 0,
      ),
      body: Container(
        color: Colors.orange.shade50,
        width: double.infinity,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.03),
              Image.asset(
                'assets/logo.png',
                height: screenHeight * 0.18, // Responsive image height
              ),
              SizedBox(height: screenHeight * 0.012),
              Text(
                'Yotowawa',
                style: GoogleFonts.anton(
                  fontSize: screenWidth * 0.08, // Responsive font size
                  color: Color.fromARGB(255, 235, 0, 2),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              ...['Kosakata', 'Kalimat', 'Percakapan', 'Quiz'].map((label) {
                Widget page;
                switch (label) {
                  case 'Kosakata':
                    page = kosakataPage();
                    break;
                  case 'Kalimat':
                    page = kalimatPage();
                    break;
                  case 'Percakapan':
                    page = percakapanPage();
                    break;
                  default:
                    page = QuizPage();
                }
                return Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.012),
                  child: SizedBox(
                    width: screenWidth * 0.6, // Responsive button width
                    height: screenHeight * 0.07, // Responsive button height
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => page),
                        );
                      },
                      child: Text(
                        label,
                        style: GoogleFonts.josefinSans(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
