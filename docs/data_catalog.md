## Data Catalog Pada Gold Layer

Gold Layer merepresentasikan data di tingkat bisnis, yang diatur untuk mendukung kasus penggunaan analitis dan pelaporan. Lapisan ini terdiri dari tabel dimensi dan tabel fakta yang dirancang untuk menangkap metrik bisnis tertentu.

1. Gold Dim_Customers

| Kolom  | Type Data | Keterangan    |
|-------|------|---------|
| customer_key  | INT (PK)   | Surrogate key |
| customer_id   | INT   | Natural key dari CRM |
| full_name  | NVARCHAR   | Nama lengkap customer |
| email  | NVARCHAR   | Email customer|
| phone  | NVARCHAR   | Nomor telepon customer |
| user_type  | NVARCHAR   | Jenis user (misal: Mahasiswa, Dosen) |
| account_status  | NVARCHAR   | Status akun (aktif/nonaktif) |

2. Gold Dim_vehicle

| Kolom  | Type Data | Keterangan    |
|-------|------|---------|
| vehicle_key  | INT (PK)   | Surrogate key |
| vehicle_id   | INT   | Natural key |
| vehicle_type  | NVARCHAR   | Merek Motor |
| brand  | NVARCHAR   | Brand Motor |
| plate_number  | NVARCHAR   | No. plat kendaraan |
| driver_id | INT   | FK driver_id |
| driver_name  | NVARCHAR   | Nama Driver |
| driver_phone  | NVARCHAR   | Nomor telepon driver |

3. Gold dim_driver

| Kolom  | Type Data | Keterangan    |
|-------|------|---------|
| driver_key  | INT (PK)   | Surrogate key |
| driver_id   | INT   | Natural key |
| full_name  | NVARCHAR   | Nama lengkap driver |
| phone  | NVARCHAR   | nomor telepon driver |
| license_number  | NVARCHAR   | Nomor sim |
| status_driver | NVARCHAR   | status driver (suspended, inactive, active) |


4. Gold dim_location

| Kolom  | Type Data | Keterangan    |
|-------|------|---------|
| location_key  | INT (PK)   | Surrogate key |
| location_id   | INT   | Natural key |
| location_name  | NVARCHAR   | Nama lokasi |
| latitude  | DECIMAL(9,6)    | koordinat lintang |
| longitude  | DECIMAL(9,6)   | koordinat bujur |

5. Gold dim_time

| Kolom  | Type Data | Keterangan    |
|-------|------|---------|
| time_key  | INT (PK)   | Surrogate key |
| time_id   | INT   | Natural key |
| full_date  | DATE   | tanggal lengkap |
| day_num  | INT    | hari |
| month_num  | INT   | bulan |
| year_num  | INT   | tahun |
| weekday_name  | NVARCHAR   | nama-hari (senin-minggu) |

6. Gold fact_trip

| Kolom  | Type Data | Keterangan    |
|-------|------|---------|
| trip_id  | INT (PK)   | Primary key |
| customer_id   | INT (FK)   | FK ke dim_customer |
| driver_id  | INT (FK)   | FK ke dim_driver |
| vehicle_id  | INT (FK)   | FK ke dim_vehicle |
| origin_location_id | INT   | id lokasi |
| origin_location_name  | NVARCHAR   | nama lokasi |
| destination_location_id  | INT   | id lokasi destinasi |
| destination_location_name  | NVARCHAR   | nama destinasi lokasi |
| time_id  | INT (FK)  | nama-hari (senin-minggu) |
| trip_date  | DATE   | tanggal perjalanan |
| duration_minutes  | INT   | durasi perjalanan dalam menit |
| distance_km  | DECIMAL(5,2)   | jarak perjalanan dalam km |

6. Gold fact_payment

| Kolom  | Type Data | Keterangan    |
|-------|------|---------|
| transaction_id  | INT (PK)   | Primary key |
| customer_id   | INT (FK)   | FK ke dim_customer |
| customer_name  | NVARCHAR   | nama customer |
| payment_method  | NVARCHAR   | metode pembayaran (cash, e-wallet, credit card) |
| amount | DECIMAL(10,2)   | jumlah uang yang dibayarkan |
| promo_id  | INT   | id promo |
| time_id  | INT (FK)  | FK ke dim_time |