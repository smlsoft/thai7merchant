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
