import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prayer_beads/CONSTANTS.dart';
import 'package:vibration/vibration.dart';
import 'AnimatedFlipCounter.dart';

void main() async {
  await GetStorage.init();
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PageController _controller = PageController(
    viewportFraction: 0.1,
    initialPage: 5,
  );
  int _beadCounter = 0;
  int _numberOfCountsToCompleteRound = 33;
  int _roundCounter = 0;
  bool _canVibrate = true;
  bool _isDisposed = false;
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: SafeArea(
            child: Container(
          // color: Colors.orangeAccent,
          child: ListView(children: <Widget>[
            ListTile(
              tileColor: Colors.black45,
              title: Text("Reset everything"),
              trailing: Icon(Icons.refresh),
              onTap: () {
                _resetEveryThing();
              },
            ),
          ]),
        )),
        body: GestureDetector(
          onTap: () {
            _clicked();
          },
          onVerticalDragStart: (details) {
            _clicked();
          },
          child: Container(
            // color: Colors.deepOrangeAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          textDirection: TextDirection.ltr,
                          children: <Widget>[
                            _Counter(
                                counter: _roundCounter, counterName: 'Round'),
                            _Counter(
                                counter: _beadCounter, counterName: 'Beads'),
                          ],
                        ),
                      ],
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: PageView.builder(
                      reverse: true,
                      physics: NeverScrollableScrollPhysics(),
                      controller: _controller,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, position) {
                        return Container(
                          child: Image.asset(
                            'assets/bead-1.png',
                          ),
                        );
                      },
                      itemCount: null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loadSettings() async {
    bool canVibrate = await Vibration.hasVibrator();
    if (!_isDisposed) {
      setState(() {
        _canVibrate = canVibrate;
        _loadData();
      });
    }
  }

  void _loadData() {
    if (!_isDisposed) {
      setState(() {
        _beadCounter = GetStorage().read(kBeadsCount) ?? 0;
        _roundCounter = GetStorage().read(kRoundCount) ?? 0;
      });
    }
  }

  void _resetEveryThing() {
    GetStorage().write(kBeadsCount, 0);
    GetStorage().write(kRoundCount, 0);
    _loadData();
  }

  void _clicked() {
    if (!_isDisposed) {
      setState(() {
        _beadCounter++;
        if (_beadCounter > _numberOfCountsToCompleteRound) {
          _beadCounter = 0;
          _roundCounter++;
          if (_canVibrate) Vibration.vibrate(duration: 100, amplitude: 100);
        }
      });
    }
    GetStorage().write(kBeadsCount, _beadCounter);
    GetStorage().write(kRoundCount, _roundCounter);
    int nextPage = _controller.page.round() + 1;
    _controller.animateToPage(nextPage,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }
}

class _Counter extends StatelessWidget {
  _Counter(
      {Key key,
      @required this.counter,
      this.tsCounter =
          const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
      @required this.counterName,
      this.tsCounterName = const TextStyle(
          fontSize: 20,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w300)})
      : super(key: key);
  final int counter;
  final TextStyle tsCounter;
  final String counterName;
  final TextStyle tsCounterName;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedFlipCounter(
          duration: Duration(milliseconds: 300),
          value: counter,
        ),
        Text('$counterName', style: tsCounterName)
      ],
    );
  }
}
