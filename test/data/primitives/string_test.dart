import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/string.dart';

void main() {
  group("validateString", () {
    test("does nothing when empty", () {
      expect(() => validateString("", "Example Description"), returnsNormally);
    });

    test("does nothing when one byte shorter than the length limit", () {
      expect(() => validateString("${"𩸽" * 16382}あ§a", "Example Description"), returnsNormally);
    });

    test("does nothing when at the length limit", () {
      expect(() => validateString("${"𩸽" * 16382}あ§aa", "Example Description"), returnsNormally);
    });

    test("throws an exception when one byte longer than the length limit", () {
      expect(
              () => validateString("${"𩸽" * 16382}あ§aaa", "Example Description"),
          throwsA(predicate((e) =>
          e is RangeError &&
              e.message ==
                  "Example Description - Value contains too many bytes when UTF-8 encoded (greater than 65535).")));
    });

    test("throws an exception when two bytes longer than the length limit", () {
      expect(
              () => validateString("${"𩸽" * 16382}あ§aaaa", "Example Description"),
          throwsA(predicate((e) =>
          e is RangeError &&
              e.message ==
                  "Example Description - Value contains too many bytes when UTF-8 encoded (greater than 65535).")));
    });
  });

  group("serializeString", () {
    test("can serialize an empty string", () {
      expect(serializeString("", "Example Description").toList(), orderedEquals([0, 0]));
    });

    test("can serialize a non-empty string", () {
      expect(serializeString("Test §あ𩸽 Value", "Example Description").toList(), orderedEquals([0, 20, 0x54, 0x65, 0x73, 0x74, 0x20, 0xc2, 0xa7, 0xe3, 0x81, 0x82, 0xf0, 0xa9, 0xb8, 0xbd, 0x20, 0x56, 0x61, 0x6c, 0x75, 0x65]));
    });

    test("does not throw when one byte shorter than the length limit", () {
      expect(() => serializeString("${"𩸽" * 16382}あ§a", "Example Description").toList(), returnsNormally);
    });

    test("does not throw when at the length limit", () {
      expect(() => serializeString("${"𩸽" * 16382}あ§aa", "Example Description").toList(), returnsNormally);
    });

    test("throws an exception when one byte longer than the length limit", () {
      expect(
              () => serializeString("${"𩸽" * 16382}あ§aaa", "Example Description").toList(),
          throwsA(predicate((e) =>
          e is RangeError &&
              e.message ==
                  "Example Description - Value contains too many bytes when UTF-8 encoded (greater than 65535).")));
    });

    test("throws an exception when two bytes longer than the length limit", () {
      expect(
              () => serializeString("${"𩸽" * 16382}あ§aaaa", "Example Description").toList(),
          throwsA(predicate((e) =>
          e is RangeError &&
              e.message ==
                  "Example Description - Value contains too many bytes when UTF-8 encoded (greater than 65535).")));
    });
  });

  group("deserializeString", () {
    test("throws the expected exception when the iterator ends immediately",
            () {
          expect(
              deserializeString(StreamIterator(const Stream.empty()), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after one U8",
            () {
          expect(
              deserializeString(StreamIterator(Stream.fromIterable([20])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends after two U8s",
            () {
          expect(
                  () =>
                      deserializeString(StreamIterator(Stream.fromIterable([20, 0])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator ends before the string is fully described",
            () {
          expect(
              deserializeString(
                  StreamIterator(Stream.fromIterable([0, 20, 0x54, 0x65, 0x73, 0x74, 0x20, 0xc2, 0xa7, 0xe3, 0x81, 0x82, 0xf0, 0xa9, 0xb8, 0xbd, 0x20, 0x56, 0x61])), "Example Description"),
              throwsA(predicate((e) =>
              e is StateError &&
                  e.message == "Example Description - Unexpected end of stream.")));
        });

    test("throws the expected exception when the iterator includes invalid U8s",
            () {
          expect(
              deserializeString(
                  StreamIterator(Stream.fromIterable([0, 20, 0x54, 0x65, 0x73, 0x74, 0x20, 300, 0xa7, 0xe3, 0x81, 0x82, 0xf0, 0xa9, 0xb8, 0xbd, 0x20, 0x56, 0x61, 0x6c, 0x75, 0x65])), "Example Description"),
              throwsA(predicate((e) =>
              e is RangeError &&
                  e.message ==
                      "Example Description - Value is out of range for a U8 (greater than 255).")));
        });

    test("returns the expected string when the iterable ends", () async {
      expect(
          await deserializeString(
              StreamIterator(Stream.fromIterable([0, 20, 0x54, 0x65, 0x73, 0x74, 0x20, 0xc2, 0xa7, 0xe3, 0x81, 0x82, 0xf0, 0xa9, 0xb8, 0xbd, 0x20, 0x56, 0x61, 0x6c, 0x75, 0x65])), "Example Description"),
          equals("Test §あ𩸽 Value"));
    });

    group("when the iterable does not end", () {
      final iterator = StreamIterator(Stream.fromIterable([0, 20, 0x54, 0x65, 0x73, 0x74, 0x20, 0xc2, 0xa7, 0xe3, 0x81, 0x82, 0xf0, 0xa9, 0xb8, 0xbd, 0x20, 0x56, 0x61, 0x6c, 0x75, 0x65, 0x48, 0x07, 0xe5, 0x6e]));
      var output = "";

      setUpAll(() async {
        output = await deserializeString(iterator, "Example Description");
      });

      test("returns the expected string", () {
        expect(output, equals("Test §あ𩸽 Value"));
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
