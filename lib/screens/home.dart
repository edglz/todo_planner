import 'package:flutter/material.dart';
import 'package:todo_planner/models/todo.dart';
import 'package:todo_planner/theme/colors.dart';
import 'package:todo_planner/widget/atoms/appbar.dart';
import 'package:todo_planner/widget/atoms/todo_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBgColor,
      appBar: const AppBarAtom(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            searchBox(),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: const Text(
                      'All TODOs',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ),
                  if (_foundToDo.isEmpty)
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.error_outline,
                                  size: 50, color: tdGrey),
                              Text('No se encontró ningún resultado',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20)),
                            ],
                          ),
                        ]),
                  for (ToDo todo in _foundToDo.reversed)
                    ToDoItem(
                      todo: todo,
                      onToDoChanged: _handleToDoChange,
                      onDeleteItem: _deleteToDoItem,
                    )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tdBlue,
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 500,
                color: Colors.white30,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            child: TextField(
                              controller: _todoController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                label: Text('Ingrese el nombre de su tarea'),
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: tdGrey),
                                hintText: 'Ingrese el nombre de su tarea',
                              ),
                            ),
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _addToDoItem(_todoController.text);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Agregar'),
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String toDo) {
    setState(() {
      todosList.add(ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: toDo,
      ));
    });
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: tdBlack,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: tdGrey)),
      ),
    );
  }
}
