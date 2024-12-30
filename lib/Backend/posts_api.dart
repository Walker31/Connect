import 'dart:convert';
import 'package:connect/Backend/path.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../Model/post.dart';

class PostApi {
  static final Logger logger = Logger();

  // Create Post
  Future<Map<String, dynamic>> createPost(Post post) async {
    final url = Uri.parse(ApiPath.createPost());
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'caption': post.caption,
          'author': post.author,
          'interest': post.interest,
          'pic': post.pic,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create post: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }

  // List Posts
  Future<List<Post>> listPosts() async {
    final url = Uri.parse(ApiPath.listPost());
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse JSON into a list of Post objects
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to list posts: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error listing posts: $e');
    }
  }

  Future<Post> getPostDetails(int postId) async {
    final url = Uri.parse(ApiPath.getPost(postId));
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Post.fromJson(json); // Parse the response into a Post object
      } else {
        throw Exception('Failed to get post details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching post details: $e');
    }
  }

  // Update Post
  Future<Post> updatePost(Post post) async {
    final url = Uri.parse(ApiPath.updatePost()); // Use API path utility
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'post_text': post.caption,
          'author': post.author,
          'interest': post.interest,
          'pic': post.pic,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Post.fromJson(json); // Return updated Post object
      } else {
        throw Exception('Failed to update post: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating post: $e');
    }
  }

  // Delete Post
  Future<void> deletePost(int postId) async {
    final url = Uri.parse(ApiPath.deletePost()); // Use API path utility
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': postId}),
      );

      if (response.statusCode == 200) {
        logger.i('Post deleted successfully');
      } else {
        throw Exception('Failed to delete post: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting post: $e');
    }
  }
}
