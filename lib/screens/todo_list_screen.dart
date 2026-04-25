import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../database/database_helper.dart';
import 'todo_form_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Todo> _todos = [];
  bool _isLoading = true;

  // ✅ FILTER & SEARCH
  String selectedFilter = 'all';
  String keyword = '';

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  // 🔥 LOAD DATA (SUDAH DIGANTI pakai searchTodos)
  Future<void> _loadTodos() async {
    setState(() => _isLoading = true);

    final todos = await _dbHelper.searchTodos(
      keyword: keyword,
      filter: selectedFilter,
    );

    setState(() {
      _todos = todos;
      _isLoading = false;
    });
  }

  // Toggle status
  Future<void> _toggleTodo(Todo todo) async {
    await _dbHelper.toggleTodoStatus(todo.id!, !todo.isDone);
    _loadTodos();
  }

  // Delete
  Future<void> _deleteTodo(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tugas'),
        content: const Text('Tugas ini akan dihapus secara permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _dbHelper.deleteTodo(id);
      _loadTodos();
    }
  }

  // Navigasi tambah
  Future<void> _navigateToAddForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TodoFormScreen()),
    );
    _loadTodos();
  }

  // Navigasi edit
  Future<void> _navigateToEditForm(Todo todo) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TodoFormScreen(todo: todo)),
    );
    _loadTodos();
  }

  // Format tanggal
  String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    const months = [
      'Jan','Feb','Mar','Apr','Mei','Jun',
      'Jul','Agu','Sep','Okt','Nov','Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              await _dbHelper.deleteCompletedTodos();
              _loadTodos();
            },
          ),
        ],
      ),

      // 🔥 BODY SUDAH DIUBAH (COLUMN)
      body: Column(
        children: [

          // 🔍 SEARCH
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari judul...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                keyword = value;
                _loadTodos();
              },
            ),
          ),

          // 🎯 FILTER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButton<String>(
              value: selectedFilter,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('Semua')),
                DropdownMenuItem(value: 'done', child: Text('Selesai')),
                DropdownMenuItem(value: 'undone', child: Text('Belum')),
              ],
              onChanged: (value) {
                selectedFilter = value!;
                _loadTodos();
              },
            ),
          ),

          // 📋 LIST
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _todos.isEmpty
                ? const Center(child: Text('Tidak ada data'))
                : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: Checkbox(
                      value: todo.isDone,
                      onChanged: (_) => _toggleTodo(todo),
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.isDone
                            ? TextDecoration.lineThrough
                            : null,
                        color: todo.isDone ? Colors.grey : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        if (todo.description.isNotEmpty)
                          Text(todo.description),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(todo.createdAt),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _navigateToEditForm(todo),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () =>
                              _deleteTodo(todo.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import '../models/todo.dart';
// import '../database/database_helper.dart';
// import 'todo_form_screen.dart';
//
//
//
// class TodoListScreen extends StatefulWidget {
//   const TodoListScreen({super.key});
//
//   @override
//   State<TodoListScreen> createState() => _TodoListScreenState();
// }
//
// class _TodoListScreenState extends State<TodoListScreen> {
//   final DatabaseHelper _dbHelper = DatabaseHelper();
//   List<Todo> _todos = [];
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadTodos();
//   }
//
//   // Memuat seluruh tugas dari database
//   Future<void> _loadTodos() async {
//     setState(() => _isLoading = true);
//     final todos = await _dbHelper.getAllTodos();
//     setState(() {
//       _todos = todos;
//       _isLoading = false;
//     });
//   }
//
//   // Menandai tugas sebagai selesai atau belum selesai
//   Future<void> _toggleTodo(Todo todo) async {
//     await _dbHelper.toggleTodoStatus(todo.id!, !todo.isDone);
//     _loadTodos();
//   }
//
//   // Menghapus tugas dengan konfirmasi dialog
//   Future<void> _deleteTodo(int id) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Hapus Tugas'),
//         content: const Text('Tugas ini akan dihapus secara permanen.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Batal'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text(
//               'Hapus',
//               style: TextStyle(color: Colors.red),
//             ),
//           ),
//         ],
//       ),
//     );
//     if (confirm == true) {
//       await _dbHelper.deleteTodo(id);
//       _loadTodos();
//     }
//   }
//
//   // Navigasi ke form tambah tugas baru
//   Future<void> _navigateToAddForm() async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const TodoFormScreen()),
//     );
//     _loadTodos();
//   }
//
//   // Navigasi ke form edit tugas yang sudah ada
//   Future<void> _navigateToEditForm(Todo todo) async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => TodoFormScreen(todo: todo)),
//     );
//     _loadTodos();
//   }
//
//   //   soal nomer 4
//
//   Future<void> loadTodos() async {
//     setState(() => isLoading = true);
//
//     todos = await db.searchTodos(
//       keyword: keyword,
//       filter: selectedFilter,
//     );
//
//     setState(() => isLoading = false);
//   }
//   String selectedFilter = 'all';
//   String keyword = '';
//
//   // Memformat string ISO 8601 menjadi format tanggal yang lebih ringkas
//   String _formatDate(String isoDate) {
//     final date = DateTime.parse(isoDate);
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'Mei',
//       'Jun',
//       'Jul',
//       'Agu',
//       'Sep',
//       'Okt',
//       'Nov',
//       'Des'
//     ];
//     return '${date.day} ${months[date.month - 1]} ${date.year}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('To-Do List'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.delete_sweep),
//             tooltip: 'Hapus semua yang selesai',
//             onPressed: () async {
//               await _dbHelper.deleteCompletedTodos();
//               _loadTodos();
//             },
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _todos.isEmpty
//           ? const Center(
//         child: Text(
//           'Belum ada tugas.\nTekan + untuk menambahkan.',
//           textAlign: TextAlign.center,
//           style: TextStyle(color: Colors.grey),
//         ),
//       )
//           : ListView.builder(
//         itemCount: _todos.length,
//         itemBuilder: (context, index) {
//           final todo = _todos[index];
//           return Card(
//             margin: const EdgeInsets.symmetric(
//                 horizontal: 12, vertical: 4),
//             child: ListTile(
//               leading: Checkbox(
//                 value: todo.isDone,
//                 onChanged: (_) => _toggleTodo(todo),
//               ),
//               title: Text(
//                 todo.title,
//                 style: TextStyle(
//                   decoration:
//                   todo.isDone ? TextDecoration.lineThrough : null,
//                   color: todo.isDone ? Colors.grey : null,
//                 ),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (todo.description != null &&
//                       todo.description!.isNotEmpty)
//                     Text(todo.description!),
//                   const SizedBox(height: 4),
//                   Text(
//                     _formatDate(todo.createdAt),
//                     style: const TextStyle(
//                       fontSize: 11,
//                       color: Colors.grey,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//                 ],
//               ),
//               isThreeLine: todo.description != null &&
//                   todo.description!.isNotEmpty,
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.edit, size: 20),
//                     onPressed: () => _navigateToEditForm(todo),
//                   ),
//                   IconButton(
//                     icon: const Icon(
//                       Icons.delete,
//                       size: 20,
//                       color: Colors.red,
//                     ),
//                     onPressed: () => _deleteTodo(todo.id!),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _navigateToAddForm,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
//
// }
