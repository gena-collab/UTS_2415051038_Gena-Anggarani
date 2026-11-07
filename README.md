
# CafeHunt

Aplikasi mobile berbasis Flutter untuk membantu pengguna menemukan informasi cafe dan menyimpan cafe yang ingin dikunjungi ke dalam Wishlist.

## Identitas Pengembang

- **Nama:** Gena Anggarani
- **NIM:** 2415051038
- **Kelas:** PTI 5 B
- **Program Studi:** Pendidikan Teknik Informatika

## Deskripsi Aplikasi

CafeHunt merupakan aplikasi pencarian cafe yang memanfaatkan data OpenStreetMap melalui Overpass API. Pengguna dapat melihat daftar cafe, membuka detail informasi cafe, serta menyimpan tempat yang ingin dikunjungi ke dalam Wishlist.

Data Wishlist dikelola menggunakan Supabase sehingga pengguna dapat melakukan operasi tambah, lihat, ubah, dan hapus data.

## Fitur Aplikasi

1. **Home:** Menampilkan daftar cafe berdasarkan data REST API.
2. **Cafe Detail:** Menampilkan informasi detail cafe yang dipilih.
3. **Profile:** Menampilkan halaman profil aplikasi.
4. **Wishlist:** Menampilkan daftar cafe yang telah disimpan.
5. **Wishlist Form:** Menambahkan dan mengubah data Wishlist.
6. **Wishlist Detail:** Menampilkan informasi detail cafe yang tersimpan.
7. **Responsive Layout:** Menyesuaikan tata letak berdasarkan ukuran layar.
8. **Loading dan Error State:** Menampilkan status pemuatan data dan informasi ketika terjadi kesalahan.

## Teknologi yang Digunakan

- Flutter
- Dart
- Provider dan ChangeNotifier
- HTTP
- OpenStreetMap
- Overpass API
- Supabase
- PostgreSQL

## REST API

CafeHunt menggunakan Overpass API dari OpenStreetMap untuk mengambil data lokasi cafe.

- **Metode:** GET
- **Endpoint utama:** `https://maps.mail.ru/osm/tools/overpass/api/interpreter`
- **Format response:** JSON

Data JSON diproses menjadi objek model Cafe sebelum ditampilkan pada halaman aplikasi.

## Backend Database

CafeHunt menggunakan Supabase sebagai backend database dengan tabel `wishlists`.

Data yang disimpan meliputi:

- `id`
- `cafe_id`
- `cafe_name`
- `address`
- `latitude`
- `longitude`
- `created_at`

Operasi database yang diterapkan:

- **Create:** Menambahkan cafe ke Wishlist.
- **Read:** Mengambil dan menampilkan data Wishlist.
- **Update:** Mengubah data Wishlist.
- **Delete:** Menghapus data Wishlist.

## Arsitektur Aplikasi

Aplikasi menerapkan pemisahan tanggung jawab dengan susunan:

```text
UI (Screens & Widgets)
        |
        v
Provider (ChangeNotifier)
        |
        v
Repository
        |
        v
Service
        |
        v
REST API / Supabase
```

Penjelasan:

- **UI:** Menampilkan halaman dan komponen aplikasi.
- **Provider:** Mengelola state dan memperbarui tampilan.
- **Repository:** Menjadi penghubung antara Provider dan Service.
- **Service:** Menangani komunikasi dengan REST API dan Supabase.

## Struktur Folder

```text
lib/
├── config/
├── models/
├── providers/
├── repositories/
├── screens/
├── services/
├── utils/
├── widgets/
└── main.dart
```

## Dokumentasi Tampilan

Screenshot aplikasi dilampirkan pada folder `screenshots/` sebagai bukti implementasi fitur dan tampilan CafeHunt.

## Cara Menjalankan Aplikasi

### Persyaratan

- Flutter SDK
- Dart SDK
- Android Studio atau perangkat Android
- Akun dan konfigurasi proyek Supabase

### Langkah Menjalankan

1. Clone repository:

```bash
git clone https://github.com/gena-collab/cafehunt.git
```

2. Masuk ke folder proyek:

```bash
cd cafehunt
```

3. Instal dependencies:

```bash
flutter pub get
```

4. Jalankan aplikasi dengan konfigurasi Supabase:

```bash
flutter run --dart-define=SUPABASE_URL=https://ltnuxvmknsplybovxcrt.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_PUBLISHABLE_KEY
```

Ganti `YOUR_SUPABASE_PUBLISHABLE_KEY` dengan publishable key dari proyek Supabase.

### Membuat APK Release

```bash
flutter build apk --release --dart-define=SUPABASE_URL=https://ltnuxvmknsplybovxcrt.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_PUBLISHABLE_KEY
```

File APK tersedia pada:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Repository

https://github.com/gena-collab/cafehunt
