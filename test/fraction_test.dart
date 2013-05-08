// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library fraction_test;

import 'package:unittest/unittest.dart';
import 'package:more/fraction.dart';

void main() {
  group('fraction', () {
    group('construction', () {
      test('irreducible', () {
        var fraction = new Fraction(3, 7);
        expect(fraction.numerator, 3);
        expect(fraction.denominator, 7);
      });
      test('reducible', () {
        var fraction = new Fraction(15, 35);
        expect(fraction.numerator, 3);
        expect(fraction.denominator, 7);
      });
      test('normal negative', () {
        var fraction = new Fraction(-2, 4);
        expect(fraction.numerator, -1);
        expect(fraction.denominator, 2);
      });
      test('double negative', () {
        var fraction = new Fraction(-2, -4);
        expect(fraction.numerator, 1);
        expect(fraction.denominator, 2);
      });
      test('denominator negative', () {
        var fraction = new Fraction(2, -4);
        expect(fraction.numerator, -1);
        expect(fraction.denominator, 2);
      });
      test('numerator error', () {
        expect(() => new Fraction(null), throwsArgumentError);
      });
      test('denominator error', () {
        expect(() => new Fraction(2, 0), throwsArgumentError);
        expect(() => new Fraction(2, null), throwsArgumentError);
      });
      test('double finite', () {
        expect(new Fraction.fromDouble(1 / 2), new Fraction(1, 2));
        expect(new Fraction.fromDouble(1 / 4), new Fraction(1, 4));
      });
      test('double finite (whole)', () {
        expect(new Fraction.fromDouble(5 / 2), new Fraction(5, 2));
        expect(new Fraction.fromDouble(9 / 4), new Fraction(9, 4));
      });
      test('double infinite', () {
        expect(new Fraction.fromDouble(1 / 3), new Fraction(1, 3));
        expect(new Fraction.fromDouble(1 / 7), new Fraction(1, 7));
      });
      test('double infinite (whole)', () {
        expect(new Fraction.fromDouble(5 / 3), new Fraction(5, 3));
        expect(new Fraction.fromDouble(9 / 7), new Fraction(9, 7));
      });
      test('double negative', () {
        expect(new Fraction.fromDouble(-1 / 3), new Fraction(-1, 3));
        expect(new Fraction.fromDouble(-5 / 3), new Fraction(-5, 3));
      });
    });
  });
}