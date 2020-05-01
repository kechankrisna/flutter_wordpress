class Tag {
  final int id;
  final int count;
  final String description;
  final String link;
  final String name;
  final String slug;
  final String taxonomy;
  final List meta;

  Tag({
    this.id,
    this.count,
    this.description,
    this.link,
    this.name,
    this.slug,
    this.taxonomy: "category",
    this.meta: const [],
  });

  factory Tag.fromJson(Map<String, dynamic> map) {
    return Tag(
      id: map['id'],
      count: map['count'],
      description: map['description'],
      link: map['link'],
      name: map['name'],
      slug: map['slug'],
      taxonomy: map['taxonomy'],
      meta: map['meta'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "count": this.count,
      "description": this.description,
      "link": this.link,
      "name": this.name,
      "slug": this.slug,
      "taxonomy": this.taxonomy,
      "meta": this.meta,
    };
  }
}
