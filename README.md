
# CafeHunt

Aplikasi mobile berbasis Flutter untuk membantu pengguna menemukan informasi cafe dan menyimpan cafe yang ingin dikunjungi ke dalam Wishlist.

## Identitas Pengembang

- **Nama:** Gena Anggarani
- **NIM:** 2415051038
- **Kelas:** PTI 5 B
- **Program Studi:** Pendidikan Teknik Informatika

## Deskripsi Aplikasi

CafeHunt merupakan aplikasi pencarian cafe yang menampilkan informasi tempat berdasarkan data OpenStreetMap melalui Overpass API. Pengguna dapat melihat daftar cafe, membuka detail cafe, dan menyimpan tempat yang ingin dikunjungi ke dalam Wishlist.

Data Wishlist disimpan menggunakan Supabase sehingga pengguna dapat melakukan operasi tambah, lihat, ubah, dan hapus data.

## Fitur Aplikasi

1. **Home** – Menampilkan daftar cafe dari REST API.
2. **Cafe Detail** – Menampilkan informasi detail cafe yang dipilih.
3. **Profile** – Menampilkan halaman profil aplikasi.
4. **Wishlist** – Menampilkan daftar cafe yang disimpan.
5. **Wishlist Form** – Menambahkan dan mengubah data Wishlist.
6. **Wishlist Detail** – Menampilkan informasi detail cafe yang tersimpan.
7. **Responsive Layout** – Menyesuaikan tampilan berdasarkan ukuran layar.
8. **Loading dan Error State** – Menampilkan status ketika data sedang dimuat atau terjadi kesalahan.

## Teknologi yang Digunakan

- Flutter
- Dart
- Provider dan ChangeNotifier
- HTTP
- Overpass API
- Supabase
- PostgreSQL

## REST API

CafeHunt menggunakan Overpass API dari OpenStreetMap untuk mengambil data lokasi cafe.

- Metode: GET
- Endpoint utama: `https://maps.mail.ru/osm/tools/overpass/api/interpreter`
- Data response: JSON

Aplikasi mengolah response JSON menjadi objek model Cafe sebelum ditampilkan pada halaman Home.

## Backend Database

Menggunakan Supabase dengan tabel `wishlists`.

Data yang disimpan meliputi:
- id
- cafe_id
- cafe_name
- address
- latitude
- longitude
- created_at

Operasi database:
- Create: Menambahkan Wishlist.
- Read: Mengambil dan menampilkan Wishlist.
- Update: Mengubah data Wishlist.
- Delete: Menghapus Wishlist.

## Arsitektur Aplikasi

Aplikasi menggunakan pemisahan tanggung jawab sebagai berikut:

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

## Cara Menjalankan Aplikasi

1. Pastikan Flutter dan Dart sudah terpasang.
2. Clone repository:

```bash
git clone https://github.com/gena-collab/cafehunt.git
```

3. Masuk ke folder proyek:

```bash
cd cafehunt
```

4. Instal dependencies:

```bash
flutter pub get
```

5. Jalankan aplikasi dengan konfigurasi Supabase:

```bash
flutter run --dart-define=SUPABASE_URL=https://ltnuxvmknsplybovxcrt.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_PUBLISHABLE_KEY
```

Ganti `YOUR_SUPABASE_PUBLISHABLE_KEY` dengan publishable key milik proyek Supabase.

## Repository

https://github.com/gena-collab/cafehunt
