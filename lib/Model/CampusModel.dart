class Campus {
  final String? id;
  final String? state;
  final String? campus;

  Campus({
    this.id,
    this.state,
    this.campus,
  });

  factory Campus.fromJson(Map<String, dynamic> json) {
    return Campus(
      id: json['id'] as String,
      state: json['state'] as String,
      campus: json['campus'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state': state,
      'campus': campus,
    };
  }
}
