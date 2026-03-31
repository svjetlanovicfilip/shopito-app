class ProductException implements Exception {
  final String message;

  ProductException({required this.message});
}

class ProductNetworkException extends ProductException {
  ProductNetworkException({required super.message});
}

class ProductServerException extends ProductException {
  ProductServerException({required super.message});
}

class ProductClientException extends ProductException {
  ProductClientException({required super.message});
}
