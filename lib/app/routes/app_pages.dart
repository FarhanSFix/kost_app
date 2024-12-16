import 'package:get/get.dart';

import '../modules/add_finance/bindings/add_finance_binding.dart';
import '../modules/add_finance/views/add_finance_view.dart';
import '../modules/add_kejadian/bindings/add_kejadian_binding.dart';
import '../modules/add_kejadian/views/add_kejadian_view.dart';
import '../modules/add_penghuni/bindings/add_penghuni_binding.dart';
import '../modules/add_penghuni/views/add_penghuni_view.dart';
import '../modules/add_property/bindings/add_property_binding.dart';
import '../modules/add_property/views/add_property_view.dart';
import '../modules/add_room/bindings/add_room_binding.dart';
import '../modules/add_room/views/add_room_view.dart';
import '../modules/detail_kejadian/bindings/detail_kejadian_binding.dart';
import '../modules/detail_kejadian/views/detail_kejadian_view.dart';
import '../modules/detail_pemasukan/bindings/detail_pemasukan_binding.dart';
import '../modules/detail_pemasukan/views/detail_pemasukan_view.dart';
import '../modules/detail_pengeluaran/bindings/detail_pengeluaran_binding.dart';
import '../modules/detail_pengeluaran/views/detail_pengeluaran_view.dart';
import '../modules/detail_penghuni/bindings/detail_penghuni_binding.dart';
import '../modules/detail_penghuni/views/detail_penghuni_view.dart';
import '../modules/detail_property/bindings/detail_property_binding.dart';
import '../modules/detail_property/views/detail_property_view.dart';
import '../modules/detail_room/bindings/detail_room_binding.dart';
import '../modules/detail_room/views/detail_room_view.dart';
import '../modules/edit_kejadian/bindings/edit_kejadian_binding.dart';
import '../modules/edit_kejadian/views/edit_kejadian_view.dart';
import '../modules/edit_pemasukan/bindings/edit_pemasukan_binding.dart';
import '../modules/edit_pemasukan/views/edit_pemasukan_view.dart';
import '../modules/edit_pengeluaran/bindings/edit_pengeluaran_binding.dart';
import '../modules/edit_pengeluaran/views/edit_pengeluaran_view.dart';
import '../modules/edit_penghuni/bindings/edit_penghuni_binding.dart';
import '../modules/edit_penghuni/views/edit_penghuni_view.dart';
import '../modules/edit_property/bindings/edit_property_binding.dart';
import '../modules/edit_property/views/edit_property_view.dart';
import '../modules/edit_room/bindings/edit_room_binding.dart';
import '../modules/edit_room/views/edit_room_view.dart';
import '../modules/finance/bindings/finance_binding.dart';
import '../modules/finance/views/finance_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/kejadian/bindings/kejadian_binding.dart';
import '../modules/kejadian/views/kejadian_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/penghuni/bindings/penghuni_binding.dart';
import '../modules/penghuni/views/penghuni_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/property/bindings/property_binding.dart';
import '../modules/property/views/property_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/resident_history/bindings/resident_history_binding.dart';
import '../modules/resident_history/views/resident_history_view.dart';
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
      name: _Paths.RESIDENT_HISTORY,
      page: () => const ResidentHistoryView(),
      binding: ResidentHistoryBinding(),
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
      page: () => const EditRoomView(),
      binding: EditRoomBinding(),
    ),
    GetPage(
      name: _Paths.PENGHUNI,
      page: () => const PenghuniView(),
      binding: PenghuniBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PENGHUNI,
      page: () => const AddPenghuniView(),
      binding: AddPenghuniBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PENGHUNI,
      page: () => const DetailPenghuniView(),
      binding: DetailPenghuniBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PENGHUNI,
      page: () => const EditPenghuniView(),
      binding: EditPenghuniBinding(),
    ),
    GetPage(
      name: _Paths.KEJADIAN,
      page: () => const KejadianView(),
      binding: KejadianBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_KEJADIAN,
      page: () => const DetailKejadianView(),
      binding: DetailKejadianBinding(),
    ),
    GetPage(
      name: _Paths.ADD_KEJADIAN,
      page: () => const AddKejadianView(),
      binding: AddKejadianBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_KEJADIAN,
      page: () => const EditKejadianView(),
      binding: EditKejadianBinding(),
    ),
    GetPage(
      name: _Paths.FINANCE,
      page: () => FinanceView(),
      binding: FinanceBinding(),
    ),
    GetPage(
      name: _Paths.ADD_FINANCE,
      page: () => AddFinanceView(),
      binding: AddFinanceBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PENGELUARAN,
      page: () => const DetailPengeluaranView(),
      binding: DetailPengeluaranBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PENGELUARAN,
      page: () => const EditPengeluaranView(),
      binding: EditPengeluaranBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PEMASUKAN,
      page: () => const DetailPemasukanView(),
      binding: DetailPemasukanBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PEMASUKAN,
      page: () => const EditPemasukanView(),
      binding: EditPemasukanBinding(),
    ),
    GetPage(
      name: _Paths.PROPERTY,
      page: () => const PropertyView(),
      binding: PropertyBinding(),
    ),
  ];
}
