import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/hash.dart';

void main() {
  test("empty", () {
    final a = Hash.of([], "Example Description A");
    final b = Hash.of([], "Example Description B");

    expect(a, equals(b));
    expect(a.hashCode, equals(b.hashCode));
    expect(a.toString(), equals("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"));
  });

  test("equal", () {
    final a = Hash.of([0x14, 0x9a, 0xfb, 0xf4], "Example Description A");
    final b = Hash.of([0x14, 0x9a, 0xfb, 0xf4], "Example Description B");

    expect(a, equals(b));
    expect(a.hashCode, equals(b.hashCode));
    expect(a.toString(), equals("123052ea300b15f126ec185f3389f035c3d56bd8f51f180270951aedf65d6e2d"));
  });

  test("unequal", () {
    final a = Hash.of([0x14, 0x9a, 0xfb, 0xf4], "Example Description A");
    final b = Hash.of([0x14, 0xd5, 0xfb, 0xf4], "Example Description B");

    expect(a, isNot(equals(b)));
    expect(a.hashCode, isNot(equals(b.hashCode)));
  });

  group("deserialize", () {
    test("throws the expected exception when the iterator ends immediately",
            () {
          expect(
                  () => Hash.deserialize(StreamIterator(const Stream.empty()), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after one U8",
            () {
          expect(
                  () => Hash.deserialize(                    StreamIterator(Stream.fromIterable([0xce])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after two U8s",
            () {
          expect(
                  () =>
                      Hash.deserialize(                    StreamIterator(Stream.fromIterable([0xce, 0x80])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after three U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after four U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after five U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after six U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after seven U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after eight U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after nine U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after ten U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after eleven U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after twelve U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after thirteen U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after fourteen U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after fifteen U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0xce, 0x80, 0xd9, 0xe8, 0xce, 0x5e, 0x5a, 0x09, 0xcb, 0x56, 0x48, 0x5c, 0xe6, 0xd3, 0x48])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after sixteen U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after seventeen U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after eighteen U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after nineteen U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after twenty U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd8])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after twenty-one U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd8, 0xf5])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after twenty-two U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd8, 0xf5, 0x1f])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after twenty-three U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd8, 0xf5, 0x1f, 0x18])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after twenty-four U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd8, 0xf5, 0x1f, 0x18, 0x02])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after twenty-five U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd8, 0xf5, 0x1f, 0x18, 0x02, 0x70])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after twenty-six U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd8, 0xf5, 0x1f, 0x18, 0x02, 0x70, 0x95])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after twenty-seven U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd8, 0xf5, 0x1f, 0x18, 0x02, 0x70, 0x95, 0x1a])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after twenty-eight U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd8, 0xf5, 0x1f, 0x18, 0x02, 0x70, 0x95, 0x1a, 0xed])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after twenty-nine U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd8, 0xf5, 0x1f, 0x18, 0x02, 0x70, 0x95, 0x1a, 0xed, 0xf6])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after thirty U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd8, 0xf5, 0x1f, 0x18, 0x02, 0x70, 0x95, 0x1a, 0xed, 0xf6, 0x5d])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after thirty-one U8s",
            () {
          expect(
                  () => Hash.deserialize(
                    StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd8, 0xf5, 0x1f, 0x18, 0x02, 0x70, 0x95, 0x1a, 0xed, 0xf6, 0x5d, 0x6e])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator includes invalid U8s",
            () {
          expect(
                  () => Hash.deserialize(
              StreamIterator(Stream.fromIterable(
                  [0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 300, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd8, 0xf5, 0x1f, 0x18, 0x02, 0x70, 0x95, 0x1a, 0xed, 0xf6, 0x5d, 0x6e, 0x2d])), "Example Description"),
              throwsA(predicate((e) =>
              e is RangeError &&
                  e.message ==
                      "Example Description - Value is out of range for a U8 (greater than 255).")));
        });

    test("returns the expected hash when the iterable ends", () async {
      final a = await Hash.deserialize(StreamIterator(Stream.fromIterable([0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd8, 0xf5, 0x1f, 0x18, 0x02, 0x70, 0x95, 0x1a, 0xed, 0xf6, 0x5d, 0x6e, 0x2d])), "Example Description A");
      final b = await Hash.deserialize(StreamIterator(Stream.fromIterable([0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd8, 0xf5, 0x1f, 0x18, 0x02, 0x70, 0x95, 0x1a, 0xed, 0xf6, 0x5d, 0x6e, 0x2d])), "Example Description B");
      final c = await Hash.deserialize(StreamIterator(Stream.fromIterable([0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd9, 0xf5, 0x1f, 0x18, 0x02, 0x70, 0x95, 0x1a, 0xed, 0xf6, 0x5d, 0x6e, 0x2d])), "Example Description C");

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a.toString(), equals(b.toString()));
      expect(a.toString(), equals("123052ea300b15f126ec185f3389f035c3d56bd8f51f180270951aedf65d6e2d"));
      expect(a, isNot(equals(c)));
      expect(a.hashCode, isNot(equals(c.hashCode)));
    });

    group("when the iterable does not end", () {
      final iterator = StreamIterator(Stream.fromIterable([0x12, 0x30, 0x52, 0xea, 0x30, 0x0b, 0x15, 0xf1, 0x26, 0xec, 0x18, 0x5f, 0x33, 0x89, 0xf0, 0x35, 0xc3, 0xd5, 0x6b, 0xd8, 0xf5, 0x1f, 0x18, 0x02, 0x70, 0x95, 0x1a, 0xed, 0xf6, 0x5d, 0x6e, 0x2d, 0x48, 0x07, 0xe5, 0x6e]));
      Hash output = Hash.of([], "Example Description");

      setUpAll(() async {
        output = await Hash.deserialize(iterator, "Example Description");
      });

      test("returns the expected hash", () {
        expect(output.toString(), equals("123052ea300b15f126ec185f3389f035c3d56bd8f51f180270951aedf65d6e2d"));
      });

      test("leaves the remaining U8s un-iterated", () async {
        final remaining = [];

        while (await iterator.moveNext()) {
          remaining.add(iterator.current);
        }

        expect(remaining, orderedEquals([0x48, 0x07, 0xe5, 0x6e]));
      });
    });

    test("treats deserialized and generate hashes the same", () async {
      final generated = Hash.of([0x14, 0x9a, 0xfb, 0xf4], "Example Description A");
      final deserialized = await Hash.deserialize(StreamIterator(Stream.fromIterable(generated.serialize())), "Example Description B");

      expect(generated, equals(deserialized));
      expect(generated.hashCode, equals(deserialized.hashCode));
      expect(generated.toString(), equals(deserialized.toString()));
    });
  });
}
