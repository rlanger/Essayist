import 'package:polymer/polymer.dart';

/**
 * A Polymer jot note element.
 */
@CustomTag('jot-note')
class JotNote extends PolymerElement {
  @published String content = "";

  JotNote.created() : super.created() {
  }

  void setContent() {
    content = "clicked";
  }
}

