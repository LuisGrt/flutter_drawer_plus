// DrawerPlus is based on Drawer.
// The source code of the Drawer has been re-adapted for Inner Drawer.

// more details:
// https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/drawer.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_drawer_plus/flutter_drawer_plus.dart';

/// Signature for the callback that's called when a [DrawerPlus] is
/// opened or closed.
typedef DrawerPlusCallback = void Function(bool isOpened);

/// Signature for when a pointer that is in contact with the screen and moves to the right or left
/// values between 1 and 0
typedef InnerDragUpdateCallback = void Function(
  double value,
  DrawerPlusDirection? direction,
);

class DrawerPlus extends StatefulWidget {
  const DrawerPlus({
    GlobalKey? key,
    this.leftChild,
    this.rightChild,
    required this.scaffold,
    this.offset = const DPOffset.horizontal(0.4),
    this.scale = const DPOffset.horizontal(1),
    this.proportionalChildArea = true,
    this.borderRadius = 0,
    this.onTapClose = false,
    this.tapScaffoldEnabled = false,
    this.swipe = true,
    this.swipeChild = false,
    this.duration,
    this.velocity = 1,
    this.boxShadow,
    this.colorTransitionChild,
    this.colorTransitionScaffold,
    this.leftAnimationType = DrawerPlusAnimation.static,
    this.rightAnimationType = DrawerPlusAnimation.static,
    this.backgroundDecoration,
    this.drawerPlusCallback,
    this.onDragUpdate,
  })  : assert(
          leftChild != null || rightChild != null,
          'One of leftChild or rightChild must be provided.',
        ),
        super(key: key);

  /// Left child
  final Widget? leftChild;

  /// Right child
  final Widget? rightChild;

  /// A [Scaffold] is generally used but you are free to use other widgets
  final Widget scaffold;

  /// When the [DrawerPlus] is open, it's possible to set the offset of each of the four cardinal directions
  final DPOffset offset;

  /// When the [DrawerPlus] is open to the left or to the right
  /// values between 1 and 0. (default 1)
  final DPOffset scale;

  /// The proportionalChild Area = true dynamically sets the width based on the selected offset.
  /// On false it leaves the width at 100% of the screen
  final bool proportionalChildArea;

  /// edge radius when opening the scaffold - (default 0)
  final double borderRadius;

  /// Closes the open scaffold
  final bool tapScaffoldEnabled;

  /// Closes the open scaffold
  final bool onTapClose;

  /// activate or deactivate the swipe. NOTE: when deactivate, onTap Close is implicitly activated
  final bool swipe;

  /// activate or deactivate the swipeChild. NOTE: when deactivate, onTap Close is implicitly activated
  final bool swipeChild;

  /// duration animation controller
  final Duration? duration;

  /// possibility to set the opening and closing velocity
  final double velocity;

  /// BoxShadow of scaffold open
  final List<BoxShadow>? boxShadow;

  ///Color of gradient background
  final Color? colorTransitionChild;

  ///Color of gradient background
  final Color? colorTransitionScaffold;

  /// Static or Linear or Quadratic
  final DrawerPlusAnimation leftAnimationType;

  /// Static or Linear or Quadratic
  final DrawerPlusAnimation rightAnimationType;

  /// Color of the main background
  final Decoration? backgroundDecoration;

  /// Optional callback that is called when a [DrawerPlus] is open or closed.
  final DrawerPlusCallback? drawerPlusCallback;

  /// when a pointer that is in contact with the screen and moves to the right or left
  final InnerDragUpdateCallback? onDragUpdate;

  @override
  DrawerPlusState createState() => DrawerPlusState();
}

