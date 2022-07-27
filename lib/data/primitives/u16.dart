import 'dart:async';

import 'package:maryland_game_engine/data/primitives/scratch.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

/// An unsigned 16-bit integer.
typedef U16 = int;

/// The minimum value of an unsigned 16-bit integer.
const U16 u16Min = 0;

/// The maximum value of an unsigned 16-bit integer.
const U16 u16Max = 65535;

/// Validates that a given [value] is valid as an unsigned 16-bit integer,
/// otherwise throwing a [RangeError] including the given [description].
void validateU16(U16 value, String description) {
  if (value < u16Min) {
    throw RangeError(
        "$description - Value is out of range for a U16 (less than $u16Min).");
  }

  if (value > u16Max) {
    throw RangeError(
        "$description - Value is out of range for a U16 (greater than $u16Max).");
  }
}

/// Converts a given [U16] [value] to a series of [U8]s describing it, instead
/// throwing a [RangeError] including the given [description] should the given
/// [value] not be a valid [U16].
Iterable<U8> serializeU16(U16 value, String description) sync* {
  validateU16(value, description);
  primitiveScratch.setUint16(0, value);
  yield primitiveScratch.getUint8(0);
  yield primitiveScratch.getUint8(1);
}

/// Reads the next [U16] from the given [iterator], instead throwing a
/// [StateError] including the given [description] should the given [iterator]
/// not contain enough [U8]s to completely describe one, or a [RangeError]
/// including the given [description] should the iterator contain invalid [U8]s.
Future<U16> deserializeU16(StreamIterator<U8> iterator, String description) async {
  primitiveScratch.setUint8(0, await deserializeU8(iterator, description));
  primitiveScratch.setUint8(1, await deserializeU8(iterator, description));
  return primitiveScratch.getUint16(0);
}
