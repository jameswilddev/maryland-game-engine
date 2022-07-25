/// Describes an existing game.
class GameMetadata {
  /// The name of the game.  This is 1-30 characters of a-z, 0-9 and _ and is
  /// unique locally.
  final String name;

  static final RegExp _nameRegExp = RegExp(r"^[a-z0-9_]+$");

  /// Creates a description of an existing game.  Throws an [ArgumentError] when
  /// [name] is empty, longer than 30 characters or contains characters other
  /// than a-z, 0-9 or _.
  GameMetadata(this.name) {
    if (name.isEmpty) {
      throw ArgumentError("Game names cannot be empty.");
    }

    if (name.length > 30) {
      throw ArgumentError("Game names cannot exceed 30 characters in length.");
    }

    if (!_nameRegExp.hasMatch(name)) {
      throw ArgumentError(
          "Game names can only contain the characters a-z, 0-9 and _.");
    }
  }

  @override
  bool operator ==(other) => other is GameMetadata && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => "GameMetadata $name";
}
