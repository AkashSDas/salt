/// This will handle async functions where try and catch
/// block to avoid repeating try and catch blocks
export async function runAsync(promise: Promise<any>) {
  try {
    const data = await promise;
    return [data, null];
  } catch (error) {
    return [null, error];
  }
}
