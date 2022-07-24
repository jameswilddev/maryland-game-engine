import 'package:maryland_game_engine/data/primitives/u8.dart';

import 'scratch.dart';

/// A signed 16-bit integer.
typedef S16 = int;

/// The minimum value of a signed 16-bit integer.
const S16 s16Min = -32768;

/// The maximum value of a signed 16-bit integer.
const S16 s16Max = 32767;

/// Validates that a given [value] is valid as a signed 16-bit integer,
/// otherwise throwing a [RangeError] including the given [description].
void validateS16(S16 value, String description) {
  if (value < s16Min) {
    throw RangeError(
        "$description - Value is out of range for a S16 (less than $s16Min).");
  }

  if (value > s16Max) {
    throw RangeError(
        "$description - Value is out of range for a S16 (greater than $s16Max).");
  }
}

/// Converts a given [S16] [value] to a series of [U8]s describing it, instead
/// throwing a [RangeError] including the given [description] should the given
/// [value] not be a valid [S16].
Iterable<U8> serializeS16(S16 value, String description) sync* {
  validateS16(value, description);
  primitiveScratch.setInt16(0, value);
  yield primitiveScratch.getUint8(1);
  yield primitiveScratch.getUint8(0);
}

/// Reads the next [S16] from the given [iterator], instead throwing a
/// [StateError] including the given [description] should the given [iterator]
/// not contain enough [U8]s to completely describe one, or a [RangeError]
/// including the given [description] should the iterator contain invalid [U8]s.
S16 deserializeS16(Iterator<U8> iterator, String description) {
  primitiveScratch.setUint8(1, deserializeU8(iterator, description));
  primitiveScratch.setUint8(0, deserializeU8(iterator, description));
  return primitiveScratch.getInt16(0);
}
