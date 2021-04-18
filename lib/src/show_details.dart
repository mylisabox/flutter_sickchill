part of 'flutter_sickchill.dart';

enum _ShowActions { update, rescan, delete }

class TvShowScreen extends HookWidget {
  final TvShow tvShow;
  final bool headless;

  const TvShowScreen({Key? key, required this.tvShow, this.headless = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useMemoized(() => ShowDetailsStore());

    useEffect(() {
      store.loadTvShow(tvShow);
      return null;
    }, const []);

    return Provider.value(
      value: store,
      child: Observer(
        builder: (context) {
          final details = store.tvShowDetails;
          final color = store.primaryColor ?? Theme.of(context).primaryColor;
          final brightness = ThemeData.estimateBrightnessForColor(color);

          return DefaultTabController(
            length: (details?.seasonList?.length ?? 0) + 1,
            child: Scaffold(
              body: Stack(
                fit: StackFit.expand,
                children: [
                  if (tvShow.hasFanart)
                    Image.network(
                      tvShow.fanart!,
                      fit: BoxFit.cover,
                    ),
                  if (tvShow.hasFanart)
                    ColoredBox(color: Colors.black.withOpacity(0.6)),
                  NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          automaticallyImplyLeading: !headless,
                          title: Text(
                            tvShow.name,
                            style: TextStyle(
                              color: brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          iconTheme: IconThemeData(
                            color: brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                          actions: [
                            if (!tvShow.isEnded && details != null)
                              IconButton(
                                icon: Icon(details.isPaused
                                    ? Icons.play_arrow
                                    : Icons.pause),
                                onPressed: () {
                                  store.pauseOrResumeShow();
                                },
                              ),
                            PopupMenuButton<_ShowActions>(
                              itemBuilder: (context) {
                                return const [
                                  PopupMenuItem<_ShowActions>(
                                    child: Text('Update'),
                                    value: _ShowActions.update,
                                  ),
                                  PopupMenuItem<_ShowActions>(
                                    child: Text('Rescan'),
                                    value: _ShowActions.rescan,
                                  ),
                                  PopupMenuItem<_ShowActions>(
                                    child: Text('Delete show'),
                                    value: _ShowActions.delete,
                                  ),
                                ];
                              },
                              onSelected: (selected) async {
                                switch (selected) {
                                  case _ShowActions.update:
                                    store.updateShow().catchError((err) {
                                      _showErrors(context,
                                          description:
                                              (err as SickChillException)
                                                  .message);
                                    },
                                        test: (err) => err
                                            is SickChillException).catchError(
                                        (err) {
                                      _showErrors(context);
                                    });
                                    break;
                                  case _ShowActions.rescan:
                                    store.rescanShow().catchError((err) {
                                      _showErrors(context,
                                          description:
                                              (err as SickChillException)
                                                  .message);
                                    },
                                        test: (err) => err
                                            is SickChillException).catchError(
                                        (err) {
                                      _showErrors(context);
                                    });
                                    break;
                                  case _ShowActions.delete:
                                    if (await _showConfirm(
                                        context,
                                        'Delete show?',
                                        'Are you sure you want to delete this show?')) {
                                      store
                                          .deleteShow(await _showConfirm(
                                              context,
                                              'Also delete show data?',
                                              'Are you sure you want to also delete files of this show?'))
                                          .then((_) =>
                                              Navigator.of(context).pop(true))
                                          .catchError((err) {
                                        _showErrors(context,
                                            description:
                                                (err as SickChillException)
                                                    .message);
                                      },
                                              test: (err) => err
                                                  is SickChillException).catchError(
                                              (err) {
                                        _showErrors(context);
                                      });
                                    }
                                    break;
                                }
                              },
                            ),
                          ],
                          brightness: brightness,
                          backgroundColor: color,
                          pinned: true,
                          floating: true,
                          forceElevated: innerBoxIsScrolled,
                          stretch: true,
                          bottom: _TvShowBanner(
                            banner: tvShow.banner,
                            bottom: details == null
                                ? null
                                : TabBar(
                                    isScrollable: true,
                                    indicatorColor: color,
                                    labelColor: brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    tabs: [
                                      Tab(
                                        text: 'Info',
                                      ),
                                      for (var i = 0;
                                          i < details.seasonList!.length;
                                          i++)
                                        Tab(
                                          text:
                                              'Season ${details.seasonList![i]}',
                                        ),
                                    ],
                                  ),
                          ),
                        ),
                      ];
                    },
                    body: details == null
                        ? Center(child: CircularProgressIndicator())
                        : TabBarView(
                            children: [
                              TvShowStats(
                                tvShowDetails: details,
                              ),
                              for (var i = 0;
                                  i < details.seasonList!.length;
                                  i++)
                                TvShowSeason(
                                  tvShowDetails: details,
                                  seasonNumber: details.seasonList![i],
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TvShowBanner extends StatelessWidget implements PreferredSizeWidget {
  final String? banner;
  final PreferredSizeWidget? bottom;

  const _TvShowBanner({Key? key, this.banner, this.bottom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (bottom != null) bottom!,
        if (banner != null)
          Image.network(
            banner!,
            fit: BoxFit.fitWidth,
            height: kToolbarHeight,
            width: double.infinity,
          ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight((bottom?.preferredSize.height ?? 0) + kToolbarHeight);
}

class TvShowStats extends StatelessWidget {
  final TvShowDetails tvShowDetails;

  const TvShowStats({Key? key, required this.tvShowDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        primary: false,
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey.withOpacity(0.7),
              ),
              clipBehavior: Clip.hardEdge,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Image.network(
                      tvShowDetails.poster,
                      fit: BoxFit.cover,
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tvShowDetails.name,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          _ShowStatLine(
                            name: 'Airs',
                            value: tvShowDetails.airs! +
                                ' on ' +
                                tvShowDetails.network!,
                          ),
                          _ShowStatLine(
                            name: 'Network',
                            value: tvShowDetails.network,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              tvShowDetails.status,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey.withOpacity(0.7),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('More information',
                        style: Theme.of(context).textTheme.headline6),
                    _ShowStatLine(
                      name: 'Language',
                      value: tvShowDetails.language!.toUpperCase(),
                    ),
                    _ShowStatLine(
                      name: 'Subtitles',
                      value: tvShowDetails.needSubtitles ? 'Yes' : 'No',
                    ),
                    _ShowStatLine(
                      name: 'Quality',
                      value: tvShowDetails.quality,
                    ),
                    _ShowStatLine(
                      name: 'Location',
                      value: tvShowDetails.location,
                    ),
                    Text('Genre:'),
                    Wrap(
                      spacing: 5,
                      children: tvShowDetails.genre!
                          .map((e) => Chip(label: Text(e)))
                          .toList(),
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

class _ShowStatLine extends StatelessWidget {
  final String? name;
  final String? value;

  const _ShowStatLine({Key? key, this.name, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        children: [
          Text('$name: '),
          Text(value!),
        ],
      ),
    );
  }
}

class TvShowSeason extends HookWidget {
  final TvShowDetails tvShowDetails;
  final int seasonNumber;

  const TvShowSeason(
      {Key? key, required this.tvShowDetails, required this.seasonNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ShowDetailsStore>(context);

    useEffect(() {
      store.loadSeason(seasonNumber);
      return null;
    }, const []);
    return Observer(builder: (context) {
      final season = store.currentSeasons[seasonNumber];

      if (season == null) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(store.primaryColor),
          ),
        );
      }

      return SingleChildScrollView(
        primary: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey.withOpacity(0.7),
            ),
            child: Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Icon(Icons.search)),
                    DataColumn(label: Icon(Icons.subtitles)),
                    DataColumn(label: Text('N°'), numeric: true),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Air date')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Subtitles')),
                  ],
                  rows: season.episodes.reversed
                      .map(
                        (e) => DataRow(
                          color: MaterialStateProperty.resolveWith((states) {
                            if (e.isDownloaded ||
                                e.status.toLowerCase() == 'archived') {
                              return Colors.green.withOpacity(0.4);
                            }
                            if (e.status.toLowerCase() == 'skipped') {
                              return Colors.blue.withOpacity(0.4);
                            }
                            if (e.status.toLowerCase() == 'snatched') {
                              return Colors.purpleAccent.withOpacity(0.4);
                            }
                            if (e.status.toLowerCase() == 'wanted') {
                              return Colors.red.withOpacity(0.4);
                            }
                            return null;
                          }),
                          cells: [
                            DataCell(Observer(builder: (context) {
                              if (store.episodeInSearch.contains(e.number)) {
                                return SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    valueColor: AlwaysStoppedAnimation(
                                        store.primaryColor),
                                  ),
                                );
                              }
                              return Icon(Icons.search);
                            }),
                                onTap: () => store.searchEpisode(
                                    seasonNumber, e.number)),
                            DataCell(
                                e.isDownloaded
                                    ? Observer(builder: (context) {
                                        if (store.episodeSubtitleInSearch
                                            .contains(e.number)) {
                                          return SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      store.primaryColor),
                                            ),
                                          );
                                        }
                                        return Icon(Icons.subtitles);
                                      })
                                    : Container(), onTap: () {
                              if (e.isDownloaded) {
                                store.searchEpisodeSubtitle(
                                    seasonNumber, e.number);
                              }
                            }),
                            DataCell(
                              Text(e.number),
                            ),
                            DataCell(
                              Text(e.name),
                            ),
                            DataCell(
                              Text(e.airdate == null
                                  ? '-'
                                  : _defaultDateFormat.format(e.airdate!)),
                            ),
                            DataCell(
                              Text(e.status +
                                  (e.quality!.toLowerCase() == 'n/a'
                                      ? ''
                                      : ' (${e.quality})')),
                            ),
                            DataCell(
                              Text(e.subtitles!),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
