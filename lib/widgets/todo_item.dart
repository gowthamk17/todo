// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {

  final Todo todo;
  final onTodoChange;
  final onTodoDelete;

  const TodoItem({super.key, required this.todo, required this.onTodoChange, required this.onTodoDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChange(todo);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Icon(
        todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
        color: tdBlue,
      ),
      title: Text(
        todo.todoText,
        style: TextStyle(
          fontSize: 16,
          color: tdBlack,
          decoration: todo.isDone ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      trailing: Container(
        height: 35,
        width: 35,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: tdRed,
          borderRadius: BorderRadius.circular(5),
        ),
        child: IconButton(
          color: Colors.white,
          iconSize: 18,
          icon: const Icon(Icons.delete,),
          onPressed: () {
            onTodoDelete(todo.id);
          },
        ),
      ),
    );
  }
}
