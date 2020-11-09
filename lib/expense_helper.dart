import 'models/expense.dart';
import 'package:sqflite/sqflite.dart';

final String tableExpenses = "expenses";
final String columnId = "id";
final String columnName = 'name';
final String columnCategory = 'category';
final String columnDate = 'date';
final String columnNominal = 'nominal';

class ExpenseHelper{
  static Database _database;
  static ExpenseHelper _expenseHelper;

  ExpenseHelper._createInstance();
  factory ExpenseHelper(){
    if (_expenseHelper == null){
      _expenseHelper = ExpenseHelper._createInstance();
    }
    return ExpenseHelper();
  }

  Future<Database> get database async {
    if (_database != null){
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "expenses.db";

    var database = await openDatabase(
        path,
      version: 1,
      onCreate: (db, version){
          db.execute('''
          create table $tableExpenses(
          $columnId integer primary key autoincrement,
          $columnName text not null,
          $columnCategory text not null,
          $columnDate text not null,
          $columnNominal integer not null)
          ''');
      }
    );

    return database;
  }

  void insertExpense(Expense itemExpense) async {
    var db = await this.database;
    var result = await db.insert(tableExpenses, itemExpense.toMap());
    print(result);
  }
}