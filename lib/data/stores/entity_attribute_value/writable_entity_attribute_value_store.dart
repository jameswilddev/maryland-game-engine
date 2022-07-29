import 'package:maryland_game_engine/data/stores/entity_attribute_value/entity_attribute_value_store.dart';

import '../../primitives/attribute_id.dart';
import '../../primitives/entity_id.dart';

/// An entity-attribute-value store which can be written to.
class WritableEntityAttributeValueStore<T> {
  /// The store which is read from when this store lacks a map
  final EntityAttributeValueStore<T> backingStore;

  final Map<EntityId, Map<AttributeId, T>> _values = <EntityId, Map<AttributeId, T>>{};

  /// Creates a new entity-attribute-value store which can be written to, with a
  /// given [backingStore] to be used when no match can be found during a
  /// lookup.
  WritableEntityAttributeValueStore(this.backingStore);

  /// Retrieves the value of the specified [entityId]/[attributeId] pair.  May
  /// fall back to the [backingStore] if this store lacks such a mapping.
  /// Throws a [RangeError] when the given [attributeId] is invalid.
  T get(EntityId entityId, AttributeId attributeId) {
    validateAttributeId(attributeId, "Attribute ID");

    final valuesByAttributes = _values[entityId];

    if (valuesByAttributes == null) {
      return backingStore.get(entityId, attributeId);
    }

    if (!valuesByAttributes.containsKey(attributeId)) {
      return backingStore.get(entityId, attributeId);
    }

    return valuesByAttributes[attributeId] as T;
  }

  /// Sets of overwrites the [value] of the specified
  set(EntityId entityId, AttributeId attributeId, T value) {
    validateAttributeId(attributeId, "Attribute ID");

    final valuesByAttributes = _values[entityId];

    if (valuesByAttributes == null) {
      _values[entityId] = { attributeId: value };
    } else {
      valuesByAttributes[attributeId] = value;
    }
  }
}
