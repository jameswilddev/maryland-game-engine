import 'dart:async';
import 'dart:convert';

import 'package:maryland_game_engine/data/primitives/scratch.dart';
import 'package:maryland_game_engine/data/primitives/u16.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

/// Validates that a given [value] is valid, otherwise throwing a [RangeError]
/// including the given [description].
void validateString(String value, String description) {
  if (utf8.encode(value).length > 65535) {
    throw RangeError(
        "$description - Value contains too many bytes when UTF-8 encoded (greater than 65535).");
  }
}

/// Converts a given [String] [value] to a series of [U8]s describing it,
/// instead throwing a [RangeError] including the given [description] should the
/// given [value] not be valid.
Iterable<U8> serializeString(String value, String description) sync* {
  final encoded = utf8.encode(value);

  final length = encoded.length;

  if (length > 65535) {
    throw RangeError(
        "$description - Value contains too many bytes when UTF-8 encoded (greater than 65535).");
  }

  yield* serializeU16(length, description);
  yield* encoded;
}

/// Reads the next [String] from the given [iterator], instead throwing a
/// [StateError] including the given [description] should the given [iterator]
/// not contain enough [U8]s to completely describe one, or a [RangeError]
/// including the given [description] should the iterator contain invalid [U8]s.
Future<String> deserializeString(StreamIterator<U8> iterator, String description) async {
  final length = await deserializeU16(iterator, description);
  final bytes = await deserializeU8s(iterator, description, length).toList();
  return utf8.decode(bytes);
}
