import 'dart:async';

import 'package:flutter_sickchill/src/utils/sickchill_api_provider.dart';
import 'package:mobx/mobx.dart';
import 'package:sickchill/sickchill.dart';

part 'shows_store.g.dart';

class ShowsStore = _ShowsStore with _$ShowsStore;

abstract class _ShowsStore with Store {
  final SickChillApiProvider _sickchill;

  static ObservableFuture<ObservableList<TvShow>> emptyResponse = ObservableFuture.value(ObservableList.of([]));

  _ShowsStore(this._sickchill);

  @observable
  String searchQuery = '';

  @observable
  bool viewAsList = false;

  @observable
  ObservableFuture<ObservableList<TvShow>> tvShows = emptyResponse;

  @computed
  List<TvShow> get shows =>
      tvShows.value?.where((element) {
        if (searchQuery.isEmpty) {
          return !element.isAnime;
        }
        return !element.isAnime && element.name.toLowerCase().contains(searchQuery.toLowerCase());
      })?.toList() ??
      [];

  @computed
  List<TvShow> get animes =>
      tvShows.value?.where((element) {
        if (searchQuery.isEmpty) {
          return element.isAnime;
        }
        return element.isAnime && element.name.toLowerCase().contains(searchQuery.toLowerCase());
      })?.toList() ??
      [];

  @action
  Future<void> loadTvShows() async {
    final future = _loadTvShows();
    tvShows = ObservableFuture(future);
    return future;
  }

  @action
  void filter(String query) {
    if (searchQuery?.trim() == query.trim()) {
      return;
    }
    searchQuery = query;
  }

  @action
  Future<void> addShow(
    int indexerId, {
    bool isAnime = false,
    TvShowEpisodeStatus status,
    TvShowEpisodeStatus futureStatus,
    TvShowEpisodeQuality quality,
    bool scene = false,
    bool subtitles = true,
    bool folderSeasons = true,
  }) async {
    await _sickchill.api.addShow(
      indexerId: indexerId,
      isAnime: isAnime,
      seasonFolders: folderSeasons,
      searchSubtitles: subtitles,
      futureStatus: futureStatus,
      status: status,
      scene: scene,
      quality: quality,
    );

    loadTvShows();
  }

  Future<ObservableList<TvShow>> _loadTvShows() async {
    return ObservableList.of(await _sickchill.api.getShows());
  }

  void dispose() {
    _sickchill.dispose();
  }
}
