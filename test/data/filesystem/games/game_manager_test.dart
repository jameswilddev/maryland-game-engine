import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fs_shim/fs.dart';
import 'package:maryland_game_engine/data/filesystem/games/game_manager.dart';
import 'package:maryland_game_engine/data/filesystem/games/game_metadata.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

@GenerateMocks([PathProviderPlatform, FileSystem, Directory, FileSystemEntity, FileStat])
import 'game_manager_test.mocks.dart';

void main() {
  group("list", () {
    test(
        "throws an exception when no application documents directory is available", () async {
      final pathProviderPlatform = MockPathProviderPlatform();
      when(pathProviderPlatform.getApplicationDocumentsPath()).thenAnswer((_) async => null);
      final fileSystem = MockFileSystem();
      final gameManager = GameManager();
      final actual = <GameMetadata>[];

      final future = (() async {
        await for (final item in gameManager.list(pathProviderPlatform, fileSystem)) {
          actual.add(item);
        }
      })();

      expect(future, throwsA(predicate((e) =>
      e is UnsupportedError &&
      e.message ==
      "Unable to locate the application documents path.")));
      try { await future; } on UnsupportedError {
        expect(actual, isEmpty);
        verify(pathProviderPlatform.getApplicationDocumentsPath()).called(1);
        verifyNoMoreInteractions(pathProviderPlatform);
        verifyNoMoreInteractions(fileSystem
        );
      }
    });

    test("returns an empty list when no games directory exists", () async {
      final pathProviderPlatform = MockPathProviderPlatform();
      when(pathProviderPlatform.getApplicationDocumentsPath()).thenAnswer((realInvocation) async => "test-application-documents-path");
      final gamesDirectory = MockDirectory();
      final gamesDirectoryStat = MockFileStat();
      when(gamesDirectoryStat.type).thenReturn(FileSystemEntityType.notFound);
      when(gamesDirectory.stat()).thenAnswer((realInvocation) async => gamesDirectoryStat);
      final fileSystem = MockFileSystem();
      when(fileSystem.directory(path.join("test-application-documents-path", "Maryland Game Engine", "Games"))).thenAnswer((realInvocation) => gamesDirectory);
      final gameManager = GameManager();

      final actual = await gameManager.list(pathProviderPlatform, fileSystem).toList();

      expect(actual, isEmpty);
      verify(pathProviderPlatform.getApplicationDocumentsPath()).called(1);
      verifyNoMoreInteractions(pathProviderPlatform);
      verify(fileSystem.directory(path.join("test-application-documents-path", "Maryland Game Engine", "Games"))).called(1);
      verifyNoMoreInteractions(fileSystem
      );
      verify(gamesDirectory.stat()).called(1);
      verifyNoMoreInteractions(gamesDirectory);
      verify(gamesDirectoryStat.type);
      verifyNoMoreInteractions(gamesDirectoryStat);
    });

    test("throws an exception when the games directory is not a directory", () async {
      final pathProviderPlatform = MockPathProviderPlatform();
      when(pathProviderPlatform.getApplicationDocumentsPath()).thenAnswer((realInvocation) async => "test-application-documents-path");
      final gamesDirectory = MockDirectory();
      final gamesDirectoryStat = MockFileStat();
      when(gamesDirectoryStat.type).thenReturn([FileSystemEntityType.link, FileSystemEntityType.file][Random().nextInt(2)]);
      when(gamesDirectory.stat()).thenAnswer((realInvocation) async => gamesDirectoryStat);
      final fileSystem = MockFileSystem();
      when(fileSystem.directory(path.join("test-application-documents-path", "Maryland Game Engine", "Games"))).thenAnswer((realInvocation) => gamesDirectory);
      final gameManager = GameManager();
      final actual = <GameMetadata>[];

      final future = (() async {
        await for (final item in gameManager.list(pathProviderPlatform, fileSystem)) {
          actual.add(item);
        }
      })();

      expect(future, throwsA(predicate((e) =>
      e is UnsupportedError &&
          e.message ==
              "The games directory exists, but is not a directory.")));
      try { await future; } on UnsupportedError {
        expect(actual, isEmpty);
        verify(pathProviderPlatform.getApplicationDocumentsPath()).called(1);
        verifyNoMoreInteractions(pathProviderPlatform);
        verify(fileSystem.directory(
            path.join("test-application-documents-path", "Maryland Game Engine", "Games"))).called(1);
        verifyNoMoreInteractions(fileSystem
        );
        verify(gamesDirectory.stat()).called(1);
        verifyNoMoreInteractions(gamesDirectory);
        verify(gamesDirectoryStat.type);
        verifyNoMoreInteractions(gamesDirectoryStat);
      }
    });

    test("returns metadata describing the games in the directory", () async  {
      final pathProviderPlatform = MockPathProviderPlatform();
      when(pathProviderPlatform.getApplicationDocumentsPath()).thenAnswer((realInvocation) async => "test-application-documents-path");
      final gamesDirectory = MockDirectory();
      final gamesDirectoryStat = MockFileStat();
      when(gamesDirectoryStat.type).thenReturn(FileSystemEntityType.directory);
      when(gamesDirectory.stat()).thenAnswer((realInvocation) async => gamesDirectoryStat);
      final fileStatWhichIsNotADirectory = MockFileStat();
      when(fileStatWhichIsNotADirectory.type).thenAnswer((realInvocation) => [FileSystemEntityType.notFound, FileSystemEntityType.file, FileSystemEntityType.link][Random().nextInt(3)]);
      final fileStat = MockFileStat();
      when(fileStat.type).thenReturn(FileSystemEntityType.directory);
      final fileSystemEntityWhichIsNotADirectory = MockFileSystemEntity();
      when(fileSystemEntityWhichIsNotADirectory.stat()).thenAnswer((realInvocation) async => fileStatWhichIsNotADirectory);
      when(fileSystemEntityWhichIsNotADirectory.path).thenReturn("example_non_directory_name");
      final fileSystemEntityWhichIsInvalidlyNamed = MockFileSystemEntity();
      when(fileSystemEntityWhichIsInvalidlyNamed.path).thenReturn(path.join("test-application-documents-path", "Maryland Game Engine", "Games", "example invalid name b"));
      final fileSystemEntityWhichIsNotADirectoryAndInvalidlyNamed = MockFileSystemEntity();
      when(fileSystemEntityWhichIsNotADirectoryAndInvalidlyNamed.path).thenReturn(path.join("test-application-documents-path", "Maryland Game Engine", "Games", "example invalid name b"));
      final fileSystemEntityA = MockFileSystemEntity();
      when(fileSystemEntityA.stat()).thenAnswer((realInvocation) async => fileStat);
      when(fileSystemEntityA.path).thenReturn(path.join("test-application-documents-path", "Maryland Game Engine", "Games", "example_game_name_a"));
      final fileSystemEntityB = MockFileSystemEntity();
      when(fileSystemEntityB.stat()).thenAnswer((realInvocation) async => fileStat);
      when(fileSystemEntityB.path).thenReturn(path.join("test-application-documents-path", "Maryland Game Engine", "Games", "example_game_name_b"));
      final fileSystemEntityC = MockFileSystemEntity();
      when(fileSystemEntityC.stat()).thenAnswer((realInvocation) async => fileStat);
      when(fileSystemEntityC.path).thenReturn(path.join("test-application-documents-path", "Maryland Game Engine", "Games", "example_game_name_c"));
      when(gamesDirectory.list()).thenAnswer((realInvocation) async* {
        yield fileSystemEntityB;
        yield fileSystemEntityWhichIsNotADirectoryAndInvalidlyNamed;
        yield fileSystemEntityA;
        yield fileSystemEntityWhichIsInvalidlyNamed;
        yield fileSystemEntityWhichIsNotADirectory;
        yield fileSystemEntityC;
      });
      final fileSystem = MockFileSystem();
      when(fileSystem.directory(path.join("test-application-documents-path", "Maryland Game Engine", "Games"))).thenAnswer((realInvocation) => gamesDirectory);
      final gameManager = GameManager();

      final actual = await gameManager.list(pathProviderPlatform, fileSystem).toList();

      expect(actual, orderedEquals([GameMetadata("example_game_name_a"), GameMetadata("example_game_name_b"), GameMetadata("example_game_name_c")]));
      verify(pathProviderPlatform.getApplicationDocumentsPath()).called(1);
      verifyNoMoreInteractions(pathProviderPlatform);
      verify(fileSystem.directory(path.join("test-application-documents-path", "Maryland Game Engine", "Games"))).called(1);
      verifyNoMoreInteractions(fileSystem
      );
      verify(gamesDirectory.stat()).called(1);
      verify(gamesDirectory.list()).called(1);
      verifyNoMoreInteractions(gamesDirectory);
      verify(gamesDirectoryStat.type);
      verifyNoMoreInteractions(gamesDirectoryStat);
      verify(fileSystemEntityB.stat()).called(1);
      verify(fileSystemEntityB.path);
      verifyNoMoreInteractions(fileSystemEntityB);
      verify(fileSystemEntityWhichIsNotADirectoryAndInvalidlyNamed.path);
      verifyNoMoreInteractions(fileSystemEntityWhichIsNotADirectoryAndInvalidlyNamed);
      verify(fileSystemEntityA.stat()).called(1);
      verify(fileSystemEntityA.path);
      verifyNoMoreInteractions(fileSystemEntityA);
      verify(fileSystemEntityWhichIsInvalidlyNamed.path);
      verifyNoMoreInteractions(fileSystemEntityWhichIsInvalidlyNamed);
      verify(fileSystemEntityWhichIsNotADirectory.stat()).called(1);
      verify(fileSystemEntityWhichIsNotADirectory.path);
      verifyNoMoreInteractions(fileSystemEntityWhichIsNotADirectory);
      verify(fileSystemEntityC.stat()).called(1);
      verify(fileSystemEntityC.path);
      verifyNoMoreInteractions(fileSystemEntityC);
      verify(fileStat.type);
      verifyNoMoreInteractions(fileStat);
      verify(fileStatWhichIsNotADirectory.type);
      verifyNoMoreInteractions(fileStatWhichIsNotADirectory);
    });
  });

  group("create", () {
    test(
        "performs no IO and rethrows exception when the name is not valid", () async {
      final pathProviderPlatform = MockPathProviderPlatform();
      when(pathProviderPlatform.getApplicationDocumentsPath()).thenAnswer((_) async => null);
      final fileSystem = MockFileSystem();
      final gameManager = GameManager();

      final future = gameManager.create(pathProviderPlatform, fileSystem, "example invalid game name");

      expect(future, throwsA(predicate((e) =>
      e is ArgumentError &&
          e.message ==
              "Game names can only contain the characters a-z, 0-9 and _.")));
      try { await future; } on ArgumentError {
        verifyNoMoreInteractions(pathProviderPlatform);
        verifyNoMoreInteractions(fileSystem
        );
      }
    });

    test(
        "throws an exception when no application documents directory is available", () async {
      final pathProviderPlatform = MockPathProviderPlatform();
      when(pathProviderPlatform.getApplicationDocumentsPath()).thenAnswer((_) async => null);
      final fileSystem = MockFileSystem();
      final gameManager = GameManager();

      final future = gameManager.create(pathProviderPlatform, fileSystem, "example_game_name");

      expect(future, throwsA(predicate((e) =>
      e is UnsupportedError &&
          e.message ==
              "Unable to locate the application documents path.")));
      try { await future; } on UnsupportedError {
        verify(pathProviderPlatform.getApplicationDocumentsPath()).called(1);
        verifyNoMoreInteractions(pathProviderPlatform);
        verifyNoMoreInteractions(fileSystem
        );
      }
    });

    test("throws an exception when the games directory is not a directory", () async {
      final pathProviderPlatform = MockPathProviderPlatform();
      when(pathProviderPlatform.getApplicationDocumentsPath()).thenAnswer((realInvocation) async => "test-application-documents-path");
      final gamesDirectory = MockDirectory();
      final gamesDirectoryStat = MockFileStat();
      when(gamesDirectoryStat.type).thenReturn([FileSystemEntityType.link, FileSystemEntityType.file][Random().nextInt(2)]);
      when(gamesDirectory.stat()).thenAnswer((realInvocation) async => gamesDirectoryStat);
      final fileSystem = MockFileSystem();
      when(fileSystem.directory(path.join("test-application-documents-path", "Maryland Game Engine", "Games"))).thenAnswer((realInvocation) => gamesDirectory);
      final gameManager = GameManager();

      final future = gameManager.create(pathProviderPlatform, fileSystem, "example_game_name");

      expect(future, throwsA(predicate((e) =>
      e is UnsupportedError &&
          e.message ==
              "The games directory exists, but is not a directory.")));
      try { await future; } on UnsupportedError {
        verify(pathProviderPlatform.getApplicationDocumentsPath()).called(1);
        verifyNoMoreInteractions(pathProviderPlatform);
        verify(fileSystem.directory(
            path.join("test-application-documents-path", "Maryland Game Engine", "Games"))).called(1);
        verifyNoMoreInteractions(fileSystem
        );
        verify(gamesDirectory.stat()).called(1);
        verifyNoMoreInteractions(gamesDirectory);
        verify(gamesDirectoryStat.type);
        verifyNoMoreInteractions(gamesDirectoryStat);
      }
    });

    test("throws an exception when the specified game already exists", () async {
      final pathProviderPlatform = MockPathProviderPlatform();
      when(pathProviderPlatform.getApplicationDocumentsPath()).thenAnswer((realInvocation) async => "test-application-documents-path");
      final gamesDirectory = MockDirectory();
      final gamesDirectoryStat = MockFileStat();
      when(gamesDirectoryStat.type).thenReturn(FileSystemEntityType.directory);
      when(gamesDirectory.stat()).thenAnswer((realInvocation) async => gamesDirectoryStat);
      final gameDirectory = MockDirectory();
      final gameDirectoryStat = MockFileStat();
      when(gameDirectoryStat.type).thenReturn(FileSystemEntityType.directory);
      when(gameDirectory.stat()).thenAnswer((realInvocation) async => gameDirectoryStat);
      final fileSystem = MockFileSystem();
      when(fileSystem.directory(path.join("test-application-documents-path", "Maryland Game Engine", "Games"))).thenAnswer((realInvocation) => gamesDirectory);
      when(fileSystem.directory(path.join("test-application-documents-path", "Maryland Game Engine", "Games", "example_game_name"))).thenAnswer((realInvocation) => gameDirectory);
      final gameManager = GameManager();

      final future = gameManager.create(pathProviderPlatform, fileSystem, "example_game_name");

      expect(future, throwsA(predicate((e) =>
      e is ArgumentError &&
          e.message ==
              "This game already exists.")));
      try { await future; } on ArgumentError {
        verify(pathProviderPlatform.getApplicationDocumentsPath()).called(1);
        verifyNoMoreInteractions(pathProviderPlatform);
        verify(fileSystem.directory(
            path.join("test-application-documents-path", "Maryland Game Engine",
                "Games"))).called(1);
        verify(fileSystem.directory(
            path.join("test-application-documents-path", "Maryland Game Engine",
                "Games", "example_game_name"))).called(1);
        verifyNoMoreInteractions(fileSystem
        );
        verify(gamesDirectory.stat()).called(1);
        verifyNoMoreInteractions(gamesDirectory);
        verify(gamesDirectoryStat.type);
        verifyNoMoreInteractions(gamesDirectoryStat);
        verify(gameDirectory.stat()).called(1);
        verifyNoMoreInteractions(gameDirectory);
        verify(gameDirectoryStat.type);
        verifyNoMoreInteractions(gameDirectoryStat);
      }
    });

    test("throws an exception when the specified game already exists but not as a directory", () async {
      final pathProviderPlatform = MockPathProviderPlatform();
      when(pathProviderPlatform.getApplicationDocumentsPath()).thenAnswer((realInvocation) async => "test-application-documents-path");
      final gamesDirectory = MockDirectory();
      final gamesDirectoryStat = MockFileStat();
      when(gamesDirectoryStat.type).thenReturn(FileSystemEntityType.directory);
      when(gamesDirectory.stat()).thenAnswer((realInvocation) async => gamesDirectoryStat);
      final gameDirectory = MockDirectory();
      final gameDirectoryStat = MockFileStat();
      when(gameDirectoryStat.type).thenAnswer((realInvocation) => [FileSystemEntityType.link, FileSystemEntityType.file][Random().nextInt(2)]);
      when(gameDirectory.stat()).thenAnswer((realInvocation) async => gameDirectoryStat);
      final fileSystem = MockFileSystem();
      when(fileSystem.directory(path.join("test-application-documents-path", "Maryland Game Engine", "Games"))).thenAnswer((realInvocation) => gamesDirectory);
      when(fileSystem.directory(path.join("test-application-documents-path", "Maryland Game Engine", "Games", "example_game_name"))).thenAnswer((realInvocation) => gameDirectory);
      final gameManager = GameManager();

      final future = gameManager.create(pathProviderPlatform, fileSystem, "example_game_name");

      expect(future, throwsA(predicate((e) =>
      e is UnsupportedError &&
          e.message ==
              "The game directory exists, but is not a directory.")));
      try { await future; } on UnsupportedError {
        verify(pathProviderPlatform.getApplicationDocumentsPath()).called(1);
        verifyNoMoreInteractions(pathProviderPlatform);
        verify(fileSystem.directory(
            path.join("test-application-documents-path", "Maryland Game Engine",
                "Games"))).called(1);
        verify(fileSystem.directory(
            path.join("test-application-documents-path", "Maryland Game Engine",
                "Games", "example_game_name"))).called(1);
        verifyNoMoreInteractions(fileSystem
        );
        verify(gamesDirectory.stat()).called(1);
        verifyNoMoreInteractions(gamesDirectory);
        verify(gamesDirectoryStat.type);
        verifyNoMoreInteractions(gamesDirectoryStat);
        verify(gameDirectory.stat()).called(1);
        verifyNoMoreInteractions(gameDirectory);
        verify(gameDirectoryStat.type);
        verifyNoMoreInteractions(gameDirectoryStat);
      }
    });

    test(
        "creates a new directory for the specified game and returns its metadata", () async {
      final pathProviderPlatform = MockPathProviderPlatform();
      when(pathProviderPlatform.getApplicationDocumentsPath()).thenAnswer((realInvocation) async => "test-application-documents-path");
      final gamesDirectory = MockDirectory();
      final gamesDirectoryStat = MockFileStat();
      when(gamesDirectoryStat.type).thenReturn(FileSystemEntityType.directory);
      when(gamesDirectory.stat()).thenAnswer((realInvocation) async => gamesDirectoryStat);
      final gameDirectory = MockDirectory();
      final gameDirectoryStat = MockFileStat();
      when(gameDirectoryStat.type).thenReturn(FileSystemEntityType.notFound);
      when(gameDirectory.stat()).thenAnswer((realInvocation) async => gameDirectoryStat);
      when(gameDirectory.create(recursive: true)).thenAnswer((realInvocation) async => gameDirectory);
      final fileSystem = MockFileSystem();
      when(fileSystem.directory(path.join("test-application-documents-path", "Maryland Game Engine", "Games"))).thenAnswer((realInvocation) => gamesDirectory);
      when(fileSystem.directory(path.join("test-application-documents-path", "Maryland Game Engine", "Games", "example_game_name"))).thenAnswer((realInvocation) => gameDirectory);
      final gameManager = GameManager();

      final actual = await gameManager.create(pathProviderPlatform, fileSystem, "example_game_name");

      expect(actual, equals(GameMetadata("example_game_name")));
      verify(pathProviderPlatform.getApplicationDocumentsPath()).called(1);
      verifyNoMoreInteractions(pathProviderPlatform);
      verify(fileSystem.directory(
          path.join("test-application-documents-path", "Maryland Game Engine", "Games"))).called(1);
      verify(fileSystem.directory(
          path.join("test-application-documents-path", "Maryland Game Engine", "Games", "example_game_name"))).called(1);
      verifyNoMoreInteractions(fileSystem
      );
      verify(gamesDirectory.stat()).called(1);
      verifyNoMoreInteractions(gamesDirectory);
      verify(gamesDirectoryStat.type);
      verifyNoMoreInteractions(gamesDirectoryStat);
      verify(gameDirectory.create(recursive: true)).called(1);
      verify(gameDirectory.stat()).called(1);
      verifyNoMoreInteractions(gameDirectory);
      verify(gameDirectoryStat.type);
      verifyNoMoreInteractions(gameDirectoryStat);
    });

    test(
        "creates a new directory for the specified game and returns its metadata when no games directory exists", () async {
      final pathProviderPlatform = MockPathProviderPlatform();
      when(pathProviderPlatform.getApplicationDocumentsPath()).thenAnswer((realInvocation) async => "test-application-documents-path");
      final gamesDirectory = MockDirectory();
      final gamesDirectoryStat = MockFileStat();
      when(gamesDirectoryStat.type).thenReturn(FileSystemEntityType.notFound);
      when(gamesDirectory.stat()).thenAnswer((realInvocation) async => gamesDirectoryStat);
      final gameDirectory = MockDirectory();
      when(gameDirectory.create(recursive: true)).thenAnswer((realInvocation) async => gameDirectory);
      final fileSystem = MockFileSystem();
      when(fileSystem.directory(path.join("test-application-documents-path", "Maryland Game Engine", "Games"))).thenAnswer((realInvocation) => gamesDirectory);
      when(fileSystem.directory(path.join("test-application-documents-path", "Maryland Game Engine", "Games", "example_game_name"))).thenAnswer((realInvocation) => gameDirectory);
      final gameManager = GameManager();

      final actual = await gameManager.create(pathProviderPlatform, fileSystem, "example_game_name");

      expect(actual, equals(GameMetadata("example_game_name")));
      verify(pathProviderPlatform.getApplicationDocumentsPath()).called(1);
      verifyNoMoreInteractions(pathProviderPlatform);
      verify(fileSystem.directory(
          path.join("test-application-documents-path", "Maryland Game Engine", "Games"))).called(1);
      verify(fileSystem.directory(
          path.join("test-application-documents-path", "Maryland Game Engine", "Games", "example_game_name"))).called(1);
      verifyNoMoreInteractions(fileSystem
      );
      verify(gamesDirectory.stat()).called(1);
      verifyNoMoreInteractions(gamesDirectory);
      verify(gamesDirectoryStat.type);
      verifyNoMoreInteractions(gamesDirectoryStat);
      verify(gameDirectory.create(recursive: true)).called(1);
      verifyNoMoreInteractions(gameDirectory);
    });
  });
}
