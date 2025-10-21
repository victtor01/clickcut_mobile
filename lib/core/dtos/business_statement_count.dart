class Counts {
  final int finished;
  final int canceled;
  final int noShow;
  final int paids;

  Counts({
    required this.finished,
    required this.canceled,
    required this.noShow,
    required this.paids,
  });

  factory Counts.fromJson(Map<String, dynamic> json) {
    return Counts(
      finished: json['finished'] ?? 0,
      canceled: json['canceled'] ?? 0,
      noShow: json['noShow'] ?? 0,
      paids: json['paids'] ?? 0,
    );
  }
}