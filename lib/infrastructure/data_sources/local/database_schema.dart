// database_schema.dart

final List<String> createTables = [
  // Users table
  '''
  CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    api_id INTEGER NOT NULL UNIQUE,
    username TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone_number TEXT,
    api_token TEXT,
    created_at TEXT,
    updated_at TEXT
  );
  ''',
];
