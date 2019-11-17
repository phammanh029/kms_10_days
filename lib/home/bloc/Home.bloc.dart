import 'package:ai_touch_10_days/app.bloc.dart';
import 'package:ai_touch_10_days/repository/Repository.dart';
import 'package:ai_touch_10_days/server.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

// EVENT
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeEventStartup extends HomeEvent {}

class HomeEventRemoveData extends HomeEvent {}

class HomeEventDownloadOffline extends HomeEvent {
  final String url;

  const HomeEventDownloadOffline(this.url);

  @override
  List<Object> get props => [url];
}

// STATE
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeStateInitial extends HomeState {}

class HomeStateLoading extends HomeState {}

class HomeStateLocalExists extends HomeState {}

class HomeStateLocalNotExists extends HomeState {}

class HomeStateOfflineContentLoaded extends HomeState {
  final String content;

  const HomeStateOfflineContentLoaded(this.content);

  @override
  List<Object> get props => [content];
}

class HomeStateError extends HomeState {
  final String error;

  HomeStateError(this.error);

  @override
  List<Object> get props => [error];
}

// BLOC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final Repository repository;
  final AppBloc appBloc;
  Server _server;

  HomeBloc(this.repository, this.appBloc);

  @override
  HomeState get initialState => HomeStateInitial();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    try {
      if (event is HomeEventRemoveData) {
        yield HomeStateLoading();
        // remove data if exist
        await repository.removeData();
        yield HomeStateLocalNotExists();
      }

      if (event is HomeEventStartup) {
        // check start up
        yield HomeStateLoading();
        final hasLocal = await repository.hasOfflineData();
        if (hasLocal) {
          // do download
          yield HomeStateOfflineContentLoaded(
              await repository.loadOfflineContent());
          // start server
          _server = Server();
          // listen server on port 9000
          _server.listen(9000);
        } else {
          yield HomeStateLocalNotExists();
        }
      }

      if (event is HomeEventDownloadOffline) {
        await repository.downloadFile(event.url);
        await repository.extractOffline();
        appBloc.add(AppEventMessage('Offline data downloaded'));
      }
    } catch (err) {
      yield HomeStateError(err.toString());
    }
  }
}
