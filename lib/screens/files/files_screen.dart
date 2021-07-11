import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tz_flutter/blocs/blocs.dart';
import 'package:tz_flutter/models/models.dart';

class FilesScreen extends StatefulWidget {
  @override
  _FilesScreenState createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DownloaderBloc, DownloaderState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Файлы'),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              if (state.getCount < 30)
                context.read<DownloaderBloc>().add(DownloaderAddTask());
            },
          ),
          body: ListView.builder(
            itemCount: state.getCount,
            itemBuilder: (ctx, index) {
              FileModel file = state.files[index];
              return ListTile(
                title: Text('Файл ${file.id}'),
                subtitle: file.status == FileStatus.waiting
                    ? Text('В ожидании')
                    : file.status == FileStatus.uploading
                        ? Text('Загружается')
                        : null,
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => context.read<DownloaderBloc>().add(
                        DownloaderDeleteTask(id: file.id),
                      ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
