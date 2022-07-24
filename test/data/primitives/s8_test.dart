import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/s8.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

void main() {
  test("has a lower bound", () {
    expect(s8Min, equals(-128));
  });

  test("has an upper bound", () {
    expect(s8Max, equals(127));
  });

  group("validateS8", () {
    test("throws an exception two below the lower bound", () {
      expect(
          () => validateS8(-130, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a S8 (less than -128).")));
    });

    test("throws an exception one below the lower bound", () {
      expect(
          () => validateS8(-129, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a S8 (less than -128).")));
    });

    test("does nothing at the lower bound", () {
      expect(() => validateS8(-128, "Example Description"), returnsNormally);
    });

    test("does nothing between the lower and upper bounds", () {
      expect(() => validateS8(14, "Example Description"), returnsNormally);
    });

    test("does nothing at the upper bound", () {
      expect(() => validateS8(127, "Example Description"), returnsNormally);
    });

    test("throws an exception one above the upper bound", () {
      expect(
          () => validateS8(128, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a S8 (greater than 127).")));
    });

    test("throws an exception two above the upper bound", () {
      expect(
          () => validateS8(129, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a S8 (greater than 127).")));
    });
  });

  group("serializeS8", () {
    test("validates the input", () {
      expect(
          () => serializeS8(65536, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a S8 (greater than 127).")));
    });

    test("returns the expected sequence of U8s", () {
      expect(serializeS8(-50, "Example Description"), orderedEquals([0xce]));
    });
  });

  group("deserializeS8", () {
    test("throws the expected exception when the iterator ends immediately",
        () {
      expect(
          () => deserializeS8(<U8>[].iterator, "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of file.")));
    });

    test("throws the expected exception when the iterator includes invalid U8s",
        () {
      expect(
          () => deserializeS8(<U8>[300].iterator, "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U8 (greater than 255).")));
    });

    test("returns the expected S8 when the iterable ends", () {
      expect(
          deserializeS8([0xce].iterator, "Example Description"), equals(-50));
    });

    group("when the iterable does not end", () {
      Iterator<U8> iterator = <U8>[].iterator;
      S8 output = 0;

      setUpAll(() {
        iterator = [0xce, 0x48, 0x07, 0xe5, 0x6e].iterator;
        output = deserializeS8(iterator, "Example Description");
      });

      test("returns the expected U8", () {
        expect(output, equals(-50));
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
