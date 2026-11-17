# Marketplace Katering --- Backend


## 1. Ringkasan Proyek

Marketplace Katering menghubungkan perusahaan katering (**Merchant**)
dengan kantor/perusahaan yang membutuhkan makanan (**Customer**).

Backend bertanggung jawab atas: - Registrasi, login, autentikasi, dan
otorisasi. - Pengelolaan profil Merchant dan Customer. - Pengelolaan
kategori dan menu. - Katalog Merchant dan menu. - Checkout dan
pengelolaan pesanan. - Perhitungan total pesanan di sisi server. -
Pembuatan dan pengelolaan invoice.

**Keputusan scope awal:** satu order hanya untuk satu Merchant.

## 2. Scope Backend

**Termasuk:** REST API JSON, registrasi/login, profil, CRUD kategori dan
menu, katalog, checkout, order items, perhitungan total di backend,
invoice, validasi request, role, dan kepemilikan data.

**Belum termasuk/belum ditetapkan:** payment gateway, tracking kurir,
multi-merchant checkout, notifikasi real-time, admin panel, pajak,
ongkir, diskon, refund, dan minimum order.

## 3. Technology Stack

  -----------------------------------------------------------------------
  Layer                   Teknologi               Keterangan
  ----------------------- ----------------------- -----------------------
  Backend                 Laravel                 REST API dan business
                                                  logic

  Language                PHP                     Versi ditetapkan saat
                                                  inisialisasi

  API                     REST / JSON             Kontrak komunikasi

  Database                PostgreSQL              Database relasional

  ORM                     Eloquent                Model dan relasi

  Authentication          JWT                     Access token dan
                                                  refresh flow

  JWT package             `tymon/jwt-auth`        Verifikasi
                          (usulan)                kompatibilitas
                                                  Laravel/PHP

  Authorization           Middleware + Policies   Role dan kepemilikan
                                                  data

  Validation              Form Request            Validasi input

  Response                API Resources           Format response

  Testing                 Pest / PHPUnit          Pengujian

  File storage            Laravel Filesystem      Logo dan foto menu
  -----------------------------------------------------------------------

Versi Laravel, PHP, PostgreSQL, dan kompatibilitas package JWT harus
dipastikan saat inisialisasi. Jangan mengunci versi package sebelum
memeriksa dukungan versi Laravel yang dipilih.

## 4. Arsitektur Backend

Backend menggunakan pendekatan **Modular Monolith**. Seluruh modul
berada dalam satu aplikasi Laravel dengan pemisahan tanggung jawab
berdasarkan domain bisnis.

``` mermaid
flowchart TB
    CLIENT["API Client"] --> API["Laravel REST API"]
    API --> AUTH["Authentication"]
    API --> PROFILE["Users & Profiles"]
    API --> CATALOG["Categories & Menu Catalog"]
    API --> ORDER["Order Management"]
    API --> INVOICE["Invoice Management"]
    SECURITY["Middleware, Policies & Validation"]
    SECURITY -. protects .-> AUTH
    SECURITY -. protects .-> PROFILE
    SECURITY -. protects .-> CATALOG
    SECURITY -. protects .-> ORDER
    SECURITY -. protects .-> INVOICE
    AUTH --> DB[("PostgreSQL")]
    PROFILE --> DB
    CATALOG --> DB
    ORDER --> DB
    INVOICE --> DB
    CATALOG --> STORAGE[("File Storage")]
```

Prinsip pemisahan kode: - **Controller:** menerima request dan
mengembalikan response. - **Form Request:** memvalidasi input. -
**Service:** menjalankan business logic. - **Model:** merepresentasikan
tabel dan relasi Eloquent. - **API Resource:** membentuk response API. -
**Middleware:** memeriksa autentikasi dan role. - **Policy:** memeriksa
hak akses terhadap resource. - **Migration:** sumber utama perubahan
skema database.

Hindari menempatkan seluruh business logic di Controller.

## 5. Desain Database

### 5.1 Prinsip `users` dan `profiles`

Identitas pengguna dan detail profil hanya menggunakan **dua tabel**: -
`users`: informasi autentikasi dan role. - `profiles`: informasi profil
untuk seluruh role.

Role pada `users` membedakan Merchant dan Customer. Setiap user memiliki
maksimal satu profile melalui relasi one-to-one. Tidak menggunakan tabel
`merchant_profiles` atau `customer_profiles`.

