library more.ordering.comparator;

import 'package:more/ordering.dart';

class ComparatorOrdering<T> extends Ordering<T> {
  final Comparator<T> comparator;

  ComparatorOrdering(this.comparator);

  @override
  int compare(T a, T b) => comparator(a, b);
}
