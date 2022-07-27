import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/s32.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

void main() {
  test("has a lower bound", () {
    expect(s32Min, equals(-2147483648));
  });

  test("has an upper bound", () {
    expect(s32Max, equals(2147483647));
  });

  group("validateS32", () {
    test("throws an exception two below the lower bound", () {
      expect(
          () => validateS32(-2147483650, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a S32 (less than -2147483648).")));
    });

    test("throws an exception one below the lower bound", () {
      expect(
          () => validateS32(-2147483649, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a S32 (less than -2147483648).")));
    });

    test("does nothing at the lower bound", () {
      expect(() => validateS32(-2147483648, "Example Description"),
          returnsNormally);
    });

    test("does nothing between the lower and upper bounds", () {
      expect(() => validateS32(147, "Example Description"), returnsNormally);
    });

    test("does nothing at the upper bound", () {
      expect(() => validateS32(2147483647, "Example Description"),
          returnsNormally);
    });

    test("throws an exception one above the upper bound", () {
      expect(
          () => validateS32(2147483648, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a S32 (greater than 2147483647).")));
    });

    test("throws an exception two above the upper bound", () {
      expect(
          () => validateS32(2147483649, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a S32 (greater than 2147483647).")));
    });
  });

  group("serializeS32", () {
    test("validates the input", () {
      expect(
          () => serializeS32(4294967296, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a S32 (greater than 2147483647).")));
    });

    test("returns the expected sequence of U8s", () {
      expect(serializeS32(-388398898, "Example Description"),
          orderedEquals([0xce, 0x80, 0xd9, 0xe8]));
    });
  });

  group("deserializeS32", () {
    test("throws the expected exception when the iterator ends immediately",
        () {
      expect(
          deserializeS32(StreamIterator(const Stream.empty()), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator ends after one U8",
        () {
      expect(
          deserializeS32(StreamIterator(Stream.fromIterable([0xce])), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator ends after two U8s",
        () {
      expect(
          () =>
              deserializeS32(StreamIterator(Stream.fromIterable([0xce, 0x80])), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator ends after three U8s",
        () {
      expect(
          deserializeS32(
          StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9])), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator includes invalid U8s",
        () {
      expect(
          deserializeS32(
          StreamIterator(Stream.fromIterable([0xce, 0x80, 300, 0xd9])), "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U8 (greater than 255).")));
    });

    test("returns the expected S32 when the iterable ends", () async {
      expect(
          await deserializeS32(
          StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8])), "Example Description"),
          equals(-388398898));
    });

    group("when the iterable does not end", () {
      final iterator = StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0x48, 0x07, 0xe5, 0x6e]));
      S32 output = 0;

      setUpAll(() async {
        output = await deserializeS32(iterator, "Example Description");
      });

      test("returns the expected S32", () {
        expect(output, equals(-388398898));
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
