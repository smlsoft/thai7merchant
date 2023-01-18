import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thai7merchant/model/kitchen_model.dart';
import 'package:thai7merchant/repositories/kitchen_repository.dart';
import 'dart:io';

part 'kitchen_event.dart';
part 'kitchen_state.dart';

class KitchenBloc extends Bloc<KitchenEvent, KitchenState> {
  final KitchenRepository _kitchenRepository;

  KitchenBloc({required KitchenRepository kitchenRepository})
      : _kitchenRepository = kitchenRepository,
        super(KitchenInitial()) {
    on<KitchenLoadList>(onKitchenLoad);
    on<KitchenSave>(onKitchenSave);
    on<KitchenUpdate>(onKitchenUpdate);
    on<KitchenDelete>(kitchenDelete);
    on<KitchenDeleteMany>(kitchenDeleteMany);
    on<KitchenGet>(onKitchenGet);
  }

  void onKitchenLoad(KitchenLoadList event, Emitter<KitchenState> emit) async {
    emit(KitchenInProgress());

    try {
      final results = await _kitchenRepository.getKitchenList(
          offset: event.offset, limit: event.limit, search: event.search);

      if (results.success) {
        List<KitchenModel> kitchens = (results.data as List)
            .map((kitchen) => KitchenModel.fromJson(kitchen))
            .toList();
        emit(KitchenLoadSuccess(kitchens: kitchens));
      } else {
        emit(const KitchenLoadFailed(message: 'Kitchen Group Not Found'));
      }
    } catch (e) {
      emit(KitchenLoadFailed(message: e.toString()));
    }
  }

  void kitchenDelete(KitchenDelete event, Emitter<KitchenState> emit) async {
    emit(KitchenDeleteInProgress());
    try {
      await _kitchenRepository.deleteKitchen(event.guid);

      emit(KitchenDeleteSuccess());
    } catch (e) {
      // emit(KitchenDeleteFailure(message: e.toString()));
    }
  }

  void kitchenDeleteMany(
      KitchenDeleteMany event, Emitter<KitchenState> emit) async {
    emit(KitchenDeleteManyInProgress());
    try {
      await _kitchenRepository.deleteKitchenMany(event.guid);

      emit(KitchenDeleteManySuccess());
    } catch (e) {
      // emit(KitchenDeleteFailure(message: e.toString()));
    }
  }

  void onKitchenSave(KitchenSave event, Emitter<KitchenState> emit) async {
    emit(KitchenSaveInProgress());
    try {
      await _kitchenRepository.saveKitchen(event.kitchenModel);
      emit(KitchenSaveSuccess());
    } catch (e) {
      emit(KitchenSaveFailed(message: e.toString()));
    }
  }

  void onKitchenUpdate(KitchenUpdate event, Emitter<KitchenState> emit) async {
    emit(KitchenUpdateInProgress());
    try {
      await _kitchenRepository.updateKitchen(event.guid, event.kitchenModel);
      emit(KitchenUpdateSuccess());
    } catch (e) {
      emit(KitchenUpdateFailed(message: e.toString()));
    }
  }

  void onKitchenGet(KitchenGet event, Emitter<KitchenState> emit) async {
    emit(KitchenGetInProgress());
    try {
      final result = await _kitchenRepository.getKitchen(event.guid);
      if (result.success) {
        KitchenModel kitchen = KitchenModel.fromJson(result.data);
        emit(KitchenGetSuccess(kitchen: kitchen));
      } else {
        emit(const KitchenGetFailed(message: 'Kitchen Not Found'));
      }
    } catch (e) {
      // emit(KitchenDeleteFailure(message: e.toString()));
    }
  }
}
