import 'dart:typed_data';
import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';

import 'todo.dart';

Future<bool> insertTodo (Todo todo) async {
  var postData = {
    '\"name\"' : '\"' + todo.name + '\"',
    '\"id\"' :  '\"' + todo.id + '\"'
  };

  print("Calling the rest api with " + postData.toString());

  try {
    RestOptions options = RestOptions(
        apiName: 'flutterTodoApi',
        path: '/todo',
        body: Uint8List.fromList(postData.toString().codeUnits)
    );



    RestOperation restOperation = Amplify.API.post(
        restOptions: options
    );
    RestResponse response = await restOperation.response;
    print('POST call succeeded');
    print(new String.fromCharCodes(response.data));
    return true;
  } on ApiException catch (e) {
    print('POST call failed: $e');
    return false;
  }
}

Future<bool> deleteTodo (Todo todo) async {

  try {
    RestOptions options = RestOptions(
        apiName: 'flutterTodoApi',
        path: '/todo/object/' + todo.id + "/" + todo.name
    );
    RestOperation restOperation = Amplify.API.delete(
        restOptions: options
    );
    RestResponse response = await restOperation.response;
    print('DELETE call succeeded');
    print(new String.fromCharCodes(response.data));
    return true;
  } on ApiException catch (e) {
    print('DELETE call failed: $e');
    return false;
  }
}

Future<List<Todo>> fetchAllTodos(userId) async {

  List<Todo> todoList = [];

  try {
    RestOptions options = RestOptions(
        apiName: 'flutterTodoApi',
        path: '/todo/' + userId
    );
    RestOperation restOperation = Amplify.API.get(
        restOptions: options
    );
    RestResponse response = await restOperation.response;
    print('GET call succeeded');
    print(new String.fromCharCodes(response.data));
    List<dynamic> parsedListJson = jsonDecode(new String.fromCharCodes(response.data));
    todoList = List<Todo>.from(parsedListJson.map((i) => Todo.fromJson(i)));
    return todoList;
  } on ApiException catch (e) {
    print('GET call failed: $e');
    return todoList;
  }
}