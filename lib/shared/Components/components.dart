import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/modules/shop_login_screen/shop_login_screen.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

void navigateAndFinish (context,widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
        (route) => false
);

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit(value)?,
  Function? onChange(value)?,
  Function? onTap,
  bool isPassword = false,
  required String validatedValue,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: (value) => onSubmit!(value),
      // onChanged: (value){
      //   onChange!(value);
      // },
      //onTap: () => onTap!(),

      validator: (value){
        //validate(value);
        if(value!.isEmpty){
          return validatedValue;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null ? IconButton(
          onPressed: (){
            suffixPressed!();
            },
          icon: Icon(
            suffix,
          ),
        ) : null,
        border: OutlineInputBorder(),
      ),
    );

Widget defaultTextButton({
  required Function onPressed,
  required Widget child
})
=> TextButton(
    onPressed: (){
      onPressed();
},
    child: child
);

Widget defaultButton({
  required Function onPressed,
  required String text,
  double radius = 5.0,
  bool isUpperCase = true,
  Color backGroundColor = Colors.purple,
  double width = double.infinity ,
})
=> Container(
  height: 50,
  width: width,
  child:   MaterialButton(
      onPressed: (){
        onPressed();
      },
      child: Text(isUpperCase? text.toUpperCase() : text,
        style: TextStyle(fontSize: 20),
      ),
      textColor: Colors.white,
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: backGroundColor,

  ),
);

void navigateTo(context,widget) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
);

void showToast({
  required String text,
  required ToastStates state,
}) => Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastStates {SUCCESS , ERROR , WARNING}

Color chooseToastColor (ToastStates state){

  Color color;
  switch(state)
  {
    case ToastStates.SUCCESS :
      color = Colors.green;
      break;
    case ToastStates.ERROR :
      color = Colors.red;
      break;
    case ToastStates.WARNING :
      color = Colors.amber;
      break;
  }
  return color;
}

void signOut (context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if(value){
      navigateAndFinish(context, ShopLoginScreen());
    }
  });
}