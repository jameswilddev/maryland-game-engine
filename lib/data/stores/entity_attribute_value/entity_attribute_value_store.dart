import 'package:maryland_game_engine/data/primitives/entity_id.dart';

import '../../primitives/attribute_id.dart';

/// An entity-attribute-value store.
abstract class EntityAttributeValueStore<T> {
  /// Retrieves the value of the specified [entityId]/[attributeId] pair.  May
  /// return a default value, or one from a backing store.  Throws a
  /// [RangeError] when the given [attributeId] is invalid.
  T get(EntityId entityId, AttributeId attributeId);
}
