
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_platform/models/Post.dart';
import 'package:social_media_platform/services/firebase_post_service.dart';
import 'package:social_media_platform/settings/font_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

enum SortOption {
  dateAsc,
  dateDesc,
  titleAsc,
  titleDesc,
}

class PostSortingPage extends StatefulWidget {
  const PostSortingPage({super.key});

  @override
  State<PostSortingPage> createState() => _PostSortingPageState();
}

class _PostSortingPageState extends State<PostSortingPage> {
  final FirebasePostService _postService = FirebasePostService();
  SortOption _currentSortOption = SortOption.dateDesc;
  List<Post> _sortedPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAndSortPosts();
  }

  Future<void> _loadAndSortPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final posts = await _postService.getPostsOnce();
      setState(() {
        _sortedPosts = _sortPosts(posts, _currentSortOption);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading posts: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Post> _sortPosts(List<Post> posts, SortOption sortOption) {
    List<Post> sortedList = List.from(posts);

    switch (sortOption) {
      case SortOption.dateAsc:
        sortedList.sort((a, b) {
          if (a.createdAt == null && b.createdAt == null) return 0;
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;
          return a.createdAt!.compareTo(b.createdAt!);
        });
        break;
      case SortOption.dateDesc:
        sortedList.sort((a, b) {
          if (a.createdAt == null && b.createdAt == null) return 0;
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;
          return b.createdAt!.compareTo(a.createdAt!);
        });
        break;
      case SortOption.titleAsc:
        sortedList.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case SortOption.titleDesc:
        sortedList.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
    }

    return sortedList;
  }

  void _changeSortOption(SortOption newOption) {
    setState(() {
      _currentSortOption = newOption;
      _sortedPosts = _sortPosts(_sortedPosts, newOption);
    });
  }

  String _getSortOptionText(SortOption option) {
    switch (option) {
      case SortOption.dateAsc:
        return 'Date (Oldest First)';
      case SortOption.dateDesc:
        return 'Date (Newest First)';
      case SortOption.titleAsc:
        return 'Title (A-Z)';
      case SortOption.titleDesc:
        return 'Title (Z-A)';
    }
  }

  IconData _getSortOptionIcon(SortOption option) {
    switch (option) {
      case SortOption.dateAsc:
        return Icons.calendar_today;
      case SortOption.dateDesc:
        return Icons.calendar_month;
      case SortOption.titleAsc:
        return Icons.sort_by_alpha;
      case SortOption.titleDesc:
        return Icons.sort_by_alpha;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontSlider = Provider.of<FontSlider>(context);
    final currentFontSize = fontSlider.sliderFontValue;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sorted Posts',
          style: GoogleFonts.roboto(
            fontSize: currentFontSize + 4,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<SortOption>(
            icon: Icon(_getSortOptionIcon(_currentSortOption)),
            onSelected: _changeSortOption,
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: SortOption.dateDesc,
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: _currentSortOption == SortOption.dateDesc
                          ? Theme.of(context).primaryColor
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getSortOptionText(SortOption.dateDesc),
                      style: TextStyle(
                        fontSize: currentFontSize,
                        color: _currentSortOption == SortOption.dateDesc
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SortOption.dateAsc,
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: _currentSortOption == SortOption.dateAsc
                          ? Theme.of(context).primaryColor
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getSortOptionText(SortOption.dateAsc),
                      style: TextStyle(
                        fontSize: currentFontSize,
                        color: _currentSortOption == SortOption.dateAsc
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SortOption.titleAsc,
                child: Row(
                  children: [
                    Icon(
                      Icons.sort_by_alpha,
                      color: _currentSortOption == SortOption.titleAsc
                          ? Theme.of(context).primaryColor
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getSortOptionText(SortOption.titleAsc),
                      style: TextStyle(
                        fontSize: currentFontSize,
                        color: _currentSortOption == SortOption.titleAsc
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SortOption.titleDesc,
                child: Row(
                  children: [
                    Icon(
                      Icons.sort,
                      color: _currentSortOption == SortOption.titleDesc
                          ? Theme.of(context).primaryColor
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getSortOptionText(SortOption.titleDesc),
                      style: TextStyle(
                        fontSize: currentFontSize,
                        color: _currentSortOption == SortOption.titleDesc
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAndSortPosts,
            tooltip: 'Refresh Posts',
          ),
        ],
      ),
      body: Column(
        children: [
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getSortOptionIcon(_currentSortOption),
                  color: Theme.of(context).primaryColor,
                  size: currentFontSize + 2,
                ),
                const SizedBox(width: 8),
                Text(
                  'Sorted by: ${_getSortOptionText(_currentSortOption)}',
                  style: GoogleFonts.roboto(
                    fontSize: currentFontSize,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_sortedPosts.length} posts',
                  style: GoogleFonts.roboto(
                    fontSize: currentFontSize - 2,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _sortedPosts.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.post_add,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No posts found',
                    style: GoogleFonts.roboto(
                      fontSize: currentFontSize + 2,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first post to get started!',
                    style: GoogleFonts.roboto(
                      fontSize: currentFontSize - 2,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
                : AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _sortedPosts.length,
                itemBuilder: (context, index) {
                  final post = _sortedPosts[index];
                  String displayText = post.content.length > 100
                      ? '${post.content.substring(0, 100)}...'
                      : post.content;

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            context.push('/post/${post.id}');
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 0,
                            ),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundImage: post.authorAvatar != null && post.authorAvatar!.isNotEmpty
                                            ? NetworkImage(post.authorAvatar!)
                                            : const AssetImage('assets/default_avatar.png') as ImageProvider,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          post.authorName ?? 'Anonymous',
                                          style: GoogleFonts.roboto(
                                            fontSize: currentFontSize,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      if (_currentSortOption == SortOption.dateAsc ||
                                          _currentSortOption == SortOption.dateDesc)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '#${index + 1}',
                                            style: GoogleFonts.roboto(
                                              fontSize: currentFontSize - 4,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    post.title,
                                    style: GoogleFonts.roboto(
                                      fontSize: currentFontSize + 4,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    post.subtitle,
                                    style: GoogleFonts.roboto(
                                      fontSize: currentFontSize,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    displayText,
                                    style: GoogleFonts.roboto(
                                      fontSize: currentFontSize - 2,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        post.createdAt != null
                                            ? DateFormat('MMM dd, yyyy - HH:mm').format(post.createdAt!)
                                            : 'Unknown date',
                                        style: GoogleFonts.roboto(
                                          fontSize: currentFontSize - 4,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.favorite, color: Colors.red[300], size: currentFontSize),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${post.likes}',
                                            style: GoogleFonts.roboto(fontSize: currentFontSize - 2),
                                          ),
                                          const SizedBox(width: 16),
                                          Icon(Icons.comment, color: Colors.blue[300], size: currentFontSize),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${post.comments.length}',
                                            style: GoogleFonts.roboto(fontSize: currentFontSize - 2),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}