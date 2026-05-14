import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<String?> saveProfilePicturePath(String? profilePicturePath) async {
  if (profilePicturePath == null || profilePicturePath.startsWith('http')) {
    return profilePicturePath;
  }

  final directory = await getApplicationDocumentsDirectory();
  final fileName = p.basename(profilePicturePath);
  final permanentPath = p.join(directory.path, fileName);

  await File(profilePicturePath).copy(permanentPath);
  return permanentPath;
}
