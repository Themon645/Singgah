import 'dart:io';

import 'package:flutter/material.dart';

import 'profile_image_provider_stub.dart';

ImageProvider buildProfileImage(String? profilePicture) {
  if (profilePicture != null && profilePicture.startsWith('http')) {
    return NetworkImage(profilePicture);
  }

  if (profilePicture != null && profilePicture.isNotEmpty) {
    return FileImage(File(profilePicture));
  }

  return const NetworkImage(defaultProfileImageUrl);
}
