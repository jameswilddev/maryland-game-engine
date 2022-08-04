import 'package:maryland_game_engine/data/primitives/attribute_id.dart';

import '../../../primitives/entity_id.dart';
import 'flag_entity_attribute_value_store.dart';

/// An entity-attribute-value store which always returns a constant value of
/// [false].
class EmptyFlagEntityAttributeValueStore implements FlagEntityAttributeValueStore {
  /// Determines whether the flag specified by the given
  /// [entityId]/[attributeId] pair is set.  May return a default value, or one
  /// from a backing store.  Throws a [RangeError] when the given [attributeId]
  /// is invalid.
  @override
  bool get(EntityId entityId, AttributeId attributeId) {
    validateAttributeId(attributeId, "Attribute ID");

    return false;
  }
}