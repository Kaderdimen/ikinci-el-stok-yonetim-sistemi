-- Ornek veri (raporlari denemek icin). 01_tablolari_olustur.sql calistirildiktan sonra calistirin.

INSERT INTO Kategori VALUES (1, N'Telefon'), (2, N'Bilgisayar'), (3, N'Mobilya'), (4, N'Beyaz Eşya');

INSERT INTO Musteri VALUES
 (1, N'Ali Yılmaz',    N'5550000001'),
 (2, N'Ayşe Kaya',     N'5550000002'),
 (3, N'Mehmet Demir',  N'5550000003');

INSERT INTO Urun VALUES
 (1, 1, N'Samsung', N'A52',       N'S1', N'İyi',  N'Satıldı'),
 (2, 2, N'Lenovo',  N'T480',      N'S2', N'Orta', N'Stokta'),
 (3, 3, N'-',       N'Koltuk',    N'S3', N'İyi',  N'Satıldı'),
 (4, 4, N'Arçelik', N'Buzdolabı', N'S4', N'İyi',  N'Stokta'),
 (5, 1, N'Apple',   N'iPhone 11', N'S5', N'İyi',  N'Satıldı');

INSERT INTO Alim VALUES
 (1, 1, 1, 4000, '2026-10-01'),
 (2, 2, 2, 9000, '2026-10-03'),
 (3, 3, 3, 2500, '2026-10-05'),
 (4, 4, 1, 6000, '2026-11-02'),
 (5, 5, 2, 8000, '2026-11-04');

INSERT INTO Satis VALUES
 (1, 1, 2,  5000, '2026-10-10', N'Nakit'),
 (2, 3, 3,  3200, '2026-10-20', N'Kart'),
 (3, 5, 1, 10500, '2026-11-15', N'Nakit');

INSERT INTO KasaHareketi VALUES
 (1, '2026-10-01',  4000, N'Çıkış', 1,    NULL),
 (2, '2026-10-03',  9000, N'Çıkış', 2,    NULL),
 (3, '2026-10-05',  2500, N'Çıkış', 3,    NULL),
 (4, '2026-10-10',  5000, N'Giriş', NULL, 1),
 (5, '2026-10-20',  3200, N'Giriş', NULL, 2),
 (6, '2026-11-02',  6000, N'Çıkış', 4,    NULL),
 (7, '2026-11-04',  8000, N'Çıkış', 5,    NULL),
 (8, '2026-11-15', 10500, N'Giriş', NULL, 3);
