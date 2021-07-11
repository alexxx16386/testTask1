import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tz_flutter/models/models.dart';
import 'package:tz_flutter/repositories/repositories.dart';

part 'downloader_event.dart';
part 'downloader_state.dart';

class DownloaderBloc extends Bloc<DownloaderEvent, DownloaderState> {
  final FileRepository _fileRepository;

  DownloaderBloc({
    required FileRepository fileRepository,
  })  : _fileRepository = fileRepository,
        super(DownloaderState.initial());

  @override
  Stream<DownloaderState> mapEventToState(
    DownloaderEvent event,
  ) async* {
    if (event is DownloaderAddTask) {
      yield* _mapDownloaderAddTask(event);
    } else if (event is DownloaderDeleteTask) {
      yield* _mapDownloaderDeleteTask(event);
    } else if (event is DownloaderTaskComplete) {
      yield* _mapDownloaderTaskComplete(event);
    } else if (event is DownloaderClean) {
      yield* _mapDownloaderClean(event);
    } else if (event is DownloaderSave) {
      yield* _mapDownloaderSave(event);
    }
  }

  Stream<DownloaderState> _mapDownloaderAddTask(
    DownloaderAddTask event,
  ) async* {
    final int newFileId = _fileRepository.createFile();
    if (_fileRepository.getCountLoading() < 3) startDownload(newFileId);
    yield state.copyWith(
      status: DownloaderStatus.fileAdded,
      files: _fileRepository.getFiles(),
    );
    yield state.copyWith(
      status: DownloaderStatus.initial,
    );
  }

  Stream<DownloaderState> _mapDownloaderDeleteTask(
    DownloaderDeleteTask event,
  ) async* {
    _fileRepository.deleteFile(event.id);
    yield state.copyWith(
      status: DownloaderStatus.fileDeleted,
      files: _fileRepository.getFiles(),
    );
    yield state.copyWith(
      status: DownloaderStatus.initial,
    );
  }

  Stream<DownloaderState> _mapDownloaderTaskComplete(
    DownloaderTaskComplete event,
  ) async* {
    if (_fileRepository.getCountLoading() < 3) {
      if (_fileRepository.getCountWaiting() > 0)
        startDownload(_fileRepository.getFirstWaitingFileId());
    }

    yield DownloaderState(
      status: DownloaderStatus.fileAdded,
      files: _fileRepository.getFiles(),
    );
    yield state.copyWith(
      status: DownloaderStatus.initial,
    );
  }

  Stream<DownloaderState> _mapDownloaderClean(
    DownloaderClean event,
  ) async* {
    _fileRepository.clearFiles();
    yield state.copyWith(
      status: DownloaderStatus.fileDeleted,
      files: _fileRepository.getFiles(),
    );
    yield state.copyWith(
      status: DownloaderStatus.initial,
    );
  }

  Stream<DownloaderState> _mapDownloaderSave(
    DownloaderSave event,
  ) async* {
    yield state.copyWith(
      status: DownloaderStatus.saved,
    );
    yield state.copyWith(
      status: DownloaderStatus.initial,
    );
  }

  Future startDownload(int id) async {
    final FileModel file = _fileRepository.getFile(id);
    _fileRepository.setFileStatus(id, FileStatus.uploading);

    Future.delayed(
      Duration(seconds: file.durationSeconds),
      () {
        _fileRepository.setFileStatus(id, FileStatus.uploaded);

        add(DownloaderTaskComplete(id: file.id));
      },
    );
  }
}
