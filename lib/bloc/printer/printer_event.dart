part of 'printer_bloc.dart';

abstract class PrinterEvent extends Equatable {
  const PrinterEvent();

  @override
  List<Object> get props => [];
}

class PrinterGet extends PrinterEvent {
  final String guid;

  const PrinterGet({required this.guid});

  @override
  List<Object> get props => [guid];
}

class PrinterLoadList extends PrinterEvent {
  final int limit;
  final int offset;
  final String search;

  const PrinterLoadList(
      {required this.offset, required this.limit, required this.search});

  @override
  List<Object> get props => [];
}

class PrinterDelete extends PrinterEvent {
  final String guid;

  const PrinterDelete({
    required this.guid,
  });

  @override
  List<Object> get props => [guid];
}

class PrinterDeleteMany extends PrinterEvent {
  final List<String> guid;

  const PrinterDeleteMany({
    required this.guid,
  });

  @override
  List<Object> get props => [guid];
}

class PrinterSave extends PrinterEvent {
  final PrinterModel printerModel;

  const PrinterSave({
    required this.printerModel,
  });

  @override
  List<Object> get props => [printerModel];
}

class PrinterUpdate extends PrinterEvent {
  final String guid;
  final PrinterModel printerModel;

  const PrinterUpdate({
    required this.guid,
    required this.printerModel,
  });

  @override
  List<Object> get props => [printerModel];
}
