class BookingHistoryResponse {
  final List<BookingHistory> bookings;

  BookingHistoryResponse({required this.bookings});

  factory BookingHistoryResponse.fromJson(Map<String, dynamic> json) {
    return BookingHistoryResponse(
      bookings: (json['bookings'] as List)
							.map((item) => BookingHistory.fromJson(item))
							.toList(),
    );
  }
}

class BookingHistory {
  final String date;
  final int count;

  BookingHistory({required this.date, required this.count});

  factory BookingHistory.fromJson(Map<String, dynamic> json) {
    return BookingHistory(
      date: json['date'] as String,
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'count': count,
    };
  }
}
