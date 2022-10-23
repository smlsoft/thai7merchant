part of 'image_upload_bloc.dart';

abstract class ImageUploadState extends Equatable {
  const ImageUploadState();

  @override
  List<Object> get props => [];
}

class ImageUploadInitial extends ImageUploadState {}

class ImageUploadSaveInProgress extends ImageUploadState {}

class ImageUploadSaveSuccess extends ImageUploadState {
  ImageUpload imageUpload;

  ImageUploadSaveSuccess({
    required this.imageUpload,
  });

  @override
  List<Object> get props => [imageUpload];
}

class ImageUploadSaveFailure extends ImageUploadState {
  final String message;
  const ImageUploadSaveFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
