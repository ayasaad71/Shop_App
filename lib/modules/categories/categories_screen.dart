import 'package:flutter/material.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit , ShopStates>(
      listener: (context , state) {},
      builder : (context , state) {

        return ListView.separated(
            itemBuilder: (context , index) => buildCatItem(ShopCubit.get(context).categoriesModel!.data.data[index]),
            separatorBuilder: (context , index) => Container(width:double.infinity,color:Colors.grey),
            itemCount:ShopCubit.get(context).categoriesModel!.data.data.length ,
        );
      }
    );
  }
}

Widget buildCatItem(DataModel model) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      Image(
        image: NetworkImage(model.image),
        height: 80.0,
        width: 80.0,
        fit: BoxFit.cover,
      ),
      SizedBox(
        width: 20,
      ),
      Text(
        model.name,
        style: TextStyle(
          fontSize : 20,
          fontWeight: FontWeight.bold
        ),
      ),
      Spacer(),
      IconButton(
        onPressed: (){},
        icon: Icon(Icons.arrow_forward_ios),
      ),
    ],
  ),
);
