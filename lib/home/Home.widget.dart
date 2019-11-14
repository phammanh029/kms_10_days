import 'package:ai_touch_10_days/home/bloc/Home.bloc.dart';
import 'package:ai_touch_10_days/repository/Repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final HomeBloc _bloc = HomeBloc(Repository());
  static const endpoint =
      'https://myworkspace.vn/ebooks/touch-ai-draft-day-01-free';
  static const downloadLink =
      'https://myworkspace.vn/ebooks/ebooks-touch-ai-free-19-pages.zip';
  @override
  void initState() {
    super.initState();
    _bloc.add(HomeEventStartup());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder(
            bloc: _bloc,
            builder: (context, state) {
              if (state is HomeStateLoading) {
                return const Center(child: const CircularProgressIndicator());
              }

              if (state is HomeStateLocalNotExists) {
                return CustomScrollView(slivers: <Widget>[
                  SliverAppBar(
                      floating: true,
                      pinned: false,
                      snap: false,
                      actions: <Widget>[
                        FlatButton.icon(
                            icon: const Icon(Icons.offline_pin),
                            label: const Text('Offline'),
                            onPressed: () {
                              // do download
                              _bloc.add(HomeEventDownloadOffline(downloadLink));
                            })
                      ]),
                  SliverFillRemaining(
                      child: Builder(
                          builder: (context) => WebView(
                              javascriptMode: JavascriptMode.unrestricted,
                              initialUrl: endpoint)))
                ]);
              }

              if (state is HomeStateOfflineContentLoaded) {
                return CustomScrollView(slivers: <Widget>[
                  SliverFillRemaining(
                      child: Builder(
                          builder: (context) => WebView(
                              javascriptMode: JavascriptMode.unrestricted,
                              initialUrl: 'file:///${state.content}')))
                ]);
              }

              return const Center(child: const Text('Initializing . . .'));
            }));
  }
}
