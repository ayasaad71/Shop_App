import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/shop_login_model.dart';
import 'package:shop_app/modules/shop_login_screen/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/network/remote/end_point.dart';

class ShopLoginCubit extends Cubit <ShopLoginStates> {

  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  late ShopLoginModel shopLogin;

  void userLogin({
    required String email,
    required String password
})
  {
    emit(ShopLoginLoadingState());

    DioHelper.postData(
        url: LOGIN,
        data: {
          'email' : email,
          'password' : password,
        },
        headers: {
          'lang' : 'ar',
        }
    ).then((value) {

      shopLogin = ShopLoginModel.formJson(value.data);

      emit(ShopLoginSuccessState(shopLogin));

    }).catchError((error){
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility_off_outlined;

  void changePasswordVisibility(){
    isPassword =! isPassword ;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined ;

    emit(ChangePasswordVisibilityState());
  }
}