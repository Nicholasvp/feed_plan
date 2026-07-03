import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/profile/profile_event.dart';
import '../../bloc/profile/profile_state.dart';
import 'widgets/profile_form.dart';

class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isEditing = context.read<ProfileBloc>().state is ProfileLoaded;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Profile' : 'Create Profile'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return ProfileForm(
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
            );
          }

          return ProfileForm(
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
          );
        },
      ),
    );
  }
}
