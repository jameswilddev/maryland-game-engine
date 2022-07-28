import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/attribute_id.dart';

void main() {
  test("has a lower bound", () {
    expect(attributeIdMin, equals(0));
  });

  test("has an upper bound", () {
    expect(attributeIdMax, equals(10460353202));
  });

  test("has a character set", () {
    expect(attributeIdCharacterSet, equals("_abcdefghijklmnopqrstuvwxyz"));
  });

  test("has a character set size", () {
    expect(attributeIdCharacterSetSize, equals(27));
  });

  test("has a length", () {
    expect(attributeIdLength, equals(7));
  });

  group("validateAttributeId", () {
    test("throws an exception two below the lower bound", () {
      expect(
              () => validateAttributeId(-2, "Example Description"),
          throwsA(predicate((e) =>
          e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for an attribute ID (less than 0).")));
    });

    test("throws an exception one below the lower bound", () {
      expect(
              () => validateAttributeId(-1, "Example Description"),
          throwsA(predicate((e) =>
          e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for an attribute ID (less than 0).")));
    });

    test("does nothing at the lower bound", () {
      expect(() => validateAttributeId(0, "Example Description"), returnsNormally);
    });

    test("does nothing between the lower and upper bounds", () {
      expect(() => validateAttributeId(3423462121, "Example Description"),
          returnsNormally);
    });

    test("does nothing at the upper bound", () {
      expect(() => validateAttributeId(10460353202, "Example Description"),
          returnsNormally);
    });

    test("throws an exception one above the upper bound", () {
      expect(
              () => validateAttributeId(10460353203, "Example Description"),
          throwsA(predicate((e) =>
          e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for an attribute ID (greater than 10460353202).")));
    });

    test("throws an exception two above the upper bound", () {
      expect(
              () => validateAttributeId(10460353204, "Example Description"),
          throwsA(predicate((e) =>
          e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for an attribute ID (greater than 10460353202).")));
    });
  });

  group("serializeAttributeId", () {
    test("validates the input", () {
      expect(
              () => serializeAttributeId(10460353203, "Example Description"),
          throwsA(predicate((e) =>
          e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for an attribute ID (greater than 10460353202).")));
    });

    test("returns the expected sequence of U8s", () {
      expect(serializeAttributeId(3464550888, "Example Description"),
          orderedEquals([0xce, 0x80, 0xd9, 0xe8]));
    });
  });

  group("deserializeAttributeId", () {
    test("throws the expected exception when the iterator ends immediately",
            () {
          expect(
              deserializeAttributeId(StreamIterator(const Stream.empty()), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after one U8",
            () {
          expect(
              deserializeAttributeId(StreamIterator(Stream.fromIterable([0xce])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after two U8s",
            () {
          expect(
                  () =>
                  deserializeAttributeId(StreamIterator(Stream.fromIterable([0xce, 0x80])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after three U8s",
            () {
          expect(
              deserializeAttributeId(
                  StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator includes invalid U8s",
            () {
          expect(
              deserializeAttributeId(
                  StreamIterator(Stream.fromIterable([0xce, 0x80, 300, 0xd9])), "Example Description"),
              throwsA(predicate((e) =>
              e is RangeError &&
                  e.message ==
                      "Example Description - Value is out of range for a U8 (greater than 255).")));
        });

    test("returns the expected attribute ID when the iterable ends", () async {
      expect(
          await deserializeAttributeId(
              StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8])), "Example Description"),
          equals(3464550888));
    });

    group("when the iterable does not end", () {
      final iterator = StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0x48, 0x07, 0xe5, 0x6e]));
      AttributeId output = 0;

      setUpAll(() async {
        output = await deserializeAttributeId(iterator, "Example Description");
      });

      test("returns the expected AttributeId", () {
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

  group("formatAttributeIdForDisplay", () {
    test("validates the input", () {
      expect(
              () => formatAttributeIdForDisplay(10460353203, "Example Description"),
          throwsA(predicate((e) =>
          e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for an attribute ID (greater than 10460353202).")));
    });

    test("can format 0", () {
      expect(formatAttributeIdForDisplay(0, "Example Description"), equals("_______"));
    });

    test("can format 1", () {
      expect(formatAttributeIdForDisplay(1, "Example Description"), equals("______a"));
    });

    test("can format 2", () {
      expect(formatAttributeIdForDisplay(2, "Example Description"), equals("______b"));
    });

    test("can format 27", () {
      expect(formatAttributeIdForDisplay(27, "Example Description"), equals("_____a_"));
    });

    test("can format 28", () {
      expect(formatAttributeIdForDisplay(28, "Example Description"), equals("_____aa"));
    });

    test("can format 10460353202", () {
      expect(formatAttributeIdForDisplay(10460353202, "Example Description"), equals("zzzzzzz"));
    });
  });

  group("parseAttributeId", () {
    test("rejects strings which are too short", () {
      expect(
              () => parseAttributeId("abcdef", "Example Description"),
          throwsA(predicate((e) =>
          e is RangeError &&
              e.message ==
                  "Example Description - Attribute IDs cannot be shorter than 7 characters.")));
    });

    test("rejects strings which are too long", () {
      expect(
              () => parseAttributeId("abcdefgh", "Example Description"),
          throwsA(predicate((e) =>
          e is RangeError &&
              e.message ==
                  "Example Description - Attribute IDs cannot be longer than 7 characters.")));
    });

    test("rejects strings which contain invalid characters", () {
      expect(
              () => parseAttributeId("abcFdef", "Example Description"),
          throwsA(predicate((e) =>
          e is RangeError &&
              e.message ==
                  "Example Description - Attribute IDs can only contain characters from the set _abcdefghijklmnopqrstuvwxyz.")));
    });

    test("can parse 0", () {
      expect(parseAttributeId("_______", "Example Description"), equals(0));
    });

    test("can parse 1", () {
      expect(parseAttributeId("______a", "Example Description"), equals(1));
    });

    test("can parse 2", () {
      expect(parseAttributeId("______b", "Example Description"), equals(2));
    });

    test("can parse 27", () {
      expect(parseAttributeId("_____a_", "Example Description"), equals(27));
    });

    test("can parse 28", () {
      expect(parseAttributeId("_____aa", "Example Description"), equals(28));
    });

    test("can parse 10460353202", () {
      expect(parseAttributeId("zzzzzzz", "Example Description"), equals(10460353202));
    });
  });
}
