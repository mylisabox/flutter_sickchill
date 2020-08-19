import 'dart:async';

import 'package:flutter_sickchill/src/utils/sickchill_api_provider.dart';
import 'package:mobx/mobx.dart';
import 'package:sickchill/sickchill.dart';

part 'add_show_store.g.dart';

class AddShowStore = _AddShowStore with _$AddShowStore;

abstract class _AddShowStore with Store {
  final SickChillApiProvider _sickchill;

  _AddShowStore({SickChillApiProvider sickchill}) : _sickchill = sickchill ?? SickChillApiProvider();

  String lastShowSearch;

  @observable
  List<TvShowResult> currentSearchResult = [];

  @observable
  TvShowResult selectedShow;
  @observable
  bool isAnime = false;
  @observable
  bool searchSubtitles = true;
  @observable
  bool seasonFolders = true;
  @observable
  bool sceneNumbering = false;
  @observable
  TvShowEpisodeQuality quality = TvShowEpisodeQuality.hd720;
  @observable
  TvShowEpisodeStatus status = TvShowEpisodeStatus.skipped;
  @observable
  TvShowEpisodeStatus futureStatus = TvShowEpisodeStatus.wanted;

  @action
  Future<void> searchForShow(String name) async {
    if (name.trim().length <= 3 || name.trim() == lastShowSearch?.trim()) {
      return;
    }
    lastShowSearch = name;
    selectedShow = null;
    currentSearchResult = null;
    currentSearchResult = await _sickchill.api.searchShow(name);
  }
}
