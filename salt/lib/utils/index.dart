/// To run async function without worring about try/catch blocks
Future<List<dynamic>> runAsync(Future promise) async {
  try {
    final result = await promise;
    return [result, null];
  } catch (err) {
    return [null, err];
  }
}
