library more.ordering.explicit;

import 'dart:collection';

import 'package:more/ordering.dart';

class ExplicitOrdering<T> extends Ordering<T> {
  final Map<T, int> ranking;

  factory ExplicitOrdering(List<T> list) {
    var ranking = new LinkedHashMap<T, int>();
    for (var rank = 0; rank < list.length; rank++) {
      ranking[list[rank]] = rank;
    }
    return new ExplicitOrdering._(ranking);
  }

  const ExplicitOrdering._(this.ranking);

  @override
  int compare(T a, T b) => _rank(a) - _rank(b);

  int _rank(T element) {
    var rank = ranking[element];
    if (rank == null) {
      throw new StateError('Unable to compare $element with $this');
    }
    return rank;
  }
}
