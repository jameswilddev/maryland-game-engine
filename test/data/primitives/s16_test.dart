import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/s16.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

void main() {
  test("has a lower bound", () {
    expect(s16Min, equals(-32768));
  });

  test("has an upper bound", () {
    expect(s16Max, equals(32767));
  });

  group("validateS16", () {
    test("throws an exception two below the lower bound", () {
      expect(
          () => validateS16(-32770, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a S16 (less than -32768).")));
    });

    test("throws an exception one below the lower bound", () {
      expect(
          () => validateS16(-32769, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a S16 (less than -32768).")));
    });

    test("does nothing at the lower bound", () {
      expect(() => validateS16(-32768, "Example Description"), returnsNormally);
    });

    test("does nothing between the lower and upper bounds", () {
      expect(() => validateS16(147, "Example Description"), returnsNormally);
    });

    test("does nothing at the upper bound", () {
      expect(() => validateS16(32767, "Example Description"), returnsNormally);
    });

    test("throws an exception one above the upper bound", () {
      expect(
          () => validateS16(32768, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a S16 (greater than 32767).")));
    });

    test("throws an exception two above the upper bound", () {
      expect(
          () => validateS16(32769, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a S16 (greater than 32767).")));
    });
  });

  group("serializeS16", () {
    test("validates the input", () {
      expect(
          () => serializeS16(65536, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a S16 (greater than 32767).")));
    });

    test("returns the expected sequence of U8s", () {
      expect(serializeS16(-32562, "Example Description"),
          orderedEquals([0xce, 0x80]));
    });
  });

  group("deserializeS16", () {
    test("throws the expected exception when the iterator ends immediately",
        () {
      expect(
          deserializeS16(StreamIterator(const Stream.empty()), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator ends after one U8",
        () {
      expect(
          deserializeS16(StreamIterator(Stream.fromIterable([0xce])), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator includes invalid U8s",
        () {
      expect(
          deserializeS16(StreamIterator(Stream.fromIterable([0xce, 300])), "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U8 (greater than 255).")));
    });

    test("returns the expected S16 when the iterable ends", () async {
      expect(await deserializeS16(StreamIterator(Stream.fromIterable([0xce, 0x80])), "Example Description"),
          equals(-32562));
    });

    group("when the iterable does not end", () {
      final iterator = StreamIterator(Stream.fromIterable([0xce, 0x80, 0x48, 0x07, 0xe5, 0x6e]));
      S16 output = 0;

      setUpAll(() async {
        output = await deserializeS16(iterator, "Example Description");
      });

      test("returns the expected S16", () {
        expect(output, equals(-32562));
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
