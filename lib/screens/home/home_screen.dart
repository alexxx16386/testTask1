import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tz_flutter/blocs/blocs.dart';
import 'package:tz_flutter/screens/files/files_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DownloaderBloc, DownloaderState>(
      listener: (context, state) {
        if (state.status == DownloaderStatus.saved) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Saved'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Ok'),
                ),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Home Page'),
          ),
          body: ListTile(
            title: Text('Файлы'),
            subtitle: state.getCountUnloaded > 0
                ? Text(
                    'Осталось загрузить: ${state.getCountUnloaded}. Всего файлов: ${state.getCount}')
                : Text('Кол-во файлов: ${state.getCount}'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => FilesScreen()),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (state.getCount != 0)
                          context.read<DownloaderBloc>().add(DownloaderClean());
                      },
                      child: Text('Сбросить'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (state.getCount != 0)
                          context.read<DownloaderBloc>().add(DownloaderSave());
                      },
                      child: Text('Сохранить'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
