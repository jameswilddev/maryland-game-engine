import 'package:maryland_game_engine/data/primitives/scratch.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

/// An unsigned 32-bit integer.
typedef U32 = int;

/// The minimum value of an unsigned 32-bit integer.
const U32 u32Min = 0;

/// The maximum value of an unsigned 32-bit integer.
const U32 u32Max = 4294967295;

/// Validates that a given [value] is valid as an unsigned 32-bit integer,
/// otherwise throwing a [RangeError] including the given [description].
void validateU32(U32 value, String description) {
  if (value < u32Min) {
    throw RangeError(
        "$description - Value is out of range for a U32 (less than $u32Min).");
  }

  if (value > u32Max) {
    throw RangeError(
        "$description - Value is out of range for a U32 (greater than $u32Max).");
  }
}

/// Converts a given [U32] [value] to a series of [U8]s describing it, instead
/// throwing a [RangeError] including the given [description] should the given
/// [value] not be a valid [U32].
Iterable<U8> serializeU32(U32 value, String description) sync* {
  validateU32(value, description);
  primitiveScratch.setUint32(0, value);
  yield primitiveScratch.getUint8(0);
  yield primitiveScratch.getUint8(1);
  yield primitiveScratch.getUint8(2);
  yield primitiveScratch.getUint8(3);
}

/// Reads the next [U32] from the given [iterator], instead throwing a
/// [StateError] including the given [description] should the given [iterator]
/// not contain enough [U8]s to completely describe one, or a [RangeError]
/// including the given [description] should the iterator contain invalid [U8]s.
U32 deserializeU32(Iterator<U8> iterator, String description) {
  primitiveScratch.setUint8(0, deserializeU8(iterator, description));
  primitiveScratch.setUint8(1, deserializeU8(iterator, description));
  primitiveScratch.setUint8(2, deserializeU8(iterator, description));
  primitiveScratch.setUint8(3, deserializeU8(iterator, description));
  return primitiveScratch.getUint32(0);
}