class DrawerPlusState extends State<DrawerPlus>
    with SingleTickerProviderStateMixin {
  final GlobalKey _drawerKey = GlobalKey();
  final GlobalKey _gestureDetectorKey = GlobalKey();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  ColorTween _colorTransitionChild = ColorTween(
    begin: Colors.transparent,
    end: Colors.black54,
  );
  ColorTween _colorTransitionScaffold = ColorTween(
    begin: Colors.black54,
    end: Colors.transparent,
  );
  double _width = kWidth;
  bool _previouslyOpened = false;
  Orientation _orientation = Orientation.portrait;
  LocalHistoryEntry? _historyEntry;
  late DrawerPlusDirection _position;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _position = widget.leftChild != null
        ? DrawerPlusDirection.start
        : DrawerPlusDirection.end;

    _animationController = AnimationController(
      value: 1,
      duration: widget.duration ?? kBaseSettleDuration,
      vsync: this,
    )
      ..addListener(_animationChanged)
      ..addStatusListener(_animationStatusChanged);
  }

  void _animationChanged() {
    setState(() {
      if (widget.colorTransitionChild != null) {
        _colorTransitionChild = ColorTween(
          begin: widget.colorTransitionChild!.withOpacity(0.0),
          end: widget.colorTransitionChild,
        );
      }

      if (widget.colorTransitionScaffold != null) {
        _colorTransitionScaffold = ColorTween(
          begin: widget.colorTransitionScaffold,
          end: widget.colorTransitionScaffold!.withOpacity(0.0),
        );
      }

      if (widget.onDragUpdate != null && _animationController.value < 1) {
        widget.onDragUpdate!(
          (1 - _animationController.value),
          _position,
        );
      }
    });
  }

  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic>? route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry!);
        FocusScope.of(context).setFirstFocus(_focusScopeNode);
      }
    }
  }

  void _animationStatusChanged(AnimationStatus status) {
    final bool opened = _animationController.value < 0.5 ? true : false;

    switch (status) {
      case AnimationStatus.reverse:
        break;
      case AnimationStatus.forward:
        break;
      case AnimationStatus.dismissed:
        if (_previouslyOpened != opened) {
          _previouslyOpened = opened;

          if (widget.drawerPlusCallback != null) {
            widget.drawerPlusCallback!(opened);
          }
        }

        _ensureHistoryEntry();
        break;
      case AnimationStatus.completed:
        if (_previouslyOpened != opened) {
          _previouslyOpened = opened;

          if (widget.drawerPlusCallback != null) {
            widget.drawerPlusCallback!(opened);
          }
        }

        _historyEntry?.remove();
        _historyEntry = null;
    }
  }

  void _handleHistoryEntryRemoved() {
    _historyEntry = null;
    close();
  }

  void _handleDragDown(DragDownDetails details) {
    _animationController.stop();
    //_ensureHistoryEntry();
  }

  /// get width of screen after initState
  void _updateWidth() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? box =
          _drawerKey.currentContext?.findRenderObject() as RenderBox?;

      if (box != null && box.hasSize && box.size.width > 300) {
        setState(() => _width = box.size.width);
      }
    });
  }

  void _move(DragUpdateDetails details) {
    // Ensure delta is not null and calculate its value
    double delta = (details.primaryDelta ?? 0) / _width;

    // Determine the drawer position based on the drag direction and controller value
    if (_animationController.value == 1) {
      if (delta > 0 && widget.leftChild != null) {
        _position = DrawerPlusDirection.start;
      } else if (delta < 0 && widget.rightChild != null) {
        _position = DrawerPlusDirection.end;
      }
    }

    // Calculate the offset based on the drawer position
    final double offset = _position == DrawerPlusDirection.start
        ? widget.offset.left
        : widget.offset.right;

    double ee = 1;
    if (offset <= kOffsetThreshold1) {
      ee = kAdjustmentFactor1;
    } else if (offset <= kOffsetThreshold2) {
      ee = kAdjustmentFactor2;
    } else if (offset <= kOffsetThreshold3) {
      ee = kAdjustmentFactor3;
    }

    final double adjustedOffset = 1 - (pow(offset / ee, .5) as double);

    // Reverse the delta if the drawer position is start
    if (_position == DrawerPlusDirection.start) {
      delta = -delta;
    }

    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        _animationController.value -= delta + (delta * adjustedOffset);
        break;
      case TextDirection.ltr:
        _animationController.value += delta + (delta * adjustedOffset);
        break;
    }

    final bool opened = _animationController.value < 0.5;

    if (opened != _previouslyOpened && widget.drawerPlusCallback != null) {
      widget.drawerPlusCallback!(opened);
    }

    _previouslyOpened = opened;
  }

  void _settle(DragEndDetails details) {
    // Return early if the controller is already dismissed
    if (_animationController.isDismissed) return;

    if (details.velocity.pixelsPerSecond.dx.abs() >= kMinFlingVelocity) {
      double visualVelocity =
          (details.velocity.pixelsPerSecond.dx + widget.velocity) / _width;

      // Adjust visual velocity based on drawer position
      if (_position == DrawerPlusDirection.start) {
        visualVelocity = -visualVelocity;
      }

      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          _animationController.fling(velocity: -visualVelocity);
          break;
        case TextDirection.ltr:
          _animationController.fling(velocity: visualVelocity);
          break;
      }
    } else if (_animationController.value < 0.5) {
      open();
    } else {
      close();
    }
  }

  void open({DrawerPlusDirection? direction}) {
    if (direction != null) _position = direction;
    _animationController.fling(velocity: -widget.velocity);
  }

  void close({DrawerPlusDirection? direction}) {
    if (direction != null) _position = direction;
    _animationController.fling(velocity: widget.velocity);
  }

  /// Open or Close DrawerPlus
  void toggle({DrawerPlusDirection? direction}) {
    if (_previouslyOpened) {
      close(direction: direction);
    } else {
      open(direction: direction);
    }
  }

  /// Outer Alignment
  AlignmentDirectional get _drawerOuterAlignment {
    switch (_position) {
      case DrawerPlusDirection.start:
        return AlignmentDirectional.centerEnd;
      case DrawerPlusDirection.end:
        return AlignmentDirectional.centerStart;
    }
  }

  /// Inner Alignment
  AlignmentDirectional get _drawerInnerAlignment {
    switch (_position) {
      case DrawerPlusDirection.start:
        return AlignmentDirectional.centerStart;
      case DrawerPlusDirection.end:
        return AlignmentDirectional.centerEnd;
    }
  }

  /// returns the left or right animation type based on DrawerPlusDirection
  DrawerPlusAnimation get _animationType {
    return _position == DrawerPlusDirection.start
        ? widget.leftAnimationType
        : widget.rightAnimationType;
  }

  /// returns the left or right scale based on DrawerPlusDirection
  double get _scaleFactor {
    return _position == DrawerPlusDirection.start
        ? widget.scale.left
        : widget.scale.right;
  }

  /// returns the left or right offset based on DrawerPlusDirection
  double get _offset => _position == DrawerPlusDirection.start
      ? widget.offset.left
      : widget.offset.right;

  /// return width with specific offset
  double get _widthWithOffset => (_width / 2) - (_width / 2) * _offset;

  /// Scaffold
  Widget _scaffold() {
    assert(widget.borderRadius >= 0);

    final Widget? invC = _invisibleCover();

    // TODO: Refactor this
    final Widget scaffoldChild = Stack(
      children: [
        widget.scaffold,
        if (invC != null) invC,
      ],
    );

    Widget container = Container(
      key: _drawerKey,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          widget.borderRadius * (1 - _animationController.value),
        ),
        // TODO: Assign boxShadow default value at constructor
        boxShadow: widget.boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 5,
              )
            ],
      ),
      child: widget.borderRadius != 0
          ? ClipRRect(
              borderRadius: BorderRadius.circular(
                (1 - _animationController.value) * widget.borderRadius,
              ),
              child: scaffoldChild,
            )
          : scaffoldChild,
    );

    if (_scaleFactor < 1) {
      container = Transform.scale(
        alignment: _drawerInnerAlignment,
        scale: ((1 - _scaleFactor) * _animationController.value) + _scaleFactor,
        child: container,
      );
    }

    // Vertical translate
    if ((widget.offset.top > 0 || widget.offset.bottom > 0)) {
      final double translateY = MediaQuery.of(context).size.height *
          (widget.offset.top > 0 ? -widget.offset.top : widget.offset.bottom);
      container = Transform.translate(
        offset: Offset(0, translateY * (1 - _animationController.value)),
        child: container,
      );
    }

    return container;
  }

  /// Disables the scaffolding tap when the drawer is open
  Widget? _invisibleCover() {
    final Container container = Container(
      color: _colorTransitionScaffold.evaluate(_animationController),
    );

    if (_animationController.value != 1.0 && !widget.tapScaffoldEnabled) {
      return BlockSemantics(
        child: GestureDetector(
          // On Android, the back button is used to dismiss a modal.
          excludeFromSemantics: defaultTargetPlatform == TargetPlatform.android,
          onTap: widget.onTapClose || !widget.swipe ? close : null,
          child: Semantics(
            label: MaterialLocalizations.of(context).modalBarrierDismissLabel,
            child: container,
          ),
        ),
      );
    }
    return null;
  }

  /// return widget with specific animation
  Widget _animatedChild() {
    Widget? child = _position == DrawerPlusDirection.start
        ? widget.leftChild
        : widget.rightChild;

    if (widget.swipeChild) {
      child = GestureDetector(
        onHorizontalDragUpdate: _move,
        onHorizontalDragEnd: _settle,
        child: child,
      );
    }

    final Widget container = SizedBox(
      width: widget.proportionalChildArea ? _width - _widthWithOffset : _width,
      height: MediaQuery.of(context).size.height,
      child: child,
    );

    switch (_animationType) {
      case DrawerPlusAnimation.linear:
        return Align(
          alignment: _drawerOuterAlignment,
          widthFactor: 1 - (_animationController.value),
          child: container,
        );
      case DrawerPlusAnimation.quadratic:
        return Align(
          alignment: _drawerOuterAlignment,
          widthFactor: 1 - (_animationController.value / 2),
          child: container,
        );
      default:
        return container;
    }
  }

  /// Trigger Area
  Widget? _trigger(AlignmentDirectional alignment, Widget? child) {
    final drawerIsStart = _position == DrawerPlusDirection.start;
    final padding = MediaQuery.of(context).padding;
    double dragAreaWidth = drawerIsStart ? padding.left : padding.right;

    if (Directionality.of(context) == TextDirection.rtl) {
      dragAreaWidth = drawerIsStart ? padding.right : padding.left;
    }

    dragAreaWidth = max(dragAreaWidth, kEdgeDragWidth);

    if (_animationController.status == AnimationStatus.completed &&
        widget.swipe &&
        child != null) {
      return Align(
        alignment: alignment,
        child: Container(
          color: Colors.transparent,
          width: dragAreaWidth,
        ),
      );
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    _historyEntry?.remove();
    _animationController.dispose();
    _focusScopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// initialize the correct width
    if (_width == 400 ||
        MediaQuery.of(context).orientation != _orientation) {
      _updateWidth();
      _orientation = MediaQuery.of(context).orientation;
    }

    /// wFactor depends of offset and is used by the second Align that contains the Scaffold
    final double offset = 0.5 - _offset * 0.5;
    final double wFactor = (_animationController.value * (1 - offset)) + offset;

    return Container(
      decoration: widget.backgroundDecoration ??
          BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
      child: Stack(
        alignment: _drawerInnerAlignment,
        children: <Widget>[
          FocusScope(node: _focusScopeNode, child: _animatedChild()),
          GestureDetector(
            key: _gestureDetectorKey,
            onTap: () {},
            onHorizontalDragDown: widget.swipe ? _handleDragDown : null,
            onHorizontalDragUpdate: widget.swipe ? _move : null,
            onHorizontalDragEnd: widget.swipe ? _settle : null,
            excludeFromSemantics: true,
            child: RepaintBoundary(
              child: Stack(
                children: [
                  ///Gradient
                  Container(
                    width: _animationController.value == 0 ||
                            _animationType == DrawerPlusAnimation.linear
                        ? 0
                        : null,
                    color: _colorTransitionChild.evaluate(_animationController),
                  ),
                  Align(
                    alignment: _drawerOuterAlignment,
                    child: Align(
                      alignment: _drawerInnerAlignment,
                      widthFactor: wFactor,
                      child: RepaintBoundary(
                        child: _scaffold(),
                      ),
                    ),
                  ),

                  ///Trigger
                  _trigger(AlignmentDirectional.centerStart, widget.leftChild),
                  _trigger(AlignmentDirectional.centerEnd, widget.rightChild),
                ].fold([], (prev, element) {
                  if (element != null) {
                    prev.add(element);
                  }

                  return prev;
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
