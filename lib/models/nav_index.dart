
enum Pages {
    home,
    home2,
    search,
    results,
}

class NavIndex {
    final Pages pageIndex;

    NavIndex(this.pageIndex);

    int get index => pageIndex.index;
    String get name => pageIndex.toString();
}
