import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/entity_id.dart';
import 'package:maryland_game_engine/data/stores/entity_attribute_value/reference/empty_reference_entity_attribute_value_store.dart';

void main() {
  group("get", () {
    test("returns a zero entity ID", () {
      final store = EmptyReferenceEntityAttributeValueStore();

      final actual = store.get(EntityId.generate(), 1234);

      expect(actual, equals(EntityId.zero));
    });

    test("throws an error when an invalid attribute is given", () {
      final store = EmptyReferenceEntityAttributeValueStore();

      expect(
        () => store.get(EntityId.generate(), -1),
        throwsA((e) => e is RangeError && e.message == "Attribute ID - Value is out of range for an attribute ID (less than 0).")
      );
    });
  });

  group("listReferencingEntities", () {
    test("returns an empty iterable", () {
      final store = EmptyReferenceEntityAttributeValueStore();

      final actual = store.listReferencingEntities(1234, EntityId.generate());

      expect(actual, isEmpty);
    });

    test("throws an error when an invalid attribute is given", () {
      final store = EmptyReferenceEntityAttributeValueStore();

      expect(
              () => store.listReferencingEntities(-1, EntityId.generate()),
          throwsA((e) => e is RangeError && e.message == "Attribute ID - Value is out of range for an attribute ID (less than 0).")
      );
    });
  });
}
