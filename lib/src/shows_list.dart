part of 'flutter_sickchill.dart';

class TvShowList extends HookWidget {
  final bool splitAnimes;
  final bool headless;

  TvShowList({Key key, this.splitAnimes = true, this.headless = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ShowsStore>(context);
    final refreshKey = useMemoized(() => GlobalKey<RefreshIndicatorState>());
    final showAnime = useState(false);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        refreshKey.currentState.show();
      });
      return null;
    }, const []);

    return RefreshIndicator(
      key: refreshKey,
      onRefresh: () {
        return store.loadTvShows();
      },
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            if (splitAnimes)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Search by name'),
                          onChanged: (value) {
                            store.filter(value);
                          },
                        ),
                      ),
                    ),
                    TabBar(
                      isScrollable: true,
                      tabs: [
                        Tab(
                          text: 'Shows',
                        ),
                        Tab(
                          text: 'Animes',
                        ),
                      ],
                      onTap: (index) {
                        if (index == 0 && showAnime.value) {
                          showAnime.value = false;
                        } else if (index == 1 && !showAnime.value) {
                          showAnime.value = true;
                        }
                      },
                      labelColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Scrollbar(
                child: Observer(
                  builder: (context) {
                    var shows = store.tvShows.value ?? [];
                    if (splitAnimes) {
                      shows = showAnime.value ? store.animes : store.shows;
                    }

                    if (store.viewAsList) {
                      return ListView.separated(
                        separatorBuilder: (context, index) => Divider(height: 1),
                        itemBuilder: (context, index) {
                          final tvShow = shows[index];
                          return TvShowListItem(
                            tvShow: tvShow,
                            headless: headless,
                            onRefresh: () {
                              refreshKey.currentState.show();
                            },
                            key: ValueKey(tvShow.id),
                          );
                        },
                        padding: EdgeInsets.all(4),
                        itemCount: shows.length,
                      );
                    }

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 350, childAspectRatio: .5),
                      itemBuilder: (context, index) {
                        final tvShow = shows[index];
                        return TvShowGridItem(
                          tvShow: tvShow,
                          headless: headless,
                          onRefresh: () {
                            refreshKey.currentState.show();
                          },
                          key: ValueKey(tvShow.id),
                        );
                      },
                      padding: EdgeInsets.all(4),
                      itemCount: shows.length,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TvShowListItem extends StatelessWidget {
  final TvShow tvShow;
  final DateFormat dateFormat;
  final VoidCallback onTap;
  final VoidCallback onRefresh;
  final bool headless;

  const TvShowListItem({Key key, this.headless = false, this.tvShow, this.dateFormat, this.onTap, this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final format = dateFormat ?? _defaultDateFormat;
    return InkWell(
      onTap: onTap ??
          () async {
            final needRefresh = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return TvShowScreen(tvShow: tvShow, headless: headless);
                    },
                    settings: RouteSettings(name: '/sickchill/${tvShow.id}'))) ??
                false;
            if (needRefresh) {
              onRefresh();
            }
          },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                tvShow.posterThumbnail,
              ),
              radius: 40,
              child: SizedBox(
                width: 200,
                height: 100,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tvShow.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(tvShow.nextEpisode == null ? tvShow.status : format.format(tvShow.nextEpisode)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          tvShow.quality,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        if (tvShow.network != null && tvShow.network.isNotEmpty) Image.network(tvShow.networkImage),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TvShowGridItem extends StatelessWidget {
  final TvShow tvShow;
  final DateFormat dateFormat;
  final Color backgroundColor;
  final VoidCallback onTap;
  final VoidCallback onRefresh;
  final bool headless;

  const TvShowGridItem({Key key, this.headless = false, this.tvShow, this.dateFormat, this.backgroundColor, this.onTap, this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final format = dateFormat ?? _defaultDateFormat;
    final brightness = Theme
        .of(context)
        .brightness;
    final color = backgroundColor ?? brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[300];
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.all(
          const Radius.circular(10.0),
        ),
        clipBehavior: Clip.hardEdge,
        color: color,
        child: InkWell(
          onTap: onTap ??
              () async {
                final needRefresh = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return TvShowScreen(tvShow: tvShow, headless: headless);
                }, settings: RouteSettings(name: '/sickchill/${tvShow.id}'))) ??
                    false;
                if (needRefresh) {
                  onRefresh();
                }
              },
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  tvShow.posterThumbnail,
                  fit: BoxFit.fitWidth,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes : null,
                      ),
                    );
                  },
                ),
                Center(
                  child: Text(
                    tvShow.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Center(child: Text(tvShow.nextEpisode == null ? tvShow.status : format.format(tvShow.nextEpisode))),
                Spacer(),
                if (tvShow.network != null && tvShow.network.isNotEmpty) Center(child: Image.network(tvShow.networkImage)),
                Center(
                    child: Text(
                  tvShow.quality,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
