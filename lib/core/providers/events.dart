import 'package:campus_mobile_experimental/core/models/events.dart';
import 'package:campus_mobile_experimental/core/services/events.dart';
import 'package:flutter/material.dart';

class EventsDataProvider extends ChangeNotifier {
  EventsDataProvider() {
    ///DEFAULT STATES
    _isLoading = false;

    ///INITIALIZE SERVICES
    _eventsService = EventsService();

    _eventsModels = List<EventModel>();
  }

  ///STATES
  bool _isLoading;
  DateTime _lastUpdated;
  String _error;

  ///MODELS
  List<EventModel> _eventsModels;

  ///SERVICES
  EventsService _eventsService;

  void fetchEvents() async {
    print('EventsDataProvider: fetchEvents');
    _isLoading = true;
    _error = null;
    notifyListeners();
    if (await _eventsService.fetchData()) {
      print('EventsDataProvider: fetchEvents: SUCCESS');
      _eventsModels = _eventsService.eventsModels;
      _lastUpdated = DateTime.now();

      /// check to see if the events feed returns nothing back
      if (_eventsModels.isEmpty) {
        _error = 'No events found.';
      }
    } else {
      print('EventsDataProvider: fetchEvents: ERROR');

      ///TODO: determine what error to show to the user
      _error = _eventsService.error;
    }
    _isLoading = false;
    notifyListeners();
  }

  ///SIMPLE GETTERS
  bool get isLoading => _isLoading;
  String get error => _error;
  DateTime get lastUpdated => _lastUpdated;
  List<EventModel> get eventsModels => _eventsModels;
}
