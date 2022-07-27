import 'dart:async';

import 'package:maryland_game_engine/data/primitives/u8.dart';

/// A 32-bits-per-pixel [Color], including [red], [green] and [blue] intensities
/// (where 0 = minimum intensity and 255 = maximum intensity) and a
/// (non-pre-multiplied) [opacity] (where 0 = transparent and 255 = opaque).
class Color {
  /// The intensity of the red channel (where 0 = minimum intensity and 255 =
  /// maximum intensity, non-pre-multiplied).
  final U8 red;

  /// The intensity of the green channel (where 0 = minimum intensity and 255 =
  /// maximum intensity, non-pre-multiplied).
  final U8 green;

  /// The intensity of the blue channel (where 0 = minimum intensity and 255 =
  /// maximum intensity, non-pre-multiplied).
  final U8 blue;

  /// The opacity of the overall [Color], where 0 = transparent and
  /// 255 = opaque.
  final U8 opacity;

  /// Creates a new 32-bits-per-pixel [Color], including [red], [green] and [blue]
  /// intensities (where 0 = minimum intensity and 255 = maximum intensity) and
  /// a (non-pre-multiplied) [opacity] (where 0 = transparent and 255 = opaque).
  /// Throws a [RangeError] when any argument is not a valid U8.
  Color(this.red, this.green, this.blue, this.opacity) {
    validateU8(red, "Red intensity of color");
    validateU8(green, "Green intensity of color");
    validateU8(blue, "Blue intensity of color");
    validateU8(opacity, "Opacity of color");
  }

  /// Serializes this [EntityId] to a series of [U8]s describing it.
  Iterable<U8> serialize() sync* {
    yield* serializeU8(red, "Color red intensity");
    yield* serializeU8(green, "Color green intensity");
    yield* serializeU8(blue, "Color blue intensity");
    yield* serializeU8(opacity, "Color opacity");
  }

  /// Deserializes a [Color] from a series of [U8]s describing one, instead
  /// throwing a [StateError] including the given [description] should the given
  /// [iterator] not contain enough [U8]s to fully describe one, or a
  /// [RangeError] including the given [description] should the iterator contain
  /// invalid [U8]s.
  static Future<Color> deserialize(StreamIterator<U8> iterator, String description) async {
    final red = await deserializeU8(iterator, "$description (red intensity)");
    final green = await deserializeU8(iterator, "$description (green intensity)");
    final blue = await deserializeU8(iterator, "$description (blue intensity)");
    final opacity = await deserializeU8(iterator, "$description (opacity)");

    return Color(red, green, blue, opacity);
  }

  @override
  bool operator == (other) => other is Color && red == other.red && green == other.green && blue == other.blue && opacity == other.opacity;

  @override
  int get hashCode => red << 24 | green << 16 | blue << 8 | opacity;

  @override
  String toString() => "#${red.toRadixString(16).padLeft(2, "0")}${green.toRadixString(16).padLeft(2, "0")}${blue.toRadixString(16).padLeft(2, "0")}${opacity.toRadixString(16).padLeft(2, "0")}";
}