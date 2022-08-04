import '../../../primitives/attribute_id.dart';
import '../../../primitives/entity_id.dart';
import 'flag_entity_attribute_value_store.dart';

/// An entity-attribute-value flag store which can be written to.
class WritableFlagEntityAttributeValueStore implements FlagEntityAttributeValueStore {
  /// The store which is read from when this store lacks a mapping.
  final FlagEntityAttributeValueStore backingStore;

  final Map<EntityId, Map<AttributeId, bool>> _flagsByEntityId = <EntityId, Map<AttributeId, bool>>{};

  /// Creates a new entity-attribute-value flag store which can be written to,
  /// with a given [backingStore] to be used when no match can be found during a
  /// lookup.
  WritableFlagEntityAttributeValueStore(this.backingStore);

  /// Determines whether the flag specified by the given
  /// [entityId]/[attributeId] pair is set.  May return a default value, or one
  /// from a backing store.  Throws a [RangeError] when the given [attributeId]
  /// is invalid.
  @override
  bool get(EntityId entityId, AttributeId attributeId) {
    validateAttributeId(attributeId, "Attribute ID");

    final flags = _flagsByEntityId[entityId];

    if (flags == null) {
      return backingStore.get(entityId, attributeId);
    }

    return flags[attributeId] ?? backingStore.get(entityId, attributeId);
  }

  /// Sets the flag specified by the given [entityId]/[attributeId] pair if it
  /// is not currently set.  Throws a [RangeError] when the given [attributeId]
  /// is invalid.
  void set(EntityId entityId, AttributeId attributeId) {
    validateAttributeId(attributeId, "Attribute ID");

    var flags = _flagsByEntityId[entityId];

    if (flags == null) {
      flags = {};
      _flagsByEntityId[entityId] = flags;
    }

    flags[attributeId] = true;
  }

  /// Clears the flag specified by the given [entityId]/[attributeId] pair if it
  /// is currently set.  Throws a [RangeError] when the given [attributeId] is
  /// invalid.
  void clear(EntityId entityId, AttributeId attributeId) {
    validateAttributeId(attributeId, "Attribute ID");

    var flags = _flagsByEntityId[entityId];

    if (flags == null) {
      flags = {};
      _flagsByEntityId[entityId] = flags;
    }

    flags[attributeId] = false;
  }

  /// Applies all entity-attribute-values within this store to a given [store],
  /// then clears this store.
  moveTo(WritableFlagEntityAttributeValueStore store) {
    for (final flags in _flagsByEntityId.entries) {
      final entityId = flags.key;

      for (final attribute in flags.value.entries) {
        final attributeId = attribute.key;

        if (attribute.value) {
          store.set(entityId, attributeId);
        } else {
          store.clear(entityId, attributeId);
        }
      }
    }

    _flagsByEntityId.clear();
  }
}
