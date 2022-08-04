import 'package:maryland_game_engine/data/primitives/entity_id.dart';

import '../../../primitives/attribute_id.dart';

/// An entity-attribute-value store of flags.
abstract class FlagEntityAttributeValueStore {
  /// Determines whether the flag specified by the given
  /// [entityId]/[attributeId] pair is set.  May return a default value, or one
  /// from a backing store.  Throws a [RangeError] when the given [attributeId]
  /// is invalid.
  bool get(EntityId entityId, AttributeId attributeId);
}
