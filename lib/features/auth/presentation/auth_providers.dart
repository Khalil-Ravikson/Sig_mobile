import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/storage/token_store.dart';
import '../data/auth_api.dart';
import '../data/auth_repository_impl.dart';
import '../domain/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    AuthApi(ref.watch(dioProvider)),
    ref.watch(tokenStoreProvider),
  ),
);
