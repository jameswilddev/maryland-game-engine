import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/primitives/color.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';

void main() {
  test("equal", () {
    const red = 0xe6;
    const green = 0x03;
    const blue = 0x48;
    const opacity = 0x36;

    final a = Color(red, green, blue, opacity);
    final b = Color(red, green, blue, opacity);

    expect(a.red, equals(red));
    expect(a.green, equals(green));
    expect(a.blue, equals(blue));
    expect(a.opacity, equals(opacity));
    expect(a, equals(b));
    expect(a.hashCode, equals(b.hashCode));
    expect(a.toString(), equals("#e6034836"));
    expect(a.serialize(), orderedEquals([0xe6, 0x03, 0x48, 0x36]));
  });

  test("unequal red", () {
    const green = 0x03;
    const blue = 0x48;
    const opacity = 0x36;

    final a = Color(0xce, green, blue, opacity);
    final b = Color(0x5a, green, blue, opacity);

    expect(a, isNot(equals(b)));
    expect(a.hashCode, isNot(equals(b.hashCode)));
  });

  test("unequal green", () {
    const red = 0xe6;
    const blue = 0x48;
    const opacity = 0x36;

    final a = Color(red, 0xce, blue, opacity);
    final b = Color(red, 0x5a, blue, opacity);

    expect(a, isNot(equals(b)));
    expect(a.hashCode, isNot(equals(b.hashCode)));
  });

  test("unequal blue", () {
    const red = 0xe6;
    const green = 0x03;
    const opacity = 0x36;

    final a = Color(red, green, 0xce, opacity);
    final b = Color(red, green, 0x5a, opacity);

    expect(a, isNot(equals(b)));
    expect(a.hashCode, isNot(equals(b.hashCode)));
  });

  test("unequal opacity", () {
    const red = 0xe6;
    const green = 0x03;
    const blue = 0x48;

    final a = Color(red, green, blue, 0xce);
    final b = Color(red, green, blue, 0x5a);

    expect(a, isNot(equals(b)));
    expect(a.hashCode, isNot(equals(b.hashCode)));
  });

  group("deserialize", () {
    test("throws the expected exception when the iterator ends immediately",
        () {
      expect(
          () => Color.deserialize(StreamIterator(const Stream.empty()), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description (red intensity) - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator ends after one U8",
        () {
      expect(
          () => Color.deserialize(StreamIterator(Stream.fromIterable([0xce])), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description (green intensity) - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator ends after two U8s",
        () {
      expect(
          () =>
              Color.deserialize(StreamIterator(Stream.fromIterable([0xce, 0x80])), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description (blue intensity) - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator ends after three U8s",
        () {
      expect(
          () => Color.deserialize(
          StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9])), "Example Description"),
          throwsA(predicate((e) =>
              e is StateError &&
              e.message == "Example Description (opacity) - Unexpected end of stream.")));
    });

    test("throws the expected exception when the iterator includes invalid U8s",
        () {
      expect(
          () => Color.deserialize(
          StreamIterator(Stream.fromIterable([0xce, 0x80, 300, 0xd9])), "Example Description"),
          throwsA(predicate((e) =>
              e is RangeError &&
              e.message ==
                  "Example Description (blue intensity) - Value is out of range for a U8 (greater than 255).")));
    });

    test("returns the expected color when the iterable ends", () async {
      expect(
          await Color.deserialize(
          StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8])), "Example Description"),
          equals(Color(0xce, 0x80, 0xd9, 0xe8)));
    });

    group("when the iterable does not end", () {
      final iterator = StreamIterator(Stream.fromIterable([0xce, 0x80, 0xd9, 0xe8, 0x48, 0x07, 0xe5, 0x6e]));
      Color output = Color(0, 0, 0, 0);

      setUpAll(() async {
        output = await Color.deserialize(iterator, "Example Description");
      });

      test("returns the expected color", () {
        expect(output, equals(Color(0xce, 0x80, 0xd9, 0xe8)));
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
