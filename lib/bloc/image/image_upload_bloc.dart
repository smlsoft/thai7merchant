import 'package:bloc/bloc.dart';
import 'package:thai7merchant/repositories/image_upload_repository.dart';
import 'package:thai7merchant/model/image_upload.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'image_upload_event.dart';
part 'image_upload_state.dart';

class ImageUploadBloc extends Bloc<ImageUploadEvent, ImageUploadState> {
  final ImageUploadRepository _imageUploadRepository;

  ImageUploadBloc({required ImageUploadRepository imageUploadRepository})
      : _imageUploadRepository = imageUploadRepository,
        super(ImageUploadInitial()) {
    on<ImageUploadSaved>(_onImageUpload);
  }
  void _onImageUpload(
      ImageUploadSaved event, Emitter<ImageUploadState> emit) async {
    emit(ImageUploadSaveInProgress());
    try {
      final _result =
          await _imageUploadRepository.uploadImage(event.imageupload);

      if (_result.success) {
        ImageUpload _imageUpload = ImageUpload.fromJson(_result.data);
        emit(ImageUploadSaveSuccess(imageUpload: _imageUpload));
      } else {
        emit(ImageUploadSaveFailure(message: 'ImageUpload Not Found'));
      }
    } catch (e) {
      emit(ImageUploadSaveFailure(message: e.toString()));
    }
  }
}
