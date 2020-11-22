import 'package:flutter/material.dart';
import 'package:hknews_repository/hknews_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import './app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build();

  runApp(
    MyApp(
      authenticationRepository: AuthenticationRepositoryImpl(),
      userRepository: UserRepositoryImpl(),
      storiesRepository: StoriesRepositoryImpl(),
    ),
  );
}
