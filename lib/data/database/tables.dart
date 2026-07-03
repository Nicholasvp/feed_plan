import 'package:drift/drift.dart';

class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get bio => text().nullable()();
  TextColumn get avatarPath => text().nullable()();
  IntColumn get postCount => integer().withDefault(const Constant(0))();
  IntColumn get followerCount => integer().withDefault(const Constant(0))();
  IntColumn get followingCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Carousels extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().references(Profiles, #id)();
  IntColumn get order => integer()();
  TextColumn get aspectRatio => text().withDefault(const Constant('1:1'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Pages extends Table {
  TextColumn get id => text()();
  TextColumn get carouselId => text().references(Carousels, #id)();
  IntColumn get orderIndex => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class CanvasItems extends Table {
  TextColumn get id => text()();
  TextColumn get pageId => text().references(Pages, #id)();
  TextColumn get filePath => text()();
  TextColumn get mediaType => text()();
  RealColumn get positionX => real()();
  RealColumn get positionY => real()();
  RealColumn get width => real()();
  RealColumn get height => real()();
  RealColumn get rotation => real().withDefault(const Constant(0.0))();
  IntColumn get zIndex => integer().withDefault(const Constant(0))();
  BoolColumn get spanToNextPage =>
      boolean().withDefault(const Constant(false))();
  TextColumn get cropRect => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
