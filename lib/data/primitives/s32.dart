import 'dart:async';

import 'package:maryland_game_engine/data/primitives/scratch.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

/// A signed 32-bit integer.
typedef S32 = int;

/// The minimum value of a signed 32-bit integer.
const S32 s32Min = -2147483648;

/// The maximum value of a signed 32-bit integer.
const S32 s32Max = 2147483647;

/// Validates that a given [value] is valid as a signed 32-bit integer,
/// otherwise throwing a [RangeError] including the given [description].
void validateS32(S32 value, String description) {
  if (value < s32Min) {
    throw RangeError(
        "$description - Value is out of range for a S32 (less than $s32Min).");
  }

  if (value > s32Max) {
    throw RangeError(
        "$description - Value is out of range for a S32 (greater than $s32Max).");
  }
}

/// Converts a given [S32] [value] to a series of [U8]s describing it, instead
/// throwing a [RangeError] including the given [description] should the given
/// [value] not be a valid [S32].
Iterable<U8> serializeS32(S32 value, String description) sync* {
  validateS32(value, description);
  primitiveScratch.setInt32(0, value);
  yield primitiveScratch.getUint8(3);
  yield primitiveScratch.getUint8(2);
  yield primitiveScratch.getUint8(1);
  yield primitiveScratch.getUint8(0);
}

/// Reads the next [S32] from the given [iterator], instead throwing a
/// [StateError] including the given [description] should the given [iterator]
/// not contain enough [U8]s to completely describe one, or a [RangeError]
/// including the given [description] should the iterator contain invalid [U8]s.
Future<S32> deserializeS32(StreamIterator<U8> iterator, String description) async {
  primitiveScratch.setUint8(3, await deserializeU8(iterator, description));
  primitiveScratch.setUint8(2, await deserializeU8(iterator, description));
  primitiveScratch.setUint8(1, await deserializeU8(iterator, description));
  primitiveScratch.setUint8(0, await deserializeU8(iterator, description));
  return primitiveScratch.getInt32(0);
}
