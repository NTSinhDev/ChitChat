enum TypeImage { local, remote }

class URLImage {
  String? url;
  TypeImage type;

  URLImage({
    this.url,
    this.type = TypeImage.remote,
  });

  @override
  String toString() => 'URLImage(url: $url, type: $type)';

  @override
  bool operator ==(covariant URLImage other) {
    if (identical(this, other)) return true;

    return other.url == url && other.type == type;
  }

  @override
  int get hashCode => url.hashCode ^ type.hashCode;
}
