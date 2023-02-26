enum TypeImage { local, remote }

class URLImage {
  String? url;
  TypeImage type;

  URLImage({
    this.url,
    this.type = TypeImage.remote,
  });
}
