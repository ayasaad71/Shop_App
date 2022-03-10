import 'package:shop_app/models/shop_login_model.dart';

abstract class ShopLoginStates {}

class ShopLoginInitialState extends ShopLoginStates {}

class ShopLoginLoadingState extends ShopLoginStates {}

class ShopLoginSuccessState extends ShopLoginStates {
  final ShopLoginModel shopLogin;

  ShopLoginSuccessState(this.shopLogin);

}

class ShopLoginErrorState extends ShopLoginStates {
  final String error ;
  ShopLoginErrorState(this.error);
}

class ChangePasswordVisibilityState extends ShopLoginStates {}


