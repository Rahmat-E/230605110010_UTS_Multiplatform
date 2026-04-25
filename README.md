# bab3_todo

230605110010
Rahmat Enomoto

---

##  Soal 1 - Konseptual

Pada package **sqflite**, terdapat dua metode utama untuk mengambil data dari database, yaitu **query()** dan **rawQuery()**. Keduanya memiliki fungsi yang sama, yaitu untuk mengambil data, namun berbeda dalam cara penggunaannya.

### 1. Metode query()

`query()` adalah metode tingkat tinggi (*high-level*) yang digunakan untuk mengambil data tanpa menuliskan perintah SQL secara langsung.

**Karakteristik:**

* Lebih sederhana dan mudah digunakan
* Menggunakan parameter seperti *where*, *whereArgs*, dan *orderBy*
* Lebih aman dari SQL Injection

**Contoh Kasus:**
Menampilkan semua tugas yang **belum selesai**.

```dart
final result = await db.query(
  'todos',
  where: 'isDone = ?',
  whereArgs: [0],
);
```

**Digunakan ketika:**

* Query sederhana
* Tidak membutuhkan JOIN atau query kompleks
* Operasi CRUD dasar

---

### 2. Metode rawQuery()

`rawQuery()` adalah metode tingkat rendah (*low-level*) yang digunakan untuk mengeksekusi perintah SQL secara langsung dalam bentuk string.

**Karakteristik:**

* Lebih fleksibel
* Bisa digunakan untuk query kompleks
* Harus menulis SQL secara manual

**Contoh Kasus:**
Mencari tugas berdasarkan **kata kunci pada judul**.

```dart
final result = await db.rawQuery(
  'SELECT * FROM todos WHERE title LIKE ?',
  ['%flutter%'],
);
```

**Digunakan ketika:**

* Query kompleks (JOIN, GROUP BY, dll)
* Query dinamis yang sulit ditulis dengan query()
* Kebutuhan SQL yang lebih spesifik

---

###  Kesimpulan

Metode `query()` lebih cocok untuk operasi sederhana dan terstruktur, sedangkan `rawQuery()` digunakan ketika membutuhkan fleksibilitas tinggi dengan penulisan SQL secara langsung.

---

##  Fitur Utama

*  Menambahkan tugas (Create)
*  Menampilkan daftar tugas (Read)
*  Mengedit tugas (Update)
*  Menghapus tugas (Delete)
*  Menandai tugas selesai / belum selesai
*  Pencarian tugas (Search - LIKE)
*  Filter tugas (Semua / Selesai / Belum)

---

##  Teknologi yang Digunakan

* Flutter
* SQLite (sqflite)
* Dart

---

##  Konsep yang Diterapkan

* CRUD Database
* query() dan rawQuery()
* Filter data menggunakan WHERE
* Pencarian menggunakan LIKE
* State Management sederhana (setState)

---

## 📂 Struktur Project

```plaintext
lib/
├── main.dart
├── models/
│   └── todo.dart
├── database/
│   └── database_helper.dart
├── screens/
│   ├── todo_list_screen.dart
│   └── todo_form_screen.dart
```

---

##  Cara Menjalankan

1. Clone repository:

```bash
git clone https://github.com/Rahmat-E/230605110010_UTS_Multiplatform.git
```

2. Masuk ke folder project:

```bash
cd 230605110010_UTS_Multiplatform
```

3. Install dependencies:

```bash
flutter pub get
```

4. Jalankan aplikasi:

```bash
flutter run
```

---

## 🔗 Project Lain (Bab 4 - Note App)

https://github.com/Rahmat-E/bab4_note

---

## 📝 Catatan

Project ini dibuat untuk memenuhi tugas UTS mata kuliah Multiplatform Programming.
