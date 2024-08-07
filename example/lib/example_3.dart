import 'package:flutter/material.dart';
import 'package:flutter_drawer_plus/flutter_drawer_plus.dart';

class ExampleThree extends StatefulWidget {
  const ExampleThree({super.key});

  @override
  State<ExampleThree> createState() => _ExampleThreeState();
}

class _ExampleThreeState extends State<ExampleThree> {
  final GlobalKey<DrawerPlusState> _innerDrawerKey =
      GlobalKey<DrawerPlusState>();

  final double _borderRadius = 50;

  late FocusNode myFocusNode;
  late FocusNode myFocusNode2;

  @override
  void initState() {
    myFocusNode = FocusNode();
    myFocusNode2 = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    myFocusNode2.dispose();
    super.dispose();
  }

  Color currentColor = Colors.black54;

  @override
  Widget build(BuildContext context) {
    return DrawerPlus(
      key: _innerDrawerKey,
      onTapClose: true,
      //tapScaffoldEnabled: true,
      borderRadius: _borderRadius,
      swipeChild: true,
      leftAnimationType: DrawerPlusAnimation.quadratic,
      leftChild: Material(
          color: Theme.of(context).colorScheme.surface,
          child: Center(
            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
            const Text(
              "Left Child",
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              focusNode: myFocusNode2,
            ),
            /*ListView.builder(
              itemCount: 5,
              itemBuilder:(BuildContext context, int index){
                return ListTile(title: Text('test $index'),);
              },
            )*/
                          ],
                        ),
          )),
      scaffold: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            //stops: [0.1, 0.5,0.5, 0.7, 0.9],
            colors: [
              Colors.green.shade200,
              Colors.green.shade500,
            ],
          ),
        ),
        child: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Container(
                height: double.infinity,
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    TextField(
                      focusNode: myFocusNode,
                    ),
                    const TextField(
                        //  focusNode: myFocusNode,
                        ),
                  ],
                )),
          ),
        ),
      ),
      drawerPlusCallback: (a) {
        if (a) {
          myFocusNode2.requestFocus();
        } else {
          myFocusNode.requestFocus();
        }
      },
    );
  }
}
