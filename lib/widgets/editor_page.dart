import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:notus/convert.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:html2md/html2md.dart' as html2md;

class EditorPage extends StatefulWidget {
  final String data;

  EditorPage([this.data]);

  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Here we must load the document and pass it to Zefyr controller.
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  String convertToHtml() {
    Delta _delta = _controller.document.toDelta();
    String html =
        markdown.markdownToHtml(notusMarkdown.encode(_delta).toString());
    return html;
  }

  @override
  Widget build(BuildContext context) {
    // Note that the editor requires special `ZefyrScaffold` widget to be
    // one of its parents.
    return ZefyrScaffold(
      child: ZefyrField(
        
        height: 40,
        decoration: InputDecoration(labelText: 'Description'),
        controller: _controller,
        focusNode: _focusNode,
        autofocus: false,
        physics: ClampingScrollPhysics(),
      ),
    );
  }

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument([String data]) {
    if (data == null) {
      return NotusDocument();
    }

    var markdown = html2md.convert(data);
    return NotusDocument.fromDelta(notusMarkdown.decode(markdown));
  }
}