### 5.2 Tabel `users`

  Kolom                        Tipe/aturan      Keterangan
  ---------------------------- ---------------- ----------------------------
  `id`                         BIGINT PK        ID user
  `name`                       VARCHAR          Nama akun
  `email`                      VARCHAR UNIQUE   Email login
  `password`                   VARCHAR          Password hash
  `role`                       VARCHAR/ENUM     `merchant` atau `customer`
  `is_active`                  BOOLEAN          Status akun
  `created_at`, `updated_at`   TIMESTAMP        Audit waktu

### 5.3 Tabel `profiles`

  Kolom                        Tipe/aturan        Keterangan
  ---------------------------- ------------------ ------------------------
  `id`                         BIGINT PK          ID profile
  `user_id`                    BIGINT FK UNIQUE   Relasi ke `users.id`
  `company_name`               VARCHAR            Nama perusahaan/kantor
  `contact_person`             VARCHAR NULL       PIC perusahaan
  `phone`                      VARCHAR            Nomor kontak
  `address`                    TEXT               Alamat
  `city`                       VARCHAR            Kota
  `description`                TEXT NULL          Deskripsi sesuai role
  `logo`                       VARCHAR NULL       Path logo/foto
  `created_at`, `updated_at`   TIMESTAMP          Audit waktu

Kolom yang tidak relevan untuk role tertentu dapat bernilai `NULL`.
Validasi field wajib dilakukan berdasarkan role pada Form
Request/Service. Simpan path file pada database, bukan binary file.

### 5.4 ERD Identitas dan Profil

``` mermaid
erDiagram
    USERS ||--o| PROFILES : has
    USERS {
        bigint id PK
        string name
        string email UK
        string password
        string role
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }
    PROFILES {
        bigint id PK
        bigint user_id FK,UK
        string company_name
        string contact_person
        string phone
        text address
        string city
        text description
        string logo
        timestamp created_at
        timestamp updated_at
    }
```

### 5.5 Tabel bisnis

  -----------------------------------------------------------------------
  Tabel                               Kolom utama / fungsi
  ----------------------------------- -----------------------------------
  `categories`                        `id`, `name`, `type`

  `menus`                             `id`, `merchant_profile_id` FK ke
                                      `profiles.id`, `category_id`,
                                      `name`, `description`, `photo`,
                                      `price DECIMAL`, `is_available`

  `orders`                            `id`, `order_number`,
                                      `customer_profile_id` FK ke
                                      `profiles.id`,
                                      `merchant_profile_id` FK ke
                                      `profiles.id`, `delivery_date`,
                                      `delivery_address`, `subtotal`,
                                      `total`, `status`

  `order_items`                       `id`, `order_id`, `menu_id`,
                                      `menu_name` snapshot, `price`
                                      snapshot, `quantity`, `subtotal`

  `invoices`                          `id`, `order_id` UNIQUE,
                                      `invoice_number` UNIQUE,
                                      `invoice_date`, `subtotal`,
                                      `total`, `status`
  -----------------------------------------------------------------------

`merchant_categories` belum menjadi tabel wajib. Kebutuhannya perlu
dikonfirmasi; kategori Merchant dapat diturunkan dari kategori menu
apabila sesuai aturan bisnis.

### 5.6 ERD Relasi Bisnis

``` mermaid
erDiagram
    USERS ||--o| PROFILES : has
    PROFILES ||--o{ MENUS : owns_as_merchant
    CATEGORIES ||--o{ MENUS : categorizes
    PROFILES ||--o{ ORDERS : places_as_customer
    PROFILES ||--o{ ORDERS : receives_as_merchant
    ORDERS ||--|{ ORDER_ITEMS : contains
    MENUS ||--o{ ORDER_ITEMS : referenced_by
    ORDERS ||--o| INVOICES : generates
```

`menus.merchant_profile_id`, `orders.customer_profile_id`, dan
`orders.merchant_profile_id` mengarah ke `profiles.id`. Service dan
Policy harus memastikan role profile sesuai dengan operasi yang
dilakukan.

### 5.7 Integritas Database

1.  `profiles.user_id` memiliki foreign key dan UNIQUE constraint agar
    satu user memiliki maksimal satu profile.
