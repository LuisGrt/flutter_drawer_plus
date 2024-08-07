import 'package:flutter/material.dart';
import 'package:flutter_drawer_plus/flutter_drawer_plus.dart';
import 'package:provider/provider.dart';

import 'children/left_child_1.dart';
import 'notifier/drawer_notifier.dart';
import 'children/right_child_1.dart';
import 'scaffolds/scaffolds_1.dart';

class ExampleOne extends StatelessWidget {
  final GlobalKey<DrawerPlusState> _innerDrawerKey =
      GlobalKey<DrawerPlusState>();

  ExampleOne({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerPlus(
      key: _innerDrawerKey,
      onTapClose: context.select(
        (DrawerNotifier value) => value.onTapToClose,
      ),
      tapScaffoldEnabled: context.select(
        (DrawerNotifier value) => value.tapScaffold,
      ),
      velocity: 20,
      swipeChild: true,
      offset: DPOffset.horizontal(
        context.select(
          (DrawerNotifier value) => value.offset,
        ),
      ),
      swipe: context.select(
        (DrawerNotifier value) => value.swipe,
      ),
      colorTransitionChild: context.select(
        (DrawerNotifier value) => value.colorTransition,
      ),
      colorTransitionScaffold: context.select(
        (DrawerNotifier value) => value.colorTransition,
      ),
      leftAnimationType: context.select(
        (DrawerNotifier value) => value.animationType,
      ),
      rightAnimationType: DrawerPlusAnimation.linear,
      leftChild: LeftChild(),
      rightChild: RightChild(innerDrawerKey: _innerDrawerKey),
      scaffold: ScaffoldDrawer(innerDrawerKey: _innerDrawerKey),
      onDragUpdate: (double value, DrawerPlusDirection? direction) {
        final drawerNotifier = Provider.of<DrawerNotifier>(
          context,
          listen: false,
        );
        drawerNotifier.setSwipeOffset(value);
      },
    );
  }
}
