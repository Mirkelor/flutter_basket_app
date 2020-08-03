import 'package:auto_route/auto_route.dart';
import 'package:basket_app/presentation/bloc/listing_item_bloc.dart';
import 'package:basket_app/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();
  runApp(BasketApp());
}

class BasketApp extends StatelessWidget {
  final _exNavigatorKey = GlobalKey<ExtendedNavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListingItemBloc>(
      create: (context) => getIt<ListingItemBloc>(),
      child: MaterialApp(
        title: 'Basket App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.deepOrange,
          accentColor: Colors.deepOrangeAccent,
        ),
        builder: ExtendedNavigator(
          initialRoute: Routes.storePage,
          key: _exNavigatorKey,
          router: Router(),
        ),
      ),
    );
  }
}
