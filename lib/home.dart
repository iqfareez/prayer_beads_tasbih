import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vibration/vibration.dart';

import 'CONSTANTS.dart';
import 'utils/AnimatedFlipCounter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _controller = PageController(
    viewportFraction: 0.1,
    initialPage: 5,
  );
  int imageIndex = 1;
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
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _clicked();
        },
        onVerticalDragStart: (details) {
          _clicked();
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            SizedBox(width: 45),
                            IconButton(
                                icon: Icon(Icons.palette),
                                onPressed: () {
                                  setState(() {
                                    imageIndex < 5
                                        ? imageIndex++
                                        : imageIndex = 1;
                                  });
                                }),
                            IconButton(
                                icon: Icon(Icons.refresh),
                                onPressed: () {
                                  confirmReset(context, _resetEverything);
                                }),
                          ],
                        ),
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
                        SizedBox(),
                      ],
                    ),
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
                          'assets/bead-$imageIndex.png',
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

  void _resetEverything() {
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

void confirmReset(BuildContext context, VoidCallback callback) {
  var alert = AlertDialog(
    title: Text("Reset"),
    content: Text("This action can't be undone"),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          callback();
          showSnackBar(
              context: context,
              label: 'Cleared',
              icon: CupertinoIcons.check_mark_circled);
          Navigator.of(context).pop();
        },
        child: Text('Confirm'),
      ),
    ],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

void showSnackBar({BuildContext context, String label, IconData icon}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white60,
          ),
          SizedBox(width: 5),
          Text(label)
        ],
      )));
}
