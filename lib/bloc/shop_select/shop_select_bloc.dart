import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thai7merchant/repositories/user_repository.dart';
import 'package:thai7merchant/model/shop.dart';
import 'package:get_storage/get_storage.dart';

part 'shop_select_event.dart';
part 'shop_select_state.dart';

class ShopSelectBloc extends Bloc<ShopSelectEvent, ShopSelectState> {
  final UserRepository _userRepository;

  ShopSelectBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(ShopSelectInitial()) {
    on<OnShopSelect>(_onShopSelect);
  }
  void _onShopSelect(OnShopSelect event, Emitter<ShopSelectState> emit) async {
    emit(ShopSelectInProgress());
    try {
      final _result = await _userRepository.selectShop(event.shop.shopid);

      if (_result.success) {
        final appConfig = GetStorage("AppConfig");
        appConfig.write("name", event.shop.name);
        appConfig.write("shopid", event.shop.shopid);

        emit(ShopSelectLoadSuccess(shop: event.shop));
      } else {
        emit(ShopSelectLoadFailed(message: 'Shop Not Found'));
      }
    } catch (e) {
      emit(ShopSelectLoadFailed(message: e.toString()));
    }
  }
}
