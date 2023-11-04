
enum Pages {
    notFound,
    home,
    bookmarks,
    search,
    results,
}

class NavIndex {
    final Pages pageIndex;

    const NavIndex(this.pageIndex);

    int get index => pageIndex.index;
    String get name => pageIndex.toString();

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
        other is NavIndex &&
            runtimeType == other.runtimeType &&
            pageIndex == other.pageIndex;

    @override
    int get hashCode => pageIndex.hashCode;
}
