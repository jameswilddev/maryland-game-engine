import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/entity_id.dart';
import 'package:maryland_game_engine/data/stores/entity_attribute_value/flag/empty_flag_entity_attribute_value_store.dart';

void main() {
  group("get", () {
    test("returns false", () {
      final store = EmptyFlagEntityAttributeValueStore();

      final actual = store.get(EntityId.generate(), 1234);

      expect(actual, isFalse);
    });

    test("throws an error when an invalid attribute is given", () {
      final store = EmptyFlagEntityAttributeValueStore();

      expect(
        () => store.get(EntityId.generate(), -1),
        throwsA((e) => e is RangeError && e.message == "Attribute ID - Value is out of range for an attribute ID (less than 0).")
      );
    });
  });
}
