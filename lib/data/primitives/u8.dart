import 'dart:async';

/// An unsigned 8-bit integer.
typedef U8 = int;

/// The minimum value of an unsigned 8-bit integer.
const U8 u8Min = 0;

/// The maximum value of an unsigned 8-bit integer.
const U8 u8Max = 255;

/// Validates that a given [value] is valid as an unsigned 8-bit integer,
/// otherwise throwing a [RangeError] including the given [description].
void validateU8(U8 value, String description) {
  if (value < u8Min) {
    throw RangeError(
        "$description - Value is out of range for a U8 (less than $u8Min).");
  }

  if (value > u8Max) {
    throw RangeError(
        "$description - Value is out of range for a U8 (greater than $u8Max).");
  }
}

/// Converts a given [U8] [value] to a series of [U8]s describing it, instead
/// throwing a [RangeError] including the given [description] should the given
/// [value] not be a valid [U8].
Iterable<U8> serializeU8(U8 value, String description) sync* {
  validateU8(value, description);
  yield value;
}

/// Reads the next [U8] from the given [iterator], instead throwing a
/// [StateError] including the given [description] should the given [iterator]
/// have no further items, or a [RangeError] including the given [description]
/// should the iterator contain invalid [U8]s.
Future<U8> deserializeU8(StreamIterator<U8> iterator, String description) async {
  if (!await iterator.moveNext()) {
    throw StateError("$description - Unexpected end of stream.");
  }

  U8 output = iterator.current;
  validateU8(output, description);
  return output;
}
