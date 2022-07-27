import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/filesystem/patches/patch_metadata.dart';

void main() {
  test("equal", () {
    const timestamp = -35345352974832;
    const name = "test_name_123";

    final a = PatchMetadata(timestamp, name);
    final b = PatchMetadata(timestamp, name);

    expect(a.name, equals(name));
    expect(a, equals(b));
    expect(a.hashCode, equals(b.hashCode));
    expect(a.toString(), "-0000035345352974832 - test_name_123");
  });

  test("unequal name", () {
    const timestamp = -35345352974832;

    final a = PatchMetadata(timestamp, "test_name_1");
    final b = PatchMetadata(timestamp, "test_name_2");

    expect(a, isNot(equals(b)));
  });

  test("unequal timestamp", () {
    const name = "test_name_123";

    final a = PatchMetadata(-35345352974832, name);
    final b = PatchMetadata(-35345352974831, name);

    expect(a, isNot(equals(b)));
  });

  test("does not throw an error when the timestamp is at its minimum value", () {
    final patchMetadata = PatchMetadata(-9223372036854775808, "test_name_123");

    expect(patchMetadata.toString(), equals("-9223372036854775808 - test_name_123"));
  });

  test("does not throw an error when the timestamp is 0", () {
    final patchMetadata = PatchMetadata(0, "test_name_123");

    expect(patchMetadata.toString(), equals("+0000000000000000000 - test_name_123"));
  });

  test("does not throw an error when the timestamp is at its maximum value", () {
    final patchMetadata = PatchMetadata(9223372036854775807, "test_name_123");

    expect(patchMetadata.toString(), equals("+9223372036854775807 - test_name_123"));
  });

  test("does not throw an error when the name is of the minimum length", () {
    expect(() => PatchMetadata(-35345352974832, "a"), returnsNormally);
  });

  test("does not throw an error when the name is of the maximum length", () {
    expect(
        () => PatchMetadata(-35345352974832, "abcdefghij__________0123456789"), returnsNormally);
  });

  test("throws the expected exception when the name is empty", () {
    expect(
        () => PatchMetadata(-35345352974832, ""),
        throwsA(predicate((e) =>
            e is ArgumentError && e.message == "Patch names cannot be empty.")));
  });

  test(
      "throws the expected exception when the name is one character longer than permitted",
      () {
    expect(
        () => PatchMetadata(-35345352974832, "abcdefghij___________0123456789"),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message == "Patch names cannot exceed 30 characters in length.")));
  });

  test(
      "throws the expected exception when the name is two characters longer than permitted",
      () {
    expect(
        () => PatchMetadata(-35345352974832, "abcdefghij____________0123456789"),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message == "Patch names cannot exceed 30 characters in length.")));
  });

  test(
      "throws the expected exception when the name contains upper case letters",
      () {
    expect(
        () => PatchMetadata(-35345352974832, "abcdefghij___A__0123456789"),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message ==
                "Patch names can only contain the characters a-z, 0-9 and _.")));
  });

  test("throws the expected exception when the name contains spaces", () {
    expect(
        () => PatchMetadata(-35345352974832, "abcdefghij___ __0123456789"),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message ==
                "Patch names can only contain the characters a-z, 0-9 and _.")));
  });

  test("throws the expected exception when the name contains symbols", () {
    expect(
        () => PatchMetadata(-35345352974832, "abcdefghij___\$__0123456789"),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message ==
                "Patch names can only contain the characters a-z, 0-9 and _.")));
  });

  test("throws the expected exception when the name contains new lines", () {
    expect(
        () => PatchMetadata(-35345352974832, "abcdefghij___\n__0123456789"),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message ==
                "Patch names can only contain the characters a-z, 0-9 and _.")));
  });

  group("parse", () {
    test("can parse valid directory names", () {
      final actual = PatchMetadata.parse("-0000035345352974832 - example_game_name_123");

      expect(actual, equals(PatchMetadata(-35345352974832, "example_game_name_123")));
    });

    test("can parse directory names with the minimum permitted timestamp", () {
      final actual = PatchMetadata.parse("-9223372036854775808 - example_game_name_123");

      expect(actual, equals(PatchMetadata(-9223372036854775808, "example_game_name_123")));
    });

    test("can parse directory names with the maximum permitted timestamp", () {
      final actual = PatchMetadata.parse("+9223372036854775807 - example_game_name_123");

      expect(actual, equals(PatchMetadata(9223372036854775807, "example_game_name_123")));
    });

    test("can parse directory names with a negative zero timestamp", () {
      final actual = PatchMetadata.parse("-0000000000000000000 - example_game_name_123");

      expect(actual, equals(PatchMetadata(0, "example_game_name_123")));
    });

    test("can parse directory names with a positive zero timestamp", () {
      final actual = PatchMetadata.parse("+0000000000000000000 - example_game_name_123");

      expect(actual, equals(PatchMetadata(0, "example_game_name_123")));
    });

    test("can parse directory names with a minimum length name", () {
      final actual = PatchMetadata.parse("-0000035345352974832 - a");

      expect(actual, equals(PatchMetadata(-35345352974832, "a")));
    });

    test("can parse directory names with a maximum length name", () {
      final actual = PatchMetadata.parse("-0000035345352974832 - abcdefghij__________0123456789");

      expect(actual, equals(PatchMetadata(-35345352974832, "abcdefghij__________0123456789")));
    });

    test("throws the expected exception when the timestamp is lacking a sign", () {
      expect(
              () => PatchMetadata.parse("0000035345352974832 - abcdefghij__________0123456789"),
          throwsA(predicate((e) =>
          e is ArgumentError &&
              e.message ==
                  "The given directory name is not formatted like a patch.")));
    });

    test("throws the expected exception when the timestamp has an invalid sign", () {
      expect(
              () => PatchMetadata.parse("?0000035345352974832 - abcdefghij__________0123456789"),
          throwsA(predicate((e) =>
          e is ArgumentError &&
              e.message ==
                  "The given directory name is not formatted like a patch.")));
    });

    test("throws the expected exception when the timestamp is lacking a digit", () {
      expect(
              () => PatchMetadata.parse("-000035345352974832 - abcdefghij__________0123456789"),
          throwsA(predicate((e) =>
          e is ArgumentError &&
              e.message ==
                  "The given directory name is not formatted like a patch.")));
    });

    test("throws the expected exception when the timestamp has an excess digit", () {
      expect(
              () => PatchMetadata.parse("-00000035345352974832 - abcdefghij__________0123456789"),
          throwsA(predicate((e) =>
          e is ArgumentError &&
              e.message ==
                  "The given directory name is not formatted like a patch.")));
    });

    test("throws the expected exception when the timestamp contains non-digits", () {
      expect(
              () => PatchMetadata.parse("-000003a5345352974832 - abcdefghij__________0123456789"),
          throwsA(predicate((e) =>
          e is ArgumentError &&
              e.message ==
                  "The given directory name is not formatted like a patch.")));
    });

    test("throws the expected exception when the timestamp is one less than possible", () {
      expect(
              () => PatchMetadata.parse("-9223372036854775809 - abcdefghij__________0123456789"),
          throwsA(predicate((e) =>
          e is ArgumentError &&
              e.message ==
                  "Patch timestamps cannot be less than -9223372036854775808 or greater than 9223372036854775807.")));
    });

    test("throws the expected exception when the timestamp is two less than possible", () {
      expect(
              () => PatchMetadata.parse("-9223372036854775810 - abcdefghij__________0123456789"),
          throwsA(predicate((e) =>
          e is ArgumentError &&
              e.message ==
                  "Patch timestamps cannot be less than -9223372036854775808 or greater than 9223372036854775807.")));
    });

    test("throws the expected exception when the timestamp is one greater than possible", () {
      expect(
              () => PatchMetadata.parse("+9223372036854775808 - abcdefghij__________0123456789"),
          throwsA(predicate((e) =>
          e is ArgumentError &&
              e.message ==
                  "Patch timestamps cannot be less than -9223372036854775808 or greater than 9223372036854775807.")));
    });

    test("throws the expected exception when the timestamp is two greater than possible", () {
      expect(
              () => PatchMetadata.parse("+9223372036854775809 - abcdefghij__________0123456789"),
          throwsA(predicate((e) =>
          e is ArgumentError &&
              e.message ==
                  "Patch timestamps cannot be less than -9223372036854775808 or greater than 9223372036854775807.")));
    });

    test("throws the expected exception when the space before the hyphen is missing", () {
      expect(
              () => PatchMetadata.parse("-00000345345352974832- abcdefghij__________0123456789"),
          throwsA(predicate((e) =>
          e is ArgumentError &&
              e.message ==
                  "The given directory name is not formatted like a patch.")));
    });

    test("throws the expected exception when the hyphen is missing", () {
      expect(
              () => PatchMetadata.parse("-00000345345352974832  abcdefghij__________0123456789"),
          throwsA(predicate((e) =>
          e is ArgumentError &&
              e.message ==
                  "The given directory name is not formatted like a patch.")));
    });

    test("throws the expected exception when the space after the hyphen is missing", () {
      expect(
              () => PatchMetadata.parse("-00000345345352974832 -abcdefghij__________0123456789"),
          throwsA(predicate((e) =>
          e is ArgumentError &&
              e.message ==
                  "The given directory name is not formatted like a patch.")));
    });

    test("throws the expected exception when the name is empty", () {
      expect(
              () => PatchMetadata.parse("-00000345345352974832 - "),
          throwsA(predicate((e) =>
          e is ArgumentError &&
              e.message ==
                  "The given directory name is not formatted like a patch.")));
    });

    test(
        "throws the expected exception when the name is one character longer than permitted",
            () {
          expect(
                  () => PatchMetadata.parse("-0000035345352974832 - abcdefghij___________0123456789"),
              throwsA(predicate((e) =>
              e is ArgumentError &&
                  e.message == "Patch names cannot exceed 30 characters in length.")));
        });

    test(
        "throws the expected exception when the name is two characters longer than permitted",
            () {
          expect(
                  () => PatchMetadata.parse("-0000035345352974832 - abcdefghij____________0123456789"),
              throwsA(predicate((e) =>
              e is ArgumentError &&
                  e.message == "Patch names cannot exceed 30 characters in length.")));
        });

    test(
        "throws the expected exception when the name contains upper case letters",
            () {
          expect(
                  () => PatchMetadata.parse("-0000035345352974832 - abcdefghij___A__0123456789"),
              throwsA(predicate((e) =>
              e is ArgumentError &&
                  e.message ==
                      "Patch names can only contain the characters a-z, 0-9 and _.")));
        });

    test("throws the expected exception when the name contains spaces", () {
      expect(
              () => PatchMetadata.parse("-0000035345352974832 - abcdefghij___ __0123456789"),
          throwsA(predicate((e) =>
          e is ArgumentError &&
              e.message ==
                  "Patch names can only contain the characters a-z, 0-9 and _.")));
    });

    test("throws the expected exception when the name contains symbols", () {
      expect(
              () => PatchMetadata.parse("-0000035345352974832 - abcdefghij___\$__0123456789"),
          throwsA(predicate((e) =>
          e is ArgumentError &&
              e.message ==
                  "Patch names can only contain the characters a-z, 0-9 and _.")));
    });

    test("throws the expected exception when the name contains new lines", () {
      expect(
              () => PatchMetadata.parse("-0000035345352974832 - abcdefghij___\n__0123456789"),
          throwsA(predicate((e) =>
          e is ArgumentError &&
              e.message ==
                  "Patch names can only contain the characters a-z, 0-9 and _.")));
    });
  });
}
