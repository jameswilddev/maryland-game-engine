import 'package:fs_shim/fs.dart';
import 'package:path/path.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'game_metadata.dart';

/// A service which manages games.
class GameManager {
  /// Lists all games which exist on the given [fileSystem], using paths from
  /// the given [pathProviderPlatform].  Throws [UnsupportedError] should the
  /// given [pathProviderPlatform] not provide an application documents path, or
  /// should the games subdirectory within not be a directory.
  Stream<GameMetadata> list(PathProviderPlatform pathProviderPlatform,
      FileSystem fileSystem)

  async

  * {
    final documentsPath = await pathProviderPlatform
        .getApplicationDocumentsPath();

    if (documentsPath == null) {
      throw UnsupportedError("Unable to locate the application documents path.");
    }

    final gamesPath = join(documentsPath, "Maryland Game Engine", "Games");
    final gamesDirectory = fileSystem.directory(gamesPath);

    final gamesDirectoryStat = await gamesDirectory.stat();

    switch (gamesDirectoryStat.type) {
      case FileSystemEntityType.directory:
        break;

      case FileSystemEntityType.notFound:
        return;

      default:
        throw UnsupportedError("The games directory exists, but is not a directory.");
    }

    final entities = await gamesDirectory.list().toList();
    entities.sort((a, b) => a.path.compareTo(b.path));

    for (final entity in entities) {
      GameMetadata output;

      try {
        output = GameMetadata(basename(entity.path));
      } on ArgumentError {
        continue;
      }

      final childStat = await entity.stat();

      if (childStat.type == FileSystemEntityType.directory) {
        yield output;
      }
    }
  }

  /// Creates a new game on the given [fileSystem], using paths from the given
  /// [pathProviderPlatform], returning its [GameMetadata] on success.  Instead
  /// throws an [ArgumentError] if the specified game already exists or the name
  /// is not valid as the name of a game.  Throws [UnsupportedError] when the
  /// given [pathProviderPlatform] does not provide an application documents
  /// path, the games subdirectory within not be a directory, or the game
  /// already exists but not as a directory.
  Future<GameMetadata> create(PathProviderPlatform pathProviderPlatform,
      FileSystem fileSystem, String name)

  async

  {
    final output = GameMetadata(name);

    final documentsPath = await pathProviderPlatform
        .getApplicationDocumentsPath();

    if (documentsPath == null) {
      throw UnsupportedError("Unable to locate the application documents path.");
    }

    final gamesPath = join(documentsPath, "Maryland Game Engine", "Games");
    final gamePath = join(gamesPath, name);

    final gamesDirectory = fileSystem.directory(gamesPath);

    final gamesDirectoryStat = await gamesDirectory.stat();

    switch (gamesDirectoryStat.type) {
      case FileSystemEntityType.directory:
        final gameDirectory = fileSystem.directory(gamePath);

        final gameDirectoryStat = await gameDirectory.stat();

        switch (gameDirectoryStat.type) {
          case FileSystemEntityType.notFound:
            await gameDirectory.create(recursive: true);
            return output;

          case FileSystemEntityType.directory:
            throw ArgumentError("This game already exists.");

          default:
            throw UnsupportedError("The game directory exists, but is not a directory.");
        }

      case FileSystemEntityType.notFound:
        final gameDirectory = fileSystem.directory(gamePath);

        await gameDirectory.create(recursive: true);
        return output;

      default:
        throw UnsupportedError("The games directory exists, but is not a directory.");
    }
  }
}