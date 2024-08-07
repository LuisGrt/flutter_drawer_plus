import 'package:flutter/material.dart';
import 'package:flutter_drawer_plus/flutter_drawer_plus.dart';

class ExampleTwo extends StatefulWidget {
  const ExampleTwo({super.key});

  @override
  State<ExampleTwo> createState() => _ExampleTwoState();
}

class _ExampleTwoState extends State<ExampleTwo> {
  final GlobalKey<DrawerPlusState> _innerDrawerKey =
      GlobalKey<DrawerPlusState>();
  final bool _swipe = true;
  DrawerPlusAnimation _animationType = DrawerPlusAnimation.static;
  bool _proportionalChildArea = true;
  double _horizontalOffset = 0.4;
  double _verticalOffset = 0.4;
  bool _topBottom = false;
  double _scale = 0.9;
  double _borderRadius = 50;

  Color currentColor = Colors.black54;

  @override
  Widget build(BuildContext context) {
    return DrawerPlus(
      key: _innerDrawerKey,
      onTapClose: true,
      offset: DPOffset.only(
        top: _topBottom ? _verticalOffset : 0.0,
        bottom: !_topBottom ? _verticalOffset : 0.0,
        right: _horizontalOffset,
        left: _horizontalOffset,
      ),
      scale: DPOffset.horizontal(_scale),
      borderRadius: _borderRadius,
      duration: const Duration(milliseconds: 11200),
      swipe: _swipe,
      proportionalChildArea: _proportionalChildArea,
      //backgroundColor: Colors.red,
      colorTransitionChild: currentColor,
      leftAnimationType: _animationType,
      rightAnimationType: _animationType,
      leftChild: Material(
        color: Theme.of(context).colorScheme.surface,
        child: const Center(
          child: Text(
            "Left Child",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
      rightChild: Material(
        color: Theme.of(context).colorScheme.surface,
        child: const Center(
          child: Text(
            "Right Child",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
      scaffold: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            //stops: [0.1, 0.5,0.5, 0.7, 0.9],
            colors: [
              Colors.orange,
              Colors.red,
            ],
          ),
        ),
        child: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          const Text('Static'),
                          Checkbox(
                            activeColor: Colors.black,
                            value: _animationType == DrawerPlusAnimation.static,
                            onChanged: (a) {
                              setState(() =>
                                  _animationType = DrawerPlusAnimation.static);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(
                            () => _animationType = DrawerPlusAnimation.static);
                      },
                    ),
                    GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Checkbox(
                              activeColor: Colors.black,
                              value:
                                  _animationType == DrawerPlusAnimation.linear,
                              onChanged: (a) {
                                setState(() => _animationType =
                                    DrawerPlusAnimation.linear);
                              }),
                          const Text('Linear'),
                        ],
                      ),
                      onTap: () {
                        setState(
                            () => _animationType = DrawerPlusAnimation.linear);
                      },
                    ),
                    GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Checkbox(
                            activeColor: Colors.black,
                            value:
                                _animationType == DrawerPlusAnimation.quadratic,
                            onChanged: (a) {
                              setState(() => _animationType =
                                  DrawerPlusAnimation.quadratic);
                            },
                          ),
                          const Text('Quadratic'),
                        ],
                      ),
                      onTap: () {
                        setState(() =>
                            _animationType = DrawerPlusAnimation.quadratic);
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                          activeColor: Colors.black,
                          value: _proportionalChildArea == true,
                          onChanged: (a) {
                            setState(() => _proportionalChildArea =
                                !_proportionalChildArea);
                          }),
                      const Text('ProportionalChildArea'),
                    ],
                  ),
                  onTap: () {
                    setState(
                        () => _proportionalChildArea = !_proportionalChildArea);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    const Text('Horizontal Offset'),
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
                            value: _horizontalOffset,
                            min: 0.0,
                            max: 1,
                            divisions: 5,
                            semanticFormatterCallback: (double value) =>
                                value.round().toString(),
                            label: '$_horizontalOffset',
                            onChanged: (value) {
                              setState(() => _horizontalOffset = value);
                            },
                            onChangeEnd: (a) {
                              //_getwidthContainer();
                            },
                          ),
                        ),
                        Text(_horizontalOffset.toString()),
                        //Text(_fontSize.toString()),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    const Text('Vertical Offset'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                              activeColor: Colors.black,
                              value: _topBottom,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _topBottom = value);
                                }
                              },
                            ),
                            _topBottom
                                ? const Text('Bottom')
                                : const Text('Top'),
                          ],
                        ),
                      ],
                    ),
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
                            value: _verticalOffset,
                            min: 0.0,
                            max: 1,
                            divisions: 5,
                            semanticFormatterCallback: (double value) =>
                                value.round().toString(),
                            label: '$_verticalOffset',
                            onChanged: (a) =>
                                setState(() => _verticalOffset = a),
                          ),
                        ),
                        Text(_verticalOffset.toString()),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    const Text('Scale'),
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
                            value: _scale,
                            min: 0.0,
                            max: 1,
                            divisions: 10,
                            semanticFormatterCallback: (double value) =>
                                value.round().toString(),
                            label: '$_scale',
                            onChanged: (a) => setState(() => _scale = a),
                          ),
                        ),
                        Text(_scale.toString()),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    const Text('Border Radius'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SliderTheme(
                          data: Theme.of(context).sliderTheme.copyWith(
                                valueIndicatorTextStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.white),
                              ),
                          child: Slider(
                            activeColor: Colors.black,
                            value: _borderRadius,
                            min: 0,
                            max: 100,
                            divisions: 4,
                            semanticFormatterCallback: (double value) =>
                                value.round().toString(),
                            label: '$_borderRadius',
                            onChanged: (a) => setState(() => _borderRadius = a),
                          ),
                        ),
                        Text(_borderRadius.toString()),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
