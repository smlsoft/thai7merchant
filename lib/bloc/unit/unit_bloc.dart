import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thai7merchant/repositories/unit_repository.dart';
import 'package:thai7merchant/repositories/client.dart';
import 'package:thai7merchant/model/unit.dart';

import '../../model/unit.dart';

part 'unit_event.dart';
part 'unit_state.dart';

class UnitBloc extends Bloc<UnitEvent, UnitState> {
  final UnitRepository _unitRepository;

  UnitBloc({required UnitRepository unitRepository})
      : _unitRepository = unitRepository,
        super(UnitInitial()) {
    on<ListUnitLoad>(_onUnitLoad);
    on<ListUnitSave>(_onUnitSave);
    on<ListUnitDelete>(_UnitDelete);
  }

  void _onUnitLoad(ListUnitLoad event, Emitter<UnitState> emit) async {
    UnitLoadSuccess unitLoadSuccess;
    List<UnitModel> _previousUnit = [];
    if (state is UnitLoadSuccess) {
      unitLoadSuccess = (state as UnitLoadSuccess).copyWith();
      _previousUnit = unitLoadSuccess.unit;
    }
    emit(UnitInProgress());

    try {
      final _result = await _unitRepository.getUnitList(
          perPage: event.perPage, page: event.page, search: event.search);

      if (_result.success) {
        if (event.nextPage) {
          List<UnitModel> _unit = (_result.data as List)
              .map((unit) => UnitModel.fromJson(unit))
              .toList();

          emit(UnitLoadSuccess(unit: _unit, page: _result.page));
        } else {
          List<UnitModel> _unit = (_result.data as List)
              .map((unit) => UnitModel.fromJson(unit))
              .toList();
          // print(_unit);
          _previousUnit.addAll(_unit);
          emit(UnitLoadSuccess(unit: _previousUnit, page: _result.page));
        }
      } else {
        emit(UnitLoadFailed(message: 'Unit Not Found'));
      }
    } catch (e) {
      emit(UnitLoadFailed(message: e.toString()));
    }
  }

  void _UnitDelete(ListUnitDelete event, Emitter<UnitState> emit) async {
    emit(UnitdeleteInProgress());
    try {
      // print(event.inventory.toString());

      await _unitRepository.deleteUnit(event.id);

      emit(UnitDeleteSuccess());
    } catch (e) {
      // emit(UnitDeleteFailure(message: e.toString()));
    }
  }

  void _onUnitSave(ListUnitSave event, Emitter<UnitState> emit) async {
    emit(UnitSaveInProgress());
    try {
      // print(event.inventory.toString());

      await _unitRepository.postUnitList(event.unitModel);
      // print('Success');
      emit(UnitSaveSuccess());
    } catch (e) {
      emit(UnitSaveFailed(message: e.toString()));
    }
  }
}








//   void _onUnitSave(ListUnitSave event, Emitter<UnitState> emit) async {
//     UnitLoadSuccess unitLoadSuccess;
//     List<UnitModel> _previousUnit = [];
//     if (state is UnitLoadSuccess) {
//       unitLoadSuccess = (state as UnitLoadSuccess).copyWith();
//       _previousUnit = unitLoadSuccess.unit;
//     }
//     emit(UnitInProgress());

//     try {
//       final _result = await _unitRepository.postUnitList(
//           perPage: event.perPage, page: event.page, search: event.search);

//       if (_result.success) {
//         if (event.nextPage) {
//           List<UnitModel> _unit = (_result.data as List)
//               .map((unit) => UnitModel.fromJson(unit))
//               .toList();

//           emit(UnitLoadSuccess(unit: _unit, page: _result.page));
//         } else {
//           List<UnitModel> _unit = (_result.data as List)
//               .map((unit) => UnitModel.fromJson(unit))
//               .toList();
//           // print(_unit);
//           _previousUnit.addAll(_unit);
//           emit(UnitLoadSuccess(unit: _previousUnit, page: _result.page));
//         }
//       } else {
//         emit(UnitLoadFailed(message: 'Unit Not Found'));
//       }
//     } catch (e) {
//       emit(UnitLoadFailed(message: e.toString()));
//     }
//   }
// }
