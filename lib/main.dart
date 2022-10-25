import 'package:flutter/foundation.dart';
import 'package:thai7merchant/bloc/image/image_upload_bloc.dart';
import 'package:thai7merchant/bloc/option/option_bloc.dart';
import 'package:thai7merchant/bloc/unit/unit_bloc.dart';
import 'package:thai7merchant/menu_screen.dart';
import 'package:thai7merchant/repositories/client.dart';
import 'package:thai7merchant/repositories/unit_repository.dart';
import 'package:thai7merchant/screens/Product/product_list.dart';
import 'package:thai7merchant/usersystem/login_shop.dart';
import 'package:thai7merchant/usersystem/login_with.dart';
import 'package:thai7merchant/repositories/image_upload_repository.dart';
import 'package:thai7merchant/repositories/option_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:thai7merchant/app_observer.dart';
import 'package:thai7merchant/bloc/category/category_bloc.dart';
import 'package:thai7merchant/bloc/member/member_bloc.dart';
import 'package:thai7merchant/repositories/category_repository.dart';
import 'package:thai7merchant/bloc/inventory/inventory_bloc.dart';
import 'package:thai7merchant/bloc/list_shop/list_shop_bloc.dart';
import 'package:thai7merchant/bloc/login_bloc/login_bloc.dart';
import 'package:thai7merchant/bloc/shop_select/shop_select_bloc.dart';
import 'package:thai7merchant/repositories/inventory_repository.dart';
import 'package:thai7merchant/repositories/member_repository.dart';
import 'package:thai7merchant/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth.dart';
import 'profile.dart';
import 'package:flash/flash.dart';
import 'package:device_preview/device_preview.dart';
import 'global.dart' as global;

bool shouldUseFirebaseEmulator = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (global.apiConnected == false) {
    if (!global.isLoginProcess) {
      global.isLoginProcess = true;
      UserRepository _userRepository = UserRepository();
      await _userRepository
          .authenUser(global.apiUserName, global.apiUserPassword)
          .then((_result) async {
        if (_result.success) {
          global.apiConnected = true;
          global.apiToken = _result.data["token"];
          global.appConfig.write("token", _result.data["token"]);
          print("Login Succerss");
          ApiResponse _selectShop =
              await _userRepository.selectShop(global.apiShopCode);
          if (_selectShop.success) {
            print("Select Shop Sucess");
          }
        }
      }).catchError((e) {
        print(e);
      }).whenComplete(() async {
        global.isLoginProcess = false;
      });
    }
  }

  global.loadConfig();

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  // await SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  /*if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDo0RJaTxZqpSVsMhEhIJx8j3l_x5FJBV8',
        appId: '1:665016454480:ios:f10c2a16255b82c7333055',
        messagingSenderId: '665016454480',
        projectId: 'react-native-firebase-testing',
        authDomain: 'react-native-firebase-testing.firebaseapp.com',
        databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
        storageBucket: 'react-native-firebase-testing.appspot.com',
        measurementId: 'G-F79DJ0VFGS',
      ),
    );
  }

  if (shouldUseFirebaseEmulator) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }*/
  BlocOverrides.runZoned(
    () => runApp(
        DevicePreview(enabled: false, builder: (context) => const MyApp())),
    blocObserver: AppObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryBloc>(
          create: (_) => CategoryBloc(categoryRepository: CategoryRepository()),
        ),
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(userRepository: UserRepository()),
        ),
        BlocProvider<ListShopBloc>(
          create: (_) => ListShopBloc(userRepository: UserRepository()),
        ),
        BlocProvider<ShopSelectBloc>(
          create: (_) => ShopSelectBloc(userRepository: UserRepository()),
        ),
        BlocProvider<InventoryBloc>(
          create: (_) =>
              InventoryBloc(inventoryRepository: InventoryRepository()),
        ),
        BlocProvider<MemberBloc>(
          create: (_) => MemberBloc(memberRepository: MemberRepository()),
        ),
        BlocProvider<OptionBloc>(
          create: (_) => OptionBloc(optionRepository: OptionRepository()),
        ),
        BlocProvider<ImageUploadBloc>(
          create: (_) =>
              ImageUploadBloc(imageUploadRepository: ImageUploadRepository()),
        ),
        BlocProvider<UnitBloc>(
          create: (_) => UnitBloc(unitRepository: UnitRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Thai7 MERCHANT',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoaderOverlay(
          overlayColor: Colors.black,
          overlayOpacity: 0.8,
          child: MenuScreen(),
        ),
      ),
    );
  }
}
