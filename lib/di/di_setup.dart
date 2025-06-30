import 'package:get_it/get_it.dart';
import 'package:go_router_practice/di/di_setup.config.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();
