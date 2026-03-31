import 'dart:ui';

enum OrderStatus {
  preview,
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  returned,
  canceled,
  expired;

  static String getTextForFilter(OrderStatus status) {
    switch (status) {
      case OrderStatus.preview:
        return 'Pregled';
      case OrderStatus.pending:
        return 'Čeka potvrdu';
      case OrderStatus.confirmed:
        return 'Potvrđena';
      case OrderStatus.processing:
        return 'U obradi';
      case OrderStatus.shipped:
        return 'Poslana';
      case OrderStatus.delivered:
        return 'Isporučena';
      case OrderStatus.returned:
        return 'Vraćena';
      case OrderStatus.canceled:
        return 'Otkazana';
      case OrderStatus.expired:
        return 'Istekla';
    }
  }

  static String getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.preview:
        return 'Narudžba je u pregledu';
      case OrderStatus.pending:
        return 'Narudžba čeka potvrdu';
      case OrderStatus.confirmed:
        return 'Narudžba je potvrđena';
      case OrderStatus.processing:
        return 'Narudžba je u obradi';
      case OrderStatus.shipped:
        return 'Narudžba je poslana';
      case OrderStatus.returned:
        return 'Narudžba je vraćena';
      case OrderStatus.canceled:
        return 'Narudžba je otkazana';
      case OrderStatus.delivered:
        return 'Narudžba je isporučena';
      case OrderStatus.expired:
        return 'Narudžba je istekla';
    }
  }

  static Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.preview:
        return Color(0xFFFF9800); // Žuta - za pregled/draft statusе
      case OrderStatus.pending:
        return Color(0xFFFFC107); // Žuta - za čekanje
      case OrderStatus.confirmed:
        return Color(0xFF2196F3); // Plava - potvrđeno
      case OrderStatus.processing:
        return Color(0xFF9C27B0); // Ljubičasta - u obradi
      case OrderStatus.shipped:
        return Color(0xFF1976D2); // Plava - poslano
      case OrderStatus.returned:
        return Color(0xFF9C27B0); // Ljubičasta - vraćeno
      case OrderStatus.canceled:
        return Color(0xFFF44336); // Crvena - otkazano
      case OrderStatus.delivered:
        return Color(0xFF4CAF50); // Zelena - isporučeno
      case OrderStatus.expired:
        return Color(0xFFF44336); // Crvena - isteklo
    }
  }

  static OrderStatus fromString(String status) {
    switch (status) {
      case 'PENDING':
        return OrderStatus.pending;
      case 'CONFIRMED':
        return OrderStatus.confirmed;
      case 'PROCESSING':
        return OrderStatus.processing;
      case 'SHIPPED':
        return OrderStatus.shipped;
      case 'RETURNED':
        return OrderStatus.returned;
      case 'CANCELLED':
        return OrderStatus.canceled;
      case 'DELIVERED':
        return OrderStatus.delivered;
      case 'EXPIRED':
        return OrderStatus.expired;
      case 'PREVIEW':
        return OrderStatus.preview;
      default:
        return OrderStatus.preview;
    }
  }

  static List<OrderStatus> getStatusesForOrderDetails() {
    return [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];
  }
}
