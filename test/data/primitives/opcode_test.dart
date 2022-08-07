import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/opcode.dart';

void main() {
  group("serializeOpcode", () {
      test("can serialize setEntityAttributeU8", () {
        expect(serializeOpcode(Opcode.setEntityAttributeU8), orderedEquals([0]));
      });

      test("can serialize setEntityAttributeU16", () {
        expect(serializeOpcode(Opcode.setEntityAttributeU16), orderedEquals([1]));
      });

      test("can serialize setEntityAttributeU32", () {
        expect(serializeOpcode(Opcode.setEntityAttributeU32), orderedEquals([2]));
      });

      test("can serialize setEntityAttributeS8", () {
        expect(serializeOpcode(Opcode.setEntityAttributeS8), orderedEquals([3]));
      });

      test("can serialize setEntityAttributeS16", () {
        expect(serializeOpcode(Opcode.setEntityAttributeS16), orderedEquals([4]));
      });

      test("can serialize setEntityAttributeS32", () {
        expect(serializeOpcode(Opcode.setEntityAttributeS32), orderedEquals([5]));
      });

      test("can serialize setEntityAttributeF32", () {
        expect(serializeOpcode(Opcode.setEntityAttributeF32), orderedEquals([6]));
      });

      test("can serialize setEntityAttributeString", () {
        expect(serializeOpcode(Opcode.setEntityAttributeString), orderedEquals([7]));
      });

      test("can serialize setEntityAttributeReference", () {
        expect(serializeOpcode(Opcode.setEntityAttributeReference), orderedEquals([8]));
      });

      test("can serialize setEntityAttributeFlag", () {
        expect(serializeOpcode(Opcode.setEntityAttributeFlag), orderedEquals([9]));
      });

      test("can serialize clearEntityAttributeFlag", () {
        expect(serializeOpcode(Opcode.clearEntityAttributeFlag), orderedEquals([10]));
      });
  });

  group("deserializeOpcode", () {
    test("throws the expected exception when the iterator ends immediately",
        () {
      expect(
          deserializeOpcode(StreamIterator(const Stream.empty()), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator includes invalid U8s",
        () {
      expect(
          deserializeOpcode(StreamIterator(Stream.fromIterable([300])), "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description - Value is out of range for a U8 (greater than 255).")));
    });

    test("returns the expected opcode when the iterable ends", () async {
      expect(
          await deserializeOpcode(StreamIterator(Stream.fromIterable([0])), "Example Description"), equals(Opcode.setEntityAttributeU8));
    });

    test("can deserialize setEntityAttributeU16", () async {
      expect(
          await deserializeOpcode(StreamIterator(Stream.fromIterable([1])), "Example Description"), equals(Opcode.setEntityAttributeU16));
    });

    test("can deserialize setEntityAttributeU32", () async {
      expect(
          await deserializeOpcode(StreamIterator(Stream.fromIterable([2])), "Example Description"), equals(Opcode.setEntityAttributeU32));
    });

    test("can deserialize setEntityAttributeS8", () async {
      expect(
          await deserializeOpcode(StreamIterator(Stream.fromIterable([3])), "Example Description"), equals(Opcode.setEntityAttributeS8));
    });

    test("can deserialize setEntityAttributeS16", () async {
      expect(
          await deserializeOpcode(StreamIterator(Stream.fromIterable([4])), "Example Description"), equals(Opcode.setEntityAttributeS16));
    });

    test("can deserialize setEntityAttributeS32", () async {
      expect(
          await deserializeOpcode(StreamIterator(Stream.fromIterable([5])), "Example Description"), equals(Opcode.setEntityAttributeS32));
    });

    test("can deserialize setEntityAttributeF32", () async {
      expect(
          await deserializeOpcode(StreamIterator(Stream.fromIterable([6])), "Example Description"), equals(Opcode.setEntityAttributeF32));
    });

    test("can deserialize setEntityAttributeString", () async {
      expect(
          await deserializeOpcode(StreamIterator(Stream.fromIterable([7])), "Example Description"), equals(Opcode.setEntityAttributeString));
    });

    test("can deserialize setEntityAttributeReference", () async {
      expect(
          await deserializeOpcode(StreamIterator(Stream.fromIterable([8])), "Example Description"), equals(Opcode.setEntityAttributeReference));
    });

    test("can deserialize setEntityAttributeFlag", () async {
      expect(
          await deserializeOpcode(StreamIterator(Stream.fromIterable([9])), "Example Description"), equals(Opcode.setEntityAttributeFlag));
    });

    test("can deserialize clearEntityAttributeFlag", () async {
      expect(
          await deserializeOpcode(StreamIterator(Stream.fromIterable([10])), "Example Description"), equals(Opcode.clearEntityAttributeFlag));
    });

    test("throws the expected exception when the iterator includes invalid U8s",
            () {
          expect(
              deserializeOpcode(StreamIterator(Stream.fromIterable([11])), "Example Description"),
              throwsA(predicate((e) =>
              e is RangeError &&
                  e.message ==
                      "Example Description - Value is out of range for an opcode (greater than 10).")));
        });

    test("throws the expected exception when the iterator includes invalid U8s",
            () {
          expect(
              deserializeOpcode(StreamIterator(Stream.fromIterable([12])), "Example Description"),
              throwsA(predicate((e) =>
              e is RangeError &&
                  e.message ==
                      "Example Description - Value is out of range for an opcode (greater than 10).")));
        });

    group("when the iterable does not end", () {
      final iterator = StreamIterator(Stream.fromIterable([0, 0x48, 0x07, 0xe5, 0x6e]));
      Opcode output = Opcode.setEntityAttributeU8;

      setUpAll(() async {
        output = await deserializeOpcode(iterator, "Example Description");
      });

      test("returns the expected opcode", () {
        expect(output, equals(Opcode.setEntityAttributeU8));
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
