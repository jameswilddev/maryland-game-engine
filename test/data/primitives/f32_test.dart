import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/f32.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

void main() {
  test("serializeF32 returns the expected sequence of U8s", () {
    expect(serializeF32(-8.217036431108157E24), orderedEquals([0xce, 0x80, 0xd9, 0xe8]));
  });

  group("deserializeF32", () {
    test("throws the expected exception when the iterator ends immediately",
        () {
      expect(
          () => deserializeF32(<U8>[].iterator, "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of file.")));
    });

    test("throws the expected exception when the iterator ends after one U8",
        () {
      expect(
          () => deserializeF32(<U8>[0xce].iterator, "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of file.")));
    });

    test("throws the expected exception when the iterator ends after two U8s",
        () {
      expect(
          () =>
              deserializeF32(<U8>[0xce, 0x80].iterator, "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of file.")));
    });

    test("throws the expected exception when the iterator ends after three U8s",
        () {
      expect(
          () => deserializeF32(
              <U8>[0xce, 0x80, 0xd9].iterator, "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of file.")));
    });

    test("throws the expected exception when the iterator includes invalid U8s",
        () {
      expect(
          () => deserializeF32(
              <U8>[0xce, 0x80, 300, 0xd9].iterator, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U8 (greater than 255).")));
    });

    test("returns the expected F32 when the iterable ends", () {
      expect(
          deserializeF32(
              [0xce, 0x80, 0xd9, 0xe8].iterator, "Example Description"),
          equals(-8.217036431108157E24));
    });

    group("when the iterable does not end", () {
      Iterator<U8> iterator = <U8>[].iterator;
      F32 output = 0;

      setUpAll(() {
        iterator = [0xce, 0x80, 0xd9, 0xe8, 0x48, 0x07, 0xe5, 0x6e].iterator;
        output = deserializeF32(iterator, "Example Description");
      });

      test("returns the expected F32", () {
        expect(output, equals(-8.217036431108157E24));
      });

      test("leaves the remaining U8s un-iterated", () {
        final remaining = <U8>[];

        while (iterator.moveNext()) {
          remaining.add(iterator.current);
        }

        expect(remaining, orderedEquals([0x48, 0x07, 0xe5, 0x6e]));
      });
    });
  });
}
