import 'dart:math';

import 'package:maryland_game_engine/data/primitives/u32.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

/// A randomly-generated unique identifier for an entity, 128 bits in size,
/// analogous to a UUID or GUID.
class EntityId {
  final U32 _a;
  final U32 _b;
  final U32 _c;
  final U32 _d;
  int _internId = 0;

  EntityId._(this._a, this._b, this._c, this._d) {
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

  static final Random _random = Random.secure();

  /// Randomly generates a new [EntityId].
  static EntityId generate() {
    return EntityId._(
      _random.nextInt(u32Max),
      _random.nextInt(u32Max),
      _random.nextInt(u32Max),
      _random.nextInt(u32Max),
    );
  }

  static final List<WeakReference<EntityId>> _existing = [];

  /// Serializes this [EntityId] to a series of [U8]s describing it.
  Iterable<U8> serialize() sync* {
    yield* serializeU32(_a, "Entity ID part 1 of 4");
    yield* serializeU32(_b, "Entity ID part 2 of 4");
    yield* serializeU32(_c, "Entity ID part 3 of 4");
    yield* serializeU32(_d, "Entity ID part 4 of 4");
  }

  /// Deserializes an [EntityId] from a series of [U8]s describing one, instead
  /// throwing a [StateError] including the given [description] should the given
  /// [iterator] not contain enough [U8]s to fully describe one, or a
  /// [RangeError] including the given [description] should the iterator contain
  /// invalid [U8]s.
  static EntityId deserialize(Iterator<U8> iterator, String description) {
    final a = deserializeU32(iterator, description);
    final b = deserializeU32(iterator, description);
    final c = deserializeU32(iterator, description);
    final d = deserializeU32(iterator, description);

    for (final item in _existing) {
      final target = item.target;

      if (target != null && target._a == a && target._b == b && target._c == c && target._d == d) {
        return target;
      }
    }

    return EntityId._(a, b, c, d);
  }

  @override
  bool operator == (other) => other is EntityId && _internId == other._internId;

  @override
  int get hashCode => _internId;

  @override
  String toString() => serialize().map((u8) => u8.toRadixString(16).padLeft(2, "0")).join();
}