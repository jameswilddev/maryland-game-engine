import '../../primitives/attribute_id.dart';
import '../../primitives/entity_id.dart';

/// An entity-attribute-value store which always returns a constant value.
class EmptyEntityAttributeValueStore<T> {
  /// The constant value which is always returned.
  final T value;

  /// Creates a new entity-attribute-value store which always returns a constant
  /// [value].
  EmptyEntityAttributeValueStore(this.value);

  /// Retrieves the value of the specified [entityId]/[attributeId] pair,
  /// throwing an [ArgumentError] should the [attributeId] be invalid.  Throws a
  /// [RangeError] when the given [attributeId] is invalid.
  T get(EntityId entityId, AttributeId attributeId) {
    validateAttributeId(attributeId, "Attribute ID");

    return value;
  }
}