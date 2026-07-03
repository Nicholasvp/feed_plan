enum MediaType {
  image,
  video;

  bool get isImage => this == MediaType.image;
  bool get isVideo => this == MediaType.video;

  static MediaType fromString(String value) {
    switch (value) {
      case 'video':
        return MediaType.video;
      default:
        return MediaType.image;
    }
  }
}
