

enum SittingPosition { left, right, both }

class Tuple<A, B> {
  final A first;
  final B second;

  Tuple(this.first, this.second);

  @override
  String toString() => '($first, $second)';
}

class SittingInfo {
  SittingPosition position;
  List<Tuple<double, SittingPosition>>? segments;
  int? protectionPercentage;

  SittingInfo(
      {required this.position,
      required this.segments,
      required this.protectionPercentage});
}

