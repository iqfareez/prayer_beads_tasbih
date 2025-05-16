import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:signals/signals_flutter.dart';

import '../../menu/helpers/theme_switcher.dart';
import '../../menu/views/menu_drawer.dart';
import '../helpers/my_counter.dart';
import 'components/bead_widget.dart';
import 'components/confirm_reset_dialog.dart';
import 'components/counter_widget.dart';

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
  final counter = MyCounter();
  int _colorIndex = 1;
  final List<Color> _beadColor = [
    Colors.teal,
    Colors.lime,
    Colors.lightBlue,
    Colors.pink,
    Colors.black,
  ];

  final _buttonCarouselController = CarouselSliderController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(child: MenuDrawer()),
      body: GestureDetector(
        onTap: _incrementTasbih,
        onVerticalDragStart: (_) => _incrementTasbih(),
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
                              _colorIndex < 5 ? _colorIndex++ : _colorIndex = 1;
                            });
                            // themeColor.value = _beadColor[_colorIndex - 1];
                            setThemeColor(_beadColor[_colorIndex - 1]);
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
                                    'My total tasbeeh counter is ${counter.totalCount.value}',
                                subject: 'Total accumulated Counter',
                                title: 'Tasbeeh Counter',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    Watch((context) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        textDirection: TextDirection.ltr,
                        children: <Widget>[
                          CounterWidget(
                            counter: counter.roundCount.value,
                            counterName: 'Round',
                          ),
                          CounterWidget(
                            counter: counter.beadCount.value,
                            counterName: 'Beads',
                          ),
                        ],
                      );
                    }),
                    Watch((context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Total'),
                            const SizedBox(width: 10),
                            AnimatedFlipCounter(
                              value: counter.totalCount.value,
                              duration: const Duration(milliseconds: 730),
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
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
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.primaryContainer,
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
                itemCount: null,
                itemBuilder: (_, __) {
                  return Watch((context) {
                    return BeadWidget(color: themeColor.value, size: 90);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    // Load data from storage using the counter's loadData method
    await counter.loadData();
  }

  void _resetEverything() async {
    await counter.reset();

    showSnackBar(
      context: context,
      label: 'Counter Reset',
      icon: CupertinoIcons.check_mark_circled,
    );
  }

  void _incrementTasbih() {
    counter.increment();

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
