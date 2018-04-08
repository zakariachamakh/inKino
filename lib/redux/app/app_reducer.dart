import 'package:inkino/data/models/actor.dart';
import 'package:inkino/redux/app/app_actions.dart';
import 'package:inkino/redux/app/app_state.dart';
import 'package:inkino/redux/event/event_reducer.dart';
import 'package:inkino/redux/show/show_reducer.dart';
import 'package:inkino/redux/theater/theater_reducer.dart';
import 'package:redux/redux.dart';

AppState appReducer(AppState state, dynamic action) {
  return new AppState(
    searchQuery: _searchQueryReducer(state.searchQuery, action),
    actorsByName: actorReducer(state.actorsByName, action),
    theaterState: theaterReducer(state.theaterState, action),
    showState: showReducer(state.showState, action),
    eventState: eventReducer(state.eventState, action),
  );
}

String _searchQueryReducer(String searchQuery, action) {
  if (action is SearchQueryChangedAction) {
    return action.query;
  }

  return searchQuery;
}

final actorReducer = combineTypedReducers<Map<String, Actor>>([
  new ReducerBinding<Map<String, Actor>, ActorsUpdatedAction>(_actorsUpdated),
  new ReducerBinding<Map<String, Actor>, ReceivedActorAvatarsAction>(_receivedAvatars),
]);

Map<String, Actor> _actorsUpdated(Map<String, Actor> actorsByName, action) {
  var actors = <String, Actor>{}..addAll(actorsByName);
  action.actors.forEach((actor) {
    actors.putIfAbsent(actor.name, () => new Actor(name: actor.name));
  });

  return actors;
}

Map<String, Actor> _receivedAvatars(Map<String, Actor> actorsByName, action) {
  var actorsWithAvatars = <String, Actor>{}..addAll(actorsByName);
  action.actors.forEach((actor) {
    actorsWithAvatars[actor.name] = new Actor(
      name: actor.name,
      avatarUrl: actor.avatarUrl,
    );
  });

  return actorsWithAvatars;
}
