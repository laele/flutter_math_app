import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerFactory<GameCubit>(() => GameCubit());
}