2.  Role `merchant` atau `customer` disimpan pada `users`.
3.  Service memastikan profile dibuat dan field wajib diisi sesuai role.
4.  Gunakan `DECIMAL` untuk nilai uang, bukan floating point.
5.  `order_items` menyimpan snapshot nama menu dan harga agar histori
    transaksi tidak berubah.
6.  Satu order hanya untuk satu Merchant.
7.  Satu order menghasilkan maksimal satu invoice (`UNIQUE(order_id)`).
8.  Gunakan foreign key, unique constraint, index, dan timestamps.
9.  Pertimbangkan soft delete untuk menu.
10. Migration Laravel menjadi sumber utama perubahan skema database.

## 6. Authentication & Authorization

### 6.1 Authentication

-   Login memvalidasi email/password dan menerbitkan JWT.
-   Password disimpan menggunakan Laravel Hash (bcrypt/Argon2).
-   Usulan masa berlaku: access token 15 menit, refresh token 7 hari.
-   Refresh token perlu mendukung rotation dan revocation.
-   Endpoint privat memverifikasi signature, algoritma yang diizinkan,
    expiry, dan claims relevan.
-   Detail implementasi token mengikuti kemampuan package JWT yang
    dipilih.

Untuk browser SPA: access token disimpan di memory; refresh token
menggunakan cookie `HttpOnly`, `Secure`, `SameSite` dengan
rotation/revocation; terapkan CSRF protection sesuai pola cookie; jangan
simpan refresh token di `localStorage`; HTTPS wajib di production.

### 6.2 Authorization

Authentication memastikan identitas pengguna, sedangkan authorization
menentukan akses terhadap fitur dan data.

Gunakan middleware untuk autentikasi/pemeriksaan role, Policy untuk
kepemilikan resource, dan Service untuk validasi aturan bisnis lintas
model.

Aturan akses: - Hanya Merchant yang dapat mengelola menu miliknya. -
Merchant hanya dapat melihat dan memproses order yang ditujukan
kepadanya. - Customer hanya dapat melihat order dan invoice miliknya. -
Profile Merchant harus berasal dari user dengan role `merchant`. -
Profile Customer harus berasal dari user dengan role `customer`.

### 6.3 Endpoint Auth

  Method   Endpoint                  Fungsi
  -------- ------------------------- ------------------------------
  POST     `/api/v1/auth/register`   Registrasi
  POST     `/api/v1/auth/login`      Login
  POST     `/api/v1/auth/refresh`    Refresh access token
  POST     `/api/v1/auth/logout`     Revoke token/refresh session
  GET      `/api/v1/auth/me`         User aktif

## 7. Modul dan Endpoint Utama

Seluruh endpoint menggunakan prefix `/api/v1`.

  -----------------------------------------------------------------------
  Area                                Endpoint inti
  ----------------------------------- -----------------------------------
  Profile                             `GET/PUT /profile`

  Merchant menus                      CRUD `/merchant/menus`

  Merchant orders                     `GET /merchant/orders`, detail, dan
                                      update status

  Marketplace                         `GET /merchants`,
                                      `/merchants/{id}`, `/menus`,
                                      `/categories`

  Customer orders                     `POST /orders`, `GET /orders`,
                                      detail

  Invoice                             `GET /invoices`, detail, download
  -----------------------------------------------------------------------

Endpoint profile mengembalikan profile user yang sedang login. Endpoint
Merchant/Customer membatasi akses berdasarkan `users.role` dan profile
pemilik.

## 8. Business Flow

### 8.1 Registrasi dan Login

``` mermaid
flowchart TD
    A["User membuka aplikasi"] --> B["Pilih Register"]
    B --> C{"Pilih role"}
    C -->|Merchant| D["Isi akun dan data katering"]
    C -->|Customer| E["Isi akun dan data kantor"]
    D --> F["Validasi berdasarkan role"]
    E --> F
    F --> G["Hash password"]
    G --> H["DB transaction: simpan user dan satu profile"]
    H --> I["Login"]
    I --> J["Validasi kredensial"]
    J --> K["Terbitkan JWT"]
    K --> L["Akses sesuai role"]
```

Penyimpanan `users` dan `profiles` dilakukan dalam satu database
transaction agar tidak terbentuk akun tanpa profile akibat proses gagal.

### 8.2 Merchant Mengelola Menu

