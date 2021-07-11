part of 'downloader_bloc.dart';

abstract class DownloaderEvent extends Equatable {
  const DownloaderEvent();

  @override
  List<Object> get props => [];
}

class DownloaderAddTask extends DownloaderEvent {}

class DownloaderDeleteTask extends DownloaderEvent {
  final int id;

  const DownloaderDeleteTask({required this.id});

  @override
  List<Object> get props => [id];
}

class DownloaderTaskComplete extends DownloaderEvent {
  final int id;

  const DownloaderTaskComplete({required this.id});

  @override
  List<Object> get props => [id];
}

class DownloaderSave extends DownloaderEvent {}

class DownloaderClean extends DownloaderEvent {}
