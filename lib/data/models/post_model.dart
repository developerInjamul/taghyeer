class PostModel {
  final int id;
  final String title;
  final String body;
  final int userId;
  final List<String> tags;
  final ReactionsModel reactions;
  final int views;

  const PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.tags,
    required this.reactions,
    required this.views,
  });

  String get preview {
    if (body.length <= 120) return body;
    return '${body.substring(0, 120)}...';
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userId: json['userId'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      reactions: ReactionsModel.fromJson(
        json['reactions'] as Map<String, dynamic>? ?? {},
      ),
      views: json['views'] ?? 0,
    );
  }
}

class ReactionsModel {
  final int likes;
  final int dislikes;

  const ReactionsModel({required this.likes, required this.dislikes});

  factory ReactionsModel.fromJson(Map<String, dynamic> json) {
    return ReactionsModel(
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
    );
  }
}

class PostsResponse {
  final List<PostModel> posts;
  final int total;
  final int skip;
  final int limit;

  const PostsResponse({
    required this.posts,
    required this.total,
    required this.skip,
    required this.limit,
  });

  bool get hasMore => (skip + limit) < total;

  factory PostsResponse.fromJson(Map<String, dynamic> json) {
    return PostsResponse(
      posts: (json['posts'] as List<dynamic>? ?? [])
          .map((p) => PostModel.fromJson(p as Map<String, dynamic>))
          .toList(),
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }
}
