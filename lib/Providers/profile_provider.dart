import 'package:flutter/material.dart';

import '../Model/profile.dart';

class ProfileProvider with ChangeNotifier {
  Profile? _profile = Profile(
      gender: 'Male', interests: [], phoneNo: '7200148739', name: 'Aditya');

  // Getter for the profile
  Profile? get profile => _profile;

  // Setter to update the profile
  void setProfile(Profile profile) {
    _profile = profile;
    notifyListeners();
  }

  // Method to update specific fields in the profile
  void updateProfile({
    String? name,
    int? age,
    String? gender,
    String? phoneNo,
    String? about,
    String? profilePicture,
    List<String>? pictures,
    List<String>? interests,
  }) {
    if (_profile != null) {
      _profile = Profile(
        id: _profile!.id,
        name: name ?? _profile!.name,
        age: age ?? _profile!.age,
        gender: gender ?? _profile!.gender,
        phoneNo: phoneNo ?? _profile!.phoneNo,
        about: about ?? _profile!.about,
        profilePicture: profilePicture ?? _profile!.profilePicture,
        pictures: pictures ?? _profile!.pictures,
        interests: interests ?? _profile!.interests,
      );
      notifyListeners();
    }
  }

  // Method to clear the profile (e.g., on logout)
  void clearProfile() {
    _profile = null;
    notifyListeners();
  }
}
