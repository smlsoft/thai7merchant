part of 'shop_select_bloc.dart';

abstract class ShopSelectState extends Equatable {
  const ShopSelectState();

  @override
  List<Object> get props => [];
}

class ShopSelectInitial extends ShopSelectState {}

class ShopSelectInProgress extends ShopSelectState {}

class ShopSelectLoadSuccess extends ShopSelectState {
  Shop shop;

  ShopSelectLoadSuccess({
    required this.shop,
  });

  @override
  List<Object> get props => [shop];
}

class ShopSelectLoadFailed extends ShopSelectState {
  final String message;
  ShopSelectLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
