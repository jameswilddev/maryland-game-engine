/// Describes an existing patch.
class PatchMetadata {
  /// The (64-bit) Unix timestamp on which the patch was created.
  final int timestamp;

  /// The name of the patch.  This is 1-30 characters of a-z, 0-9 and _.
  final String name;

  /// When false, the patch will not be included when loading the game.
  final bool enabled;

  static final RegExp _nameRegExp = RegExp(r"^[a-z0-9_]+$");

  /// Creates a description of an existing patch.  Throws an [ArgumentError]
  /// when the given [name] is empty, longer than 30 characters or contains
  /// characters other than a-z, 0-9 or _.
  PatchMetadata(this.timestamp, this.name, this.enabled) {
    if (name.isEmpty) {
      throw ArgumentError("Patch names cannot be empty.");
    }

    if (name.length > 30) {
      throw ArgumentError("Patch names cannot exceed 30 characters in length.");
    }

    if (!_nameRegExp.hasMatch(name)) {
      throw ArgumentError(
          "Patch names can only contain the characters a-z, 0-9 and _.");
    }
  }

  static final RegExp _directoryNameRegExp = RegExp(r"^[+-]\d{19} - ");

  /// Creates a description of an existing patch from the name of its directory.
  /// Throws [ArgumentError] when the directory name cannot be parsed.
  static PatchMetadata parse(String directoryName, bool enabled) {
    if (!_directoryNameRegExp.hasMatch(directoryName)) {
      throw ArgumentError(
          "The given directory name is not formatted like a patch.");
    }

    final timestamp = int.tryParse(directoryName.substring(0, 20));

    if (timestamp == null) {
      throw ArgumentError(
          "Patch timestamps cannot be less than -9223372036854775808 or greater than 9223372036854775807.");
    }

    final name = directoryName.substring(23);

    return PatchMetadata(timestamp, name, enabled);
  }

  @override
  bool operator ==(other) => other is PatchMetadata && timestamp == other.timestamp && name == other.name && enabled == other.enabled;

  @override
  int get hashCode => timestamp;

  @override
  String toString() => "${timestamp >= 0 ? "+" : "-"}${timestamp.toString().replaceAll("+", "").replaceAll("-", "").padLeft(19, "0")} - $name";
}
