class SpiderScanner {
  final String id;
  final String name;

  SpiderScanner({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory SpiderScanner.fromJson(Map<String, dynamic> json) =>
      SpiderScanner(id: json['id'], name: json['name']);
}
