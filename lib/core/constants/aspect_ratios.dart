class AspectRatioPreset {
  const AspectRatioPreset({
    required this.label,
    required this.value,
    required this.width,
    required this.height,
  });

  final String label;
  final String value;
  final double width;
  final double height;

  static const square = AspectRatioPreset(
    label: 'Square (1:1)',
    value: '1:1',
    width: 1,
    height: 1,
  );

  static const portrait = AspectRatioPreset(
    label: 'Portrait (4:5)',
    value: '4:5',
    width: 4,
    height: 5,
  );

  static const story = AspectRatioPreset(
    label: 'Story (9:16)',
    value: '9:16',
    width: 9,
    height: 16,
  );

  static const landscape = AspectRatioPreset(
    label: 'Landscape (16:9)',
    value: '16:9',
    width: 16,
    height: 9,
  );

  static const List<AspectRatioPreset> all = [
    square,
    portrait,
    story,
    landscape,
  ];

  static AspectRatioPreset fromValue(String value) {
    return all.firstWhere(
      (preset) => preset.value == value,
      orElse: () => square,
    );
  }
}
