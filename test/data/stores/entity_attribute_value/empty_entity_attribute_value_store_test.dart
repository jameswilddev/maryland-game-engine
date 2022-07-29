import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/entity_id.dart';
import 'package:maryland_game_engine/data/stores/entity_attribute_value/empty_entity_attribute_value_store.dart';

void main() {
  test("exposes the value", () {
    const value = "test value";

    final store = EmptyEntityAttributeValueStore(value);

    expect(store.value, equals(value));
  });

  group("get", () {
    test("returns the value", () {
      const value = "test value";
      final store = EmptyEntityAttributeValueStore(value);

      final actual = store.get(EntityId.generate(), 1234);

      expect(actual, equals(value));
    });

    test("throws an error when an invalid attribute is given", () {
      const value = "test value";
      final store = EmptyEntityAttributeValueStore(value);

      expect(
        () => store.get(EntityId.generate(), -1),
        throwsA((e) => e is RangeError && e.message == "Attribute ID - Value is out of range for an attribute ID (less than 0).")
      );
    });
  });
}
