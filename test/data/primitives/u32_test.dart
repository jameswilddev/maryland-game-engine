import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';
import 'package:maryland_game_engine/data/primitives/u32.dart';

void main() {
  test("has a lower bound", () {
    expect(u32Min, equals(0));
  });

  test("has an upper bound", () {
    expect(u32Max, equals(4294967295));
  });

  group("validateU32", () {
    test("throws an exception two below the lower bound", () {
      expect(
          () => validateU32(-2, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U32 (less than 0).")));
    });

    test("throws an exception one below the lower bound", () {
      expect(
          () => validateU32(-1, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U32 (less than 0).")));
    });

    test("does nothing at the lower bound", () {
      expect(() => validateU32(0, "Example Description"), returnsNormally);
    });

    test("does nothing between the lower and upper bounds", () {
      expect(() => validateU32(3423462121, "Example Description"),
          returnsNormally);
    });

    test("does nothing at the upper bound", () {
      expect(() => validateU32(4294967295, "Example Description"),
          returnsNormally);
    });

    test("throws an exception one above the upper bound", () {
      expect(
          () => validateU32(4294967296, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U32 (greater than 4294967295).")));
    });

    test("throws an exception two above the upper bound", () {
      expect(
          () => validateU32(4294967297, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U32 (greater than 4294967295).")));
    });
  });

  group("serializeU32", () {
    test("validates the input", () {
      expect(
          () => serializeU32(4294967296, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U32 (greater than 4294967295).")));
    });

    test("returns the expected sequence of U8s", () {
      expect(serializeU32(3464550888, "Example Description"),
          orderedEquals([0xce, 0x80, 0xd9, 0xe8]));
    });
  });

  group("deserializeU32", () {
    test("throws the expected exception when the iterator ends immediately",
        () {
      expect(
          deserializeU32(StreamIterator(const Stream.empty()), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator ends after one U8",
        () {
      expect(
          deserializeU32(StreamIterator(Stream.fromIterable([0xce])), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator ends after two U8s",
        () {
      expect(
          () =>
              deserializeU32(StreamIterator(Stream.fromIterable([0xce, 0x80])), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator ends after three U8s",
        () {
      expect(
          deserializeU32(
          StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9])), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator includes invalid U8s",
        () {
      expect(
          deserializeU32(
          StreamIterator(Stream.fromIterable([0xce, 0x80, 300, 0xd9])), "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U8 (greater than 255).")));
    });

    test("returns the expected U32 when the iterable ends", () async {
      expect(
          await deserializeU32(
          StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8])), "Example Description"),
          equals(3464550888));
    });

    group("when the iterable does not end", () {
      final iterator = StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0x48, 0x07, 0xe5, 0x6e]));
      U32 output = 0;

      setUpAll(() async {
        output = await deserializeU32(iterator, "Example Description");
      });

      test("returns the expected U32", () {
        expect(output, equals(3464550888));
      });

      test("leaves the remaining U8s un-iterated", () async {
        final remaining = [];

        while (await iterator.moveNext()) {
          remaining.add(iterator.current);
        }

        expect(remaining, orderedEquals([0x48, 0x07, 0xe5, 0x6e]));
      });
    });
  });
}
