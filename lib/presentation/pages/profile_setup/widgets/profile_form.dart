import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/file_utils.dart';
import '../../../../core/utils/logger.dart';
import '../../../../data/models/profile_model.dart';
import '../../../../l10n/generated/app_localizations.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({
    super.key,
    this.initialProfile,
    required this.onSave,
  });

  final ProfileModel? initialProfile;
  final void Function(
    String name,
    String? bio,
    String? avatarPath,
    int followers,
    int following,
  ) onSave;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _followersController = TextEditingController();
  final _followingController = TextEditingController();
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    if (widget.initialProfile != null) {
      _nameController.text = widget.initialProfile!.name;
      _bioController.text = widget.initialProfile!.bio ?? '';
      _followersController.text = '${widget.initialProfile!.followerCount}';
      _followingController.text = '${widget.initialProfile!.followingCount}';
      _avatarPath = widget.initialProfile!.avatarPath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _followersController.dispose();
    _followingController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    try {
      final permanentPath = await FileUtils.copyToPermanentStorage(image.path);
      setState(() => _avatarPath = permanentPath);
    } catch (e, stackTrace) {
      Logger.logError('Failed to save avatar', context: 'ProfileForm', stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickAvatar,
            child: CircleAvatar(
              radius: 48,
              backgroundColor: theme.colorScheme.primaryContainer,
              backgroundImage: _avatarPath != null
                  ? FileImage(File(_avatarPath!))
                  : null,
              child: _avatarPath == null
                  ? Icon(
                      Icons.camera_alt,
                      size: 32,
                      color: theme.colorScheme.onPrimaryContainer,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tapToChangePhoto,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.name,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _bioController,
            decoration: InputDecoration(
              labelText: l10n.bio,
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _followersController,
                  decoration: InputDecoration(
                    labelText: l10n.followers,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _followingController,
                  decoration: InputDecoration(
                    labelText: l10n.following,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (_nameController.text.trim().isNotEmpty) {
                  widget.onSave(
                    _nameController.text.trim(),
                    _bioController.text.trim().isEmpty
                        ? null
                        : _bioController.text.trim(),
                    _avatarPath,
                    int.tryParse(_followersController.text) ?? 0,
                    int.tryParse(_followingController.text) ?? 0,
                  );
                }
              },
              child: Text(l10n.save),
            ),
          ),
        ],
      ),
    );
  }
}
