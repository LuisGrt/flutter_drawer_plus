# flutter_drawer_plus
[![Pub Version](https://img.shields.io/pub/v/flutter_drawer_plus)](https://pub.dev/packages/flutter_drawer_plus)
![GitHub License](https://img.shields.io/github/license/LuisGrt/flutter_drawer_plus)


> This is a fork from [flutter_inner_drawer](https://pub.dartlang.org/packages/futter_inner_drawer)


Drawer Plus is an easy way to create an internal side section (left/right) where you can insert a list menu or other.

## Installing
Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  flutter_drawer_plus: "^1.1.1"
```
## Demo
<div style="display: flex; justify-content: center; align-items: center; width: 100%;">
  <img src="https://github.com/LuisGrt/flutter_drawer_plus/raw/master/assets/img/example5.1.gif" style="margin: 15px;" width="250" alt="Example 5.1">
  <img src="https://github.com/LuisGrt/flutter_drawer_plus/raw/master/assets/img/example5.3.gif" style="margin: 15px;" width="250" alt="Example 5.3">
</div>

### Simple usage
```dart
import 'package:flutter_drawer_plus/flutter_drawer_plus.dart';
   
    @override
    Widget build(BuildContext context) {
        return DrawerPlus(
            key: _drawerPlusKey,
            onTapClose: true, // default false
            swipe: true, // default true            
            colorTransitionChild: Color.red, // default Color.black54
            colorTransitionScaffold: Color.black54, // default Color.black54
            // When setting the vertical offset, be sure to use only top or bottom
            offset: IDOffset.only(
              bottom: 0.05, 
              right: 0.0, 
              left: 0.0,
            ),
            scale: DPOffset.horizontal(0.8), // set the offset in both directions
            proportionalChildArea: true, // default true
            borderRadius: 50, // default 0
            leftAnimationType: DrawerPlusAnimation.static, // default static
            rightAnimationType: DrawerPlusAnimation.quadratic,
            backgroundDecoration: BoxDecoration(color: Colors.red), // default  Theme.of(context).backgroundColor
            //when a pointer that is in contact with the screen and moves to the right or left            
            onDragUpdate: (double val, DrawerPlusDirection direction) {
                // return values between 1 and 0
                print(val);
                // check if the swipe is to the right or to the left
                print(direction==InnerDrawerDirection.start);
            },
            drawerPlusCallback: (a) => print(a), // return  true (open) or false (close)
            leftChild: Container(), // required if rightChild is not set
            rightChild: Container(), // required if leftChild is not set
            // A Scaffold is generally used but you are free to use other widgets
            // Note: use "automaticallyImplyLeading: false" if you do not personalize "leading" of Bar
            scaffold: Scaffold(
                appBar: AppBar(
                    automaticallyImplyLeading: false
                ),
            ) 
            /* OR
            scaffold: CupertinoPageScaffold(                
                navigationBar: CupertinoNavigationBar(
                    automaticallyImplyLeading: false,
                ),
            ), 
            */
        );
    }
    
    //  Current State of InnerDrawerState
    final GlobalKey<DrawerPlusState> _drawerPlusKey = GlobalKey<DrawerPlusState>();    

    void _toggle()
    {
       _drawerPlusKey.currentState.toggle(
       // direction is optional 
       // if not set, the last direction will be used
       //DrawerPlusDirection.start OR DrawerPlusDirection.end                        
        direction: DrawerPlusDirection.end 
       );
    }
    
```

### DrawerPlus Parameters
| PropName                             | Description                                                                                                              | default value                                                   |
|:-------------------------------------|:-------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------|
| `scaffold`                           | *A Scaffold is generally used but you are free to use other widgets*                                                     | required                                                        |
| `leftChild`                          | *Inner Widget*                                                                                                           | required if rightChild is not set                               |
| `rightChild`                         | *Inner Widget*                                                                                                           | required if leftChild is not set                                |
| `leftOffset(deprecated)`             | *Offset drawer width*                                                                                                    | 0.4                                                             |
| `rightOffset(deprecated)`            | *Offset drawer width*                                                                                                    | 0.4                                                             |
| `leftScale(deprecated)`              | *Left scaffold scaling*                                                                                                  | 1                                                               |
| `rightScale(deprecated)`             | *Right scaffold scaling*                                                                                                 | 1                                                               |
| `offset`                             | *Offset DrawerPlus width*                                                                                                | DPOffset.horizontal(0.4)                                        |
| `scale`                              | *Scaffold scaling*                                                                                                       | DPOffset.horizontal(1)                                          |
| `proportionalChildArea`              | *If true, dynamically sets the width based on the selected offset, otherwise it leaves the width at 100% of the screen.* | true                                                            |
| `borderRadius`                       | *For scaffold border*                                                                                                    | 0                                                               |
| `onTapClose`                         | *Tap on the Scaffold closes it*                                                                                          | false                                                           |
| `swipe`                              | *activate or deactivate the swipe*                                                                                       | true                                                            |
| `swipeChild`                         | *activate or deactivate the swipeChild*                                                                                  | false                                                           |
| `duration`                           | *Animation Controller duration*                                                                                          | Duration(milliseconds: 246)                                     |
| `velocity`                           | *Allows you to set the opening and closing velocity when using the open/close methods*                                   | 1                                                               |
| `tapScaffoldEnabled`                 | *Possibility to tap the scaffold even when open*                                                                         | false                                                           |
| `boxShadow`                          | *BoxShadow of scaffold opened*                                                                                           | [BoxShadow(color: Colors.black.withOpacity(0.5),blurRadius: 5)] |
| `colorTransitionChild`               | *Change background color while swiping*                                                                                  | Colors.black54                                                  |
| `colorTransitionScaffold`            | *Change background color while swiping*                                                                                  | Colors.black54                                                  |
| `leftAnimationType`                  | *static / linear / quadratic*                                                                                            | static                                                          |
| `rightAnimationType`                 | *static / linear / quadratic*                                                                                            | static                                                          |
| `backgroundDecoration`               | *possibility to manage the main background Decoration*                                                                   | BoxDecoration(color: Theme.of(context).backgroundColor)         |
| `drawerPlusCallback`                 | *Optional callback that is called when a DrawerPlus is opened or closed*                                                 |                                                                 |
| `onDragUpdate`                       | *When a pointer that is in contact with the screen and moves to the right or left*                                       |                                                                 |
| `_drawerPlusKey.currentState.open`   | *Current State of GlobalKey<DrawerPlusState>(check example) - OPEN*                                                      |                                                                 |
| `_drawerPlusKey.currentState.close`  | *Current State of GlobalKey<DrawerPlusState>(check example) - CLOSE*                                                     |                                                                 |
| `_drawerPlusKey.currentState.toggle` | *Current State of GlobalKey<DrawerPlusState>(check example) - OPEN or CLOSE*                                             |                                                                 |

## Issues
If you encounter problems, open an issue. Pull request are also welcome.
