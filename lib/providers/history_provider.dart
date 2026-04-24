import 'package:flutter/material.dart';
import '../models/calculation_history.dart';
import '../services/storage_service.dart';
class HistoryProvider extends ChangeNotifier
{
  List<CalculationHistory> _history=[];
  int _maxSize=50;
  List<CalculationHistory> get history=>_history;
  HistoryProvider()
  {
    _load();
  }
  Future<void> _load() async
  {
    _history=await StorageService.loadHistory();
    notifyListeners();
  }
  void addHistory(String expression,String result,{int? maxSize}) async
  {
    if(result=='Error')
      return;
    final limit=maxSize ?? _maxSize;
    _history.insert(0,CalculationHistory(
      expression:expression,
      result:result,
      timestamp:DateTime.now(),
    ));
    if(_history.length>limit)
      _history.removeLast();
    await StorageService.saveHistory(_history);
    notifyListeners();
  }
  Future<void> clearHistory() async
  {
    _history.clear();
    await StorageService.clearHistory();
    notifyListeners();
  }
  void removeItem(int index) async
  {
    if(index<0||index>=_history.length)
      return;
    _history.removeAt(index);
    await StorageService.saveHistory(_history);
    notifyListeners();
  }
  void setMaxSize(int size)
  {
    _maxSize=size;
    if(_history.length>size)
    {
      _history=_history.sublist(0,size);
      StorageService.saveHistory(_history);
      notifyListeners();
    }
  }
}
