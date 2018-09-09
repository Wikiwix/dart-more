library more.int_math.gcd;

/// Returns the greatest common divisor (GCD) of two or more integers (at least
/// one of which is not zero). This is the largest positive integer that divides
/// the numbers without a remainder. For example, the GCD of 8 and 12 is 4.
int gcd(int a, int b) {
  while (b != 0) {
    final t = b;
    b = a % b;
    a = t;
  }
  return a;
}
