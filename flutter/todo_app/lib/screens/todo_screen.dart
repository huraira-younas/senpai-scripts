import 'package:todo_app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

@immutable
class Todo {
  final bool isComplete;
  final DateTime date;
  final String text;

  const Todo({
    required this.isComplete,
    required this.date,
    required this.text,
  });

  Todo copyWith({bool? isComplete, DateTime? date, String? text}) => Todo(
    isComplete: isComplete ?? this.isComplete,
    date: date ?? this.date,
    text: text ?? this.text,
  );

  // toJson, fromJson, copyWith, toString, equal Overload
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _todos = <Todo>[
    Todo(text: "Subscribe now", isComplete: false, date: DateTime.now()),
  ];

  void addTodo() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final todo = Todo(isComplete: false, text: text, date: DateTime.now());
    setState(() => _todos.insert(0, todo));
    _focusNode.unfocus();
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
          ),
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          title: Text(
            "Todo App",
            style: TextStyle(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 30),
              //? Top Secion
              Text(
                "Today",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              Text(
                DateFormat("MMMM dd, yyyy").format(DateTime.now()),
                style: TextStyle(color: AppColors.grayColor, fontSize: 14),
              ),

              const SizedBox(height: 30),
              //? Text Field
              Row(
                spacing: 10,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter todo here...",
                        labelText: "Enter todo here",
                        alignLabelWithHint: true,
                        isDense: true,
                        labelStyle: TextStyle(color: Colors.grey[500]),
                        floatingLabelStyle: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w800,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: addTodo,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 13),
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Add",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              //? Array of Todos
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  shrinkWrap: true,
                  itemCount: _todos.length,
                  itemBuilder: (_, index) {
                    final todo = _todos[index];
                    return Dismissible(
                      key: ValueKey(todo),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        padding: EdgeInsets.only(right: 16),
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _todos.remove(todo);
                      },
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              _todos[index] = todo.copyWith(
                                isComplete: !todo.isComplete,
                              );
                            });
                          },
                          leading: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    todo.isComplete
                                        ? AppColors.grayColor
                                        : Colors.white,
                              ),
                            ),
                            height: 20,
                            width: 20,
                            child:
                                todo.isComplete
                                    ? Icon(
                                      Icons.check,
                                      color: AppColors.grayColor,
                                      size: 14,
                                    )
                                    : null,
                          ),
                          tileColor: Color.fromARGB(255, 44, 42, 42),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(
                            todo.text,
                            style: TextStyle(
                              decoration:
                                  todo.isComplete
                                      ? TextDecoration.lineThrough
                                      : null,
                              decorationThickness: 3,
                              decorationColor: Colors.grey[700],
                              color:
                                  todo.isComplete
                                      ? AppColors.grayColor
                                      : Colors.white,
                            ),
                          ),
                          trailing: Text(
                            DateFormat("hh:mm aa").format(todo.date),
                            style: TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
