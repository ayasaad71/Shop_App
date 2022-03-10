import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/constants.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder: (context,state){
        return BuildCondition(
          condition: ShopCubit.get(context).homeModel != null && ShopCubit.get(context).categoriesModel != null ,
          builder: (context) => productsBuilder(ShopCubit.get(context).homeModel, ShopCubit.get(context).categoriesModel , context),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

Widget productsBuilder(HomeModel? model , CategoriesModel? categoriesModel , context){
  return SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Column(
      children: [
        CarouselSlider(
          items: model!.data!.banners.map((e) => Image(
            image: NetworkImage('${e.image}'),
            width: double.infinity,
            fit: BoxFit.cover,
          ),).toList(),
          options: CarouselOptions(
            initialPage: 0,
            height: 250,
            autoPlay: true,
            viewportFraction: 1,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(seconds: 1),
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
        ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context , index) => buildCategoryItem(categoriesModel!.data.data[index]),
                    separatorBuilder: (context , index) => SizedBox(width: 10,),
                    itemCount: categoriesModel!.data.data.length,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'New Products',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          color: Colors.grey[300],
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            childAspectRatio: 1 / 1.58,
            children: List.generate(
                    model.data!.products.length,
                    (index) => buildGridProduct(model.data!.products[index],context)
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildGridProduct(ProductModel model , context) => Container(
  color: Colors.white,
  child: Column(

    children: [

      Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          Image(

            image: NetworkImage(model.image),

            height: 200,

            width: double.infinity,

            fit: BoxFit.cover,

          ),
          if(model.discount != 0)
            Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            color: Colors.red,
            child: Text(
              'DISCOUNT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),

      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.name ,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.3
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  "${model.price} EG",
                  style: TextStyle(
                    color: defaultColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Spacer(),

                if (model.discount != 0)
                  Text(
                  "${model.oldPrice } EG",
                  style: TextStyle(
                      color: Colors.red[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough
                  ),
                ),

                Spacer() ,

                IconButton(
                    onPressed: (){
                      ShopCubit.get(context).changeFavorites(model.id);
                      print(model.id);
                    },
                    icon: Icon(
                      ShopCubit.get(context).favorites[model.id] !
                          ? Icons.favorite : Icons.favorite_border_outlined,
                      color: Colors.red,
                    ),
                    padding: EdgeInsets.zero,

                )

              ],
            ),

          ],
        ),
      ),

    ],

  ),
);

Widget buildCategoryItem(DataModel model) => Stack(
  alignment: AlignmentDirectional.bottomCenter,
  children: [
    Image(
      image: NetworkImage(model.image),
      height: 100,
      width: 100,
      fit: BoxFit.cover,
    ),
    Container(
      height: 20,
      width: 100,
      color: Colors.black,
      alignment: AlignmentDirectional.center,
      child: Text(
        model.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  ],
);