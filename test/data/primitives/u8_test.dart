import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

void main() {
  test("has a lower bound", () {
    expect(u8Min, equals(0));
  });

  test("has an upper bound", () {
    expect(u8Max, equals(255));
  });

  group("validateU8", () {
    test("throws an exception two below the lower bound", () {
      expect(
          () => validateU8(-2, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U8 (less than 0).")));
    });

    test("throws an exception one below the lower bound", () {
      expect(
          () => validateU8(-1, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U8 (less than 0).")));
    });

    test("does nothing at the lower bound", () {
      expect(() => validateU8(0, "Example Description"), returnsNormally);
    });

    test("does nothing between the lower and upper bounds", () {
      expect(() => validateU8(147, "Example Description"), returnsNormally);
    });

    test("does nothing at the upper bound", () {
      expect(() => validateU8(255, "Example Description"), returnsNormally);
    });

    test("throws an exception one above the upper bound", () {
      expect(
          () => validateU8(256, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U8 (greater than 255).")));
    });

    test("throws an exception two above the upper bound", () {
      expect(
          () => validateU8(257, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U8 (greater than 255).")));
    });
  });

  group("serializeU8", () {
    test("validates the input", () {
      expect(
          () => serializeU8(65536, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U8 (greater than 255).")));
    });

    test("returns the expected sequence of U8s", () {
      expect(serializeU8(0xce, "Example Description"), orderedEquals([0xce]));
    });
  });

  group("deserializeU8", () {
    test("throws the expected exception when the iterator ends immediately",
        () {
      expect(
          deserializeU8(StreamIterator(const Stream.empty()), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator includes invalid U8s",
        () {
      expect(
          deserializeU8(StreamIterator(Stream.fromIterable([300])), "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U8 (greater than 255).")));
    });

    test("returns the expected U8 when the iterable ends", () async {
      expect(
          await deserializeU8(StreamIterator(Stream.fromIterable([0xce])), "Example Description"), equals(0xce));
    });

    group("when the iterable does not end", () {
      final iterator = StreamIterator(Stream.fromIterable([0xce, 0x48, 0x07, 0xe5, 0x6e]));
      U8 output = 0;

      setUpAll(() async {
        output = await deserializeU8(iterator, "Example Description");
      });

      test("returns the expected U8", () {
        expect(output, equals(0xce));
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

  group("deserializeU8s", () {
    test("throws the expected exception when the quantity is negative one",
            () {
          expect(
              deserializeU8s(StreamIterator(Stream.fromIterable([0xce, 0x48, 0x07])), "Example Description", -1).toList(),
              throwsA(predicate((e) =>
              e is RangeError &&
                  e.message == "Example Description - Cannot deserialize a negative quantity of bytes.")));
        });

    test("throws the expected exception when the quantity is negative two",
            () {
          expect(
              deserializeU8s(StreamIterator(Stream.fromIterable([0xce, 0x48, 0x07])), "Example Description", -2).toList(),
              throwsA(predicate((e) =>
              e is RangeError &&
                  e.message == "Example Description - Cannot deserialize a negative quantity of bytes.")));
        });

    test("throws the expected exception when the iterator ends too early",
            () {
          expect(
              deserializeU8s(StreamIterator(Stream.fromIterable([0xce, 0x48])), "Example Description", 3).toList(),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator includes invalid U8s",
            () {
          expect(
              deserializeU8s(StreamIterator(Stream.fromIterable([0xce, 300, 0x07])), "Example Description", 3).toList(),
              throwsA(predicate((e) =>
              e is RangeError &&
                  e.message ==
                      "Example Description - Value is out of range for a U8 (greater than 255).")));
        });

    test("returns the expected U8 when none are required", () async {
      expect(
          await deserializeU8s(StreamIterator(const Stream.empty()), "Example Description", 0).toList(),
          isEmpty);
    });

    test("returns the expected U8 when the iterable ends", () async {
      expect(
          await deserializeU8s(StreamIterator(Stream.fromIterable([0xce, 0x48, 0x07])), "Example Description", 3).toList(),
          orderedEquals([0xce, 0x48, 0x07]));
    });

    group("when the iterable does not end", () {
      final iterator = StreamIterator(Stream.fromIterable([0xce, 0x48, 0x07, 0xe5, 0x6e]));
      var output = <U8>[];

      setUpAll(() async {
        output = await deserializeU8s(iterator, "Example Description", 3).toList();
      });

      test("returns the expected U8s", () {
        expect(output, orderedEquals([0xce, 0x48, 0x07]));
      });

      test("leaves the remaining U8s un-iterated", () async {
        final remaining = [];

        while (await iterator.moveNext()) {
          remaining.add(iterator.current);
        }

        expect(remaining, orderedEquals([0xe5, 0x6e]));
      });
    });
  });
}
