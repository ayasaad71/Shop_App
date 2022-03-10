import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {

  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);

}