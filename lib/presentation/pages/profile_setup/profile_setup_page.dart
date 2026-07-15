import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/profile/profile_event.dart';
import '../../bloc/profile/profile_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'widgets/profile_form.dart';
import 'widgets/username_setup.dart';

class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isEditing = context.read<ProfileBloc>().state is ProfileLoaded;

    if (isEditing) {
      return _EditProfileView();
    }

    return const UsernameSetup();
  }
}

class _EditProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.editProfile),
            ),
            body: ProfileForm(
              initialProfile: state.profile,
              onSave: (name, bio, avatarPath, followers, following) {
                context.read<ProfileBloc>().add(
                      CreateNewProfile(
                        name: name,
                        bio: bio,
                        avatarPath: avatarPath,
                        followerCount: followers,
                        followingCount: following,
                      ),
                    );
                context.go('/');
              },
            ),
          );
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
