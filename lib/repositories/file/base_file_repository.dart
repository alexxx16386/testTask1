import 'package:tz_flutter/models/models.dart';

abstract class BaseFileRepository {
  List<FileModel> getFiles();
  int createFile();
  void deleteFile(int id);
  int getCountUnloaded();
  int getCountLoading();
  int getCountWaiting();
  int getFirstWaitingFileId();
  FileModel getFile(int id);
  void setFileStatus(int id, FileStatus status);
  void clearFiles();
}
