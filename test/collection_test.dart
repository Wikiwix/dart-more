library more.test.collection_test;

import 'dart:math';

import 'package:more/collection.dart';
import 'package:test/test.dart';

List<bool> randomBooleans(int seed, int length) {
  var list = <bool>[];
  var generator = Random(seed);
  for (var i = 0; i < length; i++) {
    list.add(generator.nextBool());
  }
  return list;
}

void main() {
  group('bi-map', () {
    var example = BiMap.from({1: 'a', 2: 'b', 3: 'c'});
    group('construction', () {
      test('empty', () {
        var target = BiMap();
        expect(target, isEmpty);
        expect(target.isEmpty, isTrue);
        expect(target.isNotEmpty, isFalse);
        expect(target, hasLength(0));
      });
      test('idenity', () {
        var target = BiMap.identity();
        expect(target, isEmpty);
        expect(target.isEmpty, isTrue);
        expect(target.isNotEmpty, isFalse);
        expect(target, hasLength(0));
      });
      test('copy', () {
        var target = BiMap.from(example);
        expect(target.keys, [1, 2, 3]);
        expect(target.values, ['a', 'b', 'c']);
      });
      test('iterable', () {
        var target = BiMap.fromIterable(example.keys);
        expect(target.keys, [1, 2, 3]);
        expect(target.values, [1, 2, 3]);
        target = BiMap.fromIterable(example.keys, key: (e) => e + 1);
        expect(target.keys, [2, 3, 4]);
        expect(target.values, [1, 2, 3]);
        target = BiMap.fromIterable(example.keys, value: (e) => e + 1);
        expect(target.keys, [1, 2, 3]);
        expect(target.values, [2, 3, 4]);
      });
      test('iterables', () {
        var target1 = BiMap.fromIterables(example.keys, example.values);
        expect(target1.keys, [1, 2, 3]);
        expect(target1.values, ['a', 'b', 'c']);
        var target2 = BiMap.fromIterables(example.values, example.keys);
        expect(target2.keys, ['a', 'b', 'c']);
        expect(target2.values, [1, 2, 3]);
      });
      test('iterables (error)', () {
        expect(() => BiMap.fromIterables([1], []), throwsArgumentError);
        expect(() => BiMap.fromIterables([], [1]), throwsArgumentError);
      });
    });
    group('accessing', () {
      test('indexed', () {
        expect(example[2], 'b');
        expect(example['b'], isNull);
      });
      test('indexed of inverse', () {
        expect(example.inverse['b'], 2);
        expect(example.inverse[2], isNull);
      });
      test('keys', () {
        expect(example.keys, [1, 2, 3]);
        expect(example.containsKey(2), isTrue);
        expect(example.containsKey('b'), isFalse);
      });
      test('keys of inverse', () {
        expect(example.inverse.keys, ['a', 'b', 'c']);
        expect(example.inverse.containsKey(2), isFalse);
        expect(example.inverse.containsKey('b'), isTrue);
      });
      test('values', () {
        expect(example.values, ['a', 'b', 'c']);
        expect(example.containsValue(2), isFalse);
        expect(example.containsValue('b'), isTrue);
      });
      test('values of inverse', () {
        expect(example.inverse.values, [1, 2, 3]);
        expect(example.inverse.containsValue(2), isTrue);
        expect(example.inverse.containsValue('b'), isFalse);
      });
      test('inverse updates', () {
        var target = BiMap.from(example);
        var inverse = target.inverse;
        target[4] = 'd';
        expect(inverse['d'], 4, reason: 'inverse sees addition');
        target.remove(3);
        expect(inverse[3], isNull, reason: 'inverse sees removal');
        inverse['e'] = 5;
        expect(target[5], 'e', reason: 'inverse updates target');
        inverse.remove('d');
        expect(target[4], isNull, reason: 'inverse updates target');
      });
      test('forward updates', () {
        var target = BiMap.from(example);
        var forward = target.forward;
        target[4] = 'd';
        expect(forward[4], 'd', reason: 'inverse sees addition');
        target.remove(3);
        expect(forward[3], isNull, reason: 'inverse sees removal');
        forward[5] = 'e';
        expect(target[5], 'e', reason: 'inverse updates target');
        forward.remove(4);
        expect(target[4], isNull, reason: 'inverse updates target');
      });
      test('backward udpates', () {
        var target = BiMap.from(example);
        var backward = target.backward;
        target[4] = 'd';
        expect(backward['d'], 4, reason: 'inverse sees addition');
        target.remove(3);
        expect(backward[3], isNull, reason: 'inverse sees removal');
        backward['e'] = 5;
        expect(target[5], 'e', reason: 'inverse updates target');
        backward.remove('d');
        expect(target[4], isNull, reason: 'inverse updates target');
      });
      test('iteration', () {
        var keys = <int>[];
        var values = <String>[];
        example.forEach((key, value) {
          keys.add(key);
          values.add(value);
        });
        expect(example.keys, keys);
        expect(example.values, values);
      });
    });
    group('writing', () {
      test('define', () {
        var target = BiMap();
        target[1] = 'a';
        expect(target.keys, [1]);
        expect(target.values, ['a']);
      });
      test('define inverse', () {
        var target = BiMap();
        target.inverse[1] = 'a';
        expect(target.keys, ['a']);
        expect(target.values, [1]);
      });
      test('redefine key to new value', () {
        var target = BiMap.from(example);
        target[2] = 'd';
        expect(target.keys, [1, 3, 2]);
        expect(target.values, ['a', 'c', 'd']);
      });
      test('redefine value to new key', () {
        var target = BiMap.from(example);
        target[4] = 'b';
        expect(target.keys, [1, 3, 4]);
        expect(target.values, ['a', 'c', 'b']);
      });
      test('redefine key and value', () {
        var target = BiMap.from(example);
        target[1] = 'c';
        expect(target.keys, [2, 1]);
        expect(target.values, ['b', 'c']);
      });
      test('remove key', () {
        var target = BiMap.from(example);
        expect(target.remove(2), 'b');
        expect(target.keys, [1, 3]);
        expect(target.values, ['a', 'c']);
        expect(target.inverse.keys, ['a', 'c']);
        expect(target.inverse.values, [1, 3]);
      });
      test('remove value', () {
        var target = BiMap.from(example);
        expect(target.inverse.remove('b'), 2);
        expect(target.keys, [1, 3]);
        expect(target.values, ['a', 'c']);
        expect(target.inverse.keys, ['a', 'c']);
        expect(target.inverse.values, [1, 3]);
      });
      test('clear', () {
        var target = BiMap.from(example);
        target.clear();
        expect(target, isEmpty);
        expect(target.inverse, isEmpty);
      });
      test('define if absent', () {
        var target = BiMap.from(example);
        target.putIfAbsent(1, () => fail('Value already present!'));
        target.putIfAbsent(4, () => 'd');
        expect(target[4], 'd');
      });
    });
  });
  group('bitlist', () {
    group('construction', () {
      test('without elements', () {
        var target = BitList(0);
        expect(target, isEmpty);
        expect(target, hasLength(0));
        expect(target, []);
      });
      test('with elements', () {
        for (var len = 1; len < 100; len++) {
          var target = BitList(len);
          expect(target, isNot(isEmpty));
          expect(target, hasLength(len));
          expect(target, everyElement(isFalse));
        }
      });
      test('with filled false', () {
        for (var len = 1; len < 100; len++) {
          var target = BitList.filled(len, false);
          expect(target, isNot(isEmpty));
          expect(target, hasLength(len));
          expect(target, everyElement(isFalse));
        }
      });
      test('with filled true', () {
        for (var len = 1; len < 100; len++) {
          var target = BitList.filled(len, true);
          expect(target, isNot(isEmpty));
          expect(target, hasLength(len));
          expect(target, everyElement(isTrue));
        }
      });
      test('from List', () {
        for (var len = 0; len < 100; len++) {
          var source = List<bool>.from(randomBooleans(457 * len, len));
          var target = BitList.from(source);
          expect(source, target);
          expect(source, target.toList());
        }
      });
      test('from Set', () {
        for (var len = 0; len < 100; len++) {
          var source = Set<bool>.from(randomBooleans(827 * len, len));
          var target = BitList.from(source);
          expect(source, target);
          expect(source, target.toSet());
        }
      });
      test('from BitList', () {
        for (var len = 0; len < 10; len++) {
          var source = Set<bool>.from(randomBooleans(287 * len, len));
          var target = BitList.from(source);
          expect(source, target);
          expect(target, source);
        }
      });
    });
    group('accessors', () {
      test('reading', () {
        for (var len = 0; len < 100; len++) {
          var source = randomBooleans(135 * len, len);
          var target = BitList.from(source);
          expect(() => target[-1], throwsRangeError);
          for (var i = 0; i < len; i++) {
            expect(target[i], source[i]);
          }
          expect(() => target[len], throwsRangeError);
        }
      });
      test('writing', () {
        for (var len = 0; len < 100; len++) {
          var source = randomBooleans(396 * len, len);
          var target = BitList(len);
          expect(() => target[-1] = true, throwsRangeError);
          for (var i = 0; i < len; i++) {
            target[i] = source[i];
            expect(target.sublist(0, i), source.sublist(0, i));
            expect(target.sublist(i + 1), everyElement(isFalse));
          }
          expect(() => target[len] = true, throwsRangeError);
        }
      });
      test('flipping', () {
        for (var len = 0; len < 100; len++) {
          var source = BitList.from(randomBooleans(385 * len, len));
          var target = ~source;
          expect(() => target.flip(-1), throwsRangeError);
          for (var i = 0; i < len; i++) {
            var before = source[i];
            source.flip(i);
            expect(!before, source[i]);
          }
          expect(() => target.flip(len), throwsRangeError);
          expect(target, source);
        }
      });
      test('counting', () {
        for (var len = 0; len < 100; len++) {
          var list = BitList.from(randomBooleans(823 * len, len));
          var trueCount = list.count(true);
          var falseCount = list.count(false);
          expect(trueCount + falseCount, list.length);
          expect(trueCount, list.where((b) => b == true).length);
          expect(falseCount, list.where((b) => b == false).length);
        }
      });
    });
    group('operators', () {
      test('complement', () {
        var source = BitList.from(randomBooleans(702, 100));
        var target = ~source;
        for (var i = 0; i < target.length; i++) {
          expect(target[i], !source[i]);
        }
      });
      test('intersection', () {
        var source1 = BitList.from(randomBooleans(439, 100));
        var source2 = BitList.from(randomBooleans(902, 100));
        var target = source1 & source2;
        for (var i = 0; i < target.length; i++) {
          expect(target[i], source1[i] && source2[i]);
        }
        expect(target, source2 & source1);
        var other = BitList(99);
        expect(() => other & source1, throwsArgumentError);
        expect(() => source1 & other, throwsArgumentError);
      });
      test('union', () {
        var source1 = BitList.from(randomBooleans(817, 100));
        var source2 = BitList.from(randomBooleans(858, 100));
        var target = source1 | source2;
        for (var i = 0; i < target.length; i++) {
          expect(target[i], source1[i] || source2[i]);
        }
        expect(target, source2 | source1);
        var other = BitList(99);
        expect(() => other | source1, throwsArgumentError);
        expect(() => source1 | other, throwsArgumentError);
      });
      test('difference', () {
        var source1 = BitList.from(randomBooleans(364, 100));
        var source2 = BitList.from(randomBooleans(243, 100));
        var target = source1 - source2;
        for (var i = 0; i < target.length; i++) {
          expect(target[i], source1[i] && !source2[i]);
        }
        expect(target, source1 & ~source2);
        var other = BitList(99);
        expect(() => other - source1, throwsArgumentError);
        expect(() => source1 - other, throwsArgumentError);
      });
      test('shift-left', () {
        for (var len = 0; len < 100; len++) {
          var source = BitList.from(randomBooleans(836 * len, len));
          for (var shift = 0; shift <= len + 10; shift++) {
            var target = source << shift;
            if (shift == 0) {
              expect(target, source);
            } else if (shift >= len) {
              expect(target, everyElement(isFalse));
            } else {
              for (var i = shift; i < source.length; i++) {
                expect(target[i], source[i - shift]);
              }
            }
          }
          expect(() => source << -1, throwsArgumentError);
        }
      });
      test('shift-right', () {
        for (var len = 0; len < 100; len++) {
          var source = BitList.from(randomBooleans(963 * len, len));
          for (var shift = 0; shift <= len + 10; shift++) {
            var target = source >> shift;
            if (shift == 0) {
              expect(target, source);
            } else if (shift >= len) {
              expect(target, everyElement(isFalse));
            } else {
              for (var i = 0; i < source.length - shift; i++) {
                expect(target[i], source[i + shift]);
              }
            }
          }
          expect(() => source >> -1, throwsArgumentError);
        }
      });
    });
    test('fixed length', () {
      var list = BitList(32);
      expect(() => list.add(false), throwsUnsupportedError);
      expect(() => list.addAll([true, false]), throwsUnsupportedError);
      expect(() => list.clear(), throwsUnsupportedError);
      expect(() => list.insert(2, true), throwsUnsupportedError);
      expect(() => list.insertAll(2, [true, false]), throwsUnsupportedError);
      expect(() => list.length = 10, throwsUnsupportedError);
      expect(() => list.remove(true), throwsUnsupportedError);
      expect(() => list.removeAt(2), throwsUnsupportedError);
      expect(() => list.removeLast(), throwsUnsupportedError);
      expect(() => list.removeRange(2, 4), throwsUnsupportedError);
      expect(() => list.removeWhere((value) => true), throwsUnsupportedError);
      expect(
          () => list.replaceRange(2, 4, [true, false]), throwsUnsupportedError);
      expect(() => list.retainWhere((value) => false), throwsUnsupportedError);
    });
  });
  group('multiset', () {
    group('construct', () {
      test('empty', () {
        var set = Multiset();
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
      test('empty identity', () {
        var set = Multiset.identity();
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
      test('one unique', () {
        var set = Multiset.from(['a']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(1));
        expect(set, unorderedEquals(['a']));
        expect(set.distinct, unorderedEquals(['a']));
        expect(set.counts, unorderedEquals([1]));
      });
      test('many unique', () {
        var set = Multiset.from(['a', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([1, 1, 1]));
      });
      test('one repeated', () {
        var set = Multiset.from(['a', 'a', 'a']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'a', 'a']));
        expect(set.distinct, unorderedEquals(['a']));
        expect(set.counts, unorderedEquals([3]));
      });
      test('many repeated', () {
        var set = Multiset.from(['a', 'a', 'a', 'b', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('copy', () {
        var set = Multiset.from(Multiset.from(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('generate', () {
        var set = Multiset.fromIterable(['a', 'a', 'a', 'b', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('generate with key', () {
        var set = Multiset.fromIterable(['a', 'a', 'a', 'b', 'b', 'c'],
            key: (e) => (e as String).codeUnitAt(0));
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals([97, 97, 97, 98, 98, 99]));
        expect(set.distinct, unorderedEquals([97, 98, 99]));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('generate with count', () {
        var set = Multiset.fromIterable(['aaa', 'bb', 'c'],
            key: (e) => (e as String).substring(0, 1),
            count: (e) => (e as String).length);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
    });
    group('adding', () {
      test('zero', () {
        var set = Multiset();
        set..add('a', 0)..add('b', 0);
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
      test('single', () {
        var set = Multiset();
        set..add('a')..add('b')..add('b');
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([1, 2]));
      });
      test('multiple', () {
        var set = Multiset();
        set..add('a', 2)..add('b', 3);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
      test('all', () {
        var set = Multiset();
        set.addAll(['a', 'a', 'b', 'b', 'b']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([3, 2]));
      });
      test('error', () {
        var set = Multiset();
        expect(() => set.add('a', -1), throwsArgumentError);
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
    });
    group('remvoing', () {
      test('zero', () {
        var set = Multiset.from(['a', 'a', 'b', 'b', 'b']);
        set..remove('a', 0)..remove('b', 0);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
      test('single', () {
        var set = Multiset.from(['a', 'a', 'b', 'b', 'b']);
        set..remove('a')..remove('b');
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([1, 2]));
      });
      test('multiple', () {
        var set = Multiset.from(['a', 'a', 'b', 'b', 'b']);
        set..remove('a', 3)..remove('b', 2);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(1));
        expect(set, unorderedEquals(['b']));
        expect(set.distinct, unorderedEquals(['b']));
        expect(set.counts, unorderedEquals([1]));
      });
      test('all', () {
        var set = Multiset.from(['a', 'a', 'b', 'b', 'b']);
        set.removeAll(['a', 'b', 'b']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(2));
        expect(set, unorderedEquals(['a', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([1, 1]));
      });
      test('clear', () {
        var set = Multiset.from(['a', 'a', 'b', 'b', 'b']);
        set.clear();
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
      test('invalid', () {
        var set = Multiset.from(['a', 'a', 'b', 'b', 'b']);
        expect(() => set.remove('c'), returnsNormally);
        expect(() => set.remove('z'), returnsNormally);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
      test('error', () {
        var set = Multiset.from(['a', 'a', 'b', 'b', 'b']);
        expect(() => set.remove('a', -1), throwsArgumentError);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
    });
    group('access', () {
      test('single', () {
        var set = Multiset();
        set['a'] = 2;
        expect(set['a'], 2);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(2));
        expect(set, unorderedEquals(['a', 'a']));
        expect(set.distinct, unorderedEquals(['a']));
        expect(set.counts, unorderedEquals([2]));
      });
      test('multiple', () {
        var set = Multiset();
        set['a'] = 2;
        set['b'] = 3;
        expect(set['a'], 2);
        expect(set['b'], 3);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([3, 2]));
      });
      test('remove', () {
        var set = Multiset.from(['a', 'a', 'b', 'b', 'b']);
        set['b'] = 0;
        expect(set, isNot(isEmpty));
        expect(set, hasLength(2));
        expect(set, unorderedEquals(['a', 'a']));
        expect(set.distinct, unorderedEquals(['a']));
        expect(set.counts, unorderedEquals([2]));
      });
      test('error', () {
        var set = Multiset.from(['a', 'a', 'b', 'b', 'b']);
        expect(() => set['a'] = -1, throwsArgumentError);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
    });
    group('operator', () {
      var firstList = ['a', 'b', 'c', 'c'];
      var firstSet = Multiset.from(firstList);
      var secondList = ['a', 'c', 'd', 'd'];
      var secondSet = Multiset.from(secondList);
      test('contains', () {
        expect(firstSet.contains('a'), isTrue);
        expect(firstSet.contains('b'), isTrue);
        expect(firstSet.contains('c'), isTrue);
        expect(firstSet.contains('d'), isFalse);
      });
      test('containsAll', () {
        expect(firstSet.containsAll(firstSet), isTrue);
        expect(firstSet.containsAll(secondSet), isFalse);
        expect(firstSet.containsAll(Multiset()), isTrue);
        expect(firstSet.containsAll(Multiset.from(['a', 'b', 'b'])), isFalse);
        expect(firstSet.containsAll(Multiset.from(['a', 'b', 'd'])), isFalse);
      });
      test('containsAll (iterable)', () {
        expect(firstSet.containsAll(firstList), isTrue);
        expect(firstSet.containsAll(secondList), isFalse);
        expect(firstSet.containsAll([]), isTrue);
        expect(firstSet.containsAll(['a']), isTrue);
        expect(firstSet.containsAll(['x']), isFalse);
        expect(firstSet.containsAll(['a', 'b', 'b']), isFalse);
        expect(firstSet.containsAll(['a', 'b', 'd']), isFalse);
      });
      test('intersection', () {
        expect(firstSet.intersection(secondSet), unorderedEquals(['a', 'c']));
        expect(firstSet.intersection(secondSet).distinct,
            unorderedEquals(['a', 'c']));
        expect(secondSet.intersection(firstSet), unorderedEquals(['a', 'c']));
        expect(secondSet.intersection(firstSet).distinct,
            unorderedEquals(['a', 'c']));
      });
      test('intersection (iterable)', () {
        expect(firstSet.intersection(secondList), unorderedEquals(['a', 'c']));
        expect(secondSet.intersection(firstList), unorderedEquals(['a', 'c']));
      });
      test('union', () {
        expect(firstSet.union(secondSet),
            unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
        expect(firstSet.union(secondSet).distinct,
            unorderedEquals(['a', 'b', 'c', 'd']));
        expect(secondSet.union(firstSet),
            unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
        expect(secondSet.union(firstSet).distinct,
            unorderedEquals(['a', 'b', 'c', 'd']));
      });
      test('union (iterable)', () {
        expect(firstSet.union(secondList),
            unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
        expect(secondSet.union(firstList),
            unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
      });
      test('difference', () {
        expect(firstSet.difference(secondSet), unorderedEquals(['b', 'c']));
        expect(firstSet.difference(secondSet).distinct,
            unorderedEquals(['b', 'c']));
        expect(secondSet.difference(firstSet), unorderedEquals(['d', 'd']));
        expect(secondSet.difference(firstSet).distinct, unorderedEquals(['d']));
      });
      test('difference (iterable)', () {
        expect(firstSet.difference(secondList), unorderedEquals(['b', 'c']));
        expect(secondSet.difference(firstList), unorderedEquals(['d', 'd']));
      });
    });
  });
  group('range', () {
    void verify(List<num> range, List<num> expected) {
      expect(range, expected);
      expect(range.reversed, expected.reversed);
      var iterator = range.iterator;
      for (var i = 0; i < expected.length; i++) {
        expect(iterator.moveNext(), isTrue);
        expect(iterator.current, range[i]);
        expect(range.indexOf(iterator.current), i);
        expect(range.indexOf(iterator.current, i), i);
        expect(range.indexOf(iterator.current, -1), i);
        expect(range.lastIndexOf(iterator.current), i);
        expect(range.lastIndexOf(iterator.current, i), i);
        expect(range.lastIndexOf(iterator.current, expected.length), i);
      }
      expect(iterator.moveNext(), isFalse);
      expect(() => range[-1], throwsRangeError);
      expect(() => range[expected.length], throwsRangeError);
      for (var value in expected) {
        expect(range.contains(value), isTrue);
      }
    }

    group('int', () {
      group('constructor', () {
        test('empty', () {
          verify(IntegerRange(), []);
          expect(IntegerRange().contains(0), isFalse);
        });
        test('1 argument', () {
          verify(IntegerRange(0), []);
          verify(IntegerRange(1), [0]);
          verify(IntegerRange(2), [0, 1]);
          verify(IntegerRange(3), [0, 1, 2]);
        });
        test('2 argument', () {
          verify(IntegerRange(0, 4), [0, 1, 2, 3]);
          verify(IntegerRange(5, 9), [5, 6, 7, 8]);
          verify(IntegerRange(9, 5), [9, 8, 7, 6]);
        });
        test('3 argument (positive step)', () {
          verify(IntegerRange(2, 8, 2), [2, 4, 6]);
          verify(IntegerRange(3, 8, 2), [3, 5, 7]);
          verify(IntegerRange(4, 8, 2), [4, 6]);
          verify(IntegerRange(2, 7, 2), [2, 4, 6]);
          verify(IntegerRange(2, 6, 2), [2, 4]);
        });
        test('3 argument (negative step)', () {
          verify(IntegerRange(8, 2, -2), [8, 6, 4]);
          verify(IntegerRange(8, 3, -2), [8, 6, 4]);
          verify(IntegerRange(8, 4, -2), [8, 6]);
          verify(IntegerRange(7, 2, -2), [7, 5, 3]);
          verify(IntegerRange(6, 2, -2), [6, 4]);
        });
        test('invalid', () {
          expect(() => IntegerRange(0, 2, 0), throwsArgumentError);
          expect(() => IntegerRange(0, 2, -1), throwsArgumentError);
          expect(() => IntegerRange(2, 0, 1), throwsArgumentError);
        });
      });
      group('sublist', () {
        test('sublist (1 argument)', () {
          verify(IntegerRange(3).sublist(0), [0, 1, 2]);
          verify(IntegerRange(3).sublist(1), [1, 2]);
          verify(IntegerRange(3).sublist(2), [2]);
          verify(IntegerRange(3).sublist(3), []);
          expect(() => IntegerRange(3).sublist(4), throwsRangeError);
        });
        test('sublist (2 arguments)', () {
          verify(IntegerRange(3).sublist(0, 3), [0, 1, 2]);
          verify(IntegerRange(3).sublist(0, 2), [0, 1]);
          verify(IntegerRange(3).sublist(0, 1), [0]);
          verify(IntegerRange(3).sublist(0, 0), []);
          expect(() => IntegerRange(3).sublist(0, 4), throwsRangeError);
        });
        test('getRange', () {
          verify(IntegerRange(3).getRange(0, 3).toList(), [0, 1, 2]);
          verify(IntegerRange(3).getRange(0, 2).toList(), [0, 1]);
          verify(IntegerRange(3).getRange(0, 1).toList(), [0]);
          verify(IntegerRange(3).getRange(0, 0).toList(), []);
          expect(() => IntegerRange(3).getRange(0, 4), throwsRangeError);
        });
      });
      group('index', () {
        test('indexOf (positive step)', () {
          var r = IntegerRange(2, 7, 2); // [2, 4, 6]
          expect(r.indexOf(null), -1);
          expect(r.indexOf(1), -1);
          expect(r.indexOf(3), -1);
          expect(r.indexOf(5), -1);
          expect(r.indexOf(7), -1);
          expect(r.indexOf(2, 1), -1);
          expect(r.indexOf(4, 2), -1);
          expect(r.indexOf(6, 3), -1);
          expect(r.indexOf(8, 4), -1);
        });
        test('indexOf (negative step)', () {
          var r = IntegerRange(7, 2, -2); // [7, 5, 3]
          expect(r.indexOf(null), -1);
          expect(r.indexOf(2), -1);
          expect(r.indexOf(4), -1);
          expect(r.indexOf(6), -1);
          expect(r.indexOf(8), -1);
          expect(r.indexOf(2, 1), -1);
          expect(r.indexOf(4, 2), -1);
          expect(r.indexOf(6, 3), -1);
          expect(r.indexOf(8, 4), -1);
        });
        test('lastIndexOf (positive step)', () {
          var r = IntegerRange(2, 7, 2); // [2, 4, 6]
          expect(r.lastIndexOf(null), -1);
          expect(r.lastIndexOf(1), -1);
          expect(r.lastIndexOf(3), -1);
          expect(r.lastIndexOf(5), -1);
          expect(r.lastIndexOf(7), -1);
          expect(r.lastIndexOf(1, 1), -1);
          expect(r.lastIndexOf(3, 2), -1);
          expect(r.lastIndexOf(5, 3), -1);
          expect(r.lastIndexOf(7, 4), -1);
        });
        test('lastIndexOf (negative step)', () {
          var r = IntegerRange(7, 2, -2); // [7, 5, 3]
          expect(r.lastIndexOf(null), -1);
          expect(r.lastIndexOf(2), -1);
          expect(r.lastIndexOf(4), -1);
          expect(r.lastIndexOf(6), -1);
          expect(r.lastIndexOf(8), -1);
          expect(r.lastIndexOf(2, 1), -1);
          expect(r.lastIndexOf(4, 2), -1);
          expect(r.lastIndexOf(6, 3), -1);
          expect(r.lastIndexOf(8, 4), -1);
        });
      });
      test('printing', () {
        expect(IntegerRange().toString(), 'new IntegerRange()');
        expect(IntegerRange(1).toString(), 'new IntegerRange(1)');
        expect(IntegerRange(1, 2).toString(), 'new IntegerRange(1, 2)');
        expect(IntegerRange(1, 5, 2).toString(), 'new IntegerRange(1, 5, 2)');
      });
      test('unmodifiable', () {
        var list = IntegerRange(1, 5);
        expect(() => list[0] = 5, throwsUnsupportedError);
        expect(() => list.add(5), throwsUnsupportedError);
        expect(() => list.addAll([5, 6]), throwsUnsupportedError);
        expect(() => list.clear(), throwsUnsupportedError);
        expect(() => list.fillRange(2, 4, 5), throwsUnsupportedError);
        expect(() => list.insert(2, 5), throwsUnsupportedError);
        expect(() => list.insertAll(2, [5, 6]), throwsUnsupportedError);
        expect(() => list.length = 10, throwsUnsupportedError);
        expect(() => list.remove(5), throwsUnsupportedError);
        expect(() => list.removeAt(2), throwsUnsupportedError);
        expect(() => list.removeLast(), throwsUnsupportedError);
        expect(() => list.removeRange(2, 4), throwsUnsupportedError);
        expect(() => list.removeWhere((value) => true), throwsUnsupportedError);
        expect(() => list.replaceRange(2, 4, [5, 6]), throwsUnsupportedError);
        expect(
            () => list.retainWhere((value) => false), throwsUnsupportedError);
        expect(() => list.setAll(2, [5, 6]), throwsUnsupportedError);
        expect(() => list.setRange(2, 4, [5, 6]), throwsUnsupportedError);
        expect(() => list.shuffle(), throwsUnsupportedError);
        expect(() => list.sort(), throwsUnsupportedError);
      });
    });
    group('double', () {
      group('constructor', () {
        test('empty', () {
          verify(DoubleRange(), []);
          expect(DoubleRange().contains(0.0), isFalse);
        });
        test('1 argument', () {
          verify(DoubleRange(0.0), []);
          verify(DoubleRange(1.0), [0.0]);
          verify(DoubleRange(2.0), [0.0, 1.0]);
          verify(DoubleRange(3.0), [0.0, 1.0, 2.0]);
        });
        test('2 argument', () {
          verify(DoubleRange(0.0, 4.0), [0.0, 1.0, 2.0, 3.0]);
          verify(DoubleRange(5.0, 9.0), [5.0, 6.0, 7.0, 8.0]);
          verify(DoubleRange(9.0, 5.0), [9.0, 8.0, 7.0, 6.0]);
        });
        test('3 argument (positive step)', () {
          verify(DoubleRange(2.0, 8.0, 1.5), [2.0, 3.5, 5.0, 6.5]);
          verify(DoubleRange(3.0, 8.0, 1.5), [3.0, 4.5, 6.0, 7.5]);
          verify(DoubleRange(4.0, 8.0, 1.5), [4.0, 5.5, 7.0]);
          verify(DoubleRange(2.0, 7.0, 1.5), [2.0, 3.5, 5.0, 6.5]);
          verify(DoubleRange(2.0, 6.0, 1.5), [2.0, 3.5, 5.0]);
        });
        test('3 argument (negative step)', () {
          verify(DoubleRange(8.0, 2.0, -1.5), [8.0, 6.5, 5.0, 3.5]);
          verify(DoubleRange(8.0, 3.0, -1.5), [8.0, 6.5, 5.0, 3.5]);
          verify(DoubleRange(8.0, 4.0, -1.5), [8.0, 6.5, 5.0]);
          verify(DoubleRange(7.0, 2.0, -1.5), [7.0, 5.5, 4.0, 2.5]);
          verify(DoubleRange(6.0, 2.0, -1.5), [6.0, 4.5, 3.0]);
        });
        test('invalid', () {
          expect(() => DoubleRange(0.0, 2.0, 0.0), throwsArgumentError);
          expect(() => DoubleRange(0.0, 2.0, -1.5), throwsArgumentError);
          expect(() => DoubleRange(2.0, 0.0, 1.5), throwsArgumentError);
        });
      });
      group('sublist', () {
        test('sublist (1 argument)', () {
          verify(DoubleRange(3.0).sublist(0), [0.0, 1.0, 2.0]);
          verify(DoubleRange(3.0).sublist(1), [1.0, 2.0]);
          verify(DoubleRange(3.0).sublist(2), [2.0]);
          verify(DoubleRange(3.0).sublist(3), []);
          expect(() => DoubleRange(3.0).sublist(4), throwsRangeError);
        });
        test('sublist (2 arguments)', () {
          verify(DoubleRange(3.0).sublist(0, 3), [0.0, 1.0, 2.0]);
          verify(DoubleRange(3.0).sublist(0, 2), [0.0, 1.0]);
          verify(DoubleRange(3.0).sublist(0, 1), [0.0]);
          verify(DoubleRange(3.0).sublist(0, 0), []);
          expect(() => DoubleRange(3.0).sublist(0, 4), throwsRangeError);
        });
        test('getRange', () {
          verify(DoubleRange(3.0).getRange(0, 3).toList(), [0.0, 1.0, 2.0]);
          verify(DoubleRange(3.0).getRange(0, 2).toList(), [0.0, 1.0]);
          verify(DoubleRange(3.0).getRange(0, 1).toList(), [0.0]);
          verify(DoubleRange(3.0).getRange(0, 0).toList(), []);
          expect(() => DoubleRange(3.0).getRange(0, 4), throwsRangeError);
        });
      });
      group('index', () {
        test('indexOf (positive step)', () {
          var r = DoubleRange(2.0, 7.0, 1.5); // [2.0, 3.5, 5.0, 6.5]
          expect(r.indexOf(null), -1);
          expect(r.indexOf(1.0), -1);
          expect(r.indexOf(3.0), -1);
          expect(r.indexOf(7.0), -1);
          expect(r.indexOf(2.0, 1), -1);
          expect(r.indexOf(3.5, 2), -1);
          expect(r.indexOf(5.0, 3), -1);
          expect(r.indexOf(6.5, 4), -1);
        });
        test('indexOf (negative step)', () {
          var r = DoubleRange(7.0, 2.0, -1.5); // [7.0, 5.5, 4.0, 2.5]
          expect(r.indexOf(null), -1);
          expect(r.indexOf(2.0), -1);
          expect(r.indexOf(5.0), -1);
          expect(r.indexOf(8.0), -1);
          expect(r.indexOf(7.0, 1), -1);
          expect(r.indexOf(5.5, 2), -1);
          expect(r.indexOf(4.0, 3), -1);
          expect(r.indexOf(2.5, 4), -1);
        });
        test('lastIndexOf (positive step)', () {
          var r = DoubleRange(2.0, 7.0, 1.5); // [2.0, 3.5, 5.0, 6.5]
          expect(r.lastIndexOf(null), -1);
          expect(r.lastIndexOf(1.0), -1);
          expect(r.lastIndexOf(3.0), -1);
          expect(r.lastIndexOf(7.0), -1);
          expect(r.lastIndexOf(2.0, -1), -1);
          expect(r.lastIndexOf(3.5, 0), -1);
          expect(r.lastIndexOf(5.0, 1), -1);
          expect(r.lastIndexOf(6.5, 2), -1);
          expect(r.lastIndexOf(7.0, 3), -1);
          expect(r.lastIndexOf(8.5, 4), -1);
        });
        test('lastIndexOf (negative step)', () {
          var r = DoubleRange(7.0, 2.0, -1.5); // [7.0, 5.5, 4.0, 2.5]
          expect(r.lastIndexOf(null), -1);
          expect(r.lastIndexOf(2.0), -1);
          expect(r.lastIndexOf(5.0), -1);
          expect(r.lastIndexOf(8.0), -1);
          expect(r.lastIndexOf(7.0, -1), -1);
          expect(r.lastIndexOf(5.5, 0), -1);
          expect(r.lastIndexOf(4.0, 1), -1);
          expect(r.lastIndexOf(2.5, 2), -1);
          expect(r.lastIndexOf(1.0, 3), -1);
          expect(r.lastIndexOf(0.0, 4), -1);
        });
      });
      test('printing', () {
        expect(DoubleRange().toString(), 'new DoubleRange()');
        expect(DoubleRange(1.2).toString(), 'new DoubleRange(1.2)');
        expect(DoubleRange(1.2, 3.4).toString(), 'new DoubleRange(1.2, 3.4)');
        expect(DoubleRange(1.2, 3.4, 0.5).toString(),
            'new DoubleRange(1.2, 3.4, 0.5)');
      });
      test('unmodifiable', () {
        var list = DoubleRange(1.0, 5.0);
        expect(() => list[0] = 5.0, throwsUnsupportedError);
        expect(() => list.add(5.0), throwsUnsupportedError);
        expect(() => list.addAll([5.0, 6.0]), throwsUnsupportedError);
        expect(() => list.clear(), throwsUnsupportedError);
        expect(() => list.fillRange(2, 4, 5.0), throwsUnsupportedError);
        expect(() => list.insert(2, 5.0), throwsUnsupportedError);
        expect(() => list.insertAll(2, [5.0, 6.0]), throwsUnsupportedError);
        expect(() => list.length = 10, throwsUnsupportedError);
        expect(() => list.remove(5.0), throwsUnsupportedError);
        expect(() => list.removeAt(2), throwsUnsupportedError);
        expect(() => list.removeLast(), throwsUnsupportedError);
        expect(() => list.removeRange(2, 4), throwsUnsupportedError);
        expect(() => list.removeWhere((value) => true), throwsUnsupportedError);
        expect(
            () => list.replaceRange(2, 4, [5.0, 6.0]), throwsUnsupportedError);
        expect(
            () => list.retainWhere((value) => false), throwsUnsupportedError);
        expect(() => list.setAll(2, [5.0, 6.0]), throwsUnsupportedError);
        expect(() => list.setRange(2, 4, [5.0, 6.0]), throwsUnsupportedError);
        expect(() => list.sort(), throwsUnsupportedError);
      });
    });
  });
  group('string', () {
    group('immutable', () {
      var empty = string('');
      var plenty = string('More Dart');
      test('creating', () {
        var coerced = string(123);
        expect(coerced.length, 3);
        expect(coerced.toString(), '123');
      });
      test('isEmtpy', () {
        expect(empty.isEmpty, isTrue);
        expect(plenty.isEmpty, isFalse);
      });
      test('length', () {
        expect(empty.length, 0);
        expect(plenty.length, 9);
      });
      test('reading', () {
        expect(plenty[0], 'M');
        expect(plenty[1], 'o');
        expect(plenty[2], 'r');
        expect(plenty[3], 'e');
        expect(plenty[4], ' ');
        expect(plenty[5], 'D');
        expect(plenty[6], 'a');
        expect(plenty[7], 'r');
        expect(plenty[8], 't');
      });
      test('reading (range error)', () {
        expect(() => empty[0], throwsRangeError);
        expect(() => plenty[-1], throwsRangeError);
        expect(() => plenty[9], throwsRangeError);
      });
      test('converting', () {
        expect(empty.toList(), []);
        expect(plenty.toList(), ['M', 'o', 'r', 'e', ' ', 'D', 'a', 'r', 't']);
        expect(empty.toSet(), Set());
        expect(
            plenty.toSet(), Set.from(['M', 'o', 'r', 'e', ' ', 'D', 'a', 't']));
        expect(empty.toString(), '');
        expect(plenty.toString(), 'More Dart');
      });
      test('read-only', () {
        expect(() => plenty[0] = 'a', throwsUnsupportedError);
        expect(() => plenty.length = 10, throwsUnsupportedError);
        expect(() => plenty.add('a'), throwsUnsupportedError);
        expect(() => plenty.remove('a'), throwsUnsupportedError);
      });
      test('sublist', () {
        expect(plenty.sublist(5).toString(), plenty.toString().substring(5));
        expect(
            plenty.sublist(5, 7).toString(), plenty.toString().substring(5, 7));
      });
    });
    group('mutable', () {
      var empty = mutableString('');
      var plenty = mutableString('More Dart');
      test('creating', () {
        var coerced = mutableString(123);
        expect(coerced.length, 3);
        expect(coerced.toString(), '123');
      });
      test('isEmtpy', () {
        expect(empty.isEmpty, isTrue);
        expect(plenty.isEmpty, isFalse);
      });
      test('length', () {
        expect(empty.length, 0);
        expect(plenty.length, 9);
      });
      test('reading', () {
        expect(plenty[0], 'M');
        expect(plenty[1], 'o');
        expect(plenty[2], 'r');
        expect(plenty[3], 'e');
        expect(plenty[4], ' ');
        expect(plenty[5], 'D');
        expect(plenty[6], 'a');
        expect(plenty[7], 'r');
        expect(plenty[8], 't');
      });
      test('reading (range error)', () {
        expect(() => empty[0], throwsRangeError);
        expect(() => plenty[-1], throwsRangeError);
        expect(() => plenty[9], throwsRangeError);
      });
      test('writing', () {
        var mutable = mutableString('abc');
        mutable[1] = 'd';
        expect(mutable.toString(), 'adc');
      });
      test('writing (range error)', () {
        expect(() => empty[0] = 'a', throwsRangeError);
        expect(() => plenty[-1] = 'a', throwsRangeError);
        expect(() => plenty[9] = 'a', throwsRangeError);
      });
      test('writing (argument error)', () {
        expect(() => plenty[0] = 'ab', throwsArgumentError);
      });
      test('adding', () {
        var mutable = mutableString('abc');
        mutable.add('d');
        expect(mutable.toString(), 'abcd');
      });
      test('removing', () {
        var mutable = mutableString('abc');
        mutable.remove('a');
        expect(mutable.toString(), 'bc');
      });
      test('converting', () {
        expect(empty.toList(), []);
        expect(plenty.toList(), ['M', 'o', 'r', 'e', ' ', 'D', 'a', 'r', 't']);
        expect(empty.toSet(), Set());
        expect(
            plenty.toSet(), Set.from(['M', 'o', 'r', 'e', ' ', 'D', 'a', 't']));
        expect(empty.toString(), '');
        expect(plenty.toString(), 'More Dart');
      });
      test('sublist', () {
        expect(plenty.sublist(5).toString(), plenty.toString().substring(5));
        expect(
            plenty.sublist(5, 7).toString(), plenty.toString().substring(5, 7));
      });
    });
  });
}
