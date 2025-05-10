import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prayer_beads/features/menu/views/menu_drawer.dart';
import 'package:prayer_beads/features/tasbih/views/components/confirm_reset_dialog.dart';
import 'package:prayer_beads/features/tasbih/views/components/counter_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vibration/vibration.dart';

import '../../../CONSTANTS.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _controller = PageController(
    viewportFraction: 0.1,
    initialPage: 5,
  );
  final int _numberOfCountsToCompleteRound = 33;
  int _imageIndex = 1;
  int _beadCounter = 0;
  int _roundCounter = 0;
  int _accumulatedCounter = 0;
  bool _canVibrate = true;
  bool _isDisposed = false;
  final List<Color> _bgColour = [
    Colors.teal.shade50,
    Colors.lime.shade50,
    Colors.lightBlue.shade50,
    Colors.pink.shade50,
    Colors.black12,
  ];

  final _buttonCarouselController = CarouselSliderController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      drawer: Drawer(child: MenuDrawer()),
      body: GestureDetector(
        onTap: _clicked,
        onVerticalDragStart: (_) => _clicked(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Menu',
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                        IconButton(
                          tooltip: 'Change colour',
                          icon: const Icon(Icons.palette_outlined),
                          onPressed: () {
                            setState(() {
                              _imageIndex < 5 ? _imageIndex++ : _imageIndex = 1;
                            });
                          },
                        ),
                        IconButton(
                          tooltip: 'Reset counter',
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            promptResetCounter(context, _resetEverything);
                          },
                        ),
                        IconButton(
                          tooltip: 'Share my accumulated value',
                          icon: const Icon(Icons.share),
                          onPressed: () {
                            SharePlus.instance.share(
                              ShareParams(
                                text:
                                    'My total tasbeeh counter is $_accumulatedCounter',
                                subject: 'Total accumulated Counter',
                                title: 'Tasbeeh Counter',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      textDirection: TextDirection.ltr,
                      children: <Widget>[
                        CounterWidget(
                          counter: _roundCounter,
                          counterName: 'Round',
                        ),
                        CounterWidget(
                          counter: _beadCounter,
                          counterName: 'Beads',
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Accumulated'),
                          const SizedBox(width: 10),
                          AnimatedFlipCounter(
                            value: _accumulatedCounter,
                            duration: const Duration(milliseconds: 730),
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CarouselSlider(
                      carouselController: _buttonCarouselController,
                      options: CarouselOptions(
                        height: 100.0,
                        enlargeCenterPage: true,
                      ),
                      items:
                          [1, 2, 3, 4].map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _bgColour[_imageIndex - 1],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Image.asset('assets/zikr/$i.png'),
                                );
                              },
                            );
                          }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            _buttonCarouselController.previousPage();
                          },
                          icon: const Icon(Icons.navigate_before),
                        ),
                        IconButton(
                          onPressed: () {
                            _buttonCarouselController.nextPage();
                          },
                          icon: const Icon(Icons.navigate_next),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: PageView.builder(
                reverse: true,
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                scrollDirection: Axis.vertical,
                itemBuilder: (_, __) {
                  return Image.asset('assets/beads/bead-$_imageIndex.png');
                },
                itemCount: null,
              ),
            ),
          ],
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
        _accumulatedCounter =
            _roundCounter * _numberOfCountsToCompleteRound + _beadCounter;
      });
    }
  }

  void _resetEverything() {
    // clear all data
    GetStorage().write(kBeadsCount, 0);
    GetStorage().write(kRoundCount, 0);

    // reflect changes to UI
    _loadData();

    showSnackBar(
      context: context,
      label: 'Cleared',
      icon: CupertinoIcons.check_mark_circled,
    );
  }

  void _clicked() {
    if (!_isDisposed) {
      setState(() {
        _beadCounter++;
        _accumulatedCounter++;
        if (_beadCounter > _numberOfCountsToCompleteRound) {
          _beadCounter = 1;
          _roundCounter++;
          if (_canVibrate) Vibration.vibrate(duration: 100, amplitude: 100);
        }
      });
    }
    GetStorage().write(kBeadsCount, _beadCounter);
    GetStorage().write(kRoundCount, _roundCounter);
    int nextPage = _controller.page!.round() + 1;
    _controller.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }
}

/// Requests user confirmation to reset the counter
Future<void> promptResetCounter(
  BuildContext context,
  VoidCallback onReset,
) async {
  final res = await showDialog(
    context: context,
    builder: (_) {
      return ConfirmResetDialog();
    },
  );

  if (res == null) return;
  if (res) {
    onReset.call();
  }
}

void showSnackBar({
  required BuildContext context,
  required String label,
  required IconData icon,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          Icon(icon, color: Colors.white60),
          const SizedBox(width: 5),
          Text(label),
        ],
      ),
    ),
  );
}
