import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/entity_id.dart';
import 'package:maryland_game_engine/data/stores/entity_attribute_value/reference/reference_entity_attribute_value_store.dart';
import 'package:maryland_game_engine/data/stores/entity_attribute_value/reference/writable_reference_entity_attribute_value_store.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ReferenceEntityAttributeValueStore, WritableReferenceEntityAttributeValueStore])
import 'writable_reference_entity_attribute_value_store_test.mocks.dart';

void main() {
  test("exposes the backing store", () {
    final backingStore = MockReferenceEntityAttributeValueStore();

    final store = WritableReferenceEntityAttributeValueStore(backingStore);

    expect(store.backingStore, equals(backingStore));
    verifyZeroInteractions(backingStore);
  });


  test("get throws an error when an invalid attribute is given", () {
    final backingStore = MockReferenceEntityAttributeValueStore();
    final store = WritableReferenceEntityAttributeValueStore(backingStore);

    expect(
            () => store.get(EntityId.generate(), -1),
        throwsA((e) => e is RangeError && e.message == "Attribute ID - Value is out of range for an attribute ID (less than 0).")
    );
    verifyZeroInteractions(backingStore);
  });

  test("set throws an error when an invalid attribute is given", () {
    final backingStore = MockReferenceEntityAttributeValueStore();
    final store = WritableReferenceEntityAttributeValueStore(backingStore);

    expect(
            () => store.set(EntityId.generate(), -1, EntityId.generate()),
        throwsA((e) => e is RangeError && e.message == "Attribute ID - Value is out of range for an attribute ID (less than 0).")
    );
    verifyZeroInteractions(backingStore);
  });

  test("listReferencingEntities throws an error when an invalid attribute is given", () {
    final backingStore = MockReferenceEntityAttributeValueStore();
    final store = WritableReferenceEntityAttributeValueStore(backingStore);

    expect(
            () => store.listReferencingEntities(-1, EntityId.generate()),
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
    final entityJId = EntityId.generate();
    final entityKId = EntityId.generate();
    final entityLId = EntityId.generate();
    final entityMId = EntityId.generate();
    final entityNId = EntityId.generate();
    final entityOId = EntityId.generate();
    final entityPId = EntityId.generate();
    final entityQId = EntityId.generate();
    final entityRId = EntityId.generate();
    final entitySId = EntityId.generate();
    final entityTId = EntityId.generate();
    final entityUId = EntityId.generate();
    const attributeAId = 1234;
    const attributeBId = 5959;
    const attributeCId = 2211;
    final backingStore = MockReferenceEntityAttributeValueStore();
    when(backingStore.get(entityAId, attributeCId)).thenReturn(entityFId);
    when(backingStore.get(entityGId, attributeAId)).thenReturn(entityHId);
    when(backingStore.listReferencingEntities(attributeBId, entityDId)).thenReturn([entityAId, entityKId, entityJId, entityQId]);
    when(backingStore.listReferencingEntities(attributeBId, entityMId)).thenReturn([entityNId, entityOId]);
    when(backingStore.listReferencingEntities(attributeBId, entityTId)).thenReturn([]);
    final writableReferenceEntityAttributeValueStore = WritableReferenceEntityAttributeValueStore(backingStore);

    writableReferenceEntityAttributeValueStore.set(entityAId, attributeBId, entityCId);
    writableReferenceEntityAttributeValueStore.set(entityAId, attributeAId, entityBId);
    writableReferenceEntityAttributeValueStore.set(entityAId, attributeBId, entityDId);
    writableReferenceEntityAttributeValueStore.set(entityEId, attributeAId, entityBId);
    writableReferenceEntityAttributeValueStore.set(entityIId, attributeBId, entityDId);
    writableReferenceEntityAttributeValueStore.set(entityKId, attributeBId, entityLId);
    writableReferenceEntityAttributeValueStore.set(entityOId, attributeBId, entityPId);
    writableReferenceEntityAttributeValueStore.set(entityQId, attributeBId, entityDId);
    writableReferenceEntityAttributeValueStore.set(entityQId, attributeBId, entityRId);
    writableReferenceEntityAttributeValueStore.set(entitySId, attributeBId, entityTId);
    writableReferenceEntityAttributeValueStore.set(entitySId, attributeBId, entityUId);
    final valueAA = writableReferenceEntityAttributeValueStore.get(entityAId, attributeAId);
    final valueAB = writableReferenceEntityAttributeValueStore.get(entityAId, attributeBId);
    final valueEA = writableReferenceEntityAttributeValueStore.get(entityEId, attributeAId);
    final valueAC = writableReferenceEntityAttributeValueStore.get(entityAId, attributeCId);
    final valueGA = writableReferenceEntityAttributeValueStore.get(entityGId, attributeAId);
    final referencesBD = writableReferenceEntityAttributeValueStore.listReferencingEntities(attributeBId, entityDId);
    final referencesBM = writableReferenceEntityAttributeValueStore.listReferencingEntities(attributeBId, entityMId);
    final referencesBT = writableReferenceEntityAttributeValueStore.listReferencingEntities(attributeBId, entityTId);

    expect(valueAA, equals(entityBId));
    expect(valueAB, equals(entityDId));
    expect(valueEA, equals(entityBId));
    expect(valueAC, equals(entityFId));
    expect(valueGA, equals(entityHId));
    expect(referencesBD, unorderedEquals([entityAId, entityIId, entityJId]));
    expect(referencesBM, unorderedEquals([entityNId]));
    expect(referencesBT, isEmpty);
    verify(backingStore.get(entityAId, attributeCId)).called(1);
    verify(backingStore.get(entityGId, attributeAId)).called(1);
    verify(backingStore.listReferencingEntities(attributeBId, entityDId)).called(1);
    verify(backingStore.listReferencingEntities(attributeBId, entityMId)).called(1);
    verify(backingStore.listReferencingEntities(attributeBId, entityTId)).called(1);
    verifyNoMoreInteractions(backingStore);
  });

  group("moveTo", () {
    test("applies changes", () {
      final entityAId = EntityId.generate();
      final entityBId = EntityId.generate();
      final entityCId = EntityId.generate();
      final entityDId = EntityId.generate();
      final entityEId = EntityId.generate();
      final entityIId = EntityId.generate();
      final entityKId = EntityId.generate();
      final entityLId = EntityId.generate();
      final entityOId = EntityId.generate();
      final entityPId = EntityId.generate();
      final entityQId = EntityId.generate();
      final entityRId = EntityId.generate();
      final entitySId = EntityId.generate();
      final entityTId = EntityId.generate();
      final entityUId = EntityId.generate();
      const attributeAId = 1234;
      const attributeBId = 5959;
      final backingStore = MockReferenceEntityAttributeValueStore();
      final writableReferenceEntityAttributeValueStore = WritableReferenceEntityAttributeValueStore(backingStore);
      final target = MockWritableReferenceEntityAttributeValueStore();
      when(target.set(entityAId, attributeAId, entityBId)).thenReturn(null);
      when(target.set(entityAId, attributeBId, entityDId)).thenReturn(null);
      when(target.set(entityEId, attributeAId, entityBId)).thenReturn(null);
      when(target.set(entityIId, attributeBId, entityDId)).thenReturn(null);
      when(target.set(entityKId, attributeBId, entityLId)).thenReturn(null);
      when(target.set(entityOId, attributeBId, entityPId)).thenReturn(null);
      when(target.set(entityQId, attributeBId, entityRId)).thenReturn(null);
      when(target.set(entitySId, attributeBId, entityUId)).thenReturn(null);
      writableReferenceEntityAttributeValueStore.set(entityAId, attributeBId, entityCId);
      writableReferenceEntityAttributeValueStore.set(entityAId, attributeAId, entityBId);
      writableReferenceEntityAttributeValueStore.set(entityAId, attributeBId, entityDId);
      writableReferenceEntityAttributeValueStore.set(entityEId, attributeAId, entityBId);
      writableReferenceEntityAttributeValueStore.set(entityIId, attributeBId, entityDId);
      writableReferenceEntityAttributeValueStore.set(entityKId, attributeBId, entityLId);
      writableReferenceEntityAttributeValueStore.set(entityOId, attributeBId, entityPId);
      writableReferenceEntityAttributeValueStore.set(entityQId, attributeBId, entityDId);
      writableReferenceEntityAttributeValueStore.set(entityQId, attributeBId, entityRId);
      writableReferenceEntityAttributeValueStore.set(entitySId, attributeBId, entityTId);
      writableReferenceEntityAttributeValueStore.set(entitySId, attributeBId, entityUId);

      writableReferenceEntityAttributeValueStore.moveTo(target);

      verifyZeroInteractions(backingStore);
      verify(target.set(entityAId, attributeAId, entityBId)).called(1);
      verify(target.set(entityAId, attributeBId, entityDId)).called(1);
      verify(target.set(entityEId, attributeAId, entityBId)).called(1);
      verify(target.set(entityIId, attributeBId, entityDId)).called(1);
      verify(target.set(entityKId, attributeBId, entityLId)).called(1);
      verify(target.set(entityOId, attributeBId, entityPId)).called(1);
      verify(target.set(entityQId, attributeBId, entityRId)).called(1);
      verify(target.set(entitySId, attributeBId, entityUId)).called(1);
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
      final entityJId = EntityId.generate();
      final entityKId = EntityId.generate();
      final entityLId = EntityId.generate();
      final entityMId = EntityId.generate();
      final entityNId = EntityId.generate();
      final entityOId = EntityId.generate();
      final entityPId = EntityId.generate();
      final entityQId = EntityId.generate();
      final entityRId = EntityId.generate();
      final entitySId = EntityId.generate();
      final entityTId = EntityId.generate();
      final entityUId = EntityId.generate();
      final entityVId = EntityId.generate();
      final entityWId = EntityId.generate();
      final entityXId = EntityId.generate();
      const attributeAId = 1234;
      const attributeBId = 5959;
      const attributeCId = 2211;
      final backingStore = MockReferenceEntityAttributeValueStore();
      when(backingStore.get(entityAId, attributeAId)).thenReturn(entityVId);
      when(backingStore.get(entityAId, attributeBId)).thenReturn(entityWId);
      when(backingStore.get(entityEId, attributeAId)).thenReturn(entityXId);
      when(backingStore.get(entityAId, attributeCId)).thenReturn(entityFId);
      when(backingStore.get(entityGId, attributeAId)).thenReturn(entityHId);
      when(backingStore.listReferencingEntities(attributeBId, entityDId)).thenReturn([entityAId, entityKId, entityJId, entityQId]);
      when(backingStore.listReferencingEntities(attributeBId, entityMId)).thenReturn([entityNId, entityOId]);
      when(backingStore.listReferencingEntities(attributeBId, entityTId)).thenReturn([]);
      final writableReferenceEntityAttributeValueStore = WritableReferenceEntityAttributeValueStore(backingStore);
      final target = MockWritableReferenceEntityAttributeValueStore();
      when(target.set(entityAId, attributeAId, entityBId)).thenReturn(null);
      when(target.set(entityAId, attributeBId, entityDId)).thenReturn(null);
      when(target.set(entityEId, attributeAId, entityBId)).thenReturn(null);
      when(target.set(entityIId, attributeBId, entityDId)).thenReturn(null);
      when(target.set(entityKId, attributeBId, entityLId)).thenReturn(null);
      when(target.set(entityOId, attributeBId, entityPId)).thenReturn(null);
      when(target.set(entityQId, attributeBId, entityRId)).thenReturn(null);
      when(target.set(entitySId, attributeBId, entityUId)).thenReturn(null);
      writableReferenceEntityAttributeValueStore.set(entityAId, attributeBId, entityCId);
      writableReferenceEntityAttributeValueStore.set(entityAId, attributeAId, entityBId);
      writableReferenceEntityAttributeValueStore.set(entityAId, attributeBId, entityDId);
      writableReferenceEntityAttributeValueStore.set(entityEId, attributeAId, entityBId);
      writableReferenceEntityAttributeValueStore.set(entityIId, attributeBId, entityDId);
      writableReferenceEntityAttributeValueStore.set(entityKId, attributeBId, entityLId);
      writableReferenceEntityAttributeValueStore.set(entityOId, attributeBId, entityPId);
      writableReferenceEntityAttributeValueStore.set(entityQId, attributeBId, entityDId);
      writableReferenceEntityAttributeValueStore.set(entityQId, attributeBId, entityRId);
      writableReferenceEntityAttributeValueStore.set(entitySId, attributeBId, entityTId);
      writableReferenceEntityAttributeValueStore.set(entitySId, attributeBId, entityUId);

      writableReferenceEntityAttributeValueStore.moveTo(target);

      final valueAA = writableReferenceEntityAttributeValueStore.get(entityAId, attributeAId);
      final valueAB = writableReferenceEntityAttributeValueStore.get(entityAId, attributeBId);
      final valueEA = writableReferenceEntityAttributeValueStore.get(entityEId, attributeAId);
      final valueAC = writableReferenceEntityAttributeValueStore.get(entityAId, attributeCId);
      final valueGA = writableReferenceEntityAttributeValueStore.get(entityGId, attributeAId);
      final referencesBD = writableReferenceEntityAttributeValueStore.listReferencingEntities(attributeBId, entityDId);
      final referencesBM = writableReferenceEntityAttributeValueStore.listReferencingEntities(attributeBId, entityMId);
      final referencesBT = writableReferenceEntityAttributeValueStore.listReferencingEntities(attributeBId, entityTId);
      expect(valueAA, equals(entityVId));
      expect(valueAB, equals(entityWId));
      expect(valueEA, equals(entityXId));
      expect(valueAC, equals(entityFId));
      expect(valueGA, equals(entityHId));
      expect(referencesBD, unorderedEquals([entityAId, entityKId, entityJId, entityQId]));
      expect(referencesBM, unorderedEquals([entityNId, entityOId]));
      expect(referencesBT, isEmpty);
      verify(backingStore.get(entityAId, attributeAId)).called(1);
      verify(backingStore.get(entityAId, attributeBId)).called(1);
      verify(backingStore.get(entityEId, attributeAId)).called(1);
      verify(backingStore.get(entityAId, attributeCId)).called(1);
      verify(backingStore.get(entityGId, attributeAId)).called(1);
      verify(backingStore.listReferencingEntities(attributeBId, entityDId)).called(1);
      verify(backingStore.listReferencingEntities(attributeBId, entityMId)).called(1);
      verify(backingStore.listReferencingEntities(attributeBId, entityTId)).called(1);
      verifyNoMoreInteractions(backingStore);
    });
  });
}
