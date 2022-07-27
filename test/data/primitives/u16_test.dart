import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/u16.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

void main() {
  test("has a lower bound", () {
    expect(u16Min, equals(0));
  });

  test("has an upper bound", () {
    expect(u16Max, equals(65535));
  });

  group("validateU16", () {
    test("throws an exception two below the lower bound", () {
      expect(
          () => validateU16(-2, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U16 (less than 0).")));
    });

    test("throws an exception one below the lower bound", () {
      expect(
          () => validateU16(-1, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U16 (less than 0).")));
    });

    test("does nothing at the lower bound", () {
      expect(() => validateU16(0, "Example Description"), returnsNormally);
    });

    test("does nothing between the lower and upper bounds", () {
      expect(() => validateU16(32821, "Example Description"), returnsNormally);
    });

    test("does nothing at the upper bound", () {
      expect(() => validateU16(65535, "Example Description"), returnsNormally);
    });

    test("throws an exception one above the upper bound", () {
      expect(
          () => validateU16(65536, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U16 (greater than 65535).")));
    });

    test("throws an exception two above the upper bound", () {
      expect(
          () => validateU16(65537, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U16 (greater than 65535).")));
    });
  });

  group("serializeU16", () {
    test("validates the input", () {
      expect(
          () => serializeU16(65536, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U16 (greater than 65535).")));
    });

    test("returns the expected sequence of U8s", () {
      expect(serializeU16(52864, "Example Description"),
          orderedEquals([0xce, 0x80]));
    });
  });

  group("deserializeU16", () {
    test("throws the expected exception when the iterator ends immediately",
        () {
      expect(
          deserializeU16(StreamIterator(const Stream.empty()), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator ends after one U8",
        () {
      expect(
          deserializeU16(StreamIterator(Stream.fromIterable([0xce])), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator includes invalid U8s",
        () {
      expect(
          deserializeU16(StreamIterator(Stream.fromIterable([0xce, 300])), "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U8 (greater than 255).")));
    });

    test("returns the expected U16 when the iterable ends", () async {
      expect(await deserializeU16(StreamIterator(Stream.fromIterable([0xce, 0x80])), "Example Description"),
          equals(52864));
    });

    group("when the iterable does not end", () {
      final iterator = StreamIterator(Stream.fromIterable([0xce, 0x80, 0x48, 0x07, 0xe5, 0x6e]));
      U16 output = 0;

      setUpAll(() async {
        output = await deserializeU16(iterator, "Example Description");
      });

      test("returns the expected U16", () {
        expect(output, equals(52864));
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
