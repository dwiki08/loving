class Aura {
  final String name;
  final int count;
  final int duration;
  final DateTime? startTime;

  Aura({
    required this.name,
    required this.count,
    required this.duration,
    this.startTime,
  });

  // in milliseconds
  int get remainingTimeMs {
    if (startTime == null) return duration * 1000;
    final currentTime = DateTime.now();
    final elapsedTime = currentTime.difference(startTime!).inMilliseconds;
    return duration * 1000 - elapsedTime;
  }

  Aura copyWith({
    String? name,
    int? count,
    int? duration,
    DateTime? startTime,
  }) {
    return Aura(
      name: name ?? this.name,
      count: count ?? this.count,
      duration: duration ?? this.duration,
      startTime: startTime ?? this.startTime,
    );
  }

  factory Aura.fromJson(Map<String, dynamic> json) {
    return Aura(
      name: json['nam'] as String,
      count: (json['val'] as int?) ?? 1,
      duration: json['dur'] as int,
      startTime: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'count': count, 'duration': duration};
  }
}
