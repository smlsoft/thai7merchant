part of 'member_bloc.dart';

abstract class MemberEvent extends Equatable {
  const MemberEvent();

  @override
  List<Object> get props => [];
}

class ListMemberLoad extends MemberEvent {
  int page;
  int perPage;
  String search;
  bool nextPage;

  ListMemberLoad(
      {required this.page,
      required this.perPage,
      required this.search,
      required this.nextPage});

  @override
  List<Object> get props => [];
}

class ListMemberLoadById extends MemberEvent {
  String id;
  ListMemberLoadById({required this.id});

  @override
  List<Object> get props => [];
}

class MemberSaved extends MemberEvent {
  final Member member;

  const MemberSaved({
    required this.member,
  });

  @override
  List<Object> get props => [member];
}

class MemberUpdate extends MemberEvent {
  final Member member;

  const MemberUpdate({
    required this.member,
  });

  @override
  List<Object> get props => [member];
}

class MemberDelete extends MemberEvent {
  final String id;

  const MemberDelete({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
