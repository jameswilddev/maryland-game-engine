import 'package:maryland_game_engine/data/primitives/entity_id.dart';
import 'package:maryland_game_engine/data/stores/entity_attribute_value/entity_attribute_value_store.dart';

import '../../../primitives/attribute_id.dart';

/// An entity-attribute-value store of references to entities.
abstract class ReferenceEntityAttributeValueStore extends EntityAttributeValueStore<EntityId> {
  /// Lists all [EntityId]s which refer to a given [entityId] using a specified
  /// [attributeId].  Throws a [RangeError] when the given [attributeId] is
  /// invalid.
  Iterable<EntityId> listReferencingEntities(AttributeId attributeId, EntityId entityId);
}
