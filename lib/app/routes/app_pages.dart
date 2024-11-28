import 'package:get/get.dart';

import '../modules/add_property/bindings/add_property_binding.dart';
import '../modules/add_property/views/add_property_view.dart';
import '../modules/add_room/bindings/add_room_binding.dart';
import '../modules/add_room/views/add_room_view.dart';
import '../modules/detail_property/bindings/detail_property_binding.dart';
import '../modules/detail_property/views/detail_property_view.dart';
import '../modules/detail_room/bindings/detail_room_binding.dart';
import '../modules/detail_room/views/detail_room_view.dart';
import '../modules/edit_property/bindings/edit_property_binding.dart';
import '../modules/edit_property/views/edit_property_view.dart';
import '../modules/edit_room/bindings/edit_room_binding.dart';
import '../modules/edit_room/views/edit_room_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/property/bindings/property_binding.dart';
import '../modules/property/views/property_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/room/bindings/room_binding.dart';
import '../modules/room/views/room_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PROPERTY,
      page: () => const PropertyView(),
      binding: PropertyBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PROPERTY,
      page: () => const AddPropertyView(),
      binding: AddPropertyBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PROPERTY,
      page: () => const DetailPropertyView(),
      binding: DetailPropertyBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ROOM,
      page: () => const AddRoomView(),
      binding: AddRoomBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_ROOM,
      page: () => const DetailRoomView(),
      binding: DetailRoomBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROPERTY,
      page: () => const EditPropertyView(),
      binding: EditPropertyBinding(),
    ),
    GetPage(
      name: _Paths.ROOM,
      page: () => const RoomView(),
      binding: RoomBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_ROOM,
      page: () => EditRoomView(),
      binding: EditRoomBinding(),
    ),
  ];
}
