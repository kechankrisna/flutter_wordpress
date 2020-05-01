class Author {
  final int id;
  final String name;
  final String url;
  final String description;
  final String link;
  final String slug;
  final Map<String, dynamic> avatar_urls;

  Author(
      {this.id,
      this.name,
      this.url,
      this.description,
      this.link,
      this.slug,
      this.avatar_urls});

  factory Author.fromJson(Map<String, dynamic> map) {
    return Author(
      id: map["id"],
      name: map["name"],
      url: map["url"],
      link: map["link"],
      slug: map["slug"],
      avatar_urls: Map.castFrom(map["avatar_urls"]),
    );
  }
}
