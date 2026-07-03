// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarPathMeta = const VerificationMeta(
    'avatarPath',
  );
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
    'avatar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _postCountMeta = const VerificationMeta(
    'postCount',
  );
  @override
  late final GeneratedColumn<int> postCount = GeneratedColumn<int>(
    'post_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _followerCountMeta = const VerificationMeta(
    'followerCount',
  );
  @override
  late final GeneratedColumn<int> followerCount = GeneratedColumn<int>(
    'follower_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _followingCountMeta = const VerificationMeta(
    'followingCount',
  );
  @override
  late final GeneratedColumn<int> followingCount = GeneratedColumn<int>(
    'following_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    bio,
    avatarPath,
    postCount,
    followerCount,
    followingCount,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
        _avatarPathMeta,
        avatarPath.isAcceptableOrUnknown(data['avatar_path']!, _avatarPathMeta),
      );
    }
    if (data.containsKey('post_count')) {
      context.handle(
        _postCountMeta,
        postCount.isAcceptableOrUnknown(data['post_count']!, _postCountMeta),
      );
    }
    if (data.containsKey('follower_count')) {
      context.handle(
        _followerCountMeta,
        followerCount.isAcceptableOrUnknown(
          data['follower_count']!,
          _followerCountMeta,
        ),
      );
    }
    if (data.containsKey('following_count')) {
      context.handle(
        _followingCountMeta,
        followingCount.isAcceptableOrUnknown(
          data['following_count']!,
          _followingCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      ),
      avatarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_path'],
      ),
      postCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}post_count'],
      )!,
      followerCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}follower_count'],
      )!,
      followingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}following_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final String id;
  final String name;
  final String? bio;
  final String? avatarPath;
  final int postCount;
  final int followerCount;
  final int followingCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Profile({
    required this.id,
    required this.name,
    this.bio,
    this.avatarPath,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['post_count'] = Variable<int>(postCount);
    map['follower_count'] = Variable<int>(followerCount);
    map['following_count'] = Variable<int>(followingCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      name: Value(name),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      postCount: Value(postCount),
      followerCount: Value(followerCount),
      followingCount: Value(followingCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      bio: serializer.fromJson<String?>(json['bio']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      postCount: serializer.fromJson<int>(json['postCount']),
      followerCount: serializer.fromJson<int>(json['followerCount']),
      followingCount: serializer.fromJson<int>(json['followingCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'bio': serializer.toJson<String?>(bio),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'postCount': serializer.toJson<int>(postCount),
      'followerCount': serializer.toJson<int>(followerCount),
      'followingCount': serializer.toJson<int>(followingCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Profile copyWith({
    String? id,
    String? name,
    Value<String?> bio = const Value.absent(),
    Value<String?> avatarPath = const Value.absent(),
    int? postCount,
    int? followerCount,
    int? followingCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Profile(
    id: id ?? this.id,
    name: name ?? this.name,
    bio: bio.present ? bio.value : this.bio,
    avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
    postCount: postCount ?? this.postCount,
    followerCount: followerCount ?? this.followerCount,
    followingCount: followingCount ?? this.followingCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      bio: data.bio.present ? data.bio.value : this.bio,
      avatarPath: data.avatarPath.present
          ? data.avatarPath.value
          : this.avatarPath,
      postCount: data.postCount.present ? data.postCount.value : this.postCount,
      followerCount: data.followerCount.present
          ? data.followerCount.value
          : this.followerCount,
      followingCount: data.followingCount.present
          ? data.followingCount.value
          : this.followingCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bio: $bio, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('postCount: $postCount, ')
          ..write('followerCount: $followerCount, ')
          ..write('followingCount: $followingCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    bio,
    avatarPath,
    postCount,
    followerCount,
    followingCount,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.name == this.name &&
          other.bio == this.bio &&
          other.avatarPath == this.avatarPath &&
          other.postCount == this.postCount &&
          other.followerCount == this.followerCount &&
          other.followingCount == this.followingCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> bio;
  final Value<String?> avatarPath;
  final Value<int> postCount;
  final Value<int> followerCount;
  final Value<int> followingCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bio = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.postCount = const Value.absent(),
    this.followerCount = const Value.absent(),
    this.followingCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String id,
    required String name,
    this.bio = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.postCount = const Value.absent(),
    this.followerCount = const Value.absent(),
    this.followingCount = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Profile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? bio,
    Expression<String>? avatarPath,
    Expression<int>? postCount,
    Expression<int>? followerCount,
    Expression<int>? followingCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (bio != null) 'bio': bio,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (postCount != null) 'post_count': postCount,
      if (followerCount != null) 'follower_count': followerCount,
      if (followingCount != null) 'following_count': followingCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? bio,
    Value<String?>? avatarPath,
    Value<int>? postCount,
    Value<int>? followerCount,
    Value<int>? followingCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatarPath: avatarPath ?? this.avatarPath,
      postCount: postCount ?? this.postCount,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (postCount.present) {
      map['post_count'] = Variable<int>(postCount.value);
    }
    if (followerCount.present) {
      map['follower_count'] = Variable<int>(followerCount.value);
    }
    if (followingCount.present) {
      map['following_count'] = Variable<int>(followingCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bio: $bio, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('postCount: $postCount, ')
          ..write('followerCount: $followerCount, ')
          ..write('followingCount: $followingCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CarouselsTable extends Carousels
    with TableInfo<$CarouselsTable, Carousel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarouselsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aspectRatioMeta = const VerificationMeta(
    'aspectRatio',
  );
  @override
  late final GeneratedColumn<String> aspectRatio = GeneratedColumn<String>(
    'aspect_ratio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1:1'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    order,
    aspectRatio,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'carousels';
  @override
  VerificationContext validateIntegrity(
    Insertable<Carousel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('aspect_ratio')) {
      context.handle(
        _aspectRatioMeta,
        aspectRatio.isAcceptableOrUnknown(
          data['aspect_ratio']!,
          _aspectRatioMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Carousel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Carousel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      aspectRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aspect_ratio'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CarouselsTable createAlias(String alias) {
    return $CarouselsTable(attachedDatabase, alias);
  }
}

class Carousel extends DataClass implements Insertable<Carousel> {
  final String id;
  final String profileId;
  final int order;
  final String aspectRatio;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Carousel({
    required this.id,
    required this.profileId,
    required this.order,
    required this.aspectRatio,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['order'] = Variable<int>(order);
    map['aspect_ratio'] = Variable<String>(aspectRatio);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CarouselsCompanion toCompanion(bool nullToAbsent) {
    return CarouselsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      order: Value(order),
      aspectRatio: Value(aspectRatio),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Carousel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Carousel(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      order: serializer.fromJson<int>(json['order']),
      aspectRatio: serializer.fromJson<String>(json['aspectRatio']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'order': serializer.toJson<int>(order),
      'aspectRatio': serializer.toJson<String>(aspectRatio),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Carousel copyWith({
    String? id,
    String? profileId,
    int? order,
    String? aspectRatio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Carousel(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    order: order ?? this.order,
    aspectRatio: aspectRatio ?? this.aspectRatio,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Carousel copyWithCompanion(CarouselsCompanion data) {
    return Carousel(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      order: data.order.present ? data.order.value : this.order,
      aspectRatio: data.aspectRatio.present
          ? data.aspectRatio.value
          : this.aspectRatio,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Carousel(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('order: $order, ')
          ..write('aspectRatio: $aspectRatio, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, order, aspectRatio, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Carousel &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.order == this.order &&
          other.aspectRatio == this.aspectRatio &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CarouselsCompanion extends UpdateCompanion<Carousel> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<int> order;
  final Value<String> aspectRatio;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CarouselsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.order = const Value.absent(),
    this.aspectRatio = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CarouselsCompanion.insert({
    required String id,
    required String profileId,
    required int order,
    this.aspectRatio = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       order = Value(order),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Carousel> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<int>? order,
    Expression<String>? aspectRatio,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (order != null) 'order': order,
      if (aspectRatio != null) 'aspect_ratio': aspectRatio,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CarouselsCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<int>? order,
    Value<String>? aspectRatio,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CarouselsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      order: order ?? this.order,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (aspectRatio.present) {
      map['aspect_ratio'] = Variable<String>(aspectRatio.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarouselsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('order: $order, ')
          ..write('aspectRatio: $aspectRatio, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PagesTable extends Pages with TableInfo<$PagesTable, Page> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carouselIdMeta = const VerificationMeta(
    'carouselId',
  );
  @override
  late final GeneratedColumn<String> carouselId = GeneratedColumn<String>(
    'carousel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES carousels (id)',
    ),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, carouselId, orderIndex, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Page> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('carousel_id')) {
      context.handle(
        _carouselIdMeta,
        carouselId.isAcceptableOrUnknown(data['carousel_id']!, _carouselIdMeta),
      );
    } else if (isInserting) {
      context.missing(_carouselIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Page map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Page(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      carouselId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}carousel_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PagesTable createAlias(String alias) {
    return $PagesTable(attachedDatabase, alias);
  }
}

class Page extends DataClass implements Insertable<Page> {
  final String id;
  final String carouselId;
  final int orderIndex;
  final DateTime createdAt;
  const Page({
    required this.id,
    required this.carouselId,
    required this.orderIndex,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['carousel_id'] = Variable<String>(carouselId);
    map['order_index'] = Variable<int>(orderIndex);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PagesCompanion toCompanion(bool nullToAbsent) {
    return PagesCompanion(
      id: Value(id),
      carouselId: Value(carouselId),
      orderIndex: Value(orderIndex),
      createdAt: Value(createdAt),
    );
  }

  factory Page.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Page(
      id: serializer.fromJson<String>(json['id']),
      carouselId: serializer.fromJson<String>(json['carouselId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'carouselId': serializer.toJson<String>(carouselId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Page copyWith({
    String? id,
    String? carouselId,
    int? orderIndex,
    DateTime? createdAt,
  }) => Page(
    id: id ?? this.id,
    carouselId: carouselId ?? this.carouselId,
    orderIndex: orderIndex ?? this.orderIndex,
    createdAt: createdAt ?? this.createdAt,
  );
  Page copyWithCompanion(PagesCompanion data) {
    return Page(
      id: data.id.present ? data.id.value : this.id,
      carouselId: data.carouselId.present
          ? data.carouselId.value
          : this.carouselId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Page(')
          ..write('id: $id, ')
          ..write('carouselId: $carouselId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, carouselId, orderIndex, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Page &&
          other.id == this.id &&
          other.carouselId == this.carouselId &&
          other.orderIndex == this.orderIndex &&
          other.createdAt == this.createdAt);
}

class PagesCompanion extends UpdateCompanion<Page> {
  final Value<String> id;
  final Value<String> carouselId;
  final Value<int> orderIndex;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PagesCompanion({
    this.id = const Value.absent(),
    this.carouselId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PagesCompanion.insert({
    required String id,
    required String carouselId,
    required int orderIndex,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       carouselId = Value(carouselId),
       orderIndex = Value(orderIndex),
       createdAt = Value(createdAt);
  static Insertable<Page> custom({
    Expression<String>? id,
    Expression<String>? carouselId,
    Expression<int>? orderIndex,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (carouselId != null) 'carousel_id': carouselId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PagesCompanion copyWith({
    Value<String>? id,
    Value<String>? carouselId,
    Value<int>? orderIndex,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PagesCompanion(
      id: id ?? this.id,
      carouselId: carouselId ?? this.carouselId,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (carouselId.present) {
      map['carousel_id'] = Variable<String>(carouselId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PagesCompanion(')
          ..write('id: $id, ')
          ..write('carouselId: $carouselId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CanvasItemsTable extends CanvasItems
    with TableInfo<$CanvasItemsTable, CanvasItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CanvasItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageIdMeta = const VerificationMeta('pageId');
  @override
  late final GeneratedColumn<String> pageId = GeneratedColumn<String>(
    'page_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pages (id)',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionXMeta = const VerificationMeta(
    'positionX',
  );
  @override
  late final GeneratedColumn<double> positionX = GeneratedColumn<double>(
    'position_x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionYMeta = const VerificationMeta(
    'positionY',
  );
  @override
  late final GeneratedColumn<double> positionY = GeneratedColumn<double>(
    'position_y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<double> width = GeneratedColumn<double>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rotationMeta = const VerificationMeta(
    'rotation',
  );
  @override
  late final GeneratedColumn<double> rotation = GeneratedColumn<double>(
    'rotation',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _zIndexMeta = const VerificationMeta('zIndex');
  @override
  late final GeneratedColumn<int> zIndex = GeneratedColumn<int>(
    'z_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _spanToNextPageMeta = const VerificationMeta(
    'spanToNextPage',
  );
  @override
  late final GeneratedColumn<bool> spanToNextPage = GeneratedColumn<bool>(
    'span_to_next_page',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("span_to_next_page" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cropRectMeta = const VerificationMeta(
    'cropRect',
  );
  @override
  late final GeneratedColumn<String> cropRect = GeneratedColumn<String>(
    'crop_rect',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pageId,
    filePath,
    mediaType,
    positionX,
    positionY,
    width,
    height,
    rotation,
    zIndex,
    spanToNextPage,
    cropRect,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'canvas_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CanvasItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('page_id')) {
      context.handle(
        _pageIdMeta,
        pageId.isAcceptableOrUnknown(data['page_id']!, _pageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pageIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaTypeMeta);
    }
    if (data.containsKey('position_x')) {
      context.handle(
        _positionXMeta,
        positionX.isAcceptableOrUnknown(data['position_x']!, _positionXMeta),
      );
    } else if (isInserting) {
      context.missing(_positionXMeta);
    }
    if (data.containsKey('position_y')) {
      context.handle(
        _positionYMeta,
        positionY.isAcceptableOrUnknown(data['position_y']!, _positionYMeta),
      );
    } else if (isInserting) {
      context.missing(_positionYMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('rotation')) {
      context.handle(
        _rotationMeta,
        rotation.isAcceptableOrUnknown(data['rotation']!, _rotationMeta),
      );
    }
    if (data.containsKey('z_index')) {
      context.handle(
        _zIndexMeta,
        zIndex.isAcceptableOrUnknown(data['z_index']!, _zIndexMeta),
      );
    }
    if (data.containsKey('span_to_next_page')) {
      context.handle(
        _spanToNextPageMeta,
        spanToNextPage.isAcceptableOrUnknown(
          data['span_to_next_page']!,
          _spanToNextPageMeta,
        ),
      );
    }
    if (data.containsKey('crop_rect')) {
      context.handle(
        _cropRectMeta,
        cropRect.isAcceptableOrUnknown(data['crop_rect']!, _cropRectMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CanvasItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CanvasItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      pageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}page_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      )!,
      positionX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}position_x'],
      )!,
      positionY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}position_y'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height'],
      )!,
      rotation: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rotation'],
      )!,
      zIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}z_index'],
      )!,
      spanToNextPage: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}span_to_next_page'],
      )!,
      cropRect: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop_rect'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CanvasItemsTable createAlias(String alias) {
    return $CanvasItemsTable(attachedDatabase, alias);
  }
}

class CanvasItem extends DataClass implements Insertable<CanvasItem> {
  final String id;
  final String pageId;
  final String filePath;
  final String mediaType;
  final double positionX;
  final double positionY;
  final double width;
  final double height;
  final double rotation;
  final int zIndex;
  final bool spanToNextPage;
  final String? cropRect;
  final DateTime createdAt;
  const CanvasItem({
    required this.id,
    required this.pageId,
    required this.filePath,
    required this.mediaType,
    required this.positionX,
    required this.positionY,
    required this.width,
    required this.height,
    required this.rotation,
    required this.zIndex,
    required this.spanToNextPage,
    this.cropRect,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['page_id'] = Variable<String>(pageId);
    map['file_path'] = Variable<String>(filePath);
    map['media_type'] = Variable<String>(mediaType);
    map['position_x'] = Variable<double>(positionX);
    map['position_y'] = Variable<double>(positionY);
    map['width'] = Variable<double>(width);
    map['height'] = Variable<double>(height);
    map['rotation'] = Variable<double>(rotation);
    map['z_index'] = Variable<int>(zIndex);
    map['span_to_next_page'] = Variable<bool>(spanToNextPage);
    if (!nullToAbsent || cropRect != null) {
      map['crop_rect'] = Variable<String>(cropRect);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CanvasItemsCompanion toCompanion(bool nullToAbsent) {
    return CanvasItemsCompanion(
      id: Value(id),
      pageId: Value(pageId),
      filePath: Value(filePath),
      mediaType: Value(mediaType),
      positionX: Value(positionX),
      positionY: Value(positionY),
      width: Value(width),
      height: Value(height),
      rotation: Value(rotation),
      zIndex: Value(zIndex),
      spanToNextPage: Value(spanToNextPage),
      cropRect: cropRect == null && nullToAbsent
          ? const Value.absent()
          : Value(cropRect),
      createdAt: Value(createdAt),
    );
  }

  factory CanvasItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CanvasItem(
      id: serializer.fromJson<String>(json['id']),
      pageId: serializer.fromJson<String>(json['pageId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      positionX: serializer.fromJson<double>(json['positionX']),
      positionY: serializer.fromJson<double>(json['positionY']),
      width: serializer.fromJson<double>(json['width']),
      height: serializer.fromJson<double>(json['height']),
      rotation: serializer.fromJson<double>(json['rotation']),
      zIndex: serializer.fromJson<int>(json['zIndex']),
      spanToNextPage: serializer.fromJson<bool>(json['spanToNextPage']),
      cropRect: serializer.fromJson<String?>(json['cropRect']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pageId': serializer.toJson<String>(pageId),
      'filePath': serializer.toJson<String>(filePath),
      'mediaType': serializer.toJson<String>(mediaType),
      'positionX': serializer.toJson<double>(positionX),
      'positionY': serializer.toJson<double>(positionY),
      'width': serializer.toJson<double>(width),
      'height': serializer.toJson<double>(height),
      'rotation': serializer.toJson<double>(rotation),
      'zIndex': serializer.toJson<int>(zIndex),
      'spanToNextPage': serializer.toJson<bool>(spanToNextPage),
      'cropRect': serializer.toJson<String?>(cropRect),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CanvasItem copyWith({
    String? id,
    String? pageId,
    String? filePath,
    String? mediaType,
    double? positionX,
    double? positionY,
    double? width,
    double? height,
    double? rotation,
    int? zIndex,
    bool? spanToNextPage,
    Value<String?> cropRect = const Value.absent(),
    DateTime? createdAt,
  }) => CanvasItem(
    id: id ?? this.id,
    pageId: pageId ?? this.pageId,
    filePath: filePath ?? this.filePath,
    mediaType: mediaType ?? this.mediaType,
    positionX: positionX ?? this.positionX,
    positionY: positionY ?? this.positionY,
    width: width ?? this.width,
    height: height ?? this.height,
    rotation: rotation ?? this.rotation,
    zIndex: zIndex ?? this.zIndex,
    spanToNextPage: spanToNextPage ?? this.spanToNextPage,
    cropRect: cropRect.present ? cropRect.value : this.cropRect,
    createdAt: createdAt ?? this.createdAt,
  );
  CanvasItem copyWithCompanion(CanvasItemsCompanion data) {
    return CanvasItem(
      id: data.id.present ? data.id.value : this.id,
      pageId: data.pageId.present ? data.pageId.value : this.pageId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      positionX: data.positionX.present ? data.positionX.value : this.positionX,
      positionY: data.positionY.present ? data.positionY.value : this.positionY,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      rotation: data.rotation.present ? data.rotation.value : this.rotation,
      zIndex: data.zIndex.present ? data.zIndex.value : this.zIndex,
      spanToNextPage: data.spanToNextPage.present
          ? data.spanToNextPage.value
          : this.spanToNextPage,
      cropRect: data.cropRect.present ? data.cropRect.value : this.cropRect,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CanvasItem(')
          ..write('id: $id, ')
          ..write('pageId: $pageId, ')
          ..write('filePath: $filePath, ')
          ..write('mediaType: $mediaType, ')
          ..write('positionX: $positionX, ')
          ..write('positionY: $positionY, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('rotation: $rotation, ')
          ..write('zIndex: $zIndex, ')
          ..write('spanToNextPage: $spanToNextPage, ')
          ..write('cropRect: $cropRect, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pageId,
    filePath,
    mediaType,
    positionX,
    positionY,
    width,
    height,
    rotation,
    zIndex,
    spanToNextPage,
    cropRect,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CanvasItem &&
          other.id == this.id &&
          other.pageId == this.pageId &&
          other.filePath == this.filePath &&
          other.mediaType == this.mediaType &&
          other.positionX == this.positionX &&
          other.positionY == this.positionY &&
          other.width == this.width &&
          other.height == this.height &&
          other.rotation == this.rotation &&
          other.zIndex == this.zIndex &&
          other.spanToNextPage == this.spanToNextPage &&
          other.cropRect == this.cropRect &&
          other.createdAt == this.createdAt);
}

class CanvasItemsCompanion extends UpdateCompanion<CanvasItem> {
  final Value<String> id;
  final Value<String> pageId;
  final Value<String> filePath;
  final Value<String> mediaType;
  final Value<double> positionX;
  final Value<double> positionY;
  final Value<double> width;
  final Value<double> height;
  final Value<double> rotation;
  final Value<int> zIndex;
  final Value<bool> spanToNextPage;
  final Value<String?> cropRect;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CanvasItemsCompanion({
    this.id = const Value.absent(),
    this.pageId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.positionX = const Value.absent(),
    this.positionY = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.rotation = const Value.absent(),
    this.zIndex = const Value.absent(),
    this.spanToNextPage = const Value.absent(),
    this.cropRect = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CanvasItemsCompanion.insert({
    required String id,
    required String pageId,
    required String filePath,
    required String mediaType,
    required double positionX,
    required double positionY,
    required double width,
    required double height,
    this.rotation = const Value.absent(),
    this.zIndex = const Value.absent(),
    this.spanToNextPage = const Value.absent(),
    this.cropRect = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       pageId = Value(pageId),
       filePath = Value(filePath),
       mediaType = Value(mediaType),
       positionX = Value(positionX),
       positionY = Value(positionY),
       width = Value(width),
       height = Value(height),
       createdAt = Value(createdAt);
  static Insertable<CanvasItem> custom({
    Expression<String>? id,
    Expression<String>? pageId,
    Expression<String>? filePath,
    Expression<String>? mediaType,
    Expression<double>? positionX,
    Expression<double>? positionY,
    Expression<double>? width,
    Expression<double>? height,
    Expression<double>? rotation,
    Expression<int>? zIndex,
    Expression<bool>? spanToNextPage,
    Expression<String>? cropRect,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pageId != null) 'page_id': pageId,
      if (filePath != null) 'file_path': filePath,
      if (mediaType != null) 'media_type': mediaType,
      if (positionX != null) 'position_x': positionX,
      if (positionY != null) 'position_y': positionY,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (rotation != null) 'rotation': rotation,
      if (zIndex != null) 'z_index': zIndex,
      if (spanToNextPage != null) 'span_to_next_page': spanToNextPage,
      if (cropRect != null) 'crop_rect': cropRect,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CanvasItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? pageId,
    Value<String>? filePath,
    Value<String>? mediaType,
    Value<double>? positionX,
    Value<double>? positionY,
    Value<double>? width,
    Value<double>? height,
    Value<double>? rotation,
    Value<int>? zIndex,
    Value<bool>? spanToNextPage,
    Value<String?>? cropRect,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CanvasItemsCompanion(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      filePath: filePath ?? this.filePath,
      mediaType: mediaType ?? this.mediaType,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
      zIndex: zIndex ?? this.zIndex,
      spanToNextPage: spanToNextPage ?? this.spanToNextPage,
      cropRect: cropRect ?? this.cropRect,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pageId.present) {
      map['page_id'] = Variable<String>(pageId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (positionX.present) {
      map['position_x'] = Variable<double>(positionX.value);
    }
    if (positionY.present) {
      map['position_y'] = Variable<double>(positionY.value);
    }
    if (width.present) {
      map['width'] = Variable<double>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (rotation.present) {
      map['rotation'] = Variable<double>(rotation.value);
    }
    if (zIndex.present) {
      map['z_index'] = Variable<int>(zIndex.value);
    }
    if (spanToNextPage.present) {
      map['span_to_next_page'] = Variable<bool>(spanToNextPage.value);
    }
    if (cropRect.present) {
      map['crop_rect'] = Variable<String>(cropRect.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CanvasItemsCompanion(')
          ..write('id: $id, ')
          ..write('pageId: $pageId, ')
          ..write('filePath: $filePath, ')
          ..write('mediaType: $mediaType, ')
          ..write('positionX: $positionX, ')
          ..write('positionY: $positionY, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('rotation: $rotation, ')
          ..write('zIndex: $zIndex, ')
          ..write('spanToNextPage: $spanToNextPage, ')
          ..write('cropRect: $cropRect, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $CarouselsTable carousels = $CarouselsTable(this);
  late final $PagesTable pages = $PagesTable(this);
  late final $CanvasItemsTable canvasItems = $CanvasItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    carousels,
    pages,
    canvasItems,
  ];
}

typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      required String id,
      required String name,
      Value<String?> bio,
      Value<String?> avatarPath,
      Value<int> postCount,
      Value<int> followerCount,
      Value<int> followingCount,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> bio,
      Value<String?> avatarPath,
      Value<int> postCount,
      Value<int> followerCount,
      Value<int> followingCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $ProfilesTable, Profile> {
  $$ProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CarouselsTable, List<Carousel>>
  _carouselsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.carousels,
    aliasName: $_aliasNameGenerator(db.profiles.id, db.carousels.profileId),
  );

  $$CarouselsTableProcessedTableManager get carouselsRefs {
    final manager = $$CarouselsTableTableManager(
      $_db,
      $_db.carousels,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_carouselsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get postCount => $composableBuilder(
    column: $table.postCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get followerCount => $composableBuilder(
    column: $table.followerCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get followingCount => $composableBuilder(
    column: $table.followingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> carouselsRefs(
    Expression<bool> Function($$CarouselsTableFilterComposer f) f,
  ) {
    final $$CarouselsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carousels,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarouselsTableFilterComposer(
            $db: $db,
            $table: $db.carousels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get postCount => $composableBuilder(
    column: $table.postCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get followerCount => $composableBuilder(
    column: $table.followerCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get followingCount => $composableBuilder(
    column: $table.followingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get postCount =>
      $composableBuilder(column: $table.postCount, builder: (column) => column);

  GeneratedColumn<int> get followerCount => $composableBuilder(
    column: $table.followerCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get followingCount => $composableBuilder(
    column: $table.followingCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> carouselsRefs<T extends Object>(
    Expression<T> Function($$CarouselsTableAnnotationComposer a) f,
  ) {
    final $$CarouselsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carousels,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarouselsTableAnnotationComposer(
            $db: $db,
            $table: $db.carousels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, $$ProfilesTableReferences),
          Profile,
          PrefetchHooks Function({bool carouselsRefs})
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<int> postCount = const Value.absent(),
                Value<int> followerCount = const Value.absent(),
                Value<int> followingCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                name: name,
                bio: bio,
                avatarPath: avatarPath,
                postCount: postCount,
                followerCount: followerCount,
                followingCount: followingCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> bio = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<int> postCount = const Value.absent(),
                Value<int> followerCount = const Value.absent(),
                Value<int> followingCount = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                name: name,
                bio: bio,
                avatarPath: avatarPath,
                postCount: postCount,
                followerCount: followerCount,
                followingCount: followingCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({carouselsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (carouselsRefs) db.carousels],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (carouselsRefs)
                    await $_getPrefetchedData<
                      Profile,
                      $ProfilesTable,
                      Carousel
                    >(
                      currentTable: table,
                      referencedTable: $$ProfilesTableReferences
                          ._carouselsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ProfilesTableReferences(
                        db,
                        table,
                        p0,
                      ).carouselsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.profileId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, $$ProfilesTableReferences),
      Profile,
      PrefetchHooks Function({bool carouselsRefs})
    >;
typedef $$CarouselsTableCreateCompanionBuilder =
    CarouselsCompanion Function({
      required String id,
      required String profileId,
      required int order,
      Value<String> aspectRatio,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CarouselsTableUpdateCompanionBuilder =
    CarouselsCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<int> order,
      Value<String> aspectRatio,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CarouselsTableReferences
    extends BaseReferences<_$AppDatabase, $CarouselsTable, Carousel> {
  $$CarouselsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias(
        $_aliasNameGenerator(db.carousels.profileId, db.profiles.id),
      );

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PagesTable, List<Page>> _pagesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.pages,
    aliasName: $_aliasNameGenerator(db.carousels.id, db.pages.carouselId),
  );

  $$PagesTableProcessedTableManager get pagesRefs {
    final manager = $$PagesTableTableManager(
      $_db,
      $_db.pages,
    ).filter((f) => f.carouselId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_pagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CarouselsTableFilterComposer
    extends Composer<_$AppDatabase, $CarouselsTable> {
  $$CarouselsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> pagesRefs(
    Expression<bool> Function($$PagesTableFilterComposer f) f,
  ) {
    final $$PagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pages,
      getReferencedColumn: (t) => t.carouselId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagesTableFilterComposer(
            $db: $db,
            $table: $db.pages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CarouselsTableOrderingComposer
    extends Composer<_$AppDatabase, $CarouselsTable> {
  $$CarouselsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarouselsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CarouselsTable> {
  $$CarouselsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> pagesRefs<T extends Object>(
    Expression<T> Function($$PagesTableAnnotationComposer a) f,
  ) {
    final $$PagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pages,
      getReferencedColumn: (t) => t.carouselId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagesTableAnnotationComposer(
            $db: $db,
            $table: $db.pages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CarouselsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CarouselsTable,
          Carousel,
          $$CarouselsTableFilterComposer,
          $$CarouselsTableOrderingComposer,
          $$CarouselsTableAnnotationComposer,
          $$CarouselsTableCreateCompanionBuilder,
          $$CarouselsTableUpdateCompanionBuilder,
          (Carousel, $$CarouselsTableReferences),
          Carousel,
          PrefetchHooks Function({bool profileId, bool pagesRefs})
        > {
  $$CarouselsTableTableManager(_$AppDatabase db, $CarouselsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CarouselsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CarouselsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CarouselsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<String> aspectRatio = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CarouselsCompanion(
                id: id,
                profileId: profileId,
                order: order,
                aspectRatio: aspectRatio,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required int order,
                Value<String> aspectRatio = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CarouselsCompanion.insert(
                id: id,
                profileId: profileId,
                order: order,
                aspectRatio: aspectRatio,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CarouselsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false, pagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (pagesRefs) db.pages],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable: $$CarouselsTableReferences
                                    ._profileIdTable(db),
                                referencedColumn: $$CarouselsTableReferences
                                    ._profileIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pagesRefs)
                    await $_getPrefetchedData<Carousel, $CarouselsTable, Page>(
                      currentTable: table,
                      referencedTable: $$CarouselsTableReferences
                          ._pagesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CarouselsTableReferences(db, table, p0).pagesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.carouselId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CarouselsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CarouselsTable,
      Carousel,
      $$CarouselsTableFilterComposer,
      $$CarouselsTableOrderingComposer,
      $$CarouselsTableAnnotationComposer,
      $$CarouselsTableCreateCompanionBuilder,
      $$CarouselsTableUpdateCompanionBuilder,
      (Carousel, $$CarouselsTableReferences),
      Carousel,
      PrefetchHooks Function({bool profileId, bool pagesRefs})
    >;
typedef $$PagesTableCreateCompanionBuilder =
    PagesCompanion Function({
      required String id,
      required String carouselId,
      required int orderIndex,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PagesTableUpdateCompanionBuilder =
    PagesCompanion Function({
      Value<String> id,
      Value<String> carouselId,
      Value<int> orderIndex,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$PagesTableReferences
    extends BaseReferences<_$AppDatabase, $PagesTable, Page> {
  $$PagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CarouselsTable _carouselIdTable(_$AppDatabase db) => db.carousels
      .createAlias($_aliasNameGenerator(db.pages.carouselId, db.carousels.id));

  $$CarouselsTableProcessedTableManager get carouselId {
    final $_column = $_itemColumn<String>('carousel_id')!;

    final manager = $$CarouselsTableTableManager(
      $_db,
      $_db.carousels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_carouselIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CanvasItemsTable, List<CanvasItem>>
  _canvasItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.canvasItems,
    aliasName: $_aliasNameGenerator(db.pages.id, db.canvasItems.pageId),
  );

  $$CanvasItemsTableProcessedTableManager get canvasItemsRefs {
    final manager = $$CanvasItemsTableTableManager(
      $_db,
      $_db.canvasItems,
    ).filter((f) => f.pageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_canvasItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PagesTableFilterComposer extends Composer<_$AppDatabase, $PagesTable> {
  $$PagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CarouselsTableFilterComposer get carouselId {
    final $$CarouselsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carouselId,
      referencedTable: $db.carousels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarouselsTableFilterComposer(
            $db: $db,
            $table: $db.carousels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> canvasItemsRefs(
    Expression<bool> Function($$CanvasItemsTableFilterComposer f) f,
  ) {
    final $$CanvasItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.canvasItems,
      getReferencedColumn: (t) => t.pageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CanvasItemsTableFilterComposer(
            $db: $db,
            $table: $db.canvasItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PagesTable> {
  $$PagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CarouselsTableOrderingComposer get carouselId {
    final $$CarouselsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carouselId,
      referencedTable: $db.carousels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarouselsTableOrderingComposer(
            $db: $db,
            $table: $db.carousels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PagesTable> {
  $$PagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CarouselsTableAnnotationComposer get carouselId {
    final $$CarouselsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carouselId,
      referencedTable: $db.carousels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarouselsTableAnnotationComposer(
            $db: $db,
            $table: $db.carousels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> canvasItemsRefs<T extends Object>(
    Expression<T> Function($$CanvasItemsTableAnnotationComposer a) f,
  ) {
    final $$CanvasItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.canvasItems,
      getReferencedColumn: (t) => t.pageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CanvasItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.canvasItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PagesTable,
          Page,
          $$PagesTableFilterComposer,
          $$PagesTableOrderingComposer,
          $$PagesTableAnnotationComposer,
          $$PagesTableCreateCompanionBuilder,
          $$PagesTableUpdateCompanionBuilder,
          (Page, $$PagesTableReferences),
          Page,
          PrefetchHooks Function({bool carouselId, bool canvasItemsRefs})
        > {
  $$PagesTableTableManager(_$AppDatabase db, $PagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> carouselId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PagesCompanion(
                id: id,
                carouselId: carouselId,
                orderIndex: orderIndex,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String carouselId,
                required int orderIndex,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PagesCompanion.insert(
                id: id,
                carouselId: carouselId,
                orderIndex: orderIndex,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PagesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({carouselId = false, canvasItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (canvasItemsRefs) db.canvasItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (carouselId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.carouselId,
                                    referencedTable: $$PagesTableReferences
                                        ._carouselIdTable(db),
                                    referencedColumn: $$PagesTableReferences
                                        ._carouselIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (canvasItemsRefs)
                        await $_getPrefetchedData<
                          Page,
                          $PagesTable,
                          CanvasItem
                        >(
                          currentTable: table,
                          referencedTable: $$PagesTableReferences
                              ._canvasItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PagesTableReferences(
                                db,
                                table,
                                p0,
                              ).canvasItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pageId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PagesTable,
      Page,
      $$PagesTableFilterComposer,
      $$PagesTableOrderingComposer,
      $$PagesTableAnnotationComposer,
      $$PagesTableCreateCompanionBuilder,
      $$PagesTableUpdateCompanionBuilder,
      (Page, $$PagesTableReferences),
      Page,
      PrefetchHooks Function({bool carouselId, bool canvasItemsRefs})
    >;
typedef $$CanvasItemsTableCreateCompanionBuilder =
    CanvasItemsCompanion Function({
      required String id,
      required String pageId,
      required String filePath,
      required String mediaType,
      required double positionX,
      required double positionY,
      required double width,
      required double height,
      Value<double> rotation,
      Value<int> zIndex,
      Value<bool> spanToNextPage,
      Value<String?> cropRect,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CanvasItemsTableUpdateCompanionBuilder =
    CanvasItemsCompanion Function({
      Value<String> id,
      Value<String> pageId,
      Value<String> filePath,
      Value<String> mediaType,
      Value<double> positionX,
      Value<double> positionY,
      Value<double> width,
      Value<double> height,
      Value<double> rotation,
      Value<int> zIndex,
      Value<bool> spanToNextPage,
      Value<String?> cropRect,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$CanvasItemsTableReferences
    extends BaseReferences<_$AppDatabase, $CanvasItemsTable, CanvasItem> {
  $$CanvasItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PagesTable _pageIdTable(_$AppDatabase db) => db.pages.createAlias(
    $_aliasNameGenerator(db.canvasItems.pageId, db.pages.id),
  );

  $$PagesTableProcessedTableManager get pageId {
    final $_column = $_itemColumn<String>('page_id')!;

    final manager = $$PagesTableTableManager(
      $_db,
      $_db.pages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CanvasItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CanvasItemsTable> {
  $$CanvasItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get positionX => $composableBuilder(
    column: $table.positionX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get positionY => $composableBuilder(
    column: $table.positionY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rotation => $composableBuilder(
    column: $table.rotation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get zIndex => $composableBuilder(
    column: $table.zIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get spanToNextPage => $composableBuilder(
    column: $table.spanToNextPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cropRect => $composableBuilder(
    column: $table.cropRect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PagesTableFilterComposer get pageId {
    final $$PagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pageId,
      referencedTable: $db.pages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagesTableFilterComposer(
            $db: $db,
            $table: $db.pages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CanvasItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CanvasItemsTable> {
  $$CanvasItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get positionX => $composableBuilder(
    column: $table.positionX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get positionY => $composableBuilder(
    column: $table.positionY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rotation => $composableBuilder(
    column: $table.rotation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get zIndex => $composableBuilder(
    column: $table.zIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get spanToNextPage => $composableBuilder(
    column: $table.spanToNextPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cropRect => $composableBuilder(
    column: $table.cropRect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PagesTableOrderingComposer get pageId {
    final $$PagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pageId,
      referencedTable: $db.pages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagesTableOrderingComposer(
            $db: $db,
            $table: $db.pages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CanvasItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CanvasItemsTable> {
  $$CanvasItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<double> get positionX =>
      $composableBuilder(column: $table.positionX, builder: (column) => column);

  GeneratedColumn<double> get positionY =>
      $composableBuilder(column: $table.positionY, builder: (column) => column);

  GeneratedColumn<double> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<double> get rotation =>
      $composableBuilder(column: $table.rotation, builder: (column) => column);

  GeneratedColumn<int> get zIndex =>
      $composableBuilder(column: $table.zIndex, builder: (column) => column);

  GeneratedColumn<bool> get spanToNextPage => $composableBuilder(
    column: $table.spanToNextPage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cropRect =>
      $composableBuilder(column: $table.cropRect, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PagesTableAnnotationComposer get pageId {
    final $$PagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pageId,
      referencedTable: $db.pages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagesTableAnnotationComposer(
            $db: $db,
            $table: $db.pages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CanvasItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CanvasItemsTable,
          CanvasItem,
          $$CanvasItemsTableFilterComposer,
          $$CanvasItemsTableOrderingComposer,
          $$CanvasItemsTableAnnotationComposer,
          $$CanvasItemsTableCreateCompanionBuilder,
          $$CanvasItemsTableUpdateCompanionBuilder,
          (CanvasItem, $$CanvasItemsTableReferences),
          CanvasItem,
          PrefetchHooks Function({bool pageId})
        > {
  $$CanvasItemsTableTableManager(_$AppDatabase db, $CanvasItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CanvasItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CanvasItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CanvasItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> pageId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> mediaType = const Value.absent(),
                Value<double> positionX = const Value.absent(),
                Value<double> positionY = const Value.absent(),
                Value<double> width = const Value.absent(),
                Value<double> height = const Value.absent(),
                Value<double> rotation = const Value.absent(),
                Value<int> zIndex = const Value.absent(),
                Value<bool> spanToNextPage = const Value.absent(),
                Value<String?> cropRect = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CanvasItemsCompanion(
                id: id,
                pageId: pageId,
                filePath: filePath,
                mediaType: mediaType,
                positionX: positionX,
                positionY: positionY,
                width: width,
                height: height,
                rotation: rotation,
                zIndex: zIndex,
                spanToNextPage: spanToNextPage,
                cropRect: cropRect,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String pageId,
                required String filePath,
                required String mediaType,
                required double positionX,
                required double positionY,
                required double width,
                required double height,
                Value<double> rotation = const Value.absent(),
                Value<int> zIndex = const Value.absent(),
                Value<bool> spanToNextPage = const Value.absent(),
                Value<String?> cropRect = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CanvasItemsCompanion.insert(
                id: id,
                pageId: pageId,
                filePath: filePath,
                mediaType: mediaType,
                positionX: positionX,
                positionY: positionY,
                width: width,
                height: height,
                rotation: rotation,
                zIndex: zIndex,
                spanToNextPage: spanToNextPage,
                cropRect: cropRect,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CanvasItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pageId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (pageId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pageId,
                                referencedTable: $$CanvasItemsTableReferences
                                    ._pageIdTable(db),
                                referencedColumn: $$CanvasItemsTableReferences
                                    ._pageIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CanvasItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CanvasItemsTable,
      CanvasItem,
      $$CanvasItemsTableFilterComposer,
      $$CanvasItemsTableOrderingComposer,
      $$CanvasItemsTableAnnotationComposer,
      $$CanvasItemsTableCreateCompanionBuilder,
      $$CanvasItemsTableUpdateCompanionBuilder,
      (CanvasItem, $$CanvasItemsTableReferences),
      CanvasItem,
      PrefetchHooks Function({bool pageId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$CarouselsTableTableManager get carousels =>
      $$CarouselsTableTableManager(_db, _db.carousels);
  $$PagesTableTableManager get pages =>
      $$PagesTableTableManager(_db, _db.pages);
  $$CanvasItemsTableTableManager get canvasItems =>
      $$CanvasItemsTableTableManager(_db, _db.canvasItems);
}
