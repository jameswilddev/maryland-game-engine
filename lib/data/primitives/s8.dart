import 'dart:async';

import 'package:maryland_game_engine/data/primitives/scratch.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

/// A signed 8-bit integer.
typedef S8 = int;

/// The minimum value of a signed 8-bit integer.
const S8 s8Min = -128;

/// The maximum value of a signed 8-bit integer.
const S8 s8Max = 127;

/// Validates that a given [value] is valid as a signed 8-bit integer, otherwise
/// throwing a [RangeError] including the given [description].
void validateS8(S8 value, String description) {
  if (value < s8Min) {
    throw RangeError(
        "$description - Value is out of range for a S8 (less than $s8Min).");
  }

  if (value > s8Max) {
    throw RangeError(
        "$description - Value is out of range for a S8 (greater than $s8Max).");
  }
}

/// Converts a given [S8] [value] to a series of [U8]s describing it, instead
/// throwing a [RangeError] including the given [description] should the given
/// [value] not be a valid [S8].
Iterable<U8> serializeS8(S8 value, String description) sync* {
  validateS8(value, description);
  primitiveScratch.setInt8(0, value);
  yield primitiveScratch.getUint8(0);
}

/// Reads the next [S8] from the given [iterator], instead throwing a
/// [StateError] including the given [description] should the given [iterator]
/// not contain enough [U8]s to completely describe one, or a [RangeError]
/// including the given [description] should the iterator contain invalid [U8]s.
Future<S8> deserializeS8(StreamIterator<U8> iterator, String description) async {
  primitiveScratch.setUint8(0, await deserializeU8(iterator, description));
  return primitiveScratch.getInt8(0);
}
