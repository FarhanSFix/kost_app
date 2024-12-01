import 'package:get/get.dart';

import '../modules/add_penghuni/bindings/add_penghuni_binding.dart';
import '../modules/add_penghuni/views/add_penghuni_view.dart';
import '../modules/detail_penghuni/bindings/detail_penghuni_binding.dart';
import '../modules/detail_penghuni/views/detail_penghuni_view.dart';
import '../modules/edit_penghuni/bindings/edit_penghuni_binding.dart';
import '../modules/edit_penghuni/views/edit_penghuni_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/penghuni/bindings/penghuni_binding.dart';
import '../modules/penghuni/views/penghuni_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
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
      name: _Paths.PENGHUNI,
      page: () => PenghuniView(),
      binding: PenghuniBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PENGHUNI,
      page: () => AddPenghuniView(),
      binding: AddPenghuniBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PENGHUNI,
      page: () => DetailPenghuniView(),
      binding: DetailPenghuniBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PENGHUNI,
      page: () => EditPenghuniView(),
      binding: EditPenghuniBinding(),
    ),
  ];
}