``` mermaid
flowchart TD
    A["Merchant login"] --> B["Menu management API"]
    B --> C["Tambah / edit / hapus menu"]
    C --> D["Validasi role dan kepemilikan profile"]
    D --> E["Upload foto jika ada"]
    E --> F["Simpan menu dengan merchant_profile_id"]
    F --> G["Menu aktif tampil di katalog"]
```

### 8.3 Customer Checkout

``` mermaid
flowchart TD
    A["Customer login"] --> B["Cari Merchant"]
    B --> C["Pilih satu Merchant"]
    C --> D["Pilih menu dan jumlah"]
    D --> E["Tanggal dan alamat pengiriman"]
    E --> F["Checkout API"]
    F --> G["Validasi role, menu, Merchant, dan tanggal"]
    G --> H{"Valid?"}
    H -->|Tidak| I["Kembalikan validation error"]
    H -->|Ya| J["DB transaction"]
    J --> K["Simpan order"]
    K --> L["Simpan order items dan snapshot harga"]
    L --> M["Hitung total di backend"]
    M --> N["Generate invoice"]
    N --> O["Commit transaction"]
    O --> P["Order dan invoice tersedia"]
```

### 8.4 Status Order

``` mermaid
stateDiagram-v2
    [*] --> pending
    pending --> confirmed
    pending --> cancelled
    confirmed --> preparing
    confirmed --> cancelled
    preparing --> delivered
    delivered --> [*]
    cancelled --> [*]
```

Status usulan: `pending`, `confirmed`, `preparing`, `delivered`,
`cancelled`. Transisi dan kebijakan pembatalan perlu dikonfirmasi.

## 9. Business Rules

1.  Satu order hanya terkait dengan satu Merchant.
2.  Semua menu dalam satu order harus berasal dari Merchant yang sama.
3.  Harga diambil dari database; total dari frontend tidak dipercaya.
4.  Simpan snapshot nama menu dan harga di order item.
5.  Order, items, dan invoice dibuat dalam satu database transaction.
6.  Jika salah satu proses gagal, rollback seluruh transaksi.
7.  Invoice hanya dapat diakses Customer/Merchant yang terkait.
8.  Merchant hanya mengelola menu dan order miliknya.
9.  Customer hanya melihat order dan invoice miliknya.
10. Payment gateway belum termasuk scope awal.

## 10. Struktur Folder Backend Laravel

Struktur berikut merupakan usulan dan dapat disesuaikan dengan versi
Laravel yang digunakan.

``` text
backend/
├── app/
│   ├── Enums/
│   │   ├── UserRole.php
│   │   └── OrderStatus.php
│   ├── Http/
│   │   ├── Controllers/Api/
│   │   ├── Middleware/
│   │   ├── Requests/
│   │   └── Resources/
│   ├── Models/
│   │   ├── User.php
│   │   ├── Profile.php
│   │   ├── Category.php
│   │   ├── Menu.php
│   │   ├── Order.php
│   │   ├── OrderItem.php
│   │   └── Invoice.php
│   ├── Policies/
│   └── Services/
│       ├── AuthService.php
│       ├── ProfileService.php
│       ├── MenuService.php
│       ├── OrderService.php
│       └── InvoiceService.php
├── database/
│   ├── factories/
│   ├── migrations/
│   └── seeders/
├── routes/
│   └── api.php
├── tests/
│   ├── Feature/
│   └── Unit/
├── .env.example
├── composer.json
└── README.md
```

  Komponen            Tanggung jawab
  ------------------- -----------------------------------
  `Enums`             Nilai role dan status terstandar
  `Controllers/Api`   Handler endpoint API
  `Middleware`        Autentikasi dan pemeriksaan role
  `Requests`          Validasi input
  `Resources`         Format response JSON
  `Models`            Struktur data dan relasi Eloquent
  `Policies`          Hak akses resource
  `Services`          Business logic
  `Migrations`        Perubahan skema database
  `Seeders`           Data awal
  `Factories`         Data untuk pengujian
  `tests`             Unit test dan feature test

## 11. Standar Implementasi API

### 11.1 API Versioning

Gunakan prefix `/api/v1`. Perubahan kontrak API yang tidak kompatibel
dapat dirilis melalui versi berikutnya.

### 11.2 Validasi dan Response

