import 'dart:math';

import 'package:equatable/equatable.dart';

enum FileStatus { waiting, uploading, uploaded }

class FileModel extends Equatable {
  final int id;
  final int durationSeconds;
  final FileStatus status;

  const FileModel({
    required this.id,
    required this.durationSeconds,
    required this.status,
  });

  @override
  List<Object?> get props => [id, status];

  FileModel copyWith({
    int? id,
    int? durationSeconds,
    FileStatus? status,
  }) {
    return FileModel(
      id: id ?? this.id,
      durationSeconds: durationSeconds ?? this.id,
      status: status ?? this.status,
    );
  }

  factory FileModel.newFile(int id) {
    int durationSeconds = Random().nextInt(4) + 1;
    return FileModel(
      id: id,
      durationSeconds: durationSeconds,
      status: FileStatus.waiting,
    );
  }
}
