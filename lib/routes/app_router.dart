import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/', page: MainRoute.page, initial: true),
    AutoRoute(path: '/sign-in', page: SignInRoute.page),
  ];
}
