import 'dart:math';

/// Create random string
///
/// It returns a string of length [length] that's generated randomly
String createRandomString(int length) {
  var rnd = Random();
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ),
  );
}

/// To run async function without worring about try/catch blocks
/// It returns a list [result, err]
Future<List<dynamic>> runAsync(Future promise) async {
  try {
    final result = await promise;
    return [result, null];
  } catch (err) {
    return [null, err];
  }
}

/// Filter card method name for Stripe
/// Example:
/// - card becomes Card
/// - google_pay become GooglePay
/// - upi becomes Upi
/// - etc...
String filterPaymentMethodName(String name) {
  var elements = name.split('_');
  elements = elements.map((e) => e[0].toUpperCase() + e.substring(1)).toList();
  return elements.join('');
}
