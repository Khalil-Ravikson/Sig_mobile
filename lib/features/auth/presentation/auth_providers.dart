import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/storage/token_store.dart';
import '../data/auth_api.dart';
import '../data/auth_repository_impl.dart';
import '../data/biometria_local_auth.dart';
import '../data/perfil_local_store_seguro.dart';
import '../domain/auth_repository.dart';
import '../domain/biometria.dart';
import '../domain/perfil_local.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    AuthApi(ref.watch(dioProvider)),
    ref.watch(tokenStoreProvider),
  ),
);

final biometriaProvider = Provider<Biometria>((ref) => BiometriaLocalAuth());

final perfilLocalStoreProvider = Provider<PerfilLocalStore>(
  (ref) => PerfilLocalStoreSeguro(),
);
