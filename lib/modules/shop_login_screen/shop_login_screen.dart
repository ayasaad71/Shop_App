import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/modules/shop_layout.dart';
import 'package:shop_app/modules/shop_login_screen/cubit/cubit.dart';
import 'package:shop_app/modules/shop_login_screen/cubit/states.dart';
import 'package:shop_app/modules/shop_register_screen/register_screen.dart';
import 'package:shop_app/shared/Components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class ShopLoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState> ();

    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit,ShopLoginStates>(
        listener: (context,state){
          if(state is ShopLoginSuccessState){
            if(state.shopLogin.status == true){
              print(state.shopLogin.message);
              print(state.shopLogin.data!.token);

              CacheHelper.saveData(key: 'token', value:state.shopLogin.data!.token ).then((value) {
                navigateAndFinish(context, ShopLayout());
              });
            }
            else{
              print(state.shopLogin.message);
              showToast(
                  text: state.shopLogin.message,
                  state: ToastStates.ERROR
              );

            }
          }
        },
        builder: (context,state){
          return Scaffold(

            appBar: AppBar(
              elevation: 0,
            ),

            body : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Login now to know the new offers',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey),
                        ),
                        SizedBox(height: 20,),

                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            label: 'Email Address',
                            prefix: Icons.email_outlined,
                            validatedValue: 'Email must not be empty'
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            label: 'Password',
                            isPassword: ShopLoginCubit.get(context).isPassword,
                            prefix: Icons.lock,
                            suffix: ShopLoginCubit.get(context).suffix,
                            suffixPressed: (){
                              ShopLoginCubit.get(context).changePasswordVisibility();
                            },
                            validatedValue: 'Password must not be empty',
                            onSubmit: (value){
                              if(formKey.currentState!.validate() == true){
                                ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text
                                );
                              }
                            },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        BuildCondition(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                              onPressed: (){
                                if(formKey.currentState!.validate()){
                                  ShopLoginCubit.get(context).userLogin(
                                      email: emailController.value.text,
                                      password: passwordController.value.text
                                  );
                                }
                              },
                              text: 'LOGIN'
                          ),
                          fallback: (context) => Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                'Have no account ?'
                            ),
                            defaultTextButton(
                              onPressed: (){
                                navigateTo(context, RegisterScreen());
                              },
                              child: Text('Register now'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
