// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_details_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ShowDetailsStore on _ShowDetailsStore, Store {
  Computed<Color?>? _$primaryColorComputed;

  @override
  Color? get primaryColor =>
      (_$primaryColorComputed ??= Computed<Color?>(() => super.primaryColor,
              name: '_ShowDetailsStore.primaryColor'))
          .value;

  final _$episodeInSearchAtom = Atom(name: '_ShowDetailsStore.episodeInSearch');

  @override
  ObservableList<String> get episodeInSearch {
    _$episodeInSearchAtom.reportRead();
    return super.episodeInSearch;
  }

  @override
  set episodeInSearch(ObservableList<String> value) {
    _$episodeInSearchAtom.reportWrite(value, super.episodeInSearch, () {
      super.episodeInSearch = value;
    });
  }

  final _$episodeSubtitleInSearchAtom =
      Atom(name: '_ShowDetailsStore.episodeSubtitleInSearch');

  @override
  ObservableList<String> get episodeSubtitleInSearch {
    _$episodeSubtitleInSearchAtom.reportRead();
    return super.episodeSubtitleInSearch;
  }

  @override
  set episodeSubtitleInSearch(ObservableList<String> value) {
    _$episodeSubtitleInSearchAtom
        .reportWrite(value, super.episodeSubtitleInSearch, () {
      super.episodeSubtitleInSearch = value;
    });
  }

  final _$paletteAtom = Atom(name: '_ShowDetailsStore.palette');

  @override
  PaletteGenerator? get palette {
    _$paletteAtom.reportRead();
    return super.palette;
  }

  @override
  set palette(PaletteGenerator? value) {
    _$paletteAtom.reportWrite(value, super.palette, () {
      super.palette = value;
    });
  }

  final _$tvShowDetailsAtom = Atom(name: '_ShowDetailsStore.tvShowDetails');

  @override
  TvShowDetails? get tvShowDetails {
    _$tvShowDetailsAtom.reportRead();
    return super.tvShowDetails;
  }

  @override
  set tvShowDetails(TvShowDetails? value) {
    _$tvShowDetailsAtom.reportWrite(value, super.tvShowDetails, () {
      super.tvShowDetails = value;
    });
  }

  final _$currentSeasonsAtom = Atom(name: '_ShowDetailsStore.currentSeasons');

  @override
  ObservableMap<int, TvShowSeason> get currentSeasons {
    _$currentSeasonsAtom.reportRead();
    return super.currentSeasons;
  }

  @override
  set currentSeasons(ObservableMap<int, TvShowSeason> value) {
    _$currentSeasonsAtom.reportWrite(value, super.currentSeasons, () {
      super.currentSeasons = value;
    });
  }

  final _$loadTvShowAsyncAction = AsyncAction('_ShowDetailsStore.loadTvShow');

  @override
  Future<void> loadTvShow(TvShow tvShow) {
    return _$loadTvShowAsyncAction.run(() => super.loadTvShow(tvShow));
  }

  final _$loadSeasonAsyncAction = AsyncAction('_ShowDetailsStore.loadSeason');

  @override
  Future<void> loadSeason(int number, {bool force = false}) {
    return _$loadSeasonAsyncAction
        .run(() => super.loadSeason(number, force: force));
  }

  final _$searchEpisodeAsyncAction =
      AsyncAction('_ShowDetailsStore.searchEpisode');

  @override
  Future<void> searchEpisode(int seasonNumber, String number) {
    return _$searchEpisodeAsyncAction
        .run(() => super.searchEpisode(seasonNumber, number));
  }

  final _$searchEpisodeSubtitleAsyncAction =
      AsyncAction('_ShowDetailsStore.searchEpisodeSubtitle');

  @override
  Future<void> searchEpisodeSubtitle(int seasonNumber, String number) {
    return _$searchEpisodeSubtitleAsyncAction
        .run(() => super.searchEpisodeSubtitle(seasonNumber, number));
  }

  final _$pauseOrResumeShowAsyncAction =
      AsyncAction('_ShowDetailsStore.pauseOrResumeShow');

  @override
  Future<void> pauseOrResumeShow() {
    return _$pauseOrResumeShowAsyncAction.run(() => super.pauseOrResumeShow());
  }

  final _$updateShowAsyncAction = AsyncAction('_ShowDetailsStore.updateShow');

  @override
  Future<void> updateShow() {
    return _$updateShowAsyncAction.run(() => super.updateShow());
  }

  final _$rescanShowAsyncAction = AsyncAction('_ShowDetailsStore.rescanShow');

  @override
  Future<void> rescanShow() {
    return _$rescanShowAsyncAction.run(() => super.rescanShow());
  }

  final _$deleteShowAsyncAction = AsyncAction('_ShowDetailsStore.deleteShow');

  @override
  Future<void> deleteShow(bool withData) {
    return _$deleteShowAsyncAction.run(() => super.deleteShow(withData));
  }

  @override
  String toString() {
    return '''
episodeInSearch: ${episodeInSearch},
episodeSubtitleInSearch: ${episodeSubtitleInSearch},
palette: ${palette},
tvShowDetails: ${tvShowDetails},
currentSeasons: ${currentSeasons},
primaryColor: ${primaryColor}
    ''';
  }
}
