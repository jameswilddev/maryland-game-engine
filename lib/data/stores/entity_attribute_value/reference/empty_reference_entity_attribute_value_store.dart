import 'package:maryland_game_engine/data/primitives/attribute_id.dart';
import 'package:maryland_game_engine/data/stores/entity_attribute_value/reference/reference_entity_attribute_value_store.dart';

import '../../../primitives/entity_id.dart';

/// An entity-attribute-value store which always returns a constant value.
class EmptyReferenceEntityAttributeValueStore implements ReferenceEntityAttributeValueStore {
  /// Retrieves the value of the specified [entityId]/[attributeId] pair,
  /// throwing an [ArgumentError] should the [attributeId] be invalid.  Throws a
  /// [RangeError] when the given [attributeId] is invalid.
  @override
  EntityId get(EntityId entityId, AttributeId attributeId) {
    validateAttributeId(attributeId, "Attribute ID");

    return EntityId.zero;
  }

  /// Lists all [EntityId]s which refer to a given [entityId] using a specified
  /// [attributeId].  Throws a [RangeError] when the given [attributeId] is
  /// invalid.
  @override
  Iterable<EntityId> listReferencingEntities(AttributeId attributeId, EntityId entityId) sync* {
    validateAttributeId(attributeId, "Attribute ID");
  }
}