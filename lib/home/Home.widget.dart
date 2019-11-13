import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          floating: true,
          pinned: false,
          snap: false,
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl:
                'https://myworkspace.vn/ebooks/touch-ai-draft-day-01-free',
          )
        ]))
      ]),
    );
  }
}
