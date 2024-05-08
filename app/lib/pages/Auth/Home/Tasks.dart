import 'dart:async';

import 'package:app/api/DeleteTask.dart' as eliminarTarea;
import 'package:app/api/EditTask.dart';
import 'package:app/api/SharedTask.dart';
import 'package:app/api/TaskGet.dart';
import 'package:app/api/TaskPost.dart';
import 'package:app/api/VerifyRegister.dart';
import 'package:app/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/api/CompletedTask.dart' as completarTarea;

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Task> tasks = [];

  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _initNotificacionMostrada();
  }

  bool _notificacionMostrada = false;

  Future<void> _initNotificacionMostrada() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificacionMostrada = prefs.getBool('notificacionMostrada') ?? false;
    });
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      TaskGet taskGet = TaskGet();
      List<Task> fetchedTasks = await taskGet.fetchTasks();
      setState(() {
        tasks = fetchedTasks;
        isLoading = false;
        print("Se ha actualizado");
      });

      // Si la notificación no se ha mostrado todavía, la mostramos
      if (!_notificacionMostrada) {
        await mostrarNotificacionTareaCercana(tasks);
        _notificacionMostrada = true; // Marcar la notificación como mostrada
        // Guardar el estado de _notificacionMostrada
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('notificacionMostrada', true);
      }
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
        tasks = [];
      });
      print('Error al obtener las tareas: $e');
    }
  }

  bool showCompletedTasks = false;
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Task> pendingTasks = tasks.where((task) => !task.completed).toList();
    List<Task> completedTasks = tasks.where((task) => task.completed).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Tareas Pendientes",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${pendingTasks.length}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: pendingTasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            _showTaskDetails(context, pendingTasks[index]);
                          },
                          child: ListTile(
                            title: Text(pendingTasks[index].title),
                            leading: Checkbox(
                              value: pendingTasks[index].completed,
                              onChanged: (bool? value) {
                                setState(() {
                                  pendingTasks[index].completed = value!;
                                });
                                if (value == true) {
                                  var id = pendingTasks[index].id;
                                  completarTarea.CompletedTask()
                                      .completarTarea(id);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            GestureDetector(
              onTap: () {
                setState(() {
                  showCompletedTasks = !showCompletedTasks;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Tareas Completadas (${completedTasks.length})",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              alignment: showCompletedTasks
                  ? Alignment.bottomCenter
                  : Alignment.topCenter,
              height: showCompletedTasks ? 150 : 0,
              child: showCompletedTasks
                  ? ListView.builder(
                      shrinkWrap: false,
                      itemCount: completedTasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            _showTaskDetails(context, completedTasks[index]);
                          },
                          child: ListTile(
                            title: Text(completedTasks[index].title),
                            leading: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                var id = completedTasks[index].id;
                                eliminarTarea.DeleteTask().delete(id);
                                _fetchTasks();
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskModal(context);
        },
        backgroundColor: Colors.blue, // Color de fondo del botón
        foregroundColor: Colors.white, // Color del icono del botón
        elevation: 4.0, // Elevación del botón
        tooltip: "Añadir",
        shape: RoundedRectangleBorder(
          // Forma del botón
          borderRadius: BorderRadius.circular(25.0), // Bordes redondeados
        ),
        child: Icon(Icons.add), // Icono del botón
      ),
    );
  }

  void _showTaskDetails(BuildContext context, Task task) {
  // Formatear la fecha en el formato deseado

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                task.title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                'Descripción: ${task.description}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text('Fecha límite: ${task.fecha}'),
            Text(
              'Añadida por: ${task.madeBy?.isEmpty ?? true ? "Yo" : task.madeBy}'
            ),
            // Agregar notas o comentarios aquí

            
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  // Aquí puedes agregar la lógica para eliminar la tarea
                  eliminarTarea.DeleteTask().delete(task.id);
                  _fetchTasks();
                  Navigator.pop(context);
                },
                child: Text('Eliminar'),
              ),
              TextButton(
                onPressed: () {
                  // Aquí puedes agregar la lógica para compartir la tarea
                  Navigator.pop(context);
                  _shareTask(context, task);
                },
                child: Text('Compartir'),
              ),
              TextButton(
                onPressed: () {
                  // Aquí puedes agregar la lógica para editar la tarea
                  Navigator.pop(context);
                  _showAddTaskModal(context, task: task);
                },
                child: Text('Editar'),
              ),
            ],
          ),
          // Agrega más acciones según sea necesario, como editar, eliminar, etc.
        ],
      );
    },
  );
}


  void _shareTask(BuildContext context, Task task) {
    TextEditingController _emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Compartir tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo electrónico'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Obtener el correo electrónico ingresado
                String email = _emailController.text;

                // Verificar si el correo electrónico no está vacío
                if (email.isNotEmpty) {
                  try {
                    bool isRegistered =
                        await VerifyRegister().isUserRegistered(email);
                    if (!isRegistered) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("El usuario no está registrado"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Aceptar"),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      SharedTask sharedTask = SharedTask();
                      await sharedTask.compartirTarea(email, task.id);
                      Navigator.pop(context);
                    }

                    // Si no hubo errores, cerrar el cuadro de diálogo
                    
                  } catch (e) {
                    // Manejar errores
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Hubo un error al compartir la tarea.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: Text('Compartir'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Cerrar el cuadro de diálogo sin hacer nada
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectedDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2200));

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  void _showAddTaskModal(BuildContext context, {Task? task}) {
    String title = task?.title ?? '';
    String description = task?.description ?? '';

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  task == null ? 'Añadir Tarea' : 'Editar Tarea',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Ingrese el título de la tarea',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    title = value;
                  },
                ),
                Text(
                  task == null ? 'Añadir Descripción' : 'Editar Descripción',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Ingrese la descripción de la tarea',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => description = value,
                  textInputAction: TextInputAction.next,
                ),
                Text(
                  task == null ? 'Añadir Fecha limite' : 'Editar Fecha Limite',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: "Fecha",
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_today),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                  onTap: () {
                    _selectedDate();
                  },
                  readOnly: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (title.isNotEmpty &&
                        description.isNotEmpty &&
                        _dateController.text.isNotEmpty) {
                      // Instancia TaskPost para enviar la nueva tarea al servidor
                      if (task == null) {
                        _addTask(title, description);
                      } else {
                        _editTarea(title, description, task.id);
                      }
                    } else {
                      // Si falta algún campo, muestra un diálogo de error
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content:
                                Text('Por favor, completa todos los campos.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text(
                    task == null ? 'Agregar' : "Editar",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addTask(String title, String description) {
    TaskPost taskport = TaskPost();
    Task newTask = Task(
      id: 0, // Ajusta el ID según tu lógica de generación de IDs en el servidor
      title: title,
      description: description,
      completed: false,
      fecha: _dateController.text,
    );
    taskport.addTask(newTask).then((_) {
      // Cuando la tarea se haya agregado exitosamente, actualiza la lista de tareas
      _fetchTasks(); // <-- Aquí se llama a _fetchTasks() para obtener las tareas actualizadas
      _dateController.text = '';
      Navigator.pop(context);
    }).catchError((error) {
      print(error);
      // Si ocurre un error al agregar la tarea, muestra un diálogo de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Ocurrió un error al agregar la tarea.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  void _editTarea(String title, String description, int id) {
    Task newTask = Task(
      id: id,
      title: title,
      description: description,
      completed: false,
      fecha: _dateController.text,
    );
    EditTask().Edit(newTask, id).then((_) {
      // Cuando la tarea se haya agregado exitosamente, actualiza la lista de tareas
      _fetchTasks(); // <-- Aquí se llama a _fetchTasks() para obtener las tareas actualizadas
      _dateController.text = '';
      Navigator.pop(context);
    }).catchError((error) {
      print(error);
      // Si ocurre un error al agregar la tarea, muestra un diálogo de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Ocurrió un error al agregar la tarea.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }
}
