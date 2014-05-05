library essayist;

import 'dart:html' as dom;
import 'dart:convert' as convert;
import 'package:angular/angular.dart';
import 'dart:indexed_db' as idb;

final String _NOTES_DB = "todo";
final String _NOTES_STORE = "todos";

idb.Database _db;
int _version = 1;


class StorageService {
  final dom.Storage _storage = dom.window.localStorage;
  static const String STORAGE_KEY = 'todos-angulardart';

  List<Item> loadItems() {
    final String data = _storage[STORAGE_KEY];

    if (data == null) {
      return [];
    }

    final List<Map> rawItems = convert.JSON.decode(data);
    return rawItems.map((item) => new Item.fromJson(item)).toList();
  }

  void saveItems(List<Item> items) {
    _storage[STORAGE_KEY] = convert.JSON.encode(items);
  }
}


class Item {
  String text;
  int sourceID;

  Item([this.text = '', this.sourceID = 0]);

  Item.fromJson(Map obj) {
    this.text = obj['content'];
    this.sourceID = obj['sourceID'];
  }

  bool get isEmpty => text.trim().isEmpty;

  Item clone() => new Item(this.text, this.sourceID);

  String toString() => '${this.sourceID} - ${this.text}';

  void normalize() {
    text = text.trim();
  }

  // This is method is called when from JSON.encode.
  Map toJson() => { 'content': text, 'sourceID': sourceID };
}


@NgController(
  selector: '[note-controller]',
  publishAs: 'NoteCtrl'
)
class NoteController {
  List<Item> notes = [];
  Item newItem = new Item();
  Item editedItem = null;
  Item previousItem = null;
  
  String content = "<li>example</li>";
  
  StorageService _storageService;

  TodoController(Scope scope, StorageService storage) {
    notes = storage.loadItems();
    _storageService = storage;

    // Since there is no native support for deeply watching collections, we
    // instead watch over the JSON-serialized string representing the items.
    // While hugely inefficient, this is a very simple work-around.
    //scope.$watch((Scope scope) => convert.JSON.encode(notes), save);
  }

  void save() {
    _storageService.saveItems(notes);
  }

  void add() {
    if (newItem.isEmpty) {
      return;
    }

    newItem.normalize();
    notes.add(newItem);
    newItem = new Item();
  }

  void remove(Item item) {
    notes.remove(item);
  }

  int total() {
    return notes.length;
  }

  void editNote(Item item) {
    editedItem = item;
    previousItem = item.clone();
  }

  void doneEditing() {
    if (editedItem == null) {
      return;
    }

    if (editedItem.isEmpty) {
      notes.remove(editedItem);
    }

    editedItem.normalize();
    editedItem = null;
    previousItem = null;
  }

  void revertEditing(Item item) {
    editedItem = null;
    item.text = previousItem.text;
    previousItem = null;
  }
}