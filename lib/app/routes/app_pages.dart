import 'package:get/get.dart';

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
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/detail_kejadian/bindings/detail_kejadian_binding.dart';
import '../modules/detail_kejadian/views/detail_kejadian_view.dart';
import '../modules/edit_kejadian/bindings/edit_kejadian_binding.dart';
import '../modules/edit_kejadian/views/edit_kejadian_view.dart';
import '../modules/kejadian/bindings/kejadian_binding.dart';
import '../modules/kejadian/views/kejadian_view.dart';
import '../modules/tambah_kejadian/bindings/tambah_kejadian_binding.dart';
import '../modules/tambah_kejadian/views/tambah_kejadian_view.dart';

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
      name: _Paths.MAIN,
      page: () => const MainView(),
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
      name: _Paths.KEJADIAN,
      page: () => KejadianView(),
      binding: KejadianBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_KEJADIAN,
      page: () => const DetailKejadianView(),
      binding: DetailKejadianBinding(),
    ),
    GetPage(
      name: _Paths.TAMBAH_KEJADIAN,
      page: () => const TambahKejadianView(),
      binding: TambahKejadianBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_KEJADIAN,
      page: () => const EditKejadianView(),
      binding: EditKejadianBinding(),
    ),
  ];
}
