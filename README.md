# bab3_todo

230605110010
Rahmat Enomoto

Soal 1 - Konseptual 
Jelaskan perbedaan antara metode query() dan rawQuery() pada package sqflite. Dalam kondisi apa masing-masing metode tersebut lebih tepat digunakan? Berikan contoh kasus singkat untuk setiap metode.

    Pada package sqflite, terdapat dua metode utama untuk mengambil data dari database, yaitu query() dan rawQuery(). Keduanya memiliki fungsi yang sama, namun berbeda dalam cara penggunaannya.
      1. Metode query()
      query() adalah metode tingkat tinggi (high-level) yang digunakan untuk mengambil data tanpa menuliskan perintah SQL secara langsung.
      Karakteristik:
        Lebih sederhana dan mudah digunakan
        Menggunakan parameter seperti where, whereArgs, dan orderBy
        Lebih aman dari SQL Injection
      contoh
        
      digunakan:
        Untuk query sederhana
        Tidak membutuhkan JOIN atau query kompleks
        Operasi CRUD dasar

      2. Metode rawQuery()
      rawQuery() adalah metode tingkat rendah (low-level) yang digunakan untuk mengeksekusi perintah SQL secara langsung dalam bentuk string.
    Karakteristik:
      Lebih fleksibel
      Bisa digunakan untuk query kompleks
      Harus menulis SQL secara manual
    digunakan:
      Query kompleks (JOIN, GROUP BY, dll)
      Query dinamis yang sulit ditulis dengan query()
      Kebutuhan SQL yang lebih spesifik
    
