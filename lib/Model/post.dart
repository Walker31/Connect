class Post {
  int? id;
  String caption;
  String? author;
  String? interest;
  String? location;
  String? pic;
  String? displayPic;
  DateTime createdAt;
  DateTime updatedAt;

  Post({
    this.id,
    required this.caption,
    this.author,
    this.interest,
    this.location,
    this.displayPic,
    this.pic,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int?,
      caption: json['post_text'] as String,
      author: json['author'] as String?,
      location: json['location'] as String?,
      displayPic: json['author_pic']
          as String?, // Updated key to match the backend response
      interest: json['interest'] as String?,
      pic: json['background']
          as String?, // Updated key to match the backend response
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Method to convert a Post object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_text': caption, // Consistent with the JSON key in fromJson
      'author': author,
      'location': location,
      'author_pic': displayPic, // Updated key to match the backend response
      'interest': interest,
      'background': pic, // Updated key to match the backend response
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
