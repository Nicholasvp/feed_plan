class GridCell {
  const GridCell({
    required this.cellId,
    required this.positionX,
    required this.positionY,
    required this.width,
    required this.height,
  });

  final String cellId;
  final double positionX;
  final double positionY;
  final double width;
  final double height;
}

class GridLayout {
  const GridLayout({
    required this.id,
    required this.name,
    required this.cells,
  });

  final String id;
  final String name;
  final List<GridCell> cells;

  static const twoHorizontal = GridLayout(
    id: '2h',
    name: '2 side by side',
    cells: [
      GridCell(cellId: 'left', positionX: 0.0, positionY: 0.0, width: 0.5, height: 1.0),
      GridCell(cellId: 'right', positionX: 0.5, positionY: 0.0, width: 0.5, height: 1.0),
    ],
  );

  static const twoVertical = GridLayout(
    id: '2v',
    name: '2 stacked',
    cells: [
      GridCell(cellId: 'top', positionX: 0.0, positionY: 0.0, width: 1.0, height: 0.5),
      GridCell(cellId: 'bottom', positionX: 0.0, positionY: 0.5, width: 1.0, height: 0.5),
    ],
  );

  static const threeTwoTopOneBottom = GridLayout(
    id: '3_2t1b',
    name: '2 top, 1 bottom',
    cells: [
      GridCell(cellId: 'top-left', positionX: 0.0, positionY: 0.0, width: 0.5, height: 0.5),
      GridCell(cellId: 'top-right', positionX: 0.5, positionY: 0.0, width: 0.5, height: 0.5),
      GridCell(cellId: 'bottom', positionX: 0.0, positionY: 0.5, width: 1.0, height: 0.5),
    ],
  );

  static const threeOneTopTwoBottom = GridLayout(
    id: '3_1t2b',
    name: '1 top, 2 bottom',
    cells: [
      GridCell(cellId: 'top', positionX: 0.0, positionY: 0.0, width: 1.0, height: 0.5),
      GridCell(cellId: 'bottom-left', positionX: 0.0, positionY: 0.5, width: 0.5, height: 0.5),
      GridCell(cellId: 'bottom-right', positionX: 0.5, positionY: 0.5, width: 0.5, height: 0.5),
    ],
  );

  static const fourGrid = GridLayout(
    id: '4',
    name: '2x2 grid',
    cells: [
      GridCell(cellId: 'top-left', positionX: 0.0, positionY: 0.0, width: 0.5, height: 0.5),
      GridCell(cellId: 'top-right', positionX: 0.5, positionY: 0.0, width: 0.5, height: 0.5),
      GridCell(cellId: 'bottom-left', positionX: 0.0, positionY: 0.5, width: 0.5, height: 0.5),
      GridCell(cellId: 'bottom-right', positionX: 0.5, positionY: 0.5, width: 0.5, height: 0.5),
    ],
  );

  static const List<GridLayout> all = [
    twoHorizontal,
    twoVertical,
    threeTwoTopOneBottom,
    threeOneTopTwoBottom,
    fourGrid,
  ];

  static GridLayout fromId(String id) {
    return all.firstWhere(
      (l) => l.id == id,
      orElse: () => twoHorizontal,
    );
  }
}
