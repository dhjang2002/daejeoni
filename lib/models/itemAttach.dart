class ItemAttach {
  final String tag;
  String url;
  String subTitle;
  String label;
  String type;
  bool bProgress;
  ItemAttach({
    required this.tag,
    this.subTitle = "",
    this.url   = "",
    this.label = "",
    this.type  = "",
    this.bProgress = false
  });

  @override
  String toString() {
    // TODO: implement toString
    return "url:$url";
  }
}