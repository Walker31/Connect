import 'package:connect/Backend/posts_api.dart';
import 'package:connect/Home/partner_card.dart';
import 'package:connect/Home/post_card.dart';
import 'package:connect/Model/profile.dart';
import 'package:connect/Settings/settings_main.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../Model/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomeState();
}

class HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Post> posts = [];
  final PostApi _postApi = PostApi();
  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final fetchedPosts = await _postApi.listPosts();
      setState(() {
        posts = fetchedPosts; // Update the posts list
      });
    } catch (e) {
      // Handle error (you can show a snackbar or a dialog)
      logger.e('Error fetching posts: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red.shade900),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_rounded,
                size: 32,
              ),
              color: Colors.red.shade900,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Settings()));
            },
            icon: const Icon(
              Icons.person,
              size: 32,
            ),
            color: Colors.red.shade900,
          ),
        ],
        leading: Icon(
          Icons.heart_broken,
          color: Colors.red.shade900,
          size: 32,
        ),
        title: Text(
          'Connect',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.red.shade900,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.red.shade900,
              borderRadius: BorderRadius.circular(24),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              labelColor: Colors.red.shade700,
              unselectedLabelColor: Colors.white,
              tabs: const [
                Tab(
                  child: Text('Make Friends'),
                ),
                Tab(
                  child: Text('Search Partners'),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              key: const PageStorageKey('tab1'),
              controller: _tabController,
              children: [
                Center(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final Post post = posts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: PostCard(
                          post: post,
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  children: [
                    Center(
                        child: PartnerCard(
                            profile: Profile(
                                interests: [], gender: 'Male', age: 20))),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.shade800.withOpacity(0.7)),
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                              )),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.shade800.withOpacity(0.7)),
                          child: IconButton(
                              onPressed: () {},
                              icon:
                                  const Icon(Icons.star, color: Colors.white)),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.shade800.withOpacity(0.7)),
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
