import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';
import 'core/database/hive_service.dart';
import 'core/utils/logger.dart';
import 'data/repositories/carousel_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'data/services/revenuecat_service.dart';
import 'presentation/bloc/carousel_editor/carousel_editor_bloc.dart';
import 'presentation/bloc/carousel_list/carousel_list_bloc.dart';
import 'presentation/bloc/locale/locale_bloc.dart';
import 'presentation/bloc/premium/premium_cubit.dart';
import 'presentation/bloc/profile/profile_bloc.dart';
import 'presentation/bloc/profile/profile_event.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load(fileName: '.env');

    await HiveService.initialize();

    await RevenueCatService.instance.initialize();

    final profilesBox = await HiveService.openProfilesBox();
    final carouselsBox = await HiveService.openCarouselsBox();
    final pagesBox = await HiveService.openPagesBox();
    final canvasItemsBox = await HiveService.openCanvasItemsBox();

    final profileRepository = ProfileRepositoryImpl(profilesBox);
    final carouselRepository = CarouselRepositoryImpl(
      carouselsBox: carouselsBox,
      pagesBox: pagesBox,
      canvasItemsBox: canvasItemsBox,
    );

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
            BlocProvider(create: (_) {
              final cubit = PremiumCubit();
              cubit.load();
              return cubit;
            }),
          ],
          child: const FeedPlanApp(),
        ),
      ),
    );
  }, (error, stackTrace) {
    Logger.logError(error.toString(), context: 'Zone', stackTrace: stackTrace);
  });
}
