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
          () => deserializeU8(<U8>[].iterator, "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of file.")));
    });

    test("throws the expected exception when the iterator includes invalid U8s",
        () {
      expect(
          () => deserializeU8(<U8>[300].iterator, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U8 (greater than 255).")));
    });

    test("returns the expected U8 when the iterable ends", () {
      expect(
          deserializeU8([0xce].iterator, "Example Description"), equals(0xce));
    });

    group("when the iterable does not end", () {
      Iterator<U8> iterator = <U8>[].iterator;
      U8 output = 0;

      setUpAll(() {
        iterator = [0xce, 0x48, 0x07, 0xe5, 0x6e].iterator;
        output = deserializeU8(iterator, "Example Description");
      });

      test("returns the expected U8", () {
        expect(output, equals(0xce));
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
