import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'core/utils/logger.dart';
import 'data/database/app_database.dart';
import 'data/repositories/carousel_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'presentation/bloc/carousel_editor/carousel_editor_bloc.dart';
import 'presentation/bloc/carousel_list/carousel_list_bloc.dart';
import 'presentation/bloc/locale/locale_bloc.dart';
import 'presentation/bloc/profile/profile_bloc.dart';
import 'presentation/bloc/profile/profile_event.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final database = AppDatabase();
    final profileRepository = ProfileRepositoryImpl(database);
    final carouselRepository = CarouselRepositoryImpl(database);

    FlutterError.onError = (details) {
      Logger.logError(
        details.exceptionAsString(),
        context: 'FlutterError',
        stackTrace: details.stack,
      );
    };

    runApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: database),
          RepositoryProvider.value(value: profileRepository),
          RepositoryProvider.value(value: carouselRepository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => LocaleBloc()),
            BlocProvider(
              create: (_) =>
                  ProfileBloc(profileRepository)..add(const LoadProfile()),
            ),
            BlocProvider(
              create: (_) => CarouselListBloc(carouselRepository),
            ),
            BlocProvider(
              create: (_) => CarouselEditorBloc(carouselRepository),
            ),
          ],
          child: const FeedPlanApp(),
        ),
      ),
    );
  }, (error, stackTrace) {
    Logger.logError(error.toString(), context: 'Zone', stackTrace: stackTrace);
  });
}
