import 'package:flutter/material.dart';
import 'package:shop_app/modules/shop_layout.dart';
import 'package:shop_app/modules/shop_login_screen/shop_login_screen.dart';
import 'package:shop_app/shared/app_cubit/app_cubit.dart';
import 'package:shop_app/shared/app_cubit/app_states.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/themes/themes.dart';
import 'modules/boarding/boarding_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  Widget widget;

  bool? onBoarding = CacheHelper.getData(key: 'OnBoarding');
  String? token = CacheHelper.getData(key: 'token');
  print(token);

  if(onBoarding != null){
    if(token != null) widget = ShopLayout();
    else widget = ShopLoginScreen();
  }else widget = OnBoardingScreen();


  runApp(MyApp(startWidget: widget,));
}

class MyApp extends StatelessWidget {

  final Widget startWidget;
  MyApp({required this.startWidget});


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit()..getHomeData()..getCategoriesData(),
        ),
        BlocProvider(create: (BuildContext context) => AppCubit())
      ],
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state) {},
        builder: (context,state) {
            return  MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              home: startWidget,
            );
        },
      ),
    );
  }
}
