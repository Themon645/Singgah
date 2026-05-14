import 'package:flutter/material.dart';

import 'profile_image_provider_stub.dart';

ImageProvider buildProfileImage(String? profilePicture) {
  if (profilePicture != null && profilePicture.startsWith('http')) {
    return NetworkImage(profilePicture);
  }

  return const NetworkImage(defaultProfileImageUrl);
}
