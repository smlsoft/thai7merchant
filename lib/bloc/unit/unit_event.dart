part of 'unit_bloc.dart';

abstract class UnitEvent extends Equatable {
  const UnitEvent();

  @override
  List<Object> get props => [];
}

class ListUnitLoad extends UnitEvent {
  int page;
  int perPage;
  String search;
  bool nextPage;

  ListUnitLoad(
      {required this.page,
      required this.perPage,
      required this.search,
      required this.nextPage});

  @override
  List<Object> get props => [];
}

class ListUnitDelete extends UnitEvent {
  final String id;

  const ListUnitDelete({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class ListUnitSave extends UnitEvent {
  final UnitModel unitModel;

  const ListUnitSave({
    required this.unitModel,
  });

  @override
  List<Object> get props => [unitModel];
}
// class ListUnitSave extends UnitEvent {
//   int page;
//   int perPage;
//   String search;
//   bool nextPage;

//   ListUnitSave(
//       {required this.page,
//       required this.perPage,
//       required this.search,
//       required this.nextPage});

//   @override
//   List<Object> get props => [];
// }
