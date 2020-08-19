// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_show_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AddShowStore on _AddShowStore, Store {
  final _$currentSearchResultAtom = Atom(name: '_AddShowStore.currentSearchResult');

  @override
  List<TvShowResult> get currentSearchResult {
    _$currentSearchResultAtom.reportRead();
    return super.currentSearchResult;
  }

  @override
  set currentSearchResult(List<TvShowResult> value) {
    _$currentSearchResultAtom.reportWrite(value, super.currentSearchResult, () {
      super.currentSearchResult = value;
    });
  }

  final _$selectedShowAtom = Atom(name: '_AddShowStore.selectedShow');

  @override
  TvShowResult get selectedShow {
    _$selectedShowAtom.reportRead();
    return super.selectedShow;
  }

  @override
  set selectedShow(TvShowResult value) {
    _$selectedShowAtom.reportWrite(value, super.selectedShow, () {
      super.selectedShow = value;
    });
  }

  final _$isAnimeAtom = Atom(name: '_AddShowStore.isAnime');

  @override
  bool get isAnime {
    _$isAnimeAtom.reportRead();
    return super.isAnime;
  }

  @override
  set isAnime(bool value) {
    _$isAnimeAtom.reportWrite(value, super.isAnime, () {
      super.isAnime = value;
    });
  }

  final _$searchSubtitlesAtom = Atom(name: '_AddShowStore.searchSubtitles');

  @override
  bool get searchSubtitles {
    _$searchSubtitlesAtom.reportRead();
    return super.searchSubtitles;
  }

  @override
  set searchSubtitles(bool value) {
    _$searchSubtitlesAtom.reportWrite(value, super.searchSubtitles, () {
      super.searchSubtitles = value;
    });
  }

  final _$seasonFoldersAtom = Atom(name: '_AddShowStore.seasonFolders');

  @override
  bool get seasonFolders {
    _$seasonFoldersAtom.reportRead();
    return super.seasonFolders;
  }

  @override
  set seasonFolders(bool value) {
    _$seasonFoldersAtom.reportWrite(value, super.seasonFolders, () {
      super.seasonFolders = value;
    });
  }

  final _$sceneNumberingAtom = Atom(name: '_AddShowStore.sceneNumbering');

  @override
  bool get sceneNumbering {
    _$sceneNumberingAtom.reportRead();
    return super.sceneNumbering;
  }

  @override
  set sceneNumbering(bool value) {
    _$sceneNumberingAtom.reportWrite(value, super.sceneNumbering, () {
      super.sceneNumbering = value;
    });
  }

  final _$qualityAtom = Atom(name: '_AddShowStore.quality');

  @override
  TvShowEpisodeQuality get quality {
    _$qualityAtom.reportRead();
    return super.quality;
  }

  @override
  set quality(TvShowEpisodeQuality value) {
    _$qualityAtom.reportWrite(value, super.quality, () {
      super.quality = value;
    });
  }

  final _$statusAtom = Atom(name: '_AddShowStore.status');

  @override
  TvShowEpisodeStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(TvShowEpisodeStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$futureStatusAtom = Atom(name: '_AddShowStore.futureStatus');

  @override
  TvShowEpisodeStatus get futureStatus {
    _$futureStatusAtom.reportRead();
    return super.futureStatus;
  }

  @override
  set futureStatus(TvShowEpisodeStatus value) {
    _$futureStatusAtom.reportWrite(value, super.futureStatus, () {
      super.futureStatus = value;
    });
  }

  final _$searchForShowAsyncAction = AsyncAction('_AddShowStore.searchForShow');

  @override
  Future<void> searchForShow(String name) {
    return _$searchForShowAsyncAction.run(() => super.searchForShow(name));
  }

  @override
  String toString() {
    return '''
currentSearchResult: ${currentSearchResult},
selectedShow: ${selectedShow},
isAnime: ${isAnime},
searchSubtitles: ${searchSubtitles},
seasonFolders: ${seasonFolders},
sceneNumbering: ${sceneNumbering},
quality: ${quality},
status: ${status},
futureStatus: ${futureStatus}
    ''';
  }
}
