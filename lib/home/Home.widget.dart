import 'package:ai_touch_10_days/app.bloc.dart';
import 'package:ai_touch_10_days/home/bloc/Home.bloc.dart';
import 'package:ai_touch_10_days/repository/Repository.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  HomeBloc _bloc;
  static const endpoint =
      'https://myworkspace.vn/ebooks/touch-ai-draft-day-01-free/';
  static const downloadLink =
      'https://myworkspace.vn/ebooks/touch-ai-draft-day-01-free/touch-ai-draft-day-01-free-offline.zip';
  @override
  void initState() {
    super.initState();
    _bloc = HomeBloc(Repository(), BlocProvider.of<AppBloc>(context));
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
        body: BlocListener<AppBloc, AppState>(
            listener: (context, state) {
              if (state is AppStateNewMessage) {
                Flushbar(title: 'Message', message: state.message)
                    .show(context);
              }
            },
            child: BlocBuilder(
                bloc: _bloc,
                builder: (context, state) {
                  if (state is HomeStateLoading) {
                    return const Center(
                        child: const CircularProgressIndicator());
                  }

                  if (state is HomeStateError) {
                    return Column(
                      children: <Widget>[
                        FlatButton.icon(
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete data'),
                            onPressed: () {
                              // do download
                              _bloc.add(HomeEventRemoveData());
                            }),
                        Text(state.error ?? 'Something went wrong')
                      ]
                    );
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
                                  _bloc.add(
                                      HomeEventDownloadOffline(downloadLink));
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
                    return _buildOfflineWidget(state);
                  }

                  return const Center(child: const Text('Initializing . . .'));
                })));
  }

  CustomScrollView _buildOfflineWidget(HomeStateOfflineContentLoaded state) {
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
          floating: true,
          pinned: false,
          snap: false,
          actions: <Widget>[
            FlatButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Delete data'),
                onPressed: () {
                  // do download
                  _bloc.add(HomeEventRemoveData());
                })
          ]),
      SliverFillRemaining(
          child: Builder(
              builder: (context) => WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: 'file:///${state.content}')))
    ]);
  }
}
