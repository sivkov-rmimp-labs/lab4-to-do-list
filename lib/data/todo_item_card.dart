import 'package:flutter/material.dart';
import 'package:lab4_todo_list/data/todo_item.dart';
import 'package:lab4_todo_list/todo_item_details_screen.dart';
import 'package:lab4_todo_list/utils.dart';

class TodoItemCard extends StatelessWidget {
  final TodoItem todoItem;

  const TodoItemCard({Key? key, required this.todoItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? truncatedDescription;
    if (todoItem.description != null) {
      final lines = todoItem.description!.split('\n');
      if (lines.length > 3) {
        truncatedDescription = '${lines.take(3).join('\n')}\n...';
      } else {
        truncatedDescription = todoItem.description;
      }

      truncatedDescription = truncatedDescription?.truncateIfLonger(70);
    }

    final dueDateChipColor = todoItem.dueDate.removeTimeComponent().isBefore(DateTime.now().removeTimeComponent()) && !todoItem.isDone
        ? Colors.red
        : Colors.black;

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return TodoItemDetailsScreen(todoItem: todoItem); // See details of to-do item
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Opacity(
                opacity: todoItem.isDone ? 0.4 : 1,
                child: Text(
                  todoItem.title.truncateIfLonger(35),
                  style: TextStyle(
                    fontSize: 16,
                    decoration: todoItem.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              if (truncatedDescription != null)
                Opacity(
                  opacity: todoItem.isDone ? 0.4 : 1,
                  child: Text(
                    truncatedDescription,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      decoration: todoItem.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(Icons.alarm, size: 20, color: dueDateChipColor),
                      ),
                      Text(todoItem.dueDate.toRussianDateOnly(), style: TextStyle(color: dueDateChipColor)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
