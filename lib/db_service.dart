// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'models/expense.dart';
//
// final tableExpenses = "expenses";
//
// class DatabaseService {
//   static final DatabaseService _instance = DatabaseService._internal();
//   Future<Database> database;
//
//   factory DatabaseService() {
//     return _instance;
//   }
//
//   DatabaseService._internal() {
//     initDatabase();
//   }
//
//   initDatabase() async {
//     database = openDatabase(
//       join(await getDatabasesPath(), 'dot_expense.db'),
//       // When the database is first created, create a table to store data.
//       onCreate: (db, version) {
//         db.execute(
//           '''CREATE TABLE $tableExpenses(
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             name STRING,
//             category STRING,
//             date STRING,
//             nominal INTEGER)
//           ''',
//         );
//       },
//       // Set the version. This executes the onCreate function and provides a
//       // path to perform database upgrades and downgrades.
//       version: 1,
//     );
//   }
//
//   Future<int> insertExpense(Expense itemExpense) async {
//     Database db = await database;
//     int id = await db.insert(tableExpenses, itemExpense.toMap());
//     return id;
//   }
//
//   Future<Expense> getItemExpense(int id) async {
//     Database db = await database;
//     List<Map> datas = await db.query(tableExpenses,
//         where: 'id = ?',
//         whereArgs: [id]);
//     if (datas.length > 0) {
//       return Expense.fromMap(datas.first);
//     }
//     return null;
//   }
// }