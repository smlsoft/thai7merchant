part of 'option_bloc.dart';

abstract class OptionState extends Equatable {
  const OptionState();

  @override
  List<Object> get props => [];
}

class OptionInitial extends OptionState {}

//Load
class OptionInProgress extends OptionState {}

class OptionLoadSuccess extends OptionState {
  List<Option> option;
  final Page? page;

  OptionLoadSuccess({required this.option, required this.page});

  OptionLoadSuccess copyWith({
    List<Option>? option,
    final Page? page,
  }) =>
      OptionLoadSuccess(
        option: option ?? this.option,
        page: page ?? this.page,
      );

  @override
  List<Object> get props => [option];
}

class OptionLoadFailed extends OptionState {
  final String message;
  OptionLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

//loadby ID

class OptionLoadByIdInProgress extends OptionState {}

class OptionLoadByIdLoadSuccess extends OptionState {
  Option option;

  OptionLoadByIdLoadSuccess({
    required this.option,
  });

  @override
  List<Object> get props => [option];
}

class OptionLoadByIdLoadFailed extends OptionState {
  final String message;
  OptionLoadByIdLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

//Load Select

class OptionLoadSelectInProgress extends OptionState {}

class OptionLoadSelectSuccess extends OptionState {
  final List<Option> option;

  const OptionLoadSelectSuccess([this.option = const []]);

  @override
  List<Object> get props => [option];
}

class OptionLoadSelectFailure extends OptionState {
  final String message;
  const OptionLoadSelectFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
//save

class OptionSaveInProgress extends OptionState {}

class OptionSaveSuccess extends OptionState {}

class OptionSaveFailure extends OptionState {
  final String message;
  const OptionSaveFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

// update

class OptionUpdateInProgress extends OptionState {}

class OptionUpdateSuccess extends OptionState {}

class OptionUpdateFailure extends OptionState {
  final String message;
  const OptionUpdateFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

// Delete

class OptionDeleteInProgress extends OptionState {}

class OptionDeleteSuccess extends OptionState {}

class OptionDeleteFailure extends OptionState {
  final String message;
  const OptionDeleteFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
