import 'package:maryland_game_engine/data/stores/entity_attribute_value/reference/reference_entity_attribute_value_store.dart';

import '../../../primitives/attribute_id.dart';
import '../../../primitives/entity_id.dart';

/// An entity-attribute-value reference store which can be written to.
class WritableReferenceEntityAttributeValueStore implements ReferenceEntityAttributeValueStore {
  /// The store which is read from when this store lacks a mapping.
  final ReferenceEntityAttributeValueStore backingStore;

  final Map<EntityId, Map<AttributeId, EntityId>> _forward = <EntityId, Map<AttributeId, EntityId>>{};
  final Map<AttributeId, Map<EntityId, Set<EntityId>>> _inverse = <AttributeId, Map<EntityId, Set<EntityId>>>{};

  /// Creates a new entity-attribute-value reference store which can be written
  /// to, with a given [backingStore] to be used when no match can be found
  /// during a lookup.
  WritableReferenceEntityAttributeValueStore(this.backingStore);

  /// Retrieves the value of the specified [entityId]/[attributeId] pair.  May
  /// fall back to the [backingStore] if this store lacks such a mapping.
  /// Throws a [RangeError] when the given [attributeId] is invalid.
  @override
  EntityId get(EntityId entityId, AttributeId attributeId) {
    validateAttributeId(attributeId, "Attribute ID");

    return _get(entityId, attributeId) ?? backingStore.get(entityId, attributeId);
  }

  EntityId? _get(EntityId entityId, AttributeId attributeId) {
    final valuesByAttributes = _forward[entityId];

    if (valuesByAttributes == null) {
      return null;
    }

    final output = valuesByAttributes[attributeId];

    if (output == null) {
      return null;
    }

    return output;
  }

  /// Lists all [EntityId]s which refer to a given [entityId] using a specified
  /// [attributeId].  Throws a [RangeError] when the given [attributeId] is
  /// invalid.
  @override
  Iterable<EntityId> listReferencingEntities(AttributeId attributeId, EntityId entityId) sync* {
    validateAttributeId(attributeId, "Attribute ID");

    final referencingEntityIdsByEntityIds = _inverse[attributeId];

    if (referencingEntityIdsByEntityIds == null) {
      for (final referencingEntityId in backingStore.listReferencingEntities(attributeId, entityId)) {
        if (_get(referencingEntityId, attributeId) == null) {
          yield referencingEntityId;
        }
      }

      return;
    }

    final referencingEntityIds = referencingEntityIdsByEntityIds[entityId];

    if (referencingEntityIds == null) {
      for (final referencingEntityId in backingStore.listReferencingEntities(attributeId, entityId)) {
        if (_get(referencingEntityId, attributeId) == null) {
          yield referencingEntityId;
        }
      }

      return;
    }

    yield* referencingEntityIds;

    for (final referencingEntityId in backingStore.listReferencingEntities(attributeId, entityId)) {
      if (! referencingEntityIds.contains(referencingEntityId)) {
        if (_get(referencingEntityId, attributeId) == null) {
          yield referencingEntityId;
        }
      }
    }
  }

  /// Sets of overwrites the [value] of the specified
  set(EntityId entityId, AttributeId attributeId, EntityId value) {
    validateAttributeId(attributeId, "Attribute ID");

    final valuesByAttributes = _forward[entityId];

    if (valuesByAttributes == null) {
      _forward[entityId] = { attributeId: value };
    } else {
      final existingValue = valuesByAttributes[attributeId];

      if (existingValue == value) {
        return;
      }

      valuesByAttributes[attributeId] = value;

      if (existingValue != null) {
        var entitiesByEntities = _inverse[attributeId]!;
        var entities = entitiesByEntities[existingValue]!;

        if (entities.length == 1) {
         entitiesByEntities.remove(existingValue);
        } else {
         entities.remove(entityId);
        }
      }
    }

    var entitiesByEntities = _inverse[attributeId];

    if (entitiesByEntities == null) {
      entitiesByEntities = {};
      _inverse[attributeId] = entitiesByEntities;
    }

    var entities = entitiesByEntities[value];

    if (entities == null) {
      entities = <EntityId>{};
      entitiesByEntities[value] = entities;
    }

    entities.add(entityId);
  }

  /// Applies all entity-attribute-values within this store to a given [store],
  /// then clears this store.
  moveTo(WritableReferenceEntityAttributeValueStore store) {
    for (final entityAttributeValue in _forward.entries) {
      final entityId = entityAttributeValue.key;

      for (final attributeValue in entityAttributeValue.value.entries) {
        final attributeId = attributeValue.key;
        final value = attributeValue.value;

        store.set(entityId, attributeId, value);
      }
    }

    _forward.clear();
    _inverse.clear();
  }
}
