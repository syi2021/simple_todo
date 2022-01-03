import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:simple_todo/main.dart';

class TodoScreen extends HookConsumerWidget {
  TodoScreen({Key? key}) : super(key: key);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoModel = ref.watch(todoProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: const Text("Menu")),
            ListTile(
              leading: const Icon(Icons.check_box),
              title: const Text("ToDo List"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20),
                height: 80,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Text("ToDo List",
                    style: Theme.of(context).textTheme.headline4),
              ),
              Expanded(
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: AnimatedList(
                            key: _listKey,
                            initialItemCount: todoModel.todoList.length,
                            itemBuilder:
                                (BuildContext context, int index, animation) {
                              return _buildItem(
                                ref,
                                index,
                                Theme.of(context).secondaryHeaderColor,
                                animation,
                              );
                            }),
                      )))
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int insertIndex = todoModel.todoList.length;
          todoModel.createTodo("");
          _listKey.currentState?.insertItem(insertIndex,
              duration: const Duration(milliseconds: 300));

          todoModel.todoList[todoModel.todoList.length - 1].focusNode
              .requestFocus();
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildItem(
    WidgetRef ref,
    int index,
    Color dismissColor,
    Animation<double> animation,
  ) {
    final todoModel = ref.watch(todoProvider);
    final id = todoModel.todoList[index].id;
    final title = todoModel.todoList[index].title;
    final check = todoModel.todoList[index].check;
    final focusNode = todoModel.todoList[index].focusNode;
    return SizeTransition(
        sizeFactor: animation,
        child: Dismissible(
          key: Key('${id.hashCode}'),
          background: Container(color: dismissColor),
          confirmDismiss: (direction) async {
            return true;
          },
          onDismissed: (direction) {
            _listKey.currentState?.removeItem(index,
                (context, animation) => const SizedBox(width: 0, height: 0));
            todoModel.deleteTodo(id);
          },
          child: ListTile(
              leading: Checkbox(
                onChanged: (e) {
                  todoModel.updateCheck(id, !check);
                },
                value: check,
              ),
              title: TextFormField(
                focusNode: focusNode,
                autofocus: false,
                initialValue: title,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  todoModel.updateTodo(id, value);
                },
                onFieldSubmitted: (value) {
                  if (value == "") {
                    _listKey.currentState?.removeItem(
                        index,
                        (context, animation) =>
                            const SizedBox(width: 0, height: 0));
                    todoModel.deleteTodo(id);
                  }
                },
              )),
        ));
  }
}
