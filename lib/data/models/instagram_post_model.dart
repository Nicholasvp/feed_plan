import 'package:equatable/equatable.dart';

class InstagramPostModel extends Equatable {
  final String id;
  final String shortCode;
  final String displayUrl;
  final String? caption;
  final int likesCount;
  final int commentsCount;
  final DateTime? timestamp;
  final String ownerUsername;
  final String type;
  final String? videoUrl;
  final String postUrl;

  const InstagramPostModel({
    required this.id,
    required this.shortCode,
    required this.displayUrl,
    this.caption,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.timestamp,
    this.ownerUsername = '',
    this.type = 'Image',
    this.videoUrl,
    this.postUrl = '',
  });

  bool get isVideo => type == 'Video';
  bool get isSidecar => type == 'Sidecar';

  factory InstagramPostModel.fromJson(Map<String, dynamic> json) {
    return InstagramPostModel(
      id: json['id']?.toString() ?? '',
      shortCode: json['shortCode']?.toString() ?? '',
      displayUrl: json['displayUrl']?.toString() ?? '',
      caption: json['caption']?.toString(),
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      timestamp: _parseTimestamp(json['timestamp']),
      ownerUsername: json['ownerUsername']?.toString() ?? '',
      type: json['type']?.toString() ?? 'Image',
      videoUrl: json['videoUrl']?.toString(),
      postUrl: json['url']?.toString() ?? '',
    );
  }

  factory InstagramPostModel.fromMap(Map<String, dynamic> map) {
    return InstagramPostModel(
      id: map['id']?.toString() ?? '',
      shortCode: map['shortCode']?.toString() ?? '',
      displayUrl: map['displayUrl']?.toString() ?? '',
      caption: map['caption']?.toString(),
      likesCount: map['likesCount'] ?? 0,
      commentsCount: map['commentsCount'] ?? 0,
      timestamp: map['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
          : null,
      ownerUsername: map['ownerUsername']?.toString() ?? '',
      type: map['type']?.toString() ?? 'Image',
      videoUrl: map['videoUrl']?.toString(),
      postUrl: map['postUrl']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shortCode': shortCode,
      'displayUrl': displayUrl,
      'caption': caption,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'ownerUsername': ownerUsername,
      'type': type,
      'videoUrl': videoUrl,
      'postUrl': postUrl,
    };
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  InstagramPostModel copyWith({
    String? id,
    String? shortCode,
    String? displayUrl,
    String? caption,
    int? likesCount,
    int? commentsCount,
    DateTime? timestamp,
    String? ownerUsername,
    String? type,
    String? videoUrl,
    String? postUrl,
  }) {
    return InstagramPostModel(
      id: id ?? this.id,
      shortCode: shortCode ?? this.shortCode,
      displayUrl: displayUrl ?? this.displayUrl,
      caption: caption ?? this.caption,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      timestamp: timestamp ?? this.timestamp,
      ownerUsername: ownerUsername ?? this.ownerUsername,
      type: type ?? this.type,
      videoUrl: videoUrl ?? this.videoUrl,
      postUrl: postUrl ?? this.postUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        shortCode,
        displayUrl,
        caption,
        likesCount,
        commentsCount,
        timestamp,
        ownerUsername,
        type,
        videoUrl,
        postUrl,
      ];
}
