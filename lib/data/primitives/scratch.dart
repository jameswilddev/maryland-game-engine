import 'dart:typed_data';

/// Temporary memory used by primitive functions.
final primitiveScratch = ByteData.view(Uint8List(4).buffer);
