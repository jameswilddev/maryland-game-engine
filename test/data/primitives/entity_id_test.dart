import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/entity_id.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

void main() {
  test("generate returns a new value each call", () {
    final a = EntityId.generate();
    final b = EntityId.generate();

    expect(a, isNot(equals(b)));
    expect(a.hashCode, isNot(equals(b.hashCode)));
    expect(a.toString(), isNot(equals(b.toString())));
    expect(a.toString(), matches(r"^[0-9a-f]{32}$"));
    expect(a.toString(), equals(a.toString()));
  });

  group("deserialize", () {
    test("throws the expected exception when the iterator ends immediately",
            () {
          expect(
                  () => EntityId.deserialize(<U8>[].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of file.")));
        });

    test("throws the expected exception when the iterator ends after one U8",
            () {
          expect(
                  () => EntityId.deserialize(<U8>[0xce].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of file.")));
        });

    test("throws the expected exception when the iterator ends after two U8s",
            () {
          expect(
                  () =>
                      EntityId.deserialize(<U8>[0xce, 0x80].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of file.")));
        });

    test("throws the expected exception when the iterator ends after three U8s",
            () {
          expect(
                  () => EntityId.deserialize(
                  <U8>[0xce, 0x80, 0xd9].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of file.")));
        });

    test("throws the expected exception when the iterator ends after four U8s",
            () {
          expect(
                  () => EntityId.deserialize(
                  <U8>[0xce, 0x80, 0xd9, 0xe8].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of file.")));
        });

    test("throws the expected exception when the iterator ends after five U8s",
            () {
          expect(
                  () => EntityId.deserialize(
                  <U8>[0xce, 0x80, 0xd9, 0xe8, 0xce].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of file.")));
        });

    test("throws the expected exception when the iterator ends after six U8s",
            () {
          expect(
                  () => EntityId.deserialize(
                  <U8>[0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of file.")));
        });

    test("throws the expected exception when the iterator ends after seven U8s",
            () {
          expect(
                  () => EntityId.deserialize(
                  <U8>[0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of file.")));
        });

    test("throws the expected exception when the iterator ends after eight U8s",
            () {
          expect(
                  () => EntityId.deserialize(
                  <U8>[0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of file.")));
        });

    test("throws the expected exception when the iterator ends after nine U8s",
            () {
          expect(
                  () => EntityId.deserialize(
                  <U8>[0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of file.")));
        });

    test("throws the expected exception when the iterator ends after ten U8s",
            () {
          expect(
                  () => EntityId.deserialize(
                  <U8>[0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of file.")));
        });

    test("throws the expected exception when the iterator ends after eleven U8s",
            () {
          expect(
                  () => EntityId.deserialize(
                  <U8>[0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of file.")));
        });

    test("throws the expected exception when the iterator ends after twelve U8s",
            () {
          expect(
                  () => EntityId.deserialize(
                  <U8>[0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of file.")));
        });

    test("throws the expected exception when the iterator ends after thirteen U8s",
            () {
          expect(
                  () => EntityId.deserialize(
                  <U8>[0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of file.")));
        });

    test("throws the expected exception when the iterator ends after fourteen U8s",
            () {
          expect(
                  () => EntityId.deserialize(
                  <U8>[0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of file.")));
        });

    test("throws the expected exception when the iterator ends after fifteen U8s",
            () {
          expect(
                  () => EntityId.deserialize(
                  <U8>[0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of file.")));
        });

    test("throws the expected exception when the iterator includes invalid U8s",
            () {
          expect(
                  () => EntityId.deserialize(
                  <U8>[0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 300, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36].iterator, "Example Description"),
              throwsA(predicate((e) =>
              e is RangeError &&
                  e.message ==
                      "Example Description - Value is out of range for a U8 (greater than 255).")));
        });

    test("returns the expected entity ID when the iterable ends", () {
      final a = EntityId.deserialize([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36].iterator, "Example Description A");
      final b = EntityId.deserialize([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36].iterator, "Example Description B");
      final c = EntityId.deserialize([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe7, 0xd3, 0x48, 0x36].iterator, "Example Description C");

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a.toString(), equals(b.toString()));
      expect(a.toString(), equals("ce80d9e8ce5e5a09cb56485ce6d34836"));
      expect(a, isNot(equals(c)));
      expect(a.hashCode, isNot(equals(c.hashCode)));
    });

    group("when the iterable does not end", () {
      Iterator<U8> iterator = <U8>[].iterator;
      EntityId output = EntityId.generate();

      setUpAll(() {
        iterator = [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36, 0x48, 0x07, 0xe5, 0x6e].iterator;
        output = EntityId.deserialize(iterator, "Example Description");
      });

      test("returns the expected entity ID", () {
        expect(output.toString(), equals("ce80d9e8ce5e5a09cb56485ce6d34836"));
      });

      test("leaves the remaining U8s un-iterated", () {
        final remaining = <U8>[];

        while (iterator.moveNext()) {
          remaining.add(iterator.current);
        }

        expect(remaining, orderedEquals([0x48, 0x07, 0xe5, 0x6e]));
      });
    });

    test("treats deserialized and generate entity IDs the same", () {
      final generated = EntityId.generate();
      final deserialized = EntityId.deserialize(generated.serialize().iterator, "Example Description");

      expect(generated, equals(deserialized));
      expect(generated.hashCode, equals(deserialized.hashCode));
      expect(generated.toString(), equals(deserialized.toString()));
    });
  });
}
