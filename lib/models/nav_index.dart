
enum Pages {
    home,
    home2,
    home3,
    search,
}

class NavIndex {
    final Pages pageIndex;

    NavIndex(this.pageIndex);

    int get index => pageIndex.index;
    String get name => pageIndex.toString();
}
