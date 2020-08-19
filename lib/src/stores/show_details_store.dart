import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sickchill/src/utils/sickchill_api_provider.dart';
import 'package:mobx/mobx.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:sickchill/sickchill.dart';

part 'show_details_store.g.dart';

class ShowDetailsStore = _ShowDetailsStore with _$ShowDetailsStore;

abstract class _ShowDetailsStore with Store {
  final SickChillApiProvider _sickchill;

  _ShowDetailsStore({SickChillApiProvider sickchill}) : _sickchill = SickChillApiProvider();

  @observable
  ObservableList<String> episodeInSearch = ObservableList.of([]);

  @observable
  ObservableList<String> episodeSubtitleInSearch = ObservableList.of([]);

  @observable
  PaletteGenerator palette;

  @computed
  Color get primaryColor {
    final candidate = [
      palette?.vibrantColor,
      palette?.lightVibrantColor,
      palette?.darkVibrantColor,
      palette?.lightMutedColor,
      palette?.mutedColor,
      palette?.darkMutedColor,
    ];
    return candidate.firstWhere((element) => element != null, orElse: () => null)?.color;
  }

  @observable
  TvShowDetails tvShowDetails;

  @observable
  ObservableMap<int, TvShowSeason> currentSeasons = ObservableMap.of({});

  @action
  Future<void> loadTvShow(TvShow tvShow) async {
    currentSeasons.clear();
    palette = null;
    episodeInSearch.clear();
    await _loadTvShow(tvShow.id);
    palette = await PaletteGenerator.fromImageProvider(
      NetworkImage(tvShow.poster),
      maximumColorCount: 5,
    );
  }

  Future<TvShowDetails> _loadTvShow(int id) async {
    return tvShowDetails = await _sickchill.api.getShowDetails(id);
  }

  @action
  Future<void> loadSeason(int number, {bool force = false}) async {
    if (currentSeasons[number] == null) {
      final results = await _sickchill.api.getSeasons(tvShowDetails.id, seasonNumber: number);
      currentSeasons[number] = results.first;
    }
  }

  @action
  Future<void> searchEpisode(int seasonNumber, String number) async {
    if (!episodeInSearch.contains(number)) {
      episodeInSearch.add(number);
      await _sickchill.api
          .searchEpisode(
            tvShowDetails.id,
            seasonNumber,
            number,
          )
          .catchError((_) {}, test: (e) => e is SickChillException);
      episodeInSearch.remove(number);
      await loadSeason(seasonNumber, force: true);
    }
  }

  @action
  Future<void> searchEpisodeSubtitle(int seasonNumber, String number) async {
    if (!episodeInSearch.contains(number)) {
      episodeSubtitleInSearch.add(number);
      await _sickchill.api
          .searchEpisodeSubtitle(
            tvShowDetails.id,
            seasonNumber,
            number,
          )
          .catchError((_) {}, test: (e) => e is SickChillException);
      episodeSubtitleInSearch.remove(number);
      await loadSeason(seasonNumber, force: true);
    }
  }

  @action
  Future<void> pauseOrResumeShow() async {
    await _sickchill.api.pauseShow(tvShowDetails.id, !tvShowDetails.isPaused);
    await _loadTvShow(tvShowDetails.id);
  }

  @action
  Future<void> updateShow() async {
    await _sickchill.api.forceFullUpdateShow(tvShowDetails.id);
    await _loadTvShow(tvShowDetails.id);
  }

  @action
  Future<void> rescanShow() async {
    await _sickchill.api.refreshShowFromDisk(tvShowDetails.id);
    await _loadTvShow(tvShowDetails.id);
  }

  @action
  Future<void> deleteShow(bool withData) async {
    await _sickchill.api.removeShow(tvShowDetails.id, removeFiles: withData ?? false);
  }
}
