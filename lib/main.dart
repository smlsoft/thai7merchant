import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thai7merchant/Screens/authen/login.dart';
import 'package:thai7merchant/bloc/color/color_bloc.dart';
import 'package:thai7merchant/bloc/image/image_upload_bloc.dart';
import 'package:thai7merchant/bloc/option/option_bloc.dart';
import 'package:thai7merchant/bloc/product_barcode/product_barcode_bloc.dart';
import 'package:thai7merchant/bloc/unit/unit_bloc.dart';
import 'package:thai7merchant/menu_screen.dart';
import 'package:thai7merchant/model/global_struct.dart';
import 'package:thai7merchant/repositories/client.dart';
import 'package:thai7merchant/repositories/color_repository.dart';
import 'package:thai7merchant/repositories/unit_repository.dart';
import 'package:thai7merchant/select_language_screen.dart';
import 'package:thai7merchant/repositories/image_upload_repository.dart';
import 'package:thai7merchant/repositories/option_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:thai7merchant/repositories/product_barcode_repository.dart';
import 'package:thai7merchant/usersystem/login_shop.dart';
import 'firebase_options.dart';
import 'global.dart' as global;
import 'package:flutter_line_liff/flutter_line_liff.dart';

bool shouldUseFirebaseEmulator = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init("thai7merchant");

  if (global.apiConnected == false) {
    if (!global.isLoginProcess) {
      global.isLoginProcess = true;
      UserRepository userRepository = UserRepository();
      await userRepository
          .authenUser(global.apiUserName, global.apiUserPassword)
          .then((_result) async {
        if (_result.success) {
          global.apiConnected = true;
          global.apiToken = _result.data["token"];
          global.appConfig.write("token", _result.data["token"]);
          print("Login Succerss");
          ApiResponse selectShop =
              await userRepository.selectShop(global.apiShopCode);
          if (selectShop.success) {
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
  if (kIsWeb) {
    // FlutterLineLiff().init(
    //   config: Config(liffId: '1657550806-b54G4eR4'),
    //   successCallback: () {
    //     print('LIFF init success.');
    //   },
    //   errorCallback: (error) {
    //     print(
    //         'LIFF init error: ${error.name}, ${error.message}, ${error.stack}');
    //   },
    // );
  } else {
    LineSDK.instance.setup("1657550806").then((_) {
      print("LineSDK Prepared");
    });
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    global.languageSystemCode =
        (json.decode(await rootBundle.loadString('assets/language.json'))
                as List)
            .map((i) => LanguageSystemCodeModel.fromJson(i))
            .toList();
    global.languageSystemCode.sort((a, b) {
      return a.code.compareTo(b.code);
    });
  } catch (_) {}

  global.userLanguage = "th";
  /*try {
    global.userLanguage = GetStorage().read("language");
  } catch (_) {}*/

  /*BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: AppObserver(),
  );*/
  runApp(const MyApp());
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
        BlocProvider<ColorBloc>(
          create: (_) => ColorBloc(colorRepository: ColorRepository()),
        ),
        BlocProvider<ProductBarcodeBloc>(
          create: (_) => ProductBarcodeBloc(
              productBarcodeRepository: ProductBarcodeRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Thai7 MERCHANT',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Login(),
        routes: <String, WidgetBuilder>{
          '/menu': (BuildContext context) => const MenuScreen(),
          '/selectlanguage': (BuildContext context) =>
              const SelectLanguageScreen(),
        },
      ),
    );
  }
}
