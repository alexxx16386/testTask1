import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tz_flutter/blocs/blocs.dart';
import 'package:tz_flutter/repositories/repositories.dart';
import 'package:tz_flutter/screens/home/home_screen.dart';

import 'blocs/simple_bloc_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObsever();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => FileRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<DownloaderBloc>(
            create: (context) =>
                DownloaderBloc(fileRepository: context.read<FileRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: HomeScreen(),
        ),
      ),
    );
  }
}
