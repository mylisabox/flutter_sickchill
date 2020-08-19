part of 'flutter_sickchill.dart';

class AddShowFloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isTablet = DeviceProxy.isTablet(context);
    return FloatingActionButton(
      onPressed: () {
        if (isTablet) {
          showDialog(
            context: context,
            builder: (context) => AddShowDialog(),
          );
        } else {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
            return AddShowScreen();
          }));
        }
      },
      child: Icon(Icons.add),
    );
  }
}

class AddShowDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add new show'),
      content: AddShowContent(),
    );
  }
}

class AddShowScreen extends StatelessWidget {
  final String title;

  const AddShowScreen({Key key, this.title = 'Add new show'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: AddShowContent(),
    );
  }
}

class AddShowContent extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useMemoized(() => AddShowStore());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Observer(
            builder: (context) => AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              child: store.selectedShow == null
                  ? TextFormField(
                      initialValue: store.lastShowSearch,
                      decoration: InputDecoration(labelText: 'Name'),
                      onChanged: (value) {
                        store.searchForShow(value);
                      },
                      autofocus: true,
                    )
                  : ListTile(
                      title: Text(store.selectedShow.name),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        store.selectedShow = null;
                      },
                      trailing: Icon(Icons.edit),
                    ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    DropdownButtonFormField<TvShowEpisodeQuality>(
                      items: TvShowEpisodeQuality.values
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.toString().split('.').last),
                              ))
                          .cast<DropdownMenuItem<TvShowEpisodeQuality>>()
                          .toList(),
                      value: store.quality,
                      onChanged: (value) {
                        store.quality = value;
                      },
                      isExpanded: true,
                      decoration: InputDecoration(labelText: 'Preferred quality'),
                    ),
                    DropdownButtonFormField<TvShowEpisodeStatus>(
                      items: TvShowEpisodeStatus.values
                          .sublist(0, TvShowEpisodeStatus.values.length - 1)
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.toString().split('.').last),
                              ))
                          .cast<DropdownMenuItem<TvShowEpisodeStatus>>()
                          .toList(),
                      value: store.status,
                      onChanged: (value) {
                        store.status = value;
                      },
                      isExpanded: true,
                      decoration: InputDecoration(labelText: 'Status for previous aired episodes'),
                    ),
                    DropdownButtonFormField<TvShowEpisodeStatus>(
                      items: TvShowEpisodeStatus.values
                          .sublist(0, TvShowEpisodeStatus.values.length - 1)
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.toString().split('.').last),
                              ))
                          .cast<DropdownMenuItem<TvShowEpisodeStatus>>()
                          .toList(),
                      value: store.futureStatus,
                      onChanged: (value) {
                        store.futureStatus = value;
                      },
                      isExpanded: true,
                      decoration: InputDecoration(labelText: 'Status for all future episodes'),
                    ),
                    Observer(
                      builder: (context) => CheckboxListTile(
                        value: store.searchSubtitles,
                        onChanged: (bool value) {
                          store.searchSubtitles = value;
                        },
                        title: Text('Subtitles'),
                        subtitle: Text('Download subtitles for this show?'),
                      ),
                    ),
                    Observer(
                      builder: (context) => CheckboxListTile(
                        value: store.seasonFolders,
                        onChanged: (bool value) {
                          store.seasonFolders = value;
                        },
                        title: Text('Season folders'),
                        subtitle: Text('Group episodes by season folder?'),
                      ),
                    ),
                    Observer(
                      builder: (context) => CheckboxListTile(
                        value: store.sceneNumbering,
                        onChanged: (bool value) {
                          store.sceneNumbering = value;
                        },
                        title: Text('Scene Numbering'),
                        subtitle: Text('NumberingIs this show scene numbered?'),
                      ),
                    ),
                    Observer(
                      builder: (context) => CheckboxListTile(
                        value: store.isAnime,
                        onChanged: (bool value) {
                          store.isAnime = value;
                        },
                        title: Text('Is anime'),
                        subtitle: Text('Is this show an Anime?'),
                      ),
                    ),
                  ],
                ),
                Observer(builder: (context) {
                  if (store.currentSearchResult == null) {
                    return Material(elevation: 8, child: Center(child: CircularProgressIndicator()));
                  }

                  return Visibility(
                    visible: store.selectedShow == null,
                    child: Material(
                      elevation: 8,
                      child: Scrollbar(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Radio(
                                onChanged: (value) {
                                  store.selectedShow = store.currentSearchResult[index];
                                },
                                groupValue: store.selectedShow?.tvdbid,
                                value: store.currentSearchResult[index].tvdbid,
                              ),
                              onTap: () {
                                store.selectedShow = store.currentSearchResult[index];
                              },
                              title: Text(store.currentSearchResult[index].name),
                            );
                          },
                          itemCount: store.currentSearchResult.length,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          ButtonBar(
            children: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
              Observer(
                  builder: (context) => FlatButton(
                      onPressed: store.selectedShow == null
                          ? null
                          : () async {
                              if (await _showLoading(
                                    context,
                                    until: () => Provider.of<ShowsStore>(context, listen: false).addShow(
                                      store.selectedShow.tvdbid,
                                      isAnime: store.isAnime,
                                      scene: store.sceneNumbering,
                                      status: store.status,
                                      folderSeasons: store.seasonFolders,
                                      quality: store.quality,
                                      futureStatus: store.futureStatus,
                                      subtitles: store.searchSubtitles,
                                    ),
                                  ) ??
                                  false) {
                                Navigator.of(context).pop();
                              }
                            },
                      child: Text(MaterialLocalizations.of(context).okButtonLabel))),
            ],
          ),
        ],
      ),
    );
  }
}
