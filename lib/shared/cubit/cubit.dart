import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favirotes/favorites_screen.dart';
import 'package:shop_app/modules/products/produts_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/network/remote/end_point.dart';

import '../constants.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeCurrentIndex(int index) {
    currentIndex = index;

    emit(ShopChangeNavIndexState());
  }

  HomeModel? homeModel;

  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      print(homeModel!.data!.banners[0].image);
      print(homeModel!.status);

      homeModel!.data!.products.forEach((element) {
        favorites.addAll({element.id: element.inFavorites});
      });

      print(favorites.toString());

      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel ;

  void changeFavorites(int productId) {

    favorites[productId]  = !favorites[productId]!;
    emit(ShopSuccessChangeFavoritesState());

    DioHelper.postData(
        url: FAVORITES,
        data: {
          'product_id' : productId
        },
      token: token
    )
        .then((value) {
          emit(ShopSuccessChangeFavoritesState());
          changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);

          if(!changeFavoritesModel!.status){
            favorites[productId] = !favorites[productId] !;
          }

          print(value.data);
    })
        .catchError((error) {

      favorites[productId] = !favorites[productId] !;

      emit(ShopErrorChangeFavoritesState());
    });
  }
}
