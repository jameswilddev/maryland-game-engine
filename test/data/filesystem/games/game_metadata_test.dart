import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/filesystem/games/game_metadata.dart';

void main() {
  test("equal", () {
    const name = "test_name_123";

    final a = GameMetadata(name);
    final b = GameMetadata(name);

    expect(a.name, equals(name));
    expect(a, equals(b));
    expect(a.hashCode, equals(b.hashCode));
    expect(a.toString(), "GameMetadata test_name_123");
  });

  test("unequal name", () {
    final a = GameMetadata("test_name_1");
    final b = GameMetadata("test_name_2");

    expect(a, isNot(equals(b)));
  });

  test("does not throw an error when the name is of the minimum length", () {
    expect(() => GameMetadata("a"), returnsNormally);
  });

  test("does not throw an error when the name is of the maximum length", () {
    expect(
        () => GameMetadata("abcdefghij__________0123456789"), returnsNormally);
  });

  test("throws the expected exception when the name is empty", () {
    expect(
        () => GameMetadata(""),
        throwsA(predicate((e) =>
            e is ArgumentError && e.message == "Game names cannot be empty.")));
  });

  test(
      "throws the expected exception when the name is one character longer than permitted",
      () {
    expect(
        () => GameMetadata("abcdefghij___________0123456789"),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message == "Game names cannot exceed 30 characters in length.")));
  });

  test(
      "throws the expected exception when the name is two characters longer than permitted",
      () {
    expect(
        () => GameMetadata("abcdefghij____________0123456789"),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message == "Game names cannot exceed 30 characters in length.")));
  });

  test(
      "throws the expected exception when the name contains upper case letters",
      () {
    expect(
        () => GameMetadata("abcdefghij___A__0123456789"),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message ==
                "Game names can only contain the characters a-z, 0-9 and _.")));
  });

  test("throws the expected exception when the name contains spaces", () {
    expect(
        () => GameMetadata("abcdefghij___ __0123456789"),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message ==
                "Game names can only contain the characters a-z, 0-9 and _.")));
  });

  test("throws the expected exception when the name contains symbols", () {
    expect(
        () => GameMetadata("abcdefghij___\$__0123456789"),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message ==
                "Game names can only contain the characters a-z, 0-9 and _.")));
  });

  test("throws the expected exception when the name contains new lines", () {
    expect(
        () => GameMetadata("abcdefghij___\n__0123456789"),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message ==
                "Game names can only contain the characters a-z, 0-9 and _.")));
  });
}
