import 'dart:async';
import 'dart:math';

import 'package:maryland_game_engine/data/primitives/scratch.dart';
import 'package:maryland_game_engine/data/primitives/u32.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

/// The 32-bit identifier for an attribute.
typedef AttributeId = U32;

/// The minimum value of an attribute ID.
const AttributeId attributeIdMin = 0;

/// The character set supported within attribute IDs.
const String attributeIdCharacterSet = "_abcdefghijklmnopqrstuvwxyz";

/// The size of the character set supported within attribute IDs.
const int attributeIdCharacterSetSize = attributeIdCharacterSet.length;

/// The number of characters within an attribute ID.
const int attributeIdLength = 7;

/// The maximum value of an attribute ID.
const AttributeId attributeIdMax = 10460353202;

/// Validates that a given [value] is valid as an attribute identifier,
/// otherwise throwing a [RangeError] including the given [description].
void validateAttributeId(AttributeId value, String description) {
  if (value < attributeIdMin) {
    throw RangeError(
        "$description - Value is out of range for an attribute ID (less than $attributeIdMin).");
  }

  if (value > attributeIdMax) {
    throw RangeError(
        "$description - Value is out of range for an attribute ID (greater than $attributeIdMax).");
  }
}

/// Converts a given [AttributeId] [value] to a series of [U8]s describing it,
/// instead throwing a [RangeError] including the given [description] should the
/// given [value] not be a valid [AttributeId].
Iterable<U8> serializeAttributeId(AttributeId value, String description) sync* {
  validateAttributeId(value, description);
  primitiveScratch.setUint32(0, value);
  yield primitiveScratch.getUint8(0);
  yield primitiveScratch.getUint8(1);
  yield primitiveScratch.getUint8(2);
  yield primitiveScratch.getUint8(3);
}

/// Reads the next [AttributeId] from the given [iterator], instead throwing a
/// [StateError] including the given [description] should the given [iterator]
/// not contain enough [U8]s to completely describe one, or a [RangeError]
/// including the given [description] should the iterator contain invalid [U8]s
/// or describe an invalid attribute ID.
Future<AttributeId> deserializeAttributeId(StreamIterator<U8> iterator, String description) async {
  primitiveScratch.setUint8(0, await deserializeU8(iterator, description));
  primitiveScratch.setUint8(1, await deserializeU8(iterator, description));
  primitiveScratch.setUint8(2, await deserializeU8(iterator, description));
  primitiveScratch.setUint8(3, await deserializeU8(iterator, description));
  final output = primitiveScratch.getUint32(0);
  validateAttributeId(output, description);
  return output;
}

/// Formats the given [value] as a [String], instead throwing an [ArgumentError]
/// when the given [value] is not a valid [AttributeId].
String formatAttributeIdForDisplay(AttributeId value, String description) {
  validateAttributeId(value, description);

  var output = "";

  for (var i = 0; i < attributeIdLength; i++) {
    final remainder = value % attributeIdCharacterSetSize;
    final character = attributeIdCharacterSet[remainder];
    output = "$character$output";
    value = (value - remainder) ~/ attributeIdCharacterSetSize;
  }

  return output;
}

/// Parses the given [value] as an [AttributeId], instead throwing an
/// [ArgumentError] when the given [value] is too long or contains unsupported
/// characters.
AttributeId parseAttributeId(String value, String description) {
  if (value.length < attributeIdLength) {
    throw RangeError("$description - Attribute IDs cannot be shorter than $attributeIdLength characters.");
  }

  if (value.length > attributeIdLength) {
    throw RangeError("$description - Attribute IDs cannot be longer than $attributeIdLength characters.");
  }

  var output = 0;

  for (var i = 0; i < attributeIdLength; i++) {
    output *= attributeIdCharacterSetSize;

    if (i < value.length) {
      final character = value.substring(i, i + 1);
      final index = attributeIdCharacterSet.indexOf(character);

      if (index == -1) {
        throw RangeError("$description - Attribute IDs can only contain characters from the set $attributeIdCharacterSet.");
      }

      output += index;
    }
  }

  return output;
}
