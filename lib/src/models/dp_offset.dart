/// An immutable set of offset in each of the four cardinal directions.
class DPOffset {
  const DPOffset.horizontal(
    double horizontal,
  )   : left = horizontal,
        top = 0.0,
        right = horizontal,
        bottom = 0.0;

  const DPOffset.only({
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
  })  : assert(
            top >= 0.0 &&
                top <= 1.0 &&
                left >= 0.0 &&
                left <= 1.0 &&
                right >= 0.0 &&
                right <= 1.0 &&
                bottom >= 0.0 &&
                bottom <= 1.0,
            'All values (top, left, right, bottom) must be between 0.0 and 1.0.'),
        assert(top >= 0.0 && bottom == 0.0 || top == 0.0 && bottom >= 0.0,
            'Either "top" must be non-negative and "bottom" must be zero, or "top" must be zero and "bottom" must be non-negative.');

  /// The offset from the left.
  final double left;

  /// The offset from the top.
  final double top;

  /// The offset from the right.
  final double right;

  /// The offset from the bottom.
  final double bottom;
}
