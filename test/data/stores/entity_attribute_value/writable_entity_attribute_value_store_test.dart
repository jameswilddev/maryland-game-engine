import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/entity_id.dart';
import 'package:maryland_game_engine/data/stores/entity_attribute_value/entity_attribute_value_store.dart';
import 'package:maryland_game_engine/data/stores/entity_attribute_value/writable_entity_attribute_value_store.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([], customMocks: [MockSpec<EntityAttributeValueStore<String?>>(as: #EntityAttributeValueStoreMock)])
import 'writable_entity_attribute_value_store_test.mocks.dart';

void main() {
  test("exposes the backing store", () {
    final backingStore = EntityAttributeValueStoreMock();

    final store = WritableEntityAttributeValueStore(backingStore);

    expect(store.backingStore, equals(backingStore));
    verifyZeroInteractions(backingStore);
  });


  test("get throws an error when an invalid attribute is given", () {
    final backingStore = EntityAttributeValueStoreMock();
    final store = WritableEntityAttributeValueStore(backingStore);

    expect(
            () => store.get(EntityId.generate(), -1),
        throwsA((e) => e is RangeError && e.message == "Attribute ID - Value is out of range for an attribute ID (less than 0).")
    );
    verifyZeroInteractions(backingStore);
  });

  test("set throws an error when an invalid attribute is given", () {
    final backingStore = EntityAttributeValueStoreMock();
    final store = WritableEntityAttributeValueStore(backingStore);

    expect(
            () => store.set(EntityId.generate(), -1, "Test Value"),
        throwsA((e) => e is RangeError && e.message == "Attribute ID - Value is out of range for an attribute ID (less than 0).")
    );
    verifyZeroInteractions(backingStore);
  });


  test("allows retrieval of set values", () {
    final nonNullEntityId = EntityId.generate();
    const nonNullAttributeId = 1234;
    const nonNullValue = "Test Non-Null Value";
    final nullEntityId = EntityId.generate();
    const nullAttributeId = 9918;
    final doubleSetEntityId = EntityId.generate();
    const doubleSetAttributeId = 2242;
    const doubleSetFirstValue = "Test First Double-Set Value";
    const doubleSetSecondValue = "Test Second Double-Set Value";
    final alternativeEntityId = EntityId.generate();
    const alternativeAttributeId = 4493;
    const nullEntityAlternativeAttributeValue = "Test Null Entity Alternative Attribute Value";
    const alternativeEntityNullAttributeValue = "Test Alternative Entity Null Attribute Value";
    const nonNullEntityAlternativeAttributeValue = "Test Non Null Entity Alternative Attribute Value";
    const alternativeEntityNonNullAttributeValue = "Test Alternative Entity Non Null Attribute Value";
    const doubleSetEntityAlternativeAttributeValue = "Test Double-Set Entity Alternative Attribute Value";
    const alternativeEntityDoubleSetAttributeValue = "Test Alternative Entity Double-Set Attribute Value";
    final backingStore = EntityAttributeValueStoreMock();
    final store = WritableEntityAttributeValueStore(backingStore);
    when(backingStore.get(nullEntityId, alternativeAttributeId)).thenReturn(nullEntityAlternativeAttributeValue);
    when(backingStore.get(alternativeEntityId, nullAttributeId)).thenReturn(alternativeEntityNullAttributeValue);
    when(backingStore.get(nonNullEntityId, alternativeAttributeId)).thenReturn(nonNullEntityAlternativeAttributeValue);
    when(backingStore.get(alternativeEntityId, nonNullAttributeId)).thenReturn(alternativeEntityNonNullAttributeValue);
    when(backingStore.get(doubleSetEntityId, alternativeAttributeId)).thenReturn(doubleSetEntityAlternativeAttributeValue);
    when(backingStore.get(alternativeEntityId, doubleSetAttributeId)).thenReturn(alternativeEntityDoubleSetAttributeValue);
    store.set(doubleSetEntityId, doubleSetAttributeId, doubleSetFirstValue);
    store.set(nonNullEntityId, nonNullAttributeId, nonNullValue);
    store.set(doubleSetEntityId, doubleSetAttributeId, doubleSetSecondValue);
    store.set(nullEntityId, nullAttributeId, null);

    final retrievedNonNull = store.get(nonNullEntityId, nonNullAttributeId);
    final retrievedNonNullEntityAlternativeAttribute = store.get(nonNullEntityId, alternativeAttributeId);
    final retrievedAlternativeEntityNonNullAttribute = store.get(alternativeEntityId, nonNullAttributeId);
    final retrievedNull = store.get(nullEntityId, nullAttributeId);
    final retrievedNullEntityAlternativeAttribute = store.get(nullEntityId, alternativeAttributeId);
    final retrievedAlternativeEntityNullAttribute = store.get(alternativeEntityId, nullAttributeId);
    final retrievedDoubleSet = store.get(doubleSetEntityId, doubleSetAttributeId);
    final retrievedDoubleSetEntityAlternativeAttribute = store.get(doubleSetEntityId, alternativeAttributeId);
    final retrievedAlternativeEntityDoubleSetAttribute = store.get(alternativeEntityId, doubleSetAttributeId);

    expect(retrievedNonNull, equals(nonNullValue));
    expect(retrievedAlternativeEntityNonNullAttribute, equals(alternativeEntityNonNullAttributeValue));
    expect(retrievedNonNullEntityAlternativeAttribute, equals(nonNullEntityAlternativeAttributeValue));
    expect(retrievedNull, isNull);
    expect(retrievedAlternativeEntityNullAttribute, equals(alternativeEntityNullAttributeValue));
    expect(retrievedNullEntityAlternativeAttribute, equals(nullEntityAlternativeAttributeValue));
    expect(retrievedDoubleSet, equals(doubleSetSecondValue));
    expect(retrievedAlternativeEntityDoubleSetAttribute, equals(alternativeEntityDoubleSetAttributeValue));
    expect(retrievedDoubleSetEntityAlternativeAttribute, equals(doubleSetEntityAlternativeAttributeValue));
  });
}
