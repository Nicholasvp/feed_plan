import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/logger.dart';
import '../../../../data/models/instagram_profile_model.dart';
import '../../../../data/services/apify_service.dart';
import '../../../../data/services/instagram_cache_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../bloc/carousel_list/carousel_list_bloc.dart';
import '../../../bloc/carousel_list/carousel_list_event.dart';
import '../../../bloc/locale/locale_bloc.dart';
import '../../../bloc/locale/locale_event.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../bloc/profile/profile_event.dart';
import '../../../bloc/profile/profile_state.dart';

class UsernameSetup extends StatefulWidget {
  const UsernameSetup({super.key});

  @override
  State<UsernameSetup> createState() => _UsernameSetupState();
}

class _UsernameSetupState extends State<UsernameSetup> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String?> _downloadProfilePic(String? url) async {
    if (url == null || url.isEmpty) return null;

    try {
      final response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 30),
          );

      if (response.statusCode == 200) {
        final appDir = await getApplicationDocumentsDirectory();
        final imagesDir = Directory('${appDir.path}/images');
        if (!await imagesDir.exists()) {
          await imagesDir.create(recursive: true);
        }

        final ext = p.extension(url.split('?').first);
        final fileName = '${const Uuid().v4()}${ext.isEmpty ? '.jpg' : ext}';
        final filePath = '${imagesDir.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        Logger.logInfo('Profile pic saved: $filePath', context: 'UsernameSetup');
        return filePath;
      }
    } catch (e) {
      Logger.logError('Failed to download profile pic: $e', context: 'UsernameSetup');
    }
    return null;
  }

  Future<void> _onSubmit() async {
    final l10n = AppLocalizations.of(context)!;
    final username = _controller.text.trim();

    if (username.isEmpty) {
      setState(() => _error = l10n.enterInstagramUsername);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apify = context.read<ApifyService>();

      Logger.logInfo('Fetching Instagram profile for: $username', context: 'UsernameSetup');

      final profile = await apify.getInstagramProfile(username: username);

      Logger.logInfo('Profile fetched: ${profile.fullName}', context: 'UsernameSetup');

      if (!mounted) return;

      final avatarPath = await _downloadProfilePic(profile.profilePicUrl);

      if (!mounted) return;

      await _createProfile(profile, username, avatarPath);

      if (!mounted) return;

      context.go('/');
    } catch (e, stackTrace) {
      Logger.logError(
        'Failed to fetch Instagram profile',
        context: 'UsernameSetup',
        stackTrace: stackTrace,
      );

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = l10n.errorFetchingPosts(e.toString());
      });
    }
  }

  Future<void> _createProfile(
    InstagramProfileModel igProfile,
    String username,
    String? avatarPath,
  ) async {
    final profileBloc = context.read<ProfileBloc>();

    profileBloc.add(CreateNewProfile(
      name: igProfile.fullName.isNotEmpty ? igProfile.fullName : igProfile.username,
      bio: igProfile.biography,
      avatarPath: avatarPath,
      followerCount: igProfile.followersCount,
      followingCount: igProfile.followsCount,
    ));

    await Future.delayed(const Duration(milliseconds: 500));

    final profileState = profileBloc.state;
    if (profileState is ProfileLoaded) {
      final cacheService = InstagramCacheService.instance;

      try {
        final apify = context.read<ApifyService>();
        final posts = await apify.getInstagramPosts(
          username: username,
          resultsLimit: 12,
        );
        await cacheService.savePosts(username, posts);
        await cacheService.markRequested();

        context.read<CarouselListBloc>().add(
              LoadCarousels(profileState.profile.id),
            );
      } catch (e) {
        Logger.logError(
          'Failed to fetch posts during setup',
          context: 'UsernameSetup',
        );
      }
    }
  }

  void _showLanguagePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = context.read<LocaleBloc>().state.locale;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.language,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: Text(l10n.english),
              trailing: currentLocale.languageCode == 'en'
                  ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                context.read<LocaleBloc>().add(const ChangeLocale(Locale('en')));
                Navigator.of(ctx).pop();
              },
            ),
            ListTile(
              leading: const Text('🇧🇷', style: TextStyle(fontSize: 24)),
              title: Text(l10n.portuguese),
              trailing: currentLocale.languageCode == 'pt'
                  ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                context.read<LocaleBloc>().add(const ChangeLocale(Locale('pt')));
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  icon: const Icon(Icons.language),
                  onPressed: () => _showLanguagePicker(context),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/feed_plan.png',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.appTitle,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.enterInstagramUsername,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _controller,
                      enabled: !_isLoading,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        hintText: l10n.instagramUsername,
                        prefixText: '@ ',
                        prefixStyle: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                      onSubmitted: (_) => _onSubmit(),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: _isLoading ? null : _onSubmit,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(l10n.confirm),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
