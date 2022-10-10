part of 'member_bloc.dart';

abstract class MemberState extends Equatable {
  const MemberState();

  @override
  List<Object> get props => [];
}

//Load

class MemberInitial extends MemberState {}

class MemberInProgress extends MemberState {}

class MemberLoadSuccess extends MemberState {
  List<Member> member;
  final Page? page;

  MemberLoadSuccess({required this.member, required this.page});

  MemberLoadSuccess copyWith({
    List<Member>? member,
    final Page? page,
  }) =>
      MemberLoadSuccess(
        member: member ?? this.member,
        page: page ?? this.page,
      );

  @override
  List<Object> get props => [member];
}

class MemberLoadFailed extends MemberState {
  final String message;
  MemberLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

//loadby ID

class MemberLoadByIdInProgress extends MemberState {}

class MemberLoadByIdLoadSuccess extends MemberState {
  Member member;

  MemberLoadByIdLoadSuccess({
    required this.member,
  });

  @override
  List<Object> get props => [member];
}

class MemberLoadByIdLoadFailed extends MemberState {
  final String message;
  MemberLoadByIdLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

//save
class MemberFormInitial extends MemberState {}

class MemberFormSaveInProgress extends MemberState {}

class MemberFormSaveSuccess extends MemberState {}

class MemberFormSaveFailure extends MemberState {
  final String message;
  const MemberFormSaveFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

// update
class MemberUpdateInitial extends MemberState {}

class MemberUpdateInProgress extends MemberState {}

class MemberUpdateSuccess extends MemberState {}

class MemberUpdateFailure extends MemberState {
  final String message;
  const MemberUpdateFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

// Delete
class MemberDeleteInitial extends MemberState {}

class MemberDeleteInProgress extends MemberState {}

class MemberDeleteSuccess extends MemberState {}

class MemberDeleteFailure extends MemberState {
  final String message;
  const MemberDeleteFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
