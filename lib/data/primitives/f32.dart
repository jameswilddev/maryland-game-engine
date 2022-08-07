import 'dart:async';

import 'package:maryland_game_engine/data/primitives/scratch.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

/// A 32-bit IEEE float.
typedef F32 = double;

/// Validates that a given [value] is valid as a 32-bit IEEE float, otherwise
/// throwing a [RangeError] including the given [description].
void validateF32(F32 value, String description) {
}

/// Converts a given [F32] [value] to a series of [U8]s describing it.
Iterable<U8> serializeF32(F32 value) sync* {
  primitiveScratch.setFloat32(0, value);
  yield primitiveScratch.getUint8(3);
  yield primitiveScratch.getUint8(2);
  yield primitiveScratch.getUint8(1);
  yield primitiveScratch.getUint8(0);
}

/// Reads the next [F32] from the given [iterator], instead throwing a
/// [StateError] including the given [description] should the given [iterator]
/// not contain enough [U8]s to completely describe one, or a [RangeError]
/// including the given [description] should the iterator contain invalid [U8]s.
Future<F32> deserializeF32(StreamIterator<U8> iterator, String description) async {
  primitiveScratch.setUint8(3, await deserializeU8(iterator, description));
  primitiveScratch.setUint8(2, await deserializeU8(iterator, description));
  primitiveScratch.setUint8(1, await deserializeU8(iterator, description));
  primitiveScratch.setUint8(0, await deserializeU8(iterator, description));
  return primitiveScratch.getFloat32(0);
}
