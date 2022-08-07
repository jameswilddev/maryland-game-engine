import 'dart:async';

import 'package:maryland_game_engine/data/primitives/u8.dart';
import 'package:maryland_game_engine/data/primitives/u16.dart';
import 'package:maryland_game_engine/data/primitives/u32.dart';
import 'package:maryland_game_engine/data/primitives/s8.dart';
import 'package:maryland_game_engine/data/primitives/s16.dart';
import 'package:maryland_game_engine/data/primitives/s32.dart';
import 'package:maryland_game_engine/data/primitives/f32.dart';

/// An opcode in a list of instructions to be executed against a database.
enum Opcode {
  /// A [U8] entity-attribute-value is to be set.
  setEntityAttributeU8,

  /// A [U16] entity-attribute-value is to be set.
  setEntityAttributeU16,

  /// A [U32] entity-attribute-value is to be set.
  setEntityAttributeU32,

  /// A [S8] entity-attribute-value is to be set.
  setEntityAttributeS8,

  /// A [S16] entity-attribute-value is to be set.
  setEntityAttributeS16,

  /// A [S32] entity-attribute-value is to be set.
  setEntityAttributeS32,

  /// A [F32] entity-attribute-value is to be set.
  setEntityAttributeF32,

  /// An entity reference entity-attribute-value is to be set.
  setEntityAttributeReference,

  /// A entity-attribute-value flag is to be set.
  setEntityAttributeFlag,

  /// A entity-attribute-value flag is to be cleared.
  clearEntityAttributeFlag,
}

/// Converts a given [Opcode] [value] to a series of [U8]s describing it.
Iterable<U8> serializeOpcode(Opcode value) sync* {
  yield value.index;
}

/// Reads the next [U8] from the given [iterator], instead throwing a
/// [StateError] including the given [description] should the given [iterator]
/// have no further items, or a [RangeError] including the given [description]
/// should the iterator contain invalid data.
Future<Opcode> deserializeOpcode(StreamIterator<U8> iterator, String description) async {
  final value = await deserializeU8(iterator, description);

  if (value >= Opcode.values.length) {
    throw RangeError("$description - Value is out of range for an opcode (greater than ${Opcode.values.length - 1}).");
  }

  return Opcode.values[value];
}
