import 'package:auto_route/auto_route_annotations.dart';
import 'package:basket_app/presentation/pages/basket_page.dart';
import 'package:basket_app/presentation/pages/store_page.dart';

@MaterialAutoRouter(routes: <AutoRoute>[
  MaterialRoute(page: StorePage, initial: true),
  MaterialRoute(page: BasketPage),
])
class $Router {}
