import 'package:tz_flutter/models/models.dart';
import 'package:tz_flutter/repositories/repositories.dart';

class FileRepository extends BaseFileRepository {
  List<FileModel> _files = [];

  @override
  int createFile() {
    int id = 0;
    if (_files.length > 0) {
      id = _files.last.id + 1;
    }
    _files.add(FileModel.newFile(id));
    return id;
  }

  @override
  void deleteFile(int id) {
    for (int i = 0; i < _files.length; i++) {
      if (_files[i].id == id) {
        _files.removeAt(i);
      }
    }
  }

  @override
  List<FileModel> getFiles() {
    return _files;
  }

  @override
  int getCountUnloaded() {
    int notLoadedCount = 0;
    for (int i = 0; i < _files.length; i++) {
      if (_files[i].status != FileStatus.uploaded) notLoadedCount += 1;
    }
    return notLoadedCount;
  }

  @override
  int getCountLoading() {
    int loadingCount = 0;
    for (int i = 0; i < _files.length; i++) {
      if (_files[i].status == FileStatus.uploading) loadingCount += 1;
    }
    return loadingCount;
  }

  @override
  FileModel getFile(int id) {
    for (int i = 0; i < _files.length; i++) {
      if (_files[i].id == id) {
        return _files[i];
      }
    }

    throw UnimplementedError();
  }

  @override
  void setFileStatus(int id, FileStatus status) {
    for (int i = 0; i < _files.length; i++) {
      if (_files[i].id == id) {
        _files[i] = _files[i].copyWith(status: status);
      }
      continue;
    }
  }

  @override
  int getCountWaiting() {
    int loadingCount = 0;
    for (int i = 0; i < _files.length; i++) {
      if (_files[i].status == FileStatus.waiting) loadingCount += 1;
    }
    return loadingCount;
  }

  @override
  int getFirstWaitingFileId() {
    for (int i = 0; i < _files.length; i++) {
      if (_files[i].status == FileStatus.waiting) return _files[i].id;
    }
    return 0;
  }

  @override
  void clearFiles() {
    _files.clear();
  }
}
