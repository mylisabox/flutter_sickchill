# flutter_sickchill

Flutter package to talk to a SickChill remote instance, for a pure dart package please check [sickchill](https://github.com/mylisabox/sickchill)

## Setup

To have this package working you need to setup a SickChillScope like this:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SickChillScope(
      baseUrl: 'http://192.168.1.35:8081',
      apiKey: 'APIKey',
      child: MaterialApp(
        ...
      ),
    );
  }
}
```

Here you just pass the base url of the remote sickchill instance, after that you can start adding UI to manage SickChill.

### Easy usage

The most easy usage is to launch a full screen, to do so use `SickChillScreen` like this:

```dart
Navigator.of(context).push(MaterialPageRoute(builder: (context) => SickChillScreen()));
```  

### Custom usage

If the easy usage doesn't fit your need you can use dedicated widgets to build your own interface, here is a list of widget available:

| Widget | Usage |
| --- | --- |
| SickChillScreen | full screen to see and interact with SickChill instance |
| TvShowList | List of the shows |
| TvShowListItem | Show data in the list view |
| TvShowGridItem | Show data in the grid view |
| AddShowFloatingButton | Floating button to open screen/dialog to add new show |
| AddShowContent | Form for adding a show |
| AddShowDialog | AddShowContent inside Dialog for adding a show |
| AddShowScreen | AddShowContent inside Screen for adding a show |
| TvShowScreen | Screen for show details |
| TvShowStats | Content of the first tab of TvShowScreen with basic show info |
| TvShowSeason | Content of a season tab of TvShowScreen with episodes info |