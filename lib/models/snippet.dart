class Snippet {
  final int? id;
  final String title;
  final String content;
  final String? language;
  final String? category;

  Snippet({
    this.id,
    required this.title,
    required this.content,
    required this.language,
    required this.category,
  });

  factory Snippet.fromJson(Map<String, dynamic> json) => Snippet(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    language: json['language'],
    category: json['category'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'language': language,
    'category': category,
  };
}
