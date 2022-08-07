import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/entity_id.dart';
import 'package:maryland_game_engine/data/stores/entity_attribute_value/flag/flag_entity_attribute_value_store.dart';
import 'package:maryland_game_engine/data/stores/entity_attribute_value/flag/writable_flag_entity_attribute_value_store.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([FlagEntityAttributeValueStore, WritableFlagEntityAttributeValueStore])
import 'writable_flag_entity_attribute_value_store_test.mocks.dart';

void main() {
  test("exposes the backing store", () {
    final backingStore = MockFlagEntityAttributeValueStore();

    final store = WritableFlagEntityAttributeValueStore(backingStore);

    expect(store.backingStore, equals(backingStore));
    verifyZeroInteractions(backingStore);
  });


  test("get throws an error when an invalid attribute is given", () {
    final backingStore = MockFlagEntityAttributeValueStore();
    final store = WritableFlagEntityAttributeValueStore(backingStore);

    expect(
            () => store.get(EntityId.generate(), -1),
        throwsA((e) => e is RangeError && e.message == "Attribute ID - Value is out of range for an attribute ID (less than 0).")
    );
    verifyZeroInteractions(backingStore);
  });

  test("set throws an error when an invalid attribute is given", () {
    final backingStore = MockFlagEntityAttributeValueStore();
    final store = WritableFlagEntityAttributeValueStore(backingStore);

    expect(
            () => store.set(EntityId.generate(), -1),
        throwsA((e) => e is RangeError && e.message == "Attribute ID - Value is out of range for an attribute ID (less than 0).")
    );
    verifyZeroInteractions(backingStore);
  });

  test("clear throws an error when an invalid attribute is given", () {
    final backingStore = MockFlagEntityAttributeValueStore();
    final store = WritableFlagEntityAttributeValueStore(backingStore);

    expect(
            () => store.clear(EntityId.generate(), -1),
        throwsA((e) => e is RangeError && e.message == "Attribute ID - Value is out of range for an attribute ID (less than 0).")
    );
    verifyZeroInteractions(backingStore);
  });

  test("allows retrieval of set values", () {
    final entityAId = EntityId.generate();
    final entityBId = EntityId.generate();
    final entityCId = EntityId.generate();
    final entityDId = EntityId.generate();
    final entityEId = EntityId.generate();
    final entityFId = EntityId.generate();
    final entityGId = EntityId.generate();
    final entityHId = EntityId.generate();
    final entityIId = EntityId.generate();
    const attributeAId = 1234;
    const attributeBId = 5959;
    final backingStore = MockFlagEntityAttributeValueStore();
    when(backingStore.get(entityAId, attributeBId)).thenReturn(true);
    when(backingStore.get(entityBId, attributeBId)).thenReturn(true);
    when(backingStore.get(entityCId, attributeBId)).thenReturn(false);
    when(backingStore.get(entityDId, attributeBId)).thenReturn(false);
    when(backingStore.get(entityHId, attributeAId)).thenReturn(true);
    when(backingStore.get(entityIId, attributeAId)).thenReturn(false);
    final writableFlagEntityAttributeValueStore = WritableFlagEntityAttributeValueStore(backingStore);
    writableFlagEntityAttributeValueStore.set(entityAId, attributeAId);
    writableFlagEntityAttributeValueStore.clear(entityBId, attributeAId);
    writableFlagEntityAttributeValueStore.set(entityCId, attributeAId);
    writableFlagEntityAttributeValueStore.set(entityCId, attributeAId);
    writableFlagEntityAttributeValueStore.set(entityDId, attributeAId);
    writableFlagEntityAttributeValueStore.clear(entityDId, attributeAId);
    writableFlagEntityAttributeValueStore.clear(entityEId, attributeAId);
    writableFlagEntityAttributeValueStore.set(entityEId, attributeAId);
    writableFlagEntityAttributeValueStore.clear(entityFId, attributeAId);
    writableFlagEntityAttributeValueStore.clear(entityFId, attributeAId);
    writableFlagEntityAttributeValueStore.set(entityGId, attributeAId);
    writableFlagEntityAttributeValueStore.clear(entityGId, attributeBId);

    final valueAA = writableFlagEntityAttributeValueStore.get(entityAId, attributeAId);
    final valueAB = writableFlagEntityAttributeValueStore.get(entityAId, attributeBId);
    final valueBA = writableFlagEntityAttributeValueStore.get(entityBId, attributeAId);
    final valueBB = writableFlagEntityAttributeValueStore.get(entityBId, attributeBId);
    final valueCA = writableFlagEntityAttributeValueStore.get(entityCId, attributeAId);
    final valueCB = writableFlagEntityAttributeValueStore.get(entityCId, attributeBId);
    final valueDA = writableFlagEntityAttributeValueStore.get(entityDId, attributeAId);
    final valueDB = writableFlagEntityAttributeValueStore.get(entityDId, attributeBId);
    final valueEA = writableFlagEntityAttributeValueStore.get(entityEId, attributeAId);
    final valueFA = writableFlagEntityAttributeValueStore.get(entityFId, attributeAId);
    final valueGA = writableFlagEntityAttributeValueStore.get(entityGId, attributeAId);
    final valueGB = writableFlagEntityAttributeValueStore.get(entityGId, attributeBId);
    final valueHA = writableFlagEntityAttributeValueStore.get(entityHId, attributeAId);
    final valueIA = writableFlagEntityAttributeValueStore.get(entityIId, attributeAId);

    expect(valueAA, isTrue);
    expect(valueAB, isTrue);
    expect(valueBA, isFalse);
    expect(valueBB, isTrue);
    expect(valueCA, isTrue);
    expect(valueCB, isFalse);
    expect(valueDA, isFalse);
    expect(valueDB, isFalse);
    expect(valueEA, isTrue);
    expect(valueFA, isFalse);
    expect(valueGA, isTrue);
    expect(valueGB, isFalse);
    expect(valueHA, isTrue);
    expect(valueIA, isFalse);
    verify(backingStore.get(entityAId, attributeBId)).called(1);
    verify(backingStore.get(entityBId, attributeBId)).called(1);
    verify(backingStore.get(entityCId, attributeBId)).called(1);
    verify(backingStore.get(entityDId, attributeBId)).called(1);
    verify(backingStore.get(entityHId, attributeAId)).called(1);
    verify(backingStore.get(entityIId, attributeAId)).called(1);
    verifyNoMoreInteractions(backingStore);
  });

  group("moveTo", () {
    test("applies changes", () {
      final entityAId = EntityId.generate();
      final entityBId = EntityId.generate();
      final entityCId = EntityId.generate();
      final entityDId = EntityId.generate();
      final entityEId = EntityId.generate();
      final entityFId = EntityId.generate();
      final entityGId = EntityId.generate();
      final entityHId = EntityId.generate();
      final entityIId = EntityId.generate();
      const attributeAId = 1234;
      const attributeBId = 5959;
      final backingStore = MockFlagEntityAttributeValueStore();
      when(backingStore.get(entityAId, attributeAId)).thenReturn(true);
      when(backingStore.get(entityAId, attributeBId)).thenReturn(false);
      when(backingStore.get(entityBId, attributeAId)).thenReturn(false);
      when(backingStore.get(entityBId, attributeBId)).thenReturn(true);
      when(backingStore.get(entityCId, attributeAId)).thenReturn(true);
      when(backingStore.get(entityCId, attributeBId)).thenReturn(true);
      when(backingStore.get(entityDId, attributeAId)).thenReturn(true);
      when(backingStore.get(entityDId, attributeBId)).thenReturn(false);
      when(backingStore.get(entityEId, attributeAId)).thenReturn(true);
      when(backingStore.get(entityFId, attributeAId)).thenReturn(false);
      when(backingStore.get(entityGId, attributeAId)).thenReturn(true);
      when(backingStore.get(entityGId, attributeBId)).thenReturn(false);
      when(backingStore.get(entityHId, attributeAId)).thenReturn(false);
      when(backingStore.get(entityIId, attributeAId)).thenReturn(true);
      final writableFlagEntityAttributeValueStore = WritableFlagEntityAttributeValueStore(backingStore);
      writableFlagEntityAttributeValueStore.set(entityAId, attributeAId);
      writableFlagEntityAttributeValueStore.clear(entityBId, attributeAId);
      writableFlagEntityAttributeValueStore.set(entityCId, attributeAId);
      writableFlagEntityAttributeValueStore.set(entityCId, attributeAId);
      writableFlagEntityAttributeValueStore.set(entityDId, attributeAId);
      writableFlagEntityAttributeValueStore.clear(entityDId, attributeAId);
      writableFlagEntityAttributeValueStore.clear(entityEId, attributeAId);
      writableFlagEntityAttributeValueStore.set(entityEId, attributeAId);
      writableFlagEntityAttributeValueStore.clear(entityFId, attributeAId);
      writableFlagEntityAttributeValueStore.clear(entityFId, attributeAId);
      writableFlagEntityAttributeValueStore.set(entityGId, attributeAId);
      writableFlagEntityAttributeValueStore.clear(entityGId, attributeBId);
      final target = MockWritableFlagEntityAttributeValueStore();

      writableFlagEntityAttributeValueStore.moveTo(target);

      verifyZeroInteractions(backingStore);
      verify(target.set(entityAId, attributeAId)).called(1);
      verify(target.clear(entityBId, attributeAId)).called(1);
      verify(target.set(entityCId, attributeAId)).called(1);
      verify(target.clear(entityDId, attributeAId)).called(1);
      verify(target.set(entityEId, attributeAId)).called(1);
      verify(target.clear(entityFId, attributeAId)).called(1);
      verify(target.set(entityGId, attributeAId)).called(1);
      verify(target.clear(entityGId, attributeBId)).called(1);
      verifyNoMoreInteractions(target);
    });

    test("resets", () {
      final entityAId = EntityId.generate();
      final entityBId = EntityId.generate();
      final entityCId = EntityId.generate();
      final entityDId = EntityId.generate();
      final entityEId = EntityId.generate();
      final entityFId = EntityId.generate();
      final entityGId = EntityId.generate();
      final entityHId = EntityId.generate();
      final entityIId = EntityId.generate();
      const attributeAId = 1234;
      const attributeBId = 5959;
      final backingStore = MockFlagEntityAttributeValueStore();
      when(backingStore.get(entityAId, attributeAId)).thenReturn(true);
      when(backingStore.get(entityAId, attributeBId)).thenReturn(false);
      when(backingStore.get(entityBId, attributeAId)).thenReturn(false);
      when(backingStore.get(entityBId, attributeBId)).thenReturn(true);
      when(backingStore.get(entityCId, attributeAId)).thenReturn(true);
      when(backingStore.get(entityCId, attributeBId)).thenReturn(true);
      when(backingStore.get(entityDId, attributeAId)).thenReturn(true);
      when(backingStore.get(entityDId, attributeBId)).thenReturn(false);
      when(backingStore.get(entityEId, attributeAId)).thenReturn(true);
      when(backingStore.get(entityFId, attributeAId)).thenReturn(false);
      when(backingStore.get(entityGId, attributeAId)).thenReturn(true);
      when(backingStore.get(entityGId, attributeBId)).thenReturn(false);
      when(backingStore.get(entityHId, attributeAId)).thenReturn(false);
      when(backingStore.get(entityIId, attributeAId)).thenReturn(true);
      final writableFlagEntityAttributeValueStore = WritableFlagEntityAttributeValueStore(backingStore);
      writableFlagEntityAttributeValueStore.set(entityAId, attributeAId);
      writableFlagEntityAttributeValueStore.clear(entityBId, attributeAId);
      writableFlagEntityAttributeValueStore.set(entityCId, attributeAId);
      writableFlagEntityAttributeValueStore.set(entityCId, attributeAId);
      writableFlagEntityAttributeValueStore.set(entityDId, attributeAId);
      writableFlagEntityAttributeValueStore.clear(entityDId, attributeAId);
      writableFlagEntityAttributeValueStore.clear(entityEId, attributeAId);
      writableFlagEntityAttributeValueStore.set(entityEId, attributeAId);
      writableFlagEntityAttributeValueStore.clear(entityFId, attributeAId);
      writableFlagEntityAttributeValueStore.clear(entityFId, attributeAId);
      writableFlagEntityAttributeValueStore.set(entityGId, attributeAId);
      writableFlagEntityAttributeValueStore.clear(entityGId, attributeBId);
      final target = MockWritableFlagEntityAttributeValueStore();

      writableFlagEntityAttributeValueStore.moveTo(target);

      final valueAA = writableFlagEntityAttributeValueStore.get(entityAId, attributeAId);
      final valueAB = writableFlagEntityAttributeValueStore.get(entityAId, attributeBId);
      final valueBA = writableFlagEntityAttributeValueStore.get(entityBId, attributeAId);
      final valueBB = writableFlagEntityAttributeValueStore.get(entityBId, attributeBId);
      final valueCA = writableFlagEntityAttributeValueStore.get(entityCId, attributeAId);
      final valueCB = writableFlagEntityAttributeValueStore.get(entityCId, attributeBId);
      final valueDA = writableFlagEntityAttributeValueStore.get(entityDId, attributeAId);
      final valueDB = writableFlagEntityAttributeValueStore.get(entityDId, attributeBId);
      final valueEA = writableFlagEntityAttributeValueStore.get(entityEId, attributeAId);
      final valueFA = writableFlagEntityAttributeValueStore.get(entityFId, attributeAId);
      final valueGA = writableFlagEntityAttributeValueStore.get(entityGId, attributeAId);
      final valueGB = writableFlagEntityAttributeValueStore.get(entityGId, attributeBId);
      final valueHA = writableFlagEntityAttributeValueStore.get(entityHId, attributeAId);
      final valueIA = writableFlagEntityAttributeValueStore.get(entityIId, attributeAId);
      expect(valueAA, isTrue);
      expect(valueAB, isFalse);
      expect(valueBA, isFalse);
      expect(valueBB, isTrue);
      expect(valueCA, isTrue);
      expect(valueCB, isTrue);
      expect(valueDA, isTrue);
      expect(valueDB, isFalse);
      expect(valueEA, isTrue);
      expect(valueFA, isFalse);
      expect(valueGA, isTrue);
      expect(valueGB, isFalse);
      expect(valueHA, isFalse);
      expect(valueIA, isTrue);
      verify(backingStore.get(entityAId, attributeAId)).called(1);
      verify(backingStore.get(entityAId, attributeBId)).called(1);
      verify(backingStore.get(entityBId, attributeAId)).called(1);
      verify(backingStore.get(entityBId, attributeBId)).called(1);
      verify(backingStore.get(entityCId, attributeAId)).called(1);
      verify(backingStore.get(entityCId, attributeBId)).called(1);
      verify(backingStore.get(entityDId, attributeAId)).called(1);
      verify(backingStore.get(entityDId, attributeBId)).called(1);
      verify(backingStore.get(entityEId, attributeAId)).called(1);
      verify(backingStore.get(entityFId, attributeAId)).called(1);
      verify(backingStore.get(entityGId, attributeAId)).called(1);
      verify(backingStore.get(entityGId, attributeBId)).called(1);
      verify(backingStore.get(entityHId, attributeAId)).called(1);
      verify(backingStore.get(entityIId, attributeAId)).called(1);
      verifyNoMoreInteractions(backingStore);
    });
  });
}
