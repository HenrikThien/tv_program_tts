import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tv_programm_ki/http/rss_client.dart';
import 'package:tv_programm_ki/tts_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Programm KI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF2d3436),
        primaryColor: const Color(0xFF00b894),
        accentColor: const Color(0xFFb2bec3),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<TvProgram>> program;

  String playButtonText = "VORLESEN";
  bool isPlaying = false;
  FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    program = RssClient().getCurrentProgram();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: program,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var list = snapshot.data as List<TvProgram>;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text("Tv Programm 👵"),
                  centerTitle: true,
                  floating: true,
                  expandedHeight: 60,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _getTvProgramWidget(list[index]),
                    childCount: list.length,
                  ),
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _getTvProgramWidget(TvProgram program) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 5,
              child: GestureDetector(
                onTap: () {
                  if (program.description.isEmpty) return;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TtsWidget(extened: true, textToSpeech: program.description, labelPlay: "VORLESEN", labelStop: "ANHALTEN"),
                              Text(
                                program.description,
                                style: TextStyle(fontSize: 27),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${program.sender} - ${program.time}", style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(program.title, style: TextStyle(fontSize: 22, color: Colors.white)),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: TtsWidget(
                extened: false,
                textToSpeech: program.sender + " um " + program.time + ". Mit ${program.title}",
              ),
            ),
          ],
        ),
        Divider(height: 40, color: Theme.of(context).primaryColor),
      ],
    );
  }
}
