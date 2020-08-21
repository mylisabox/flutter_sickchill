import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_sickchill/src/stores/add_show_store.dart';
import 'package:flutter_sickchill/src/stores/show_details_store.dart';
import 'package:flutter_sickchill/src/stores/shows_store.dart';
import 'package:flutter_sickchill/src/utils/sickchill_api_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:proxy_layout/proxy_layout.dart';
import 'package:sickchill/sickchill.dart';

part 'add_show.dart';
part 'show_details.dart';
part 'shows_list.dart';

final _defaultDateFormat = DateFormat('dd/MM/yyyy');

class SickChillScope extends StatelessWidget {
  final String baseUrl;
  final String apiKey;
  final Widget child;
  final bool enableLogs;

  const SickChillScope({
    Key key,
    @required this.baseUrl,
    @required this.child,
    @required this.apiKey,
    this.enableLogs = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<ShowsStore>(
      create: (_) {
        return ShowsStore(SickChillApiProvider.setup(baseUrl: baseUrl, enableLogs: enableLogs, apiKey: apiKey));
      },
      dispose: (_, store) => store.dispose(),
      child: child,
    );
  }
}

class SickChillScreen extends StatelessWidget {
  final String title;
  final bool splitAnimes;
  final bool headless;

  const SickChillScreen({
    Key key,
    this.title = 'SickChill',
    this.splitAnimes = true,
    this.headless = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ShowsStore>(context);
    return Scaffold(
      appBar: headless
          ? null
          : AppBar(
              title: Text(title),
              actions: [
                Observer(
                  builder: (context) => IconButton(
                    onPressed: () {
                      store.viewAsList = !store.viewAsList;
                    },
                    tooltip: store.viewAsList ? 'View as grid' : 'View as list',
                    icon: Icon(store.viewAsList ? Icons.view_module : Icons.view_list),
                  ),
                ),
        ],
      ),
      body: TvShowList(
        headless: headless,
        splitAnimes: splitAnimes,
      ),
      floatingActionButton: AddShowFloatingButton(),
    );
  }
}

Future<bool> _showConfirm(BuildContext context, String title, String description) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            FlatButton(onPressed: () => Navigator.of(context).pop(true), child: Text(MaterialLocalizations.of(context).okButtonLabel)),
            FlatButton(onPressed: () => Navigator.of(context).pop(false), child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
          ],
        ),
      ) ??
      false;
}

void _showErrors(
  BuildContext context, {
  String title = 'Ooops',
  String description = 'Sorry, an error as occurred',
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: <Widget>[
        FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text(MaterialLocalizations.of(context).okButtonLabel)),
      ],
    ),
  );
}

Future<bool> _showLoading(
  BuildContext context, {
  String title = 'Please wait',
  Future Function() until,
}) {
  return showDialog(
    context: context,
    builder: (context) => HookBuilder(
      builder: (context) {
        useEffect(() {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            until().then((value) => Navigator.of(context).pop(true)).catchError((err) {
              Navigator.of(context).pop(false);
              _showErrors(context, description: err.message);
            }, test: (err) => err is SickChillException).catchError((err) {
              Navigator.of(context).pop(false);
              _showErrors(context);
            });
          });
          return null;
        }, const []);
        return AlertDialog(
          title: Text(title),
          content: Center(child: CircularProgressIndicator()),
        );
      },
    ),
    barrierDismissible: false,
  );
}
