import 'package:crypto/crypto.dart';
import 'package:maryland_game_engine/data/primitives/u32.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

/// A SHA256 hash of a set of [U8]s.
class Hash {
  final U32 _a;
  final U32 _b;
  final U32 _c;
  final U32 _d;
  final U32 _e;
  final U32 _f;
  final U32 _g;
  final U32 _h;
  int _internId = 0;

  Hash._(this._a, this._b, this._c, this._d, this._e, this._f, this._g, this._h) {
    final wrapped = WeakReference(this);

    for (int index = 0; index < _existing.length; index++) {
      if (_existing[index].target == null) {
        _internId = index;
        _existing[index] = wrapped;
        return;
      }
    }

    _internId = _existing.length;
    _existing.add(wrapped);
  }

  /// Generates a new [Hash] from a given sequence of [U8s], instead throwing a
  /// [RangeError] including the given [description] should the iterator contain
  /// invalid [U8]s.
  static Hash of(data, description) {
    final extracted = <U8>[];

    for (final byte in data) {
      validateU8(byte, description);
      extracted.add(byte);
    }

    final digest = sha256.convert(extracted);

    return _findOrCreate(
      digest.bytes[0] << 24 | digest.bytes[1] << 16 | digest.bytes[2] << 8 | digest.bytes[3],
      digest.bytes[4] << 24 | digest.bytes[5] << 16 | digest.bytes[6] << 8 | digest.bytes[7],
      digest.bytes[8] << 24 | digest.bytes[9] << 16 | digest.bytes[10] << 8 | digest.bytes[11],
      digest.bytes[12] << 24 | digest.bytes[13] << 16 | digest.bytes[14] << 8 | digest.bytes[15],
      digest.bytes[16] << 24 | digest.bytes[17] << 16 | digest.bytes[18] << 8 | digest.bytes[19],
      digest.bytes[20] << 24 | digest.bytes[21] << 16 | digest.bytes[22] << 8 | digest.bytes[23],
      digest.bytes[24] << 24 | digest.bytes[25] << 16 | digest.bytes[26] << 8 | digest.bytes[27],
      digest.bytes[28] << 24 | digest.bytes[29] << 16 | digest.bytes[30] << 8 | digest.bytes[31]
    );
  }

  static final List<WeakReference<Hash>> _existing = [];

  /// Serializes this [Hash] to a series of [U8]s describing it.
  Iterable<U8> serialize() sync* {
    yield* serializeU32(_a, "Hash part 1 of 8");
    yield* serializeU32(_b, "Hash part 2 of 8");
    yield* serializeU32(_c, "Hash part 3 of 8");
    yield* serializeU32(_d, "Hash part 4 of 8");
    yield* serializeU32(_e, "Hash part 5 of 8");
    yield* serializeU32(_f, "Hash part 6 of 8");
    yield* serializeU32(_g, "Hash part 7 of 8");
    yield* serializeU32(_h, "Hash part 8 of 8");
  }

  /// Deserializes a [Hash] from a series of [U8]s describing one, instead
  /// throwing a [StateError] including the given [description] should the given
  /// [iterator] not contain enough [U8]s to fully describe one, or a
  /// [RangeError] including the given [description] should the iterator contain
  /// invalid [U8]s.
  static Hash deserialize(Iterator<U8> iterator, String description) {
    final a = deserializeU32(iterator, description);
    final b = deserializeU32(iterator, description);
    final c = deserializeU32(iterator, description);
    final d = deserializeU32(iterator, description);
    final e = deserializeU32(iterator, description);
    final f = deserializeU32(iterator, description);
    final g = deserializeU32(iterator, description);
    final h = deserializeU32(iterator, description);
    return _findOrCreate(a, b, c, d, e, f, g, h);
  }

  static Hash _findOrCreate(U32 a, U32 b, U32 c, U32 d, U32 e, U32 f, U32 g, U32 h) {
    for (final item in _existing) {
      final target = item.target;

      if (target != null && target._a == a && target._b == b && target._c == c && target._d == d && target._e == e && target._f == f && target._g == g && target._h == h) {
        return target;
      }
    }

    return Hash._(a, b, c, d, e, f, g, h);
  }

  @override
  bool operator == (other) => other is Hash && _internId == other._internId;

  @override
  int get hashCode => _internId;

  @override
  String toString() => serialize().map((u8) => u8.toRadixString(16).padLeft(2, "0")).join();
}