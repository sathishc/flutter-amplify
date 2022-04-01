class Todo {

  final String name;
  final String id;

  Todo({required this.name, required this.id});


  static Todo fromJson(json) {
    return Todo(name: json["name"], id: json["id"]);
  }
}