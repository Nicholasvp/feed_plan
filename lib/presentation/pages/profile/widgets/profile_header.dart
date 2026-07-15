import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/logger.dart';
import '../../../../data/models/profile_model.dart';
import '../../../../data/services/apify_service.dart';
import '../../../../data/services/instagram_cache_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../bloc/premium/premium_cubit.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../bloc/profile/profile_event.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    super.key,
    required this.profile,
    this.onPostsFetched,
  });

  final ProfileModel profile;
  final VoidCallback? onPostsFetched;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  late final TextEditingController _usernameController;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: widget.profile.instagramUsername ?? '',
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _fetchPosts() async {
    final l10n = AppLocalizations.of(context)!;
    final username = _usernameController.text.trim();

    Logger.logInfo('=== Fetch Posts Started ===', context: 'ProfileHeader');
    Logger.logInfo('Username input: "$username"', context: 'ProfileHeader');

    if (username.isEmpty) {
      Logger.logInfo('Username is empty, showing error', context: 'ProfileHeader');
      setState(() {
        _error = l10n.enterInstagramUsername;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final cacheService = InstagramCacheService.instance;
      final canRequest = await cacheService.canRequest();
      final premiumState = context.read<PremiumCubit>().state;

      Logger.logInfo('Can request API: $canRequest', context: 'ProfileHeader');
      Logger.logInfo('Is premium: ${premiumState.isPremium}', context: 'ProfileHeader');

      if (!canRequest && !premiumState.isPremium) {
        Logger.logInfo('Free user already requested today - showing paywall', context: 'ProfileHeader');
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _error = l10n.dailyLimitReached;
        });
        context.read<PremiumCubit>().presentPaywall();
        return;
      }

      await _makeApiRequest(username, cacheService);
    } catch (e, stackTrace) {
      Logger.logError(
        'Fetch posts failed: $e',
        context: 'ProfileHeader',
        stackTrace: stackTrace,
      );

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = l10n.errorFetchingPosts(e.toString());
      });
    }
  }

  Future<void> _makeApiRequest(
    String username,
    InstagramCacheService cacheService,
  ) async {
    Logger.logInfo('Calling Apify API...', context: 'ProfileHeader');

    final apify = context.read<ApifyService>();
    final posts = await apify.getInstagramPosts(
      username: username,
      resultsLimit: 9,
    );

    Logger.logInfo('Received ${posts.length} posts', context: 'ProfileHeader');

    await cacheService.savePosts(username, posts);
    await cacheService.markRequested();

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    _saveUsernameToProfile(username);

    widget.onPostsFetched?.call();
  }

  void _saveUsernameToProfile(String username) {
    Logger.logInfo('Saving username to profile...', context: 'ProfileHeader');
    final updatedProfile = widget.profile.copyWith(
      instagramUsername: username,
    );
    context.read<ProfileBloc>().add(UpdateProfile(updatedProfile));
    Logger.logInfo('=== Fetch Posts Completed ===', context: 'ProfileHeader');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: theme.colorScheme.primaryContainer,
                backgroundImage: widget.profile.avatarPath != null
                    ? FileImage(File(widget.profile.avatarPath!))
                    : null,
                child: widget.profile.avatarPath == null
                    ? Icon(
                        Icons.person,
                        size: 36,
                        color: theme.colorScheme.onPrimaryContainer,
                      )
                    : null,
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statColumn(theme, '${widget.profile.postCount}', l10n.posts),
                    _statColumn(
                        theme, '${widget.profile.followerCount}', l10n.followers),
                    _statColumn(
                        theme, '${widget.profile.followingCount}', l10n.following),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            widget.profile.name,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          if (widget.profile.bio != null && widget.profile.bio!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                widget.profile.bio!,
                style: theme.textTheme.bodySmall,
              ),
            ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _usernameController,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: l10n.instagramUsername,
                    prefixText: '@ ',
                    prefixStyle: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: (_) => _fetchPosts(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _isLoading ? null : _fetchPosts,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh, size: 20),
              ),
            ],
          ),

          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statColumn(ThemeData theme, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
