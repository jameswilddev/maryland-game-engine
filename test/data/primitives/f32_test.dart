import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/f32.dart';

void main() {
  group("validateF32", () {
    test("does nothing for zero", () {
      expect(() => validateF32(0, "Example Description"), returnsNormally);
    });

    test("does nothing for negative values", () {
      expect(() => validateF32(-8.217036431108157E24, "Example Description"), returnsNormally);
    });

    test("does nothing for positive values", () {
      expect(() => validateF32(8.217036431108157E24, "Example Description"), returnsNormally);
    });

    test("does nothing for positive infinity", () {
      expect(() => validateF32(double.infinity, "Example Description"), returnsNormally);
    });

    test("does nothing for negative infinity", () {
      expect(() => validateF32(double.negativeInfinity, "Example Description"), returnsNormally);
    });

    test("does nothing for NaN", () {
      expect(() => validateF32(double.nan, "Example Description"), returnsNormally);
    });
  });

  test("serializeF32 returns the expected sequence of U8s", () {
    expect(serializeF32(-8.217036431108157E24, "Example Description"), orderedEquals([0xce, 0x80, 0xd9, 0xe8]));
  });

  group("deserializeF32", () {
    test("throws the expected exception when the iterator ends immediately",
        () {
      expect(
          deserializeF32(StreamIterator(const Stream.empty()), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator ends after one U8",
        () {
      expect(
          deserializeF32(StreamIterator(Stream.fromIterable([0xce])), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator ends after two U8s",
        () {
      expect(
          () =>
              deserializeF32(StreamIterator(Stream.fromIterable([0xce, 0x80])), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator ends after three U8s",
        () {
      expect(
          deserializeF32(
          StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9])), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator includes invalid U8s",
        () {
      expect(
          deserializeF32(
          StreamIterator(Stream.fromIterable([0xce, 0x80, 300, 0xd9])), "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U8 (greater than 255).")));
    });

    test("returns the expected F32 when the iterable ends", () async {
      expect(
          await deserializeF32(
          StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8])), "Example Description"),
          equals(-8.217036431108157E24));
    });

    group("when the iterable does not end", () {
      final iterator = StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0x48, 0x07, 0xe5, 0x6e]));
      F32 output = 0;

      setUpAll(() async {
        output = await deserializeF32(iterator, "Example Description");
      });

      test("returns the expected F32", () {
        expect(output, equals(-8.217036431108157E24));
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
