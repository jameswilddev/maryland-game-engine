import 'package:maryland_game_engine/data/primitives/scratch.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

/// A 32-bit IEEE float.
typedef F32 = double;

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
/// not contain enough [U8]s to completely describe one.
F32 deserializeF32(Iterator<U8> iterator, String description) {
  primitiveScratch.setUint8(3, deserializeU8(iterator, description));
  primitiveScratch.setUint8(2, deserializeU8(iterator, description));
  primitiveScratch.setUint8(1, deserializeU8(iterator, description));
  primitiveScratch.setUint8(0, deserializeU8(iterator, description));
  return primitiveScratch.getFloat32(0);
}
