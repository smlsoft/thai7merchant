part of 'unit_bloc.dart';

abstract class UnitEvent extends Equatable {
  const UnitEvent();

  @override
  List<Object> get props => [];
}

class UnitGet extends UnitEvent {
  final String guid;

  const UnitGet({required this.guid});

  @override
  List<Object> get props => [guid];
}

class UnitLoadList extends UnitEvent {
  final int limit;
  final int offset;
  final String search;

  const UnitLoadList(
      {required this.offset, required this.limit, required this.search});

  @override
  List<Object> get props => [];
}

class UnitDelete extends UnitEvent {
  final String guid;

  const UnitDelete({
    required this.guid,
  });

  @override
  List<Object> get props => [guid];
}

class UnitDeleteMany extends UnitEvent {
  final List<String> guid;

  const UnitDeleteMany({
    required this.guid,
  });

  @override
  List<Object> get props => [guid];
}

class UnitSave extends UnitEvent {
  final UnitModel unitModel;

  const UnitSave({
    required this.unitModel,
  });

  @override
  List<Object> get props => [unitModel];
}

class UnitUpdate extends UnitEvent {
  final String guid;
  final UnitModel unitModel;

  const UnitUpdate({
    required this.guid,
    required this.unitModel,
  });

  @override
  List<Object> get props => [unitModel];
}
