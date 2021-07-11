part of 'downloader_bloc.dart';

enum DownloaderStatus {
  initial,
  nothing,
  fileLoaded,
  fileAdded,
  fileDeleted,
  saved
}

class DownloaderState extends Equatable {
  final List<FileModel> files;
  final DownloaderStatus status;

  const DownloaderState({
    required this.files,
    required this.status,
  });

  factory DownloaderState.initial() {
    return DownloaderState(
      files: [],
      status: DownloaderStatus.initial,
    );
  }

  int get getCountUnloaded {
    int notLoadedCount = 0;
    for (int i = 0; i < files.length; i++) {
      if (files[i].status != FileStatus.uploaded) notLoadedCount += 1;
    }
    return notLoadedCount;
  }

  int get getCount => files.length;

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [files, status];

  DownloaderState copyWith({
    List<FileModel>? files,
    DownloaderStatus? status,
  }) {
    return DownloaderState(
      files: files ?? this.files,
      status: status ?? this.status,
    );
  }
}
