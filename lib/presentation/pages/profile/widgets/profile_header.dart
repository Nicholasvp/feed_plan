import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../data/models/profile_model.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                backgroundImage: profile.avatarPath != null
                    ? FileImage(File(profile.avatarPath!))
                    : null,
                child: profile.avatarPath == null
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
                    _statColumn(theme, '${profile.postCount}', 'posts'),
                    _statColumn(
                        theme, '${profile.followerCount}', 'followers'),
                    _statColumn(
                        theme, '${profile.followingCount}', 'following'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            profile.name,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (profile.bio != null && profile.bio!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                profile.bio!,
                style: theme.textTheme.bodySmall,
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
