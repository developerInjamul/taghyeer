import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/post_model.dart';
import '../../controllers/posts_controller.dart';
import '../../controllers/products_controller.dart';
import '../../widgets/common/common_widgets.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostsController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          Obx(
            () => controller.state.value == ListState.success
                ? Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${controller.posts.length} posts',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.accentColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        switch (controller.state.value) {
          case ListState.loading:
          case ListState.initial:
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: 8,
              itemBuilder: (_, __) => const _PostShimmerFull(),
            );

          case ListState.error:
            return ErrorStateWidget(
              message: controller.errorMessage.value,
              onRetry: controller.retry,
            );

          case ListState.empty:
            return const EmptyStateWidget(
              message: 'No posts available.',
              icon: Icons.article_outlined,
            );

          case ListState.success:
            return RefreshIndicator(
              onRefresh: controller.fetchPosts,
              color: AppTheme.accentColor,
              child: ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.posts.length +
                    (controller.isPaginationLoading.value ? 1 : 0) +
                    (!controller.hasMore.value && controller.posts.isNotEmpty
                        ? 1
                        : 0),
                itemBuilder: (context, index) {
                  if (index == controller.posts.length) {
                    if (controller.isPaginationLoading.value) {
                      return const PaginationLoader();
                    }
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          '✓ All posts loaded',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    );
                  }
                  return _PostTile(post: controller.posts[index]);
                },
              ),
            );
        }
      }),
    );
  }
}

class _PostShimmerFull extends StatelessWidget {
  const _PostShimmerFull();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerTheme.color ?? Colors.transparent,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostShimmerItem(),
        ],
      ),
    );
  }
}

class _PostTile extends StatelessWidget {
  final PostModel post;

  const _PostTile({required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _showPostDetail(context, post),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.dividerTheme.color ?? Colors.transparent,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post number badge + title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '#${post.id}',
                      style: const TextStyle(
                        color: AppTheme.accentColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    post.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              post.preview,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
                fontSize: 13,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            // Tags + Reactions
            Row(
              children: [
                // Tags
                Expanded(
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: post.tags
                        .take(3)
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '#$tag',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.primaryColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                // Reactions
                Row(
                  children: [
                    const Icon(
                      Icons.thumb_up_outlined,
                      size: 14,
                      color: AppTheme.successColor,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${post.reactions.likes}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 11,
                        color: AppTheme.successColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.visibility_outlined,
                      size: 14,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${post.views}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPostDetail(BuildContext context, PostModel post) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerTheme.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Post #${post.id}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(post.title, style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 16),
                    Text(
                      post.body,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.7),
                    ),
                    const SizedBox(height: 20),
                    Divider(color: theme.dividerTheme.color),
                    const SizedBox(height: 12),
                    // Stats
                    Row(
                      children: [
                        _statChip(
                          Icons.thumb_up_outlined,
                          '${post.reactions.likes} Likes',
                          AppTheme.successColor,
                          theme,
                        ),
                        const SizedBox(width: 10),
                        _statChip(
                          Icons.thumb_down_outlined,
                          '${post.reactions.dislikes} Dislikes',
                          AppTheme.errorColor,
                          theme,
                        ),
                        const SizedBox(width: 10),
                        _statChip(
                          Icons.visibility_outlined,
                          '${post.views} Views',
                          AppTheme.primaryColor,
                          theme,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Tags
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: post.tags
                          .map(
                            (t) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppTheme.primaryColor.withOpacity(0.2),
                                ),
                              ),
                              child: Text(
                                '#$t',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statChip(
    IconData icon,
    String label,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
