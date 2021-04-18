// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shows_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ShowsStore on _ShowsStore, Store {
  Computed<List<TvShow>>? _$showsComputed;

  @override
  List<TvShow> get shows => (_$showsComputed ??=
          Computed<List<TvShow>>(() => super.shows, name: '_ShowsStore.shows'))
      .value;
  Computed<List<TvShow>>? _$animesComputed;

  @override
  List<TvShow> get animes =>
      (_$animesComputed ??= Computed<List<TvShow>>(() => super.animes,
              name: '_ShowsStore.animes'))
          .value;

  final _$searchQueryAtom = Atom(name: '_ShowsStore.searchQuery');

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  final _$viewAsListAtom = Atom(name: '_ShowsStore.viewAsList');

  @override
  bool get viewAsList {
    _$viewAsListAtom.reportRead();
    return super.viewAsList;
  }

  @override
  set viewAsList(bool value) {
    _$viewAsListAtom.reportWrite(value, super.viewAsList, () {
      super.viewAsList = value;
    });
  }

  final _$tvShowsAtom = Atom(name: '_ShowsStore.tvShows');

  @override
  ObservableFuture<ObservableList<TvShow>> get tvShows {
    _$tvShowsAtom.reportRead();
    return super.tvShows;
  }

  @override
  set tvShows(ObservableFuture<ObservableList<TvShow>> value) {
    _$tvShowsAtom.reportWrite(value, super.tvShows, () {
      super.tvShows = value;
    });
  }

  final _$loadTvShowsAsyncAction = AsyncAction('_ShowsStore.loadTvShows');

  @override
  Future<void> loadTvShows() {
    return _$loadTvShowsAsyncAction.run(() => super.loadTvShows());
  }

  final _$addShowAsyncAction = AsyncAction('_ShowsStore.addShow');

  @override
  Future<void> addShow(int indexerId,
      {bool isAnime = false,
      TvShowEpisodeStatus? status,
      TvShowEpisodeStatus? futureStatus,
      TvShowEpisodeQuality? quality,
      bool scene = false,
      bool subtitles = true,
      bool folderSeasons = true}) {
    return _$addShowAsyncAction.run(() => super.addShow(indexerId,
        isAnime: isAnime,
        status: status,
        futureStatus: futureStatus,
        quality: quality,
        scene: scene,
        subtitles: subtitles,
        folderSeasons: folderSeasons));
  }

  final _$_ShowsStoreActionController = ActionController(name: '_ShowsStore');

  @override
  void filter(String query) {
    final _$actionInfo =
        _$_ShowsStoreActionController.startAction(name: '_ShowsStore.filter');
    try {
      return super.filter(query);
    } finally {
      _$_ShowsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchQuery: ${searchQuery},
viewAsList: ${viewAsList},
tvShows: ${tvShows},
shows: ${shows},
animes: ${animes}
    ''';
  }
}
