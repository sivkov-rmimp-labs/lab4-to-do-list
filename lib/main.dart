import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lab4_todo_list/data/todo_item.dart';
import 'package:lab4_todo_list/data/todo_item_card.dart';
import 'package:lab4_todo_list/todo_item_details_screen.dart';
import 'package:lab4_todo_list/utils.dart';

Future main() async {
  await initializeDateFormatting('ru_RU');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final todoItems = [
  TodoItem(
    id: 1,
    title: 'Сходить в магазин',
    description: 'Купить:\n- Молоко\n- Хлеб\n- Рыбу\n- Семечки\n- Чачку пипсов',
    dueDate: DateTime(2023, 2, 28),
  ),
  TodoItem(
    id: 2,
    title: 'Сдать 4 лабу по РМиМП',
    dueDate: DateTime(2023, 3, 10),
    isDone: true,
  ),
  TodoItem(
    id: 3,
    title: 'Погладить собаку',
    description: 'Кто хороший мальчик? Кто хороший мальчик?',
    dueDate: DateTime(2023, 1, 1),
  ),
  TodoItem(
    id: 4,
    title: 'Слишком большое название для задачи оно сюда не влезет',
    dueDate: DateTime(2023, 5, 21),
  ),
  TodoItem(
    id: 5,
    title: 'Слишком большое описание',
    description:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
    dueDate: DateTime(2023, 6, 22),
    isDone: true,
  ),
  TodoItem(
    id: 6,
    title: 'Должна быть выполнена сегодня',
    description: 'Пока еще не просрочена',
    dueDate: DateTime.now().removeTimeComponent(),
  ),
  TodoItem(
    id: 6,
    title: 'Выполнена вчера',
    description: 'Не просрочена потому что выполнена',
    dueDate: DateTime.now().subtract(const Duration(days: 1)).removeTimeComponent(),
    isDone: true,
  ),
];

final rebuildListenable = ChangeNotifier();

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) {
                    return const TodoItemDetailsScreen(readonly: false); // Add new to-do item
                  }),
                ).then((_) {
                  rebuildListenable.notifyListeners();
                });
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(10),
        child: AnimatedBuilder(
          animation: rebuildListenable,
          builder: (context, _) {
            final orderedToDoItems = todoItems.orderBy((x) => x.isDone ? 1 : 0).thenBy((x) => x.dueDate);
            return ListView.builder(
              itemCount: todoItems.length,
              itemBuilder: (context, index) {
                final todoItem = orderedToDoItems.elementAt(index);
                return TodoItemCard(todoItem: todoItem);
              },
            );
          },
        ),
      ),
    );
  }
}
