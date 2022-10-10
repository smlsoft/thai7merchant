part of 'image_upload_bloc.dart';

abstract class ImageUploadEvent extends Equatable {
  const ImageUploadEvent();

  @override
  List<Object> get props => [];
}

class ImageUploadSaved extends ImageUploadEvent {
  final ImageUpload imageupload;

  const ImageUploadSaved({
    required this.imageupload,
  });

  @override
  List<Object> get props => [imageupload];
}
