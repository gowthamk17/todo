import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';
import '../constants/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Todo> todoList = [];
  List<Todo> _filteredList = [];
  final _todoController = TextEditingController();
  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppbar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ReorderableListView(
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        Todo item = _filteredList.removeAt(oldIndex);
                        _filteredList.insert(newIndex, item);
                      });
                    },
                    buildDefaultDragHandles: false,
                    header: Container(
                      margin: const EdgeInsets.only(top: 50, bottom: 20),
                      child: const Text(
                        "ToDo's List",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    footer: const SizedBox(
                      height: 80,
                    ),
                    children: [
                      for (int i = 0; i < _filteredList.length; i++)
                        ReorderableDragStartListener(
                          key: ValueKey(_filteredList.toList()[i].todoText),
                          index: i,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                            ),
                            child: TodoItem(
                              todo: _filteredList.toList()[i],
                              onTodoChange: _handleTodoChange,
                              onTodoDelete: _deleteTodoItem,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 0.0,
                          )
                        ]),
                    child: TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                        hintText: "Add new Todo item",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      minimumSize: const Size(60, 60),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (_todoController.text.isNotEmpty) {
                        _addToTodoList(_todoController.text);
                      }
                    },
                    child: const Text(
                      "+",
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      List<String>? savedData = _preferences.getStringList(todo.id);
      if (savedData != null) {
        _preferences.setStringList(
            todo.id, [todo.todoText, todo.isDone ? 'true' : 'false']);
      }
    });
  }

  void _deleteTodoItem(String id) {
    setState(() {
      todoList.removeWhere((item) => item.id == id);
      List<String>? savedTodoList = _preferences.getStringList('todoId');
      if (savedTodoList != null) {
        savedTodoList.remove(id);
        _preferences.remove(id);
      }
    });
  }

  void _addToTodoList(String todo) {
    setState(() {
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      Todo newTodo = Todo(id: id, todoText: todo);
      todoList.insert(0, newTodo);
      List<String>? savedTodoList = _preferences.getStringList('todoId');
      if (savedTodoList != null) {
        _preferences.setStringList('todoId', [...savedTodoList, id]);
        _preferences.setStringList(id, [todo, 'false']);
      }
    });
    _todoController.clear();
  }

  void _filterTodoList(String searchWord) {
    List<Todo> result = [];
    if (searchWord.isEmpty) {
      result = todoList;
    } else {
      result = todoList
          .where((item) =>
              item.todoText.toLowerCase().contains(searchWord.toLowerCase()))
          .toList();
    }
    setState(() {
      _filteredList = result;
    });
  }

  Future<void> _loadData() async {
    _preferences = await SharedPreferences.getInstance();
    List<String>? savedTodoIdList = _preferences.getStringList('todoId');
    if (savedTodoIdList != null) {
      for (String id in savedTodoIdList) {
        List<String>? todoData = _preferences.getStringList(id);
        if (todoData != null) {
          String todoText = todoData[0];
          String isDone = todoData[1];
          todoList.add(Todo(
              id: id,
              todoText: todoText,
              isDone: isDone == 'true' ? true : false));
        }
      }
    } else {
      _preferences.setStringList('todoId', []);
    }
    setState(() {
      _filteredList = todoList;
    });
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              child: Image.asset('assets/images/avatar.png'),
            ),
          )
        ],
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _filterTodoList(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: "Search",
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }
}