-   Gunakan Form Request untuk validasi input.
-   Gunakan API Resource untuk format response.
-   Gunakan HTTP status code sesuai hasil operasi.
-   Jangan mengembalikan password, hash, token rahasia, atau data
    internal yang tidak diperlukan.
-   Pesan error harus konsisten dan tidak membocorkan detail internal
    server.

Contoh response sukses:

``` json
{
  "success": true,
  "message": "Data berhasil diproses",
  "data": {}
}
```

Contoh response validasi:

``` json
{
  "success": false,
  "message": "Validasi gagal",
  "errors": {
    "email": ["Email wajib diisi."]
  }
}
```

Bentuk response tersebut merupakan konvensi proyek dan perlu diterapkan
konsisten pada seluruh endpoint.

### 11.3 Database Transaction

Gunakan `DB::transaction()` untuk proses yang melibatkan beberapa
penulisan data dan harus berhasil atau gagal secara keseluruhan,
khususnya checkout dan pembuatan invoice.

### 11.4 File Upload

-   Validasi tipe dan ukuran file.
-   Simpan file melalui Laravel Filesystem.
-   Simpan path file pada kolom `logo` atau `photo`.
-   Jangan menyimpan binary file langsung pada tabel profil/menu.
-   Pastikan nama file dan akses penyimpanan ditangani dengan aman.

## 12. Instalasi dan Menjalankan Backend

Perintah berikut merupakan alur awal. Sesuaikan versi PHP, ekstensi PHP,
Composer, PostgreSQL, dan package JWT dengan environment proyek.

### 12.1 Persiapan

Pastikan tersedia: - PHP sesuai persyaratan versi Laravel yang
dipilih. - Composer. - PostgreSQL. - Ekstensi PHP yang dibutuhkan
Laravel dan driver PostgreSQL. - Git.

### 12.2 Clone Repository

``` bash
git clone <repository-url>
cd marketplace-katering/backend
```

### 12.3 Install Dependency

``` bash
composer install
```

### 12.4 Konfigurasi Environment

``` bash
cp .env.example .env
php artisan key:generate
```

Atur koneksi PostgreSQL pada `.env`:

``` dotenv
APP_NAME="Marketplace Katering"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost

DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=marketplace_katering
DB_USERNAME=postgres
DB_PASSWORD=
```

Sesuaikan nama database, username, dan password dengan konfigurasi
lokal. Jangan commit `.env` ke repository.

### 12.5 Migration dan Seeder

``` bash
php artisan migrate
php artisan db:seed
```

Jika database lokal memang perlu dibangun ulang dan seluruh datanya
boleh dihapus:

``` bash
php artisan migrate:fresh --seed
```

**Peringatan:** `migrate:fresh` menghapus seluruh tabel sebelum
menjalankan migration kembali. Jangan gunakan pada database yang berisi
data penting.

### 12.6 Menjalankan Server

``` bash
php artisan serve
```

API lokal secara default tersedia di `http://127.0.0.1:8000`.

## 13. Testing

Jalankan test:

``` bash
php artisan test
```

Cakupan test minimum:

**Authentication** - Registrasi Merchant dan Customer. - Validasi email
unik. - Password tersimpan dalam bentuk hash. - Login berhasil dan
gagal. - Refresh dan logout/revocation token.

**Profile dan Authorization** - Satu user memiliki maksimal satu
profile. - Profile dibuat sesuai role. - User tidak dapat mengakses
profile milik user lain. - Role yang tidak sesuai ditolak.

**Menu dan Catalog** - Merchant dapat membuat dan memperbarui menu
miliknya. - Merchant tidak dapat mengubah menu Merchant lain. - Katalog
hanya menampilkan data yang tersedia sesuai aturan.

**Order dan Invoice** - Customer hanya dapat checkout untuk satu
Merchant. - Semua menu pada order berasal dari Merchant yang sama. -
Harga dan total dihitung ulang di backend. - Snapshot harga tersimpan
pada order items. - Kegagalan proses menyebabkan rollback. - Invoice
hanya dapat diakses pihak terkait.

## 14. Security Checklist

