part of 'shop_select_bloc.dart';

abstract class ShopSelectEvent extends Equatable {
  const ShopSelectEvent();

  @override
  List<Object> get props => [];
}

class OnShopSelect extends ShopSelectEvent {
  Shop shop;
  OnShopSelect({required this.shop});

  @override
  List<Object> get props => [];
}
