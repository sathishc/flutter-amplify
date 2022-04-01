import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'todo.dart';
import 'package:uuid/uuid.dart';
import 'todo_service.dart';

const uuid = Uuid();

class TodoList extends StatefulWidget {
  const TodoList({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<TodoList> createState() => _TodoListState();
}


class _TodoListState extends State<TodoList> {

  final TextEditingController _textFieldController = TextEditingController();
  final List<Todo> _todos = <Todo>[];

  @override
  initState() {
    super.initState();

    _getTodoList();
  }

  void _addTodoItem(String name) async {
    final user = await Amplify.Auth.getCurrentUser();
    var todo = Todo(name: name, id: user.userId);
    var insertedTodo = await insertTodo(todo);
    if(insertedTodo) {
      setState(() {
        _todos.add(todo);
      });
      _textFieldController.clear();
    } else {
      print("Unable to insert the todo");
    }

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: _todos.map((Todo todo) {
          return TodoItem(
            todo: todo,
            onTodoDeleted: _handleTodoDelete,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(),
          tooltip: 'Add Item',
          child: Icon(Icons.add)),
    );
  }



  void _handleTodoDelete(Todo todo) async {
    if(await deleteTodo(todo) == true){
      setState(() {
        _todos.remove(todo);
      });
    }
  }

  void _getTodoList() async {
    final user = await Amplify.Auth.getCurrentUser();
    List<Todo> todoList = await fetchAllTodos(user.userId);
    print("Received todo list ");
    if(todoList.length > 0){
      setState(() {
        _todos.addAll(todoList);
      });
    }
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new todo item'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your new todo'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }
}

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoDeleted,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoDeleted;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          onTodoDeleted(todo);
        },
        leading: CircleAvatar(
          child: Text(todo.name[0]),
        ),
        title: Text(todo.name),
        trailing: Icon(Icons.delete)
    );
  }
}