-   [ ] Password menggunakan Laravel Hash.
-   [ ] Secret dan credential disimpan pada environment.
-   [ ] `.env` tidak di-commit.
-   [ ] Endpoint privat dilindungi autentikasi.
-   [ ] Role middleware diterapkan pada endpoint yang sesuai.
-   [ ] Policy memeriksa kepemilikan resource.
-   [ ] Validasi request menggunakan Form Request.
-   [ ] Upload file memvalidasi MIME type dan ukuran.
-   [ ] Token memiliki expiry dan mekanisme refresh/revocation.
-   [ ] HTTPS digunakan di production.
-   [ ] Refresh token tidak disimpan di `localStorage`.
-   [ ] Checkout menggunakan database transaction.
-   [ ] Total transaksi dihitung ulang di backend.
-   [ ] Error production tidak membocorkan stack trace atau secret.

## 15. Git Branching Workflow

Hierarki branch:

``` text
main
  └── staging
        └── ondev
              └── onfeature/<nama-fitur>
```

  Branch          Fungsi
  --------------- -------------------------------------
  `main`          Production / versi stabil
  `staging`       Kandidat release dan UAT
  `ondev`         Integrasi development
  `onfeature/*`   Fitur spesifik, dibuat dari `ondev`

Alur Pull Request: 1. `onfeature/*` → `ondev` 2. `ondev` → `staging` 3.
`staging` → `main`

Hindari commit langsung ke branch utama. Gunakan Pull Request, review,
dan test sebelum merge.

Contoh nama branch: - `onfeature/auth-jwt` - `onfeature/user-profile` -
`onfeature/merchant-menu` - `onfeature/order-checkout` -
`onfeature/invoice-generation`

Contoh membuat feature branch:

``` bash
git checkout ondev
git pull origin ondev
git checkout -b onfeature/auth-jwt

git add .
git commit -m "feat(auth): implement JWT authentication"
git push -u origin onfeature/auth-jwt
```

## 16. Tahapan Implementasi Backend

  Tahap   Pekerjaan                              Output
  ------- -------------------------------------- -----------------------------
  1       Inisialisasi Laravel dan environment   Backend dapat dijalankan
  2       Migration, model, relasi, seeder       Fondasi database
  3       JWT dan role authorization             Authentication API
  4       Profile                                Profile API
  5       Kategori dan menu                      Catalog/Merchant API
  6       Marketplace query                      Catalog API
  7       Order dan order items                  Checkout API
  8       Invoice                                Invoice API
  9       Testing dan security review            Backend siap diintegrasikan

## 17. Keputusan Terbuka

  -----------------------------------------------------------------------
  Topik                               Status
  ----------------------------------- -----------------------------------
  Versi Laravel/PHP                   Pilih versi stabil dan cocok dengan
                                      environment

  JWT package                         `tymon/jwt-auth` masih usulan;
                                      verifikasi dukungan refresh/revoke

  Kategori                            Konfirmasi kategori Merchant dan
                                      menu

  Pembayaran                          Di luar scope awal

  Pembatalan order                    Aturan transisi perlu ditetapkan

  Ongkir/pajak/diskon                 Belum ditentukan

  Admin dan deployment                Ditentukan kemudian
  -----------------------------------------------------------------------

## 18. Definition of Done --- Fondasi Backend

-   [ ] Laravel REST API dapat dijalankan.
-   [ ] Koneksi PostgreSQL berhasil.
-   [ ] Migration dapat dijalankan dari database kosong.
-   [ ] Tabel `users` dan `profiles` menerapkan relasi one-to-one.
-   [ ] Registrasi Merchant dan Customer membuat satu profile sesuai
    role.
-   [ ] Model dan relasi Eloquent tervalidasi.
-   [ ] Login menghasilkan JWT yang valid.
-   [ ] Endpoint privat terlindungi.
-   [ ] Role dan ownership authorization berfungsi.
-   [ ] CRUD kategori/menu berjalan sesuai hak akses.
-   [ ] Checkout menghitung total di backend dan menggunakan
    transaction.
-   [ ] Invoice terhubung dengan order.
-   [ ] Test utama berjalan.
-   [ ] `.env.example` tersedia tanpa secret.
-   [ ] Dokumentasi backend diperbarui.

------------------------------------------------------------------------

**Dokumen baseline backend v0.3.** Desain identitas/profil tetap
menggunakan dua tabel (`users` dan `profiles`) sesuai keputusan v0.2.
README ini membatasi dokumentasi pada backend Laravel dan mempertahankan
scope bisnis awal.
