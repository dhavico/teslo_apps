import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/domain/repositories/products_repository.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';

final productsRepositoryProvider = Provider<ProdutcsRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final produtcsRepository =
      ProductsRepositoryImpl(ProductsDatasourceImpl(accessToken: accessToken));

  return produtcsRepository;
});
