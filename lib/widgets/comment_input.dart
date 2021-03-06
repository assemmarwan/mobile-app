import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utils/http.dart';

class CommentInput extends StatelessWidget {
  final String doctype;
  final String name;
  final String authorEmail;
  final Function callback;

  CommentInput(
      {@required this.doctype,
      @required this.name,
      @required this.authorEmail,
      @required this.callback});

  final TextEditingController input = TextEditingController();

  void _postComment(refDocType, refName, content, email) async {
    var queryParams = {
      'reference_doctype': refDocType,
      'reference_name': refName,
      'content': content,
      'comment_email': email,
      'comment_by': email
    };

    final response2 = await dio.post(
        '/method/frappe.desk.form.utils.add_comment',
        data: queryParams,
        options: Options(contentType: Headers.formUrlEncodedContentType));
    if (response2.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // return DioResponse.fromJson(response2.data);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

    callback();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _input = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              if(_input.text.isEmpty) {
                return;
              }
              await _postComment(doctype, name, _input.text, authorEmail);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: TextField(
        autofocus: true,
        controller: _input,
        maxLines: 9999999,
      ),
    );
    // return Container(
    //   margin: EdgeInsets.only(bottom: 10),
    //   decoration: BoxDecoration(
    //       border: Border.all(color: Color.fromRGBO(209, 216, 221, 1))),
    //   child: Column(
    //     children: <Widget>[
    //       Container(
    //         height: 30,
    //         decoration: BoxDecoration(
    //             color: Color.fromRGBO(250, 251, 252, 1),
    //             border: Border(
    //                 bottom: BorderSide(
    //                     width: 0.5, color: Color.fromRGBO(209, 216, 221, 1)))),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             Padding(
    //               padding: EdgeInsets.only(left: 5),
    //               child: Text(
    //                 'Add a Comment',
    //                 style: TextStyle(color: Color.fromRGBO(141, 153, 166, 1)),
    //               ),
    //             ),
    //             FlatButton(
    //               onPressed: () {
    //                 FocusScope.of(context).unfocus();
    //                 _postComment(doctype, name, input.text, authorEmail);
    //               },
    //               color: Color.fromRGBO(240, 244, 247, 1),
    //               child: Text('Comment'),
    //             )
    //           ],
    //         ),
    //       ),
    //       TextField(
    //         controller: input,
    //       ),
    //     ],
    //   ),
    // );
  }
}
