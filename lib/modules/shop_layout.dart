import 'package:flutter/material.dart';
import 'package:shop_app/modules/search/search_screen.dart';
import 'package:shop_app/modules/shop_login_screen/shop_login_screen.dart';
import 'package:shop_app/shared/Components/components.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var cubit = ShopCubit.get(context);

    return BlocConsumer<ShopCubit , ShopStates>(
      listener: (context , state) {},
      builder: (context , state) {
        return Scaffold(
          appBar: AppBar(
              title: Text('Salla'),
               actions: [
                 IconButton(
                   iconSize: 35,
                   onPressed: (){
                     navigateTo(context, SearchScreen());
                   },
                   icon: Icon(Icons.search),
                 ),
               ],
          ),
          body: cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index){
              cubit.changeCurrentIndex(index);
            },
            currentIndex: cubit.currentIndex,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.apps),label: 'Categories'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite),label: 'Favorites'),
              BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Settings'),
            ],
          ),
        );
      },
    );
  }
}
