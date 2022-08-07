import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/entity_id.dart';

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
  
  test("includes a zero constant", () async {
    expect(EntityId.zero.toString(), equals("00000000000000000000000000000000"));
    expect(EntityId.zero.serialize(), equals([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
    expect(EntityId.zero, equals(await EntityId.deserialize(StreamIterator(Stream.fromIterable([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])), "Example Description")));
  });

  group("deserialize", () {
    test("throws the expected exception when the iterator ends immediately",
            () {
          expect(
                  () => EntityId.deserialize(StreamIterator(const Stream.empty()), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after one U8",
            () {
          expect(
                  () => EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after two U8s",
            () {
          expect(
                  () =>
                      EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after three U8s",
            () {
          expect(
                  () => EntityId.deserialize(StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after four U8s",
            () {
          expect(
                  () => EntityId.deserialize(StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after five U8s",
            () {
          expect(
                  () => EntityId.deserialize(StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after six U8s",
            () {
          expect(
                  () => EntityId.deserialize(StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after seven U8s",
            () {
          expect(
                  () => EntityId.deserialize(StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after eight U8s",
            () {
          expect(
                  () => EntityId.deserialize(StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after nine U8s",
            () {
          expect(
                  () => EntityId.deserialize(StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after ten U8s",
            () {
          expect(
                  () => EntityId.deserialize(StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after eleven U8s",
            () {
          expect(
                  () => EntityId.deserialize(StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after twelve U8s",
            () {
          expect(
                  () => EntityId.deserialize(StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after thirteen U8s",
            () {
          expect(
                  () => EntityId.deserialize(StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after fourteen U8s",
            () {
          expect(
                  () => EntityId.deserialize(StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after fifteen U8s",
            () {
          expect(
                  () => EntityId.deserialize(StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator includes invalid U8s",
            () {
          expect(
                  () => EntityId.deserialize(StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 300, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description"),
              throwsA(predicate((e) =>
              e is RangeError &&
                  e.message ==
                      "Example Description - Value is out of range for a U8 (greater than 255).")));
        });

    test("returns the expected entity ID when the iterable ends", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");
      final c = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe7, 0xd3, 0x48, 0x36])), "Example Description C");

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a.toString(), equals(b.toString()));
      expect(a.toString(), equals("ce80d9e8ce5e5a09cb56485ce6d34836"));
      expect(a, isNot(equals(c)));
      expect(a.hashCode, isNot(equals(c.hashCode)));
    });

    group("when the iterable does not end", () {
      final iterator = StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36, 0x48, 0x07, 0xe5, 0x6e]));
      EntityId output = EntityId.generate();

      setUpAll(() async {
        output = await EntityId.deserialize(iterator, "Example Description");
      });

      test("returns the expected entity ID", () {
        expect(output.toString(), equals("ce80d9e8ce5e5a09cb56485ce6d34836"));
      });

      test("leaves the remaining U8s un-iterated", () async {
        final remaining = [];

        while (await iterator.moveNext()) {
          remaining.add(iterator.current);
        }

        expect(remaining, orderedEquals([0x48, 0x07, 0xe5, 0x6e]));
      });
    });

    test("treats deserialized and generated entity IDs the same", () async {
      final generated = EntityId.generate();
      final deserialized = await EntityId.deserialize(StreamIterator(Stream.fromIterable(generated.serialize())), "Example Description");

      expect(generated, equals(deserialized));
      expect(generated.hashCode, equals(deserialized.hashCode));
      expect(generated.toString(), equals(deserialized.toString()));
    });
  });

  group("compareTo", () {
    test("same", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, equals(0));
    });

    test("a negative", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xcd, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("a positive", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xcf, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, greaterThan(0));
    });

    test("b negative", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x7f, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("b positive", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x81, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, greaterThan(0));
    });

    test("c negative", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd8, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("c positive", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xda, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, greaterThan(0));
    });

    test("d negative", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe7, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("d positive", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe9, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, greaterThan(0));
    });

    test("e negative", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xcd, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("e positive", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xcf, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, greaterThan(0));
    });

    test("f negative", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5d, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("f positive", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5f, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, greaterThan(0));
    });

    test("g negative", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x59, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("g positive", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5b, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, greaterThan(0));
    });

    test("h negative", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x08, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("h positive", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x0a, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, greaterThan(0));
    });

    test("i negative", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xca, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("i positive", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcc, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, greaterThan(0));
    });

    test("j negative", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x55, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("j positive", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x57, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, greaterThan(0));
    });

    test("k negative", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x47, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("k positive", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x49, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, greaterThan(0));
    });

    test("l negative", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5b, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("l positive", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5d, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, greaterThan(0));
    });

    test("m negative", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe5, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("m positive", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe7, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, greaterThan(0));
    });

    test("n negative", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd2, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("n positive", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd4, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, greaterThan(0));
    });

    test("o negative", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x47, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("o positive", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x49, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, greaterThan(0));
    });

    test("p negative", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x35])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("p positive", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x37])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, greaterThan(0));
    });

    test("a supersedes b", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xcd, 0x81, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("b supersedes c", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x7f, 0xda, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("c supersedes d", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd8, 0xe9, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("d supersedes e", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe7, 0xcf, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("e supersedes f", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xcd, 0x5f, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("f supersedes g", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5d, 0x5b, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("g supersedes h", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x59, 0x0a, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("h supersedes i", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x08, 0xcc, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("i supersedes j", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xca, 0x57, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("j supersedes k", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x55, 0x49, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("k supersedes l", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x47, 0x5d, 0xe6, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("l supersedes m", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5b, 0xe7, 0xd3, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("m supersedes n", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe5, 0xd4, 0x48, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("n supersedes o", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd2, 0x49, 0x36])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });

    test("o supersedes p", () async {
      final a = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x47, 0x37])), "Example Description A");
      final b = await EntityId.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48, 0x36])), "Example Description B");

      final actual = a.compareTo(b);

      expect(actual, lessThan(0));
    });
  });
}
