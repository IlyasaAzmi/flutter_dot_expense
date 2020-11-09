# flutter_dot_expense

A new Flutter application.

## Jawaban

B
1. 2 bulan
2. Library ysng sering digunakan: 
- http: untuk melakukan komunikasi dengan backend, operasi get data, post, dll
- dio: untuk melakukan upload file atau foto ke backend
- shared preferences: menyimpan persistent data key value di local
- path_provider: menentukan file direktori dalam project
- provider: menyediakan data yang bisa diakses di seluruh widget, pendekatan reactive yang mempunyai data source of truth yang bisa digunakan di seluruh screen dan widget
3. Sejauh ini belum menerapkan design pattern, lebih ke data flow yang diterapkan menggunakan provider dengan data 'source of truth' nya sehingga data bisa diakses atau melakukan operasi dan perubahan di seluruh widget. 
Dan yang bisa saya hubungkan dengan development di Swift yaitu menggunakan arsitektur MVVM, dimana operasi dan logic dilakukan di 'ViewModel' nya (jika di iOS), untuk yg flutter ini dilakukan di data 'provider' tersebut
4. Beberapa tantangan yang dihadapi:
- Menerapkan pola reactive programming dan state management dengan 'provider' nya, karena sebelumnya menggunakan pendekatan imperative di UIKit (iOS)
- Melakukan komunikasi data dan fungsi antar widget yang sudah dipecah menjadi widget-widget tertentu yang lebih kecil pada suatu screen tertentu
5. Beberapa hal untuk meningkatkan performa:
- Widget yang tidak perlu ada perubahan dideklarasikan dengan static (const) karena tidak akan melakukan rebuild
- Screen atau widget yang tidak ada perubahan menggunakan stateless daripada stateful agar tidak melakukan rebuild dan tidak merespon ketika ada state yang berubah
