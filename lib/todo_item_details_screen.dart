import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab4_todo_list/data/todo_item.dart';
import 'package:lab4_todo_list/main.dart';
import 'package:lab4_todo_list/utils.dart';

class TodoItemDetailsScreen extends StatefulWidget {
  final TodoItem? todoItem;
  final bool readonly;

  const TodoItemDetailsScreen({Key? key, this.todoItem, this.readonly = true}) : super(key: key);

  @override
  State<TodoItemDetailsScreen> createState() => _TodoItemDetailsScreenState();
}

class _TodoItemDetailsScreenState extends State<TodoItemDetailsScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.todoItem?.title ?? '';
    _descriptionController.text = widget.todoItem?.description ?? '';
    _dueDate = widget.todoItem?.dueDate ?? DateTime.now().removeTimeComponent();
  }

  @override
  Widget build(BuildContext context) {
    String screenTitle;
    bool isAdding = false, isDisplaying = false, isEditing = false;
    if (widget.readonly) {
      if (widget.todoItem != null) {
        screenTitle = 'Подробно';
        isDisplaying = true;
      } else {
        throw Exception('Невалидное состояние _TodoItemDetailsScreenState: readonly == true && todoItem == null');
      }
    } else {
      if (widget.todoItem != null) {
        screenTitle = 'Редактирование';
        isEditing = true;
      } else {
        screenTitle = 'Добавление';
        isAdding = true;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
        actions: [
          if (isDisplaying && widget.todoItem?.isDone == false)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return TodoItemDetailsScreen(todoItem: widget.todoItem, readonly: false); // Edit to-do item
                    },
                  ),
                ).then((_) {
                  rebuildListenable.notifyListeners();
                });
              },
              icon: const Icon(Icons.edit),
            ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                label: Row(
                  children: const [
                    Text('Название'),
                    Text('*', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
              readOnly: widget.readonly,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Краткое описание'),
              minLines: null,
              maxLines: null,
              readOnly: widget.readonly,
            ),
            DateTimeField(
              mode: DateTimeFieldPickerMode.date,
              decoration: InputDecoration(
                label: Row(
                  children: const [
                    Text('Срок выполнения'),
                    Text('*', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
              initialDate: _dueDate,
              onDateSelected: (DateTime value) {
                setState(() {
                  _dueDate = value;
                });
              },
              selectedDate: _dueDate,
              enabled: !widget.readonly,
              dateFormat: DateFormat.yMMMMd('ru_RU'),
              dateTextStyle: TextStyle(
                color: widget.todoItem == null ||
                        !_dueDate!.removeTimeComponent().isBefore(DateTime.now().removeTimeComponent()) ||
                        widget.todoItem!.isDone
                    ? null // black
                    : Colors.red,
              ),
            ),
            if (isAdding)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.trim().isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Ошибка валидации'),
                            content: const Text('Поле "Заголовок" не может быть пустым!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }

                    final newToDoItem = TodoItem(
                      id: todoItems.length + 1,
                      title: _titleController.text,
                      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
                      dueDate: _dueDate!,
                    );
                    todoItems.add(newToDoItem);
                    rebuildListenable.notifyListeners();
                    Navigator.pop(context);
                  },
                  child: const Text('Добавить'),
                ),
              ),
            if (isDisplaying && widget.todoItem?.isDone == false)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: const Text('Поздравляем. Задача выполнена'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    widget.todoItem!.isDone = true;
                    rebuildListenable.notifyListeners();
                  },
                  child: const Text('Выполнить'),
                ),
              ),
            if (isEditing) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.trim().isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Ошибка валидации'),
                            content: const Text('Поле "Заголовок" не может быть пустым!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }

                    widget.todoItem!.title = _titleController.text;
                    widget.todoItem!.description =
                        _descriptionController.text.isEmpty ? null : _descriptionController.text;
                    widget.todoItem!.dueDate = _dueDate!;
                    Navigator.pop(context);
                    Navigator.pop(context);
                    rebuildListenable.notifyListeners();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Задача отредактирована')),
                    );
                  },
                  child: const Text('Сохранить'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Подтверждение удаления'),
                          content: const Text('Вы уверены, что хотите удалить задачу? Восстановить её будет нельзя.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                todoItems.remove(widget.todoItem);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Задача удалена')),
                                );
                              },
                              child: const Text('Да, удалить'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Нет, оставить'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Удалить'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
