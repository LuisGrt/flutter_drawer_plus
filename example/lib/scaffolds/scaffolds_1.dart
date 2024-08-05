import 'package:example/notifier/drawer_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_drawer_plus/flutter_drawer_plus.dart';
import 'package:provider/provider.dart';

class ScaffoldDrawer extends StatefulWidget {
  final GlobalKey<DrawerPlusState>? innerDrawerKey;

  const ScaffoldDrawer({this.innerDrawerKey, super.key});

  @override
  State<ScaffoldDrawer> createState() => ScaffoldDrawerState();
}

class ScaffoldDrawerState extends State<ScaffoldDrawer> {
  late DrawerNotifier drawer;
  late Color pickerColor;

  @override
  void initState() {
    super.initState();

    drawer = Provider.of<DrawerNotifier>(context, listen: true);
    pickerColor = drawer.colorTransition;
  }

  @override
  void dispose() {
    drawer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            ColorTween(
              begin: Colors.blueAccent,
              end: Colors.blueGrey.shade400.withRed(100),
            ).lerp(drawer.swipeOffset)!,
            ColorTween(
              begin: Colors.green,
              end: Colors.blueGrey.shade800.withGreen(80),
            ).lerp(drawer.swipeOffset)!,
          ],
        ),
      ),
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.grey[100]),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Text(
                    "Animation Type",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        child: Row(
                          children: <Widget>[
                            Text('Static'),
                            Checkbox(
                                activeColor: Colors.black,
                                value: drawer.animationType ==
                                    DrawerPlusAnimation.static,
                                onChanged: (a) {
                                  drawer.setAnimationType(
                                      DrawerPlusAnimation.static);
                                }),
                          ],
                        ),
                        onTap: () {
                          drawer.setAnimationType(DrawerPlusAnimation.static);
                        },
                      ),
                      GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                                activeColor: Colors.black,
                                value: drawer.animationType ==
                                    DrawerPlusAnimation.linear,
                                onChanged: (a) {
                                  drawer.setAnimationType(
                                      DrawerPlusAnimation.linear);
                                }),
                            Text('Linear'),
                          ],
                        ),
                        onTap: () {
                          drawer.setAnimationType(DrawerPlusAnimation.linear);
                        },
                      ),
                      GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                                activeColor: Colors.black,
                                value: drawer.animationType ==
                                    DrawerPlusAnimation.quadratic,
                                onChanged: (a) {
                                  drawer.setAnimationType(
                                      DrawerPlusAnimation.quadratic);
                                }),
                            Text('Quadratic'),
                          ],
                        ),
                        onTap: () {
                          drawer
                              .setAnimationType(DrawerPlusAnimation.quadratic);
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                                activeColor: Colors.black,
                                value: drawer.swipe,
                                onChanged: (a) {
                                  drawer.setSwipe(!drawer.swipe);
                                }),
                            Text('Swipe'),
                          ],
                        ),
                        onTap: () {
                          drawer.setSwipe(!drawer.swipe);
                        },
                      ),
                      GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                                activeColor: Colors.black,
                                value: drawer.tapScaffold,
                                onChanged: (a) {
                                  drawer.setTapScaffold(!drawer.tapScaffold);
                                }),
                            Text('TapScaffoldEnabled'),
                          ],
                        ),
                        onTap: () {
                          drawer.setTapScaffold(!drawer.tapScaffold);
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                            activeColor: Colors.black,
                            value: drawer.onTapToClose,
                            onChanged: (a) {
                              drawer.setOnTapToClose(!drawer.onTapToClose);
                            }),
                        Text('OnTap To Close'),
                      ],
                    ),
                    onTap: () {
                      drawer.setOnTapToClose(!drawer.onTapToClose);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Column(
                    children: <Widget>[
                      Text('Offset'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SliderTheme(
                            data: Theme.of(context).sliderTheme.copyWith(
                                  valueIndicatorTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                            child: Slider(
                              activeColor: Colors.black,
                              //inactiveColor: Colors.white,
                              value: drawer.offset,
                              min: 0.0,
                              max: 1,
                              divisions: 5,
                              semanticFormatterCallback: (double value) =>
                                  value.round().toString(),
                              label: '${drawer.offset}',
                              onChanged: (a) {
                                drawer.setOffset(a);
                              },
                              onChangeEnd: (a) {
                                //_getwidthContainer();
                              },
                            ),
                          ),
                          Text(
                            drawer.offset.toString(),
                          ),
                          //Text(_fontSize.toString()),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  TextButton(
                    child: Text(
                      "Set Color Transition",
                      style: TextStyle(
                        color: drawer.colorTransition,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Pick a color!'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: drawer.colorTransition,
                                onColorChanged: (Color color) =>
                                    setState(() => pickerColor = color),
                                //enableLabel: true,
                                pickerAreaHeightPercent: 0.8,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Set'),
                                onPressed: () {
                                  drawer.setColorTransition(pickerColor);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  Padding(padding: EdgeInsets.all(25)),
                  ElevatedButton(
                    child: Text("open"),
                    onPressed: () {
                      // direction is optional
                      // if not set, the last direction will be used
                      widget.innerDrawerKey?.currentState?.toggle();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
