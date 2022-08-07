import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/entity_id.dart';
import 'package:maryland_game_engine/data/primitives/opcode.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';
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
  Iterable<U8> valueSerializer(String? value, String description);
}

void main() {
  test("exposes the backing store, value validator, value serializer and opcode", () {
    final callbacks = MockCallbacks();
    final backingStore = EntityAttributeValueStoreMock();

    final store = WritableEntityAttributeValueStore(backingStore, callbacks.valueValidator, callbacks.valueSerializer, Opcode.setEntityAttributeS32);

    expect(store.backingStore, equals(backingStore));
    expect(store.valueValidator, equals(callbacks.valueValidator));
    expect(store.valueSerializer, equals(callbacks.valueSerializer));
    expect(store.opcode, equals(Opcode.setEntityAttributeS32));
    verifyZeroInteractions(callbacks);
    verifyZeroInteractions(backingStore);
  });

  test("get throws an error when an invalid attribute is given", () {
    final callbacks = MockCallbacks();
    final backingStore = EntityAttributeValueStoreMock();
    final store = WritableEntityAttributeValueStore(backingStore, callbacks.valueValidator, callbacks.valueSerializer, Opcode.setEntityAttributeS32);

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
    final store = WritableEntityAttributeValueStore(backingStore, callbacks.valueValidator, callbacks.valueSerializer, Opcode.setEntityAttributeS32);

    expect(
            () => store.set(EntityId.generate(), -1, "Test Value"),
        throwsA((e) => e is RangeError && e.message == "Attribute ID - Value is out of range for an attribute ID (less than 0).")
    );
    verifyZeroInteractions(callbacks);
    verifyZeroInteractions(backingStore);
  });

  test("allows retrieval of set values", () async {
    final nonNullEntityId = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xe8, 0x93, 0xda, 0x46, 0x99, 0x1b, 0xfd, 0xa3, 0x0b, 0x4b, 0xe9, 0xa8, 0xac, 0x35, 0xcf, 0x46])), "Example Description");
    const nonNullAttributeAId = 2582716958;
    const nonNullAttributeBId = 2342776370;
    const nonNullAttributeCId = 71725933;
    const nonNullValueA = "Test Non-Null Value A";
    const nonNullValueB = "Test Non-Null Value B";
    const nonNullValueC = "Test Non-Null Value C";
    final nullEntityId = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xe4, 0x6d, 0xe4, 0x12, 0xb8, 0x2f, 0xa1, 0x47, 0x1a, 0xc2, 0x82, 0x25, 0xe5, 0x2e, 0x88, 0x41])), "Example Description");
    const nullAttributeId = 3483855217;
    final doubleSetEntityId = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xf1, 0x6b, 0x79, 0x02, 0x44, 0xa1, 0x0d, 0xb2, 0xf9, 0x70, 0xb7, 0xfc, 0xa0, 0x8c, 0x56, 0x3a])), "Example Description");
    const doubleSetAttributeId = 3328368612;
    const doubleSetFirstValue = "Test First Double-Set Value";
    const doubleSetSecondValue = "Test Second Double-Set Value";
    final alternativeEntityId = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0x63, 0x91, 0xbc, 0x93, 0x8c, 0xa7, 0xe7, 0xa9, 0x3c, 0x1a, 0xf6, 0x62, 0x38, 0xd8, 0xf1, 0x5a, 0xb6, 0xba, 0xc5, 0x9f, 0xf9, 0x9a, 0x2e, 0x57, 0x11, 0xd7, 0x4b, 0xf4, 0x5c, 0x5d, 0xcc, 0xe1])), "Example Description");
    const alternativeAttributeId = 816065248;
    const nullEntityAlternativeAttributeValue = "Test Null Entity Alternative Attribute Value";
    const alternativeEntityNullAttributeValue = "Test Alternative Entity Null Attribute Value";
    const nonNullEntityAlternativeAttributeValue = "Test Non Null Entity Alternative Attribute Value";
    const alternativeEntityNonNullAttributeValue = "Test Alternative Entity Non Null Attribute Value";
    const doubleSetEntityAlternativeAttributeValue = "Test Double-Set Entity Alternative Attribute Value";
    const alternativeEntityDoubleSetAttributeValue = "Test Alternative Entity Double-Set Attribute Value";
    final callbacks = MockCallbacks();
    final backingStore = EntityAttributeValueStoreMock();
    final store = WritableEntityAttributeValueStore(backingStore, callbacks.valueValidator, callbacks.valueSerializer, Opcode.setEntityAttributeS32);
    when(callbacks.valueSerializer(nonNullValueA, "Value")).thenReturn([0x7e, 0xac, 0x80, 0x04, 0x19, 0x9d]);
    when(callbacks.valueSerializer(nonNullValueB, "Value")).thenReturn([0x55, 0x45]);
    when(callbacks.valueSerializer(nonNullValueC, "Value")).thenReturn([0x30, 0xd8, 0x66, 0x92, 0x1a]);
    when(callbacks.valueSerializer(doubleSetSecondValue, "Value")).thenReturn([0x19, 0x8b, 0x3b, 0x85]);
    when(callbacks.valueSerializer(null, "Value")).thenReturn([0x6f, 0x91, 0xdf]);
    when(backingStore.get(nullEntityId, alternativeAttributeId)).thenReturn(nullEntityAlternativeAttributeValue);
    when(backingStore.get(alternativeEntityId, nullAttributeId)).thenReturn(alternativeEntityNullAttributeValue);
    when(backingStore.get(nonNullEntityId, alternativeAttributeId)).thenReturn(nonNullEntityAlternativeAttributeValue);
    when(backingStore.get(alternativeEntityId, nonNullAttributeAId)).thenReturn(alternativeEntityNonNullAttributeValue);
    when(backingStore.get(doubleSetEntityId, alternativeAttributeId)).thenReturn(doubleSetEntityAlternativeAttributeValue);
    when(backingStore.get(alternativeEntityId, doubleSetAttributeId)).thenReturn(alternativeEntityDoubleSetAttributeValue);
    store.set(doubleSetEntityId, doubleSetAttributeId, doubleSetFirstValue);
    store.set(nonNullEntityId, nonNullAttributeAId, nonNullValueA);
    store.set(doubleSetEntityId, doubleSetAttributeId, doubleSetSecondValue);
    store.set(nonNullEntityId, nonNullAttributeBId, nonNullValueB);
    store.set(nullEntityId, nullAttributeId, null);
    store.set(nonNullEntityId, nonNullAttributeCId, nonNullValueC);

    final retrievedNonNullA = store.get(nonNullEntityId, nonNullAttributeAId);
    final retrievedNonNullB = store.get(nonNullEntityId, nonNullAttributeBId);
    final retrievedNonNullC = store.get(nonNullEntityId, nonNullAttributeCId);
    final retrievedNonNullEntityAlternativeAttribute = store.get(nonNullEntityId, alternativeAttributeId);
    final retrievedAlternativeEntityNonNullAttribute = store.get(alternativeEntityId, nonNullAttributeAId);
    final retrievedNull = store.get(nullEntityId, nullAttributeId);
    final retrievedNullEntityAlternativeAttribute = store.get(nullEntityId, alternativeAttributeId);
    final retrievedAlternativeEntityNullAttribute = store.get(alternativeEntityId, nullAttributeId);
    final retrievedDoubleSet = store.get(doubleSetEntityId, doubleSetAttributeId);
    final retrievedDoubleSetEntityAlternativeAttribute = store.get(doubleSetEntityId, alternativeAttributeId);
    final retrievedAlternativeEntityDoubleSetAttribute = store.get(alternativeEntityId, doubleSetAttributeId);
    final serialized = store.serialize().toList();

    expect(retrievedNonNullA, equals(nonNullValueA));
    expect(retrievedNonNullB, equals(nonNullValueB));
    expect(retrievedNonNullC, equals(nonNullValueC));
    expect(retrievedAlternativeEntityNonNullAttribute, equals(alternativeEntityNonNullAttributeValue));
    expect(retrievedNonNullEntityAlternativeAttribute, equals(nonNullEntityAlternativeAttributeValue));
    expect(retrievedNull, isNull);
    expect(retrievedAlternativeEntityNullAttribute, equals(alternativeEntityNullAttributeValue));
    expect(retrievedNullEntityAlternativeAttribute, equals(nullEntityAlternativeAttributeValue));
    expect(retrievedDoubleSet, equals(doubleSetSecondValue));
    expect(retrievedAlternativeEntityDoubleSetAttribute, equals(alternativeEntityDoubleSetAttributeValue));
    expect(retrievedDoubleSetEntityAlternativeAttribute, equals(doubleSetEntityAlternativeAttributeValue));
    expect(serialized, orderedEquals([
      5,
      0xe4, 0x6d, 0xe4, 0x12, 0xb8, 0x2f, 0xa1, 0x47, 0x1a, 0xc2, 0x82, 0x25, 0xe5, 0x2e, 0x88, 0x41,
      0xcf, 0xa7, 0x69, 0x71,
      0x6f, 0x91, 0xdf,

      5,
      0xe8, 0x93, 0xda, 0x46, 0x99, 0x1b, 0xfd, 0xa3, 0x0b, 0x4b, 0xe9, 0xa8, 0xac, 0x35, 0xcf, 0x46,
      0x04, 0x46, 0x73, 0x6D,
      0x30, 0xd8, 0x66, 0x92, 0x1a,

      5,
      0xe8, 0x93, 0xda, 0x46, 0x99, 0x1b, 0xfd, 0xa3, 0x0b, 0x4b, 0xe9, 0xa8, 0xac, 0x35, 0xcf, 0x46,
      0x8b, 0xa3, 0xee, 0x32,
      0x55, 0x45,

      5,
      0xe8, 0x93, 0xda, 0x46, 0x99, 0x1b, 0xfd, 0xa3, 0x0b, 0x4b, 0xe9, 0xa8, 0xac, 0x35, 0xcf, 0x46,
      0x99, 0xf1, 0x22, 0x1e,
      0x7e, 0xac, 0x80, 0x04, 0x19, 0x9d,

      5,
      0xf1, 0x6b, 0x79, 0x02, 0x44, 0xa1, 0x0d, 0xb2, 0xf9, 0x70, 0xb7, 0xfc, 0xa0, 0x8c, 0x56, 0x3a,
      0xc6, 0x62, 0xdf, 0xe4,
      0x19, 0x8b, 0x3b, 0x85,
    ]));
    verify(callbacks.valueValidator(doubleSetFirstValue, "Value")).called(1);
    verify(callbacks.valueValidator(nonNullValueA, "Value")).called(1);
    verify(callbacks.valueValidator(nonNullValueB, "Value")).called(1);
    verify(callbacks.valueValidator(nonNullValueC, "Value")).called(1);
    verify(callbacks.valueValidator(doubleSetSecondValue, "Value")).called(1);
    verify(callbacks.valueValidator(null, "Value")).called(1);
    verify(callbacks.valueSerializer(nonNullValueA, "Value")).called(1);
    verify(callbacks.valueSerializer(nonNullValueB, "Value")).called(1);
    verify(callbacks.valueSerializer(nonNullValueC, "Value")).called(1);
    verify(callbacks.valueSerializer(doubleSetSecondValue, "Value")).called(1);
    verify(callbacks.valueSerializer(null, "Value")).called(1);
    verifyNoMoreInteractions(callbacks);
    verify(backingStore.get(nullEntityId, alternativeAttributeId)).called(1);
    verify(backingStore.get(alternativeEntityId, nullAttributeId)).called(1);
    verify(backingStore.get(nonNullEntityId, alternativeAttributeId)).called(1);
    verify(backingStore.get(alternativeEntityId, nonNullAttributeAId)).called(1);
    verify(backingStore.get(doubleSetEntityId, alternativeAttributeId)).called(1);
    verify(backingStore.get(alternativeEntityId, doubleSetAttributeId)).called(1);
    verifyNoMoreInteractions(backingStore);
  });

  group("moveTo", () {
    test("applies changes", () async {
      final nonNullEntityId = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xe8, 0x93, 0xda, 0x46, 0x99, 0x1b, 0xfd, 0xa3, 0x0b, 0x4b, 0xe9, 0xa8, 0xac, 0x35, 0xcf, 0x46])), "Example Description");
      const nonNullAttributeAId = 2582716958;
      const nonNullAttributeBId = 2342776370;
      const nonNullAttributeCId = 71725933;
      const nonNullValueA = "Test Non-Null Value A";
      const nonNullValueB = "Test Non-Null Value B";
      const nonNullValueC = "Test Non-Null Value C";
      final nullEntityId = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xe4, 0x6d, 0xe4, 0x12, 0xb8, 0x2f, 0xa1, 0x47, 0x1a, 0xc2, 0x82, 0x25, 0xe5, 0x2e, 0x88, 0x41])), "Example Description");
      const nullAttributeId = 3483855217;
      final doubleSetEntityId = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xf1, 0x6b, 0x79, 0x02, 0x44, 0xa1, 0x0d, 0xb2, 0xf9, 0x70, 0xb7, 0xfc, 0xa0, 0x8c, 0x56, 0x3a])), "Example Description");
      const doubleSetAttributeId = 3328368612;
      const doubleSetFirstValue = "Test First Double-Set Value";
      const doubleSetSecondValue = "Test Second Double-Set Value";
      final callbacks = MockCallbacks();
      final backingStore = EntityAttributeValueStoreMock();
      final store = WritableEntityAttributeValueStore(backingStore, callbacks.valueValidator, callbacks.valueSerializer, Opcode.setEntityAttributeS32);
      store.set(doubleSetEntityId, doubleSetAttributeId, doubleSetFirstValue);
      store.set(nonNullEntityId, nonNullAttributeAId, nonNullValueA);
      store.set(doubleSetEntityId, doubleSetAttributeId, doubleSetSecondValue);
      store.set(nonNullEntityId, nonNullAttributeBId, nonNullValueB);
      store.set(nullEntityId, nullAttributeId, null);
      store.set(nonNullEntityId, nonNullAttributeCId, nonNullValueC);
      final target = WritableEntityAttributeValueStoreMock();
      when(target.set(doubleSetEntityId, doubleSetAttributeId, doubleSetSecondValue)).thenReturn(null);
      when(target.set(nonNullEntityId, nonNullAttributeAId, nonNullValueA)).thenReturn(null);
      when(target.set(nonNullEntityId, nonNullAttributeBId, nonNullValueB)).thenReturn(null);
      when(target.set(nonNullEntityId, nonNullAttributeCId, nonNullValueC)).thenReturn(null);
      when(target.set(nullEntityId, nullAttributeId, null)).thenReturn(null);

      store.moveTo(target);

      verify(callbacks.valueValidator(doubleSetFirstValue, "Value")).called(1);
      verify(callbacks.valueValidator(nonNullValueA, "Value")).called(1);
      verify(callbacks.valueValidator(nonNullValueB, "Value")).called(1);
      verify(callbacks.valueValidator(nonNullValueC, "Value")).called(1);
      verify(callbacks.valueValidator(doubleSetSecondValue, "Value")).called(1);
      verify(callbacks.valueValidator(null, "Value")).called(1);
      verifyNoMoreInteractions(callbacks);
      verifyNoMoreInteractions(backingStore);
      verify(target.set(
          doubleSetEntityId, doubleSetAttributeId, doubleSetSecondValue))
          .called(1);
      verify(target.set(nonNullEntityId, nonNullAttributeAId, nonNullValueA)).called(1);
      verify(target.set(nonNullEntityId, nonNullAttributeBId, nonNullValueB)).called(1);
      verify(target.set(nonNullEntityId, nonNullAttributeCId, nonNullValueC)).called(1);
      verify(target.set(nullEntityId, nullAttributeId, null)).called(1);
      verifyNoMoreInteractions(target);
    });

    test("resets", () async {
      final nonNullEntityId = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xe8, 0x93, 0xda, 0x46, 0x99, 0x1b, 0xfd, 0xa3, 0x0b, 0x4b, 0xe9, 0xa8, 0xac, 0x35, 0xcf, 0x46])), "Example Description");
      const nonNullAttributeAId = 2582716958;
      const nonNullAttributeBId = 2342776370;
      const nonNullAttributeCId = 71725933;
      const nonNullValueA = "Test Non-Null Value A";
      const nonNullValueB = "Test Non-Null Value B";
      const nonNullValueC = "Test Non-Null Value C";
      final nullEntityId = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xe4, 0x6d, 0xe4, 0x12, 0xb8, 0x2f, 0xa1, 0x47, 0x1a, 0xc2, 0x82, 0x25, 0xe5, 0x2e, 0x88, 0x41])), "Example Description");
      const nullAttributeId = 3483855217;
      final doubleSetEntityId = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xf1, 0x6b, 0x79, 0x02, 0x44, 0xa1, 0x0d, 0xb2, 0xf9, 0x70, 0xb7, 0xfc, 0xa0, 0x8c, 0x56, 0x3a])), "Example Description");
      const doubleSetAttributeId = 3328368612;
      const doubleSetFirstValue = "Test First Double-Set Value";
      const doubleSetSecondValue = "Test Second Double-Set Value";
      final alternativeEntityId = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0x63, 0x91, 0xbc, 0x93, 0x8c, 0xa7, 0xe7, 0xa9, 0x3c, 0x1a, 0xf6, 0x62, 0x38, 0xd8, 0xf1, 0x5a, 0xb6, 0xba, 0xc5, 0x9f, 0xf9, 0x9a, 0x2e, 0x57, 0x11, 0xd7, 0x4b, 0xf4, 0x5c, 0x5d, 0xcc, 0xe1])), "Example Description");
      const alternativeAttributeId = 816065248;
      const nonNullEntityNonNullAttributeAValue = "Test Non-Null Entity Non-Null Attribute A Value";
      const nonNullEntityNonNullAttributeBValue = "Test Non-Null Entity Non-Null Attribute B Value";
      const nonNullEntityNonNullAttributeCValue = "Test Non-Null Entity Non-Null Attribute C Value";
      const nullEntityNullAttributeValue = "Test Null Entity Null Attribute Value";
      const doubleSetEntityDoubleSetAttributeValue = "Test Double-Set Entity Double-Set Attribute Value";
      const nullEntityAlternativeAttributeValue = "Test Null Entity Alternative Attribute Value";
      const alternativeEntityNullAttributeValue = "Test Alternative Entity Null Attribute Value";
      const nonNullEntityAlternativeAttributeValue = "Test Non Null Entity Alternative Attribute Value";
      const alternativeEntityNonNullAttributeAValue = "Test Alternative Entity Non Null Attribute A Value";
      const alternativeEntityNonNullAttributeBValue = "Test Alternative Entity Non Null Attribute B Value";
      const alternativeEntityNonNullAttributeCValue = "Test Alternative Entity Non Null Attribute C Value";
      const doubleSetEntityAlternativeAttributeValue = "Test Double-Set Entity Alternative Attribute Value";
      const alternativeEntityDoubleSetAttributeValue = "Test Alternative Entity Double-Set Attribute Value";
      final callbacks = MockCallbacks();
      final backingStore = EntityAttributeValueStoreMock();
      final store = WritableEntityAttributeValueStore(backingStore, callbacks.valueValidator, callbacks.valueSerializer, Opcode.setEntityAttributeS32);
      when(backingStore.get(nullEntityId, nullAttributeId)).thenReturn(nullEntityNullAttributeValue);
      when(backingStore.get(nonNullEntityId, nonNullAttributeAId)).thenReturn(nonNullEntityNonNullAttributeAValue);
      when(backingStore.get(nonNullEntityId, nonNullAttributeBId)).thenReturn(nonNullEntityNonNullAttributeBValue);
      when(backingStore.get(nonNullEntityId, nonNullAttributeCId)).thenReturn(nonNullEntityNonNullAttributeCValue);
      when(backingStore.get(doubleSetEntityId, doubleSetAttributeId)).thenReturn(doubleSetEntityDoubleSetAttributeValue);
      when(backingStore.get(nullEntityId, alternativeAttributeId)).thenReturn(nullEntityAlternativeAttributeValue);
      when(backingStore.get(alternativeEntityId, nullAttributeId)).thenReturn(alternativeEntityNullAttributeValue);
      when(backingStore.get(nonNullEntityId, alternativeAttributeId)).thenReturn(nonNullEntityAlternativeAttributeValue);
      when(backingStore.get(alternativeEntityId, nonNullAttributeAId)).thenReturn(alternativeEntityNonNullAttributeAValue);
      when(backingStore.get(alternativeEntityId, nonNullAttributeBId)).thenReturn(alternativeEntityNonNullAttributeBValue);
      when(backingStore.get(alternativeEntityId, nonNullAttributeCId)).thenReturn(alternativeEntityNonNullAttributeCValue);
      when(backingStore.get(doubleSetEntityId, alternativeAttributeId)).thenReturn(doubleSetEntityAlternativeAttributeValue);
      when(backingStore.get(alternativeEntityId, doubleSetAttributeId)).thenReturn(alternativeEntityDoubleSetAttributeValue);
      store.set(doubleSetEntityId, doubleSetAttributeId, doubleSetFirstValue);
      store.set(nonNullEntityId, nonNullAttributeAId, nonNullValueA);
      store.set(doubleSetEntityId, doubleSetAttributeId, doubleSetSecondValue);
      store.set(nonNullEntityId, nonNullAttributeBId, nonNullValueB);
      store.set(nullEntityId, nullAttributeId, null);
      store.set(nonNullEntityId, nonNullAttributeCId, nonNullValueC);
      final target = WritableEntityAttributeValueStoreMock();
      when(target.set(doubleSetEntityId, doubleSetAttributeId, doubleSetSecondValue)).thenReturn(null);
      when(target.set(nonNullEntityId, nonNullAttributeAId, nonNullValueA)).thenReturn(null);
      when(target.set(nonNullEntityId, nonNullAttributeBId, nonNullValueB)).thenReturn(null);
      when(target.set(nonNullEntityId, nonNullAttributeCId, nonNullValueC)).thenReturn(null);
      when(target.set(nullEntityId, nullAttributeId, null)).thenReturn(null);

      store.moveTo(target);

      final retrievedNonNullA = store.get(nonNullEntityId, nonNullAttributeAId);
      final retrievedNonNullB = store.get(nonNullEntityId, nonNullAttributeBId);
      final retrievedNonNullC = store.get(nonNullEntityId, nonNullAttributeCId);
      final retrievedNonNullEntityAlternativeAttribute = store.get(nonNullEntityId, alternativeAttributeId);
      final retrievedAlternativeEntityNonNullAttributeA = store.get(alternativeEntityId, nonNullAttributeAId);
      final retrievedAlternativeEntityNonNullAttributeB = store.get(alternativeEntityId, nonNullAttributeBId);
      final retrievedAlternativeEntityNonNullAttributeC = store.get(alternativeEntityId, nonNullAttributeCId);
      final retrievedNull = store.get(nullEntityId, nullAttributeId);
      final retrievedNullEntityAlternativeAttribute = store.get(nullEntityId, alternativeAttributeId);
      final retrievedAlternativeEntityNullAttribute = store.get(alternativeEntityId, nullAttributeId);
      final retrievedDoubleSet = store.get(doubleSetEntityId, doubleSetAttributeId);
      final retrievedDoubleSetEntityAlternativeAttribute = store.get(doubleSetEntityId, alternativeAttributeId);
      final retrievedAlternativeEntityDoubleSetAttribute = store.get(alternativeEntityId, doubleSetAttributeId);
      expect(store.serialize(), isEmpty);
      expect(retrievedNonNullA, equals(nonNullEntityNonNullAttributeAValue));
      expect(retrievedNonNullB, equals(nonNullEntityNonNullAttributeBValue));
      expect(retrievedNonNullC, equals(nonNullEntityNonNullAttributeCValue));
      expect(retrievedAlternativeEntityNonNullAttributeA, equals(alternativeEntityNonNullAttributeAValue));
      expect(retrievedAlternativeEntityNonNullAttributeB, equals(alternativeEntityNonNullAttributeBValue));
      expect(retrievedAlternativeEntityNonNullAttributeC, equals(alternativeEntityNonNullAttributeCValue));
      expect(retrievedNonNullEntityAlternativeAttribute, equals(nonNullEntityAlternativeAttributeValue));
      expect(retrievedNull, equals(nullEntityNullAttributeValue));
      expect(retrievedAlternativeEntityNullAttribute, equals(alternativeEntityNullAttributeValue));
      expect(retrievedNullEntityAlternativeAttribute, equals(nullEntityAlternativeAttributeValue));
      expect(retrievedDoubleSet, equals(doubleSetEntityDoubleSetAttributeValue));
      expect(retrievedAlternativeEntityDoubleSetAttribute, equals(alternativeEntityDoubleSetAttributeValue));
      expect(retrievedDoubleSetEntityAlternativeAttribute, equals(doubleSetEntityAlternativeAttributeValue));
      verify(callbacks.valueValidator(doubleSetFirstValue, "Value")).called(1);
      verify(callbacks.valueValidator(nonNullValueA, "Value")).called(1);
      verify(callbacks.valueValidator(nonNullValueB, "Value")).called(1);
      verify(callbacks.valueValidator(nonNullValueC, "Value")).called(1);
      verify(callbacks.valueValidator(doubleSetSecondValue, "Value")).called(1);
      verify(callbacks.valueValidator(null, "Value")).called(1);
      verifyNoMoreInteractions(callbacks);
      verify(backingStore.get(nonNullEntityId, nonNullAttributeAId)).called(1);
      verify(backingStore.get(nonNullEntityId, nonNullAttributeBId)).called(1);
      verify(backingStore.get(nonNullEntityId, nonNullAttributeCId)).called(1);
      verify(backingStore.get(nullEntityId, nullAttributeId)).called(1);
      verify(backingStore.get(doubleSetEntityId, doubleSetAttributeId)).called(1);
      verify(backingStore.get(nullEntityId, alternativeAttributeId)).called(1);
      verify(backingStore.get(alternativeEntityId, nullAttributeId)).called(1);
      verify(backingStore.get(nonNullEntityId, alternativeAttributeId)).called(1);
      verify(backingStore.get(alternativeEntityId, nonNullAttributeAId)).called(1);
      verify(backingStore.get(alternativeEntityId, nonNullAttributeBId)).called(1);
      verify(backingStore.get(alternativeEntityId, nonNullAttributeCId)).called(1);
      verify(backingStore.get(doubleSetEntityId, alternativeAttributeId)).called(1);
      verify(backingStore.get(alternativeEntityId, doubleSetAttributeId)).called(1);
      verifyNoMoreInteractions(backingStore);
    });
  });
}

