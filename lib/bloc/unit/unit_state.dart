part of 'unit_bloc.dart';

abstract class UnitState extends Equatable {
  const UnitState();

  @override
  List<Object> get props => [];
}

//Load

class UnitInitial extends UnitState {}

class UnitInProgress extends UnitState {}

class UnitLoadSuccess extends UnitState {
  List<UnitModel> unit;
  final Page? page;

  UnitLoadSuccess({required this.unit, required this.page});

  UnitLoadSuccess copyWith({
    List<UnitModel>? unit,
    final Page? page,
  }) =>
      UnitLoadSuccess(
        unit: unit ?? this.unit,
        page: page ?? this.page,
      );

  @override
  List<Object> get props => [unit];
}

class UnitLoadFailed extends UnitState {
  final String message;
  UnitLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
