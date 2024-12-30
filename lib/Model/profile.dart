class Profile {
  int? id;
  String? name;
  int? age;
  String? phoneNo;
  String gender;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? about;
  String? profilePicture;
  List<String> interests;
  List<String>? pictures;
  String? password;

  // Constructor with default values
  Profile({
    this.id,
    required this.gender,
    this.password ='',
    required this.interests,
    this.name = "Anonymous", // Default name
    this.phoneNo = "", // Default empty string for phone number
    this.age = 20,
    this.createdAt,
    this.updatedAt,
    this.about = "", // Default empty string for about
    this.profilePicture = "", // Default empty string for profile picture
    this.pictures = const [], // Default empty list for pictures
  });

  // Factory method to create a Profile from JSON
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      password: json['password'] ?? '',
      gender: json['gender'],
      interests: json['interests'],
      age: json['age'] ?? 20,
      name: json['name'] ?? "Anonymous", // Default to "Anonymous" if null
      phoneNo: json['phone_no'] ?? "", // Default to empty string if null
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      about: json['about'] ?? "", // Default to empty string if null
      profilePicture:
          json['profile_picture'] ?? "", // Default to empty string if null
      pictures: json['pictures'] != null
          ? List<String>.from(json['pictures'])
          : const [], // Default to empty list if null
    );
  }

  // Method to convert Profile to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_no': phoneNo,
      'interests': interests,
      'gender': gender,
      'age': age,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'about': about,
      'profile_picture': profilePicture,
      'pictures': pictures,
    };
  }

  // Optional: Override the toString method for easier debugging
  @override
  String toString() {
    return 'Profile{id: $id, name: $name, age: $age, phoneNo: $phoneNo, createdAt: $createdAt, updatedAt: $updatedAt, about: $about, profilePicture: $profilePicture, pictures: $pictures}';
  }
}
