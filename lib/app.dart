import 'package:ai_touch_10_days/app.bloc.dart';
import 'package:ai_touch_10_days/home/Home.widget.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
              primarySwatch: Colors.indigo,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: theme,
            home: BlocProvider<AppBloc>(
                builder: (context) => AppBloc(), child: HomeWidget()),
          );
        });
  }
}
