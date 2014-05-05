import 'package:angular/angular.dart';

import 'essayist.dart';
import 'directives.dart';

main() {
  var module = new Module()
    ..type(StorageService)
    ..type(NoteController)
    ..type(TodoDOMEventDirective);
  ngBootstrap(module: module);
}