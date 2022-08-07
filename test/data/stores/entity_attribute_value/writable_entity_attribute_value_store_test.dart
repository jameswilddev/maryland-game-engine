import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/entity_id.dart';
import 'package:maryland_game_engine/data/stores/entity_attribute_value/entity_attribute_value_store.dart';
import 'package:maryland_game_engine/data/stores/entity_attribute_value/writable_entity_attribute_value_store.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Callbacks], customMocks: [
  MockSpec<EntityAttributeValueStore<String?>>(as: #EntityAttributeValueStoreMock),
  MockSpec<WritableEntityAttributeValueStore<String?>>(as: #WritableEntityAttributeValueStoreMock),
])
import 'writable_entity_attribute_value_store_test.mocks.dart';

abstract class Callbacks {
  void valueValidator(String? value, String description);
}

void main() {
  test("exposes the backing store and value validator", () {
    final callbacks = MockCallbacks();
    final backingStore = EntityAttributeValueStoreMock();

    final store = WritableEntityAttributeValueStore(backingStore, callbacks.valueValidator);

    expect(store.backingStore, equals(backingStore));
    expect(store.valueValidator, equals(callbacks.valueValidator));
    verifyZeroInteractions(callbacks);
    verifyZeroInteractions(backingStore);
  });

  test("get throws an error when an invalid attribute is given", () {
    final callbacks = MockCallbacks();
    final backingStore = EntityAttributeValueStoreMock();
    final store = WritableEntityAttributeValueStore(backingStore, callbacks.valueValidator);

    expect(
            () => store.get(EntityId.generate(), -1),
        throwsA((e) => e is RangeError && e.message == "Attribute ID - Value is out of range for an attribute ID (less than 0).")
    );
    verifyZeroInteractions(callbacks);
    verifyZeroInteractions(backingStore);
  });

  test("set throws an error when an invalid attribute is given", () {
    final callbacks = MockCallbacks();
    final backingStore = EntityAttributeValueStoreMock();
    final store = WritableEntityAttributeValueStore(backingStore, callbacks.valueValidator);

    expect(
            () => store.set(EntityId.generate(), -1, "Test Value"),
        throwsA((e) => e is RangeError && e.message == "Attribute ID - Value is out of range for an attribute ID (less than 0).")
    );
    verifyZeroInteractions(callbacks);
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
    final callbacks = MockCallbacks();
    final backingStore = EntityAttributeValueStoreMock();
    final store = WritableEntityAttributeValueStore(backingStore, callbacks.valueValidator);
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
    verify(callbacks.valueValidator(doubleSetFirstValue, "Value")).called(1);
    verify(callbacks.valueValidator(nonNullValue, "Value")).called(1);
    verify(callbacks.valueValidator(doubleSetSecondValue, "Value")).called(1);
    verify(callbacks.valueValidator(null, "Value")).called(1);
    verifyNoMoreInteractions(callbacks);
    verify(backingStore.get(nullEntityId, alternativeAttributeId)).called(1);
    verify(backingStore.get(alternativeEntityId, nullAttributeId)).called(1);
    verify(backingStore.get(nonNullEntityId, alternativeAttributeId)).called(1);
    verify(backingStore.get(alternativeEntityId, nonNullAttributeId)).called(1);
    verify(backingStore.get(doubleSetEntityId, alternativeAttributeId)).called(1);
    verify(backingStore.get(alternativeEntityId, doubleSetAttributeId)).called(1);
    verifyNoMoreInteractions(backingStore);
  });

  group("moveTo", () {
    test("applies changes", () {
      final nonNullEntityId = EntityId.generate();
      const nonNullAttributeId = 1234;
      const nonNullValue = "Test Non-Null Value";
      final nullEntityId = EntityId.generate();
      const nullAttributeId = 9918;
      final doubleSetEntityId = EntityId.generate();
      const doubleSetAttributeId = 2242;
      const doubleSetFirstValue = "Test First Double-Set Value";
      const doubleSetSecondValue = "Test Second Double-Set Value";
      final callbacks = MockCallbacks();
      final backingStore = EntityAttributeValueStoreMock();
      final store = WritableEntityAttributeValueStore(backingStore, callbacks.valueValidator);
      store.set(doubleSetEntityId, doubleSetAttributeId, doubleSetFirstValue);
      store.set(nonNullEntityId, nonNullAttributeId, nonNullValue);
      store.set(doubleSetEntityId, doubleSetAttributeId, doubleSetSecondValue);
      store.set(nullEntityId, nullAttributeId, null);
      final target = WritableEntityAttributeValueStoreMock();
      when(target.set(doubleSetEntityId, doubleSetAttributeId, doubleSetSecondValue)).thenReturn(null);
      when(target.set(nonNullEntityId, nonNullAttributeId, nonNullValue))
          .thenReturn(null);
      when(target.set(nullEntityId, nullAttributeId, null)).thenReturn(null);

      store.moveTo(target);

      verify(callbacks.valueValidator(doubleSetFirstValue, "Value")).called(1);
      verify(callbacks.valueValidator(nonNullValue, "Value")).called(1);
      verify(callbacks.valueValidator(doubleSetSecondValue, "Value")).called(1);
      verify(callbacks.valueValidator(null, "Value")).called(1);
      verifyNoMoreInteractions(callbacks);
      verifyNoMoreInteractions(backingStore);
      verify(target.set(
          doubleSetEntityId, doubleSetAttributeId, doubleSetSecondValue))
          .called(1);
      verify(target.set(nonNullEntityId, nonNullAttributeId, nonNullValue))
          .called(1);
      verify(target.set(nullEntityId, nullAttributeId, null)).called(1);
      verifyNoMoreInteractions(target);
    });

    test("resets", () {
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
      const nonNullEntityNonNullAttributeValue = "Test Non-Null Entity Non-Null Attribute Value";
      const nullEntityNullAttributeValue = "Test Null Entity Null Attribute Value";
      const doubleSetEntityDoubleSetAttributeValue = "Test Double-Set Entity Double-Set Attribute Value";
      const nullEntityAlternativeAttributeValue = "Test Null Entity Alternative Attribute Value";
      const alternativeEntityNullAttributeValue = "Test Alternative Entity Null Attribute Value";
      const nonNullEntityAlternativeAttributeValue = "Test Non Null Entity Alternative Attribute Value";
      const alternativeEntityNonNullAttributeValue = "Test Alternative Entity Non Null Attribute Value";
      const doubleSetEntityAlternativeAttributeValue = "Test Double-Set Entity Alternative Attribute Value";
      const alternativeEntityDoubleSetAttributeValue = "Test Alternative Entity Double-Set Attribute Value";
      final callbacks = MockCallbacks();
      final backingStore = EntityAttributeValueStoreMock();
      final store = WritableEntityAttributeValueStore(backingStore, callbacks.valueValidator);
      when(backingStore.get(nullEntityId, nullAttributeId)).thenReturn(nullEntityNullAttributeValue);
      when(backingStore.get(nonNullEntityId, nonNullAttributeId)).thenReturn(nonNullEntityNonNullAttributeValue);
      when(backingStore.get(doubleSetEntityId, doubleSetAttributeId)).thenReturn(doubleSetEntityDoubleSetAttributeValue);
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
      final target = WritableEntityAttributeValueStoreMock();
      when(target.set(doubleSetEntityId, doubleSetAttributeId, doubleSetSecondValue)).thenReturn(null);
      when(target.set(nonNullEntityId, nonNullAttributeId, nonNullValue))
          .thenReturn(null);
      when(target.set(nullEntityId, nullAttributeId, null)).thenReturn(null);

      store.moveTo(target);

      final retrievedNonNull = store.get(nonNullEntityId, nonNullAttributeId);
      final retrievedNonNullEntityAlternativeAttribute = store.get(nonNullEntityId, alternativeAttributeId);
      final retrievedAlternativeEntityNonNullAttribute = store.get(alternativeEntityId, nonNullAttributeId);
      final retrievedNull = store.get(nullEntityId, nullAttributeId);
      final retrievedNullEntityAlternativeAttribute = store.get(nullEntityId, alternativeAttributeId);
      final retrievedAlternativeEntityNullAttribute = store.get(alternativeEntityId, nullAttributeId);
      final retrievedDoubleSet = store.get(doubleSetEntityId, doubleSetAttributeId);
      final retrievedDoubleSetEntityAlternativeAttribute = store.get(doubleSetEntityId, alternativeAttributeId);
      final retrievedAlternativeEntityDoubleSetAttribute = store.get(alternativeEntityId, doubleSetAttributeId);
      expect(retrievedNonNull, equals(nonNullEntityNonNullAttributeValue));
      expect(retrievedAlternativeEntityNonNullAttribute, equals(alternativeEntityNonNullAttributeValue));
      expect(retrievedNonNullEntityAlternativeAttribute, equals(nonNullEntityAlternativeAttributeValue));
      expect(retrievedNull, equals(nullEntityNullAttributeValue));
      expect(retrievedAlternativeEntityNullAttribute, equals(alternativeEntityNullAttributeValue));
      expect(retrievedNullEntityAlternativeAttribute, equals(nullEntityAlternativeAttributeValue));
      expect(retrievedDoubleSet, equals(doubleSetEntityDoubleSetAttributeValue));
      expect(retrievedAlternativeEntityDoubleSetAttribute, equals(alternativeEntityDoubleSetAttributeValue));
      expect(retrievedDoubleSetEntityAlternativeAttribute, equals(doubleSetEntityAlternativeAttributeValue));
      verify(callbacks.valueValidator(doubleSetFirstValue, "Value")).called(1);
      verify(callbacks.valueValidator(nonNullValue, "Value")).called(1);
      verify(callbacks.valueValidator(doubleSetSecondValue, "Value")).called(1);
      verify(callbacks.valueValidator(null, "Value")).called(1);
      verifyNoMoreInteractions(callbacks);
      verify(backingStore.get(nonNullEntityId, nonNullAttributeId)).called(1);
      verify(backingStore.get(nullEntityId, nullAttributeId)).called(1);
      verify(backingStore.get(doubleSetEntityId, doubleSetAttributeId)).called(1);
      verify(backingStore.get(nullEntityId, alternativeAttributeId)).called(1);
      verify(backingStore.get(alternativeEntityId, nullAttributeId)).called(1);
      verify(backingStore.get(nonNullEntityId, alternativeAttributeId)).called(1);
      verify(backingStore.get(alternativeEntityId, nonNullAttributeId)).called(1);
      verify(backingStore.get(doubleSetEntityId, alternativeAttributeId)).called(1);
      verify(backingStore.get(alternativeEntityId, doubleSetAttributeId)).called(1);
      verifyNoMoreInteractions(backingStore);
    });
  });
}

