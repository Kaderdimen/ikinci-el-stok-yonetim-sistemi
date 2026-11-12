-- 6. Hafta: Ornek veri (tamamen uydurmadir; gercek kisisel bilgi icermez)
-- Once 00 ve 01 numarali dosyalar calistirilmalidir.
-- Kimlik numaralari bilincli olarak bos birakilmistir.
-- Birincil anahtarlar IDENTITY oldugu icin id kolonlari yazilmaz; satirlar id sirasiyla eklenir.
-- Kayitlarin birbirine baglantisi (FK) bu sira varsayilarak yazilmistir; dosya bos tablolara bir kez calistirilmalidir.

USE IkinciElDB;

IF EXISTS (SELECT 1 FROM Kullanici)
BEGIN
    PRINT N'Tablolarda zaten veri var. Once 01_tablolari_olustur.sql calistirin.';
    RETURN;
END;

INSERT INTO Kullanici (ad_soyad, kullanici_adi, parola_hash, rol) VALUES
    (N'Dükkân Sahibi', N'sahip', N'ORNEK_HASH_1', N'Sahip'),
    (N'Dükkân Çalışanı', N'personel', N'ORNEK_HASH_2', N'Personel');

INSERT INTO Kategori (kategori_adi) VALUES
    (N'Telefon'),
    (N'Bilgisayar'),
    (N'Mobilya'),
    (N'Beyaz Eşya'),
    (N'Televizyon'),
    (N'Küçük Ev Aletleri');

INSERT INTO Musteri (ad_soyad, telefon, adres, kimlik_no) VALUES
    (N'Ali Yılmaz', N'5550000001', N'Çankaya, Ankara', NULL),
    (N'Ayşe Kaya', N'5550000002', N'Keçiören, Ankara', NULL),
    (N'Mehmet Demir', N'5550000003', N'Yenimahalle, Ankara', NULL),
    (N'Fatma Çelik', N'5550000004', N'Mamak, Ankara', NULL),
    (N'Mustafa Şahin', N'5550000005', N'Etimesgut, Ankara', NULL),
    (N'Zeynep Arslan', N'5550000006', N'Çankaya, Ankara', NULL),
    (N'Hasan Öztürk', N'5550000007', N'Sincan, Ankara', NULL),
    (N'Emine Aydın', N'5550000008', N'Altındağ, Ankara', NULL),
    (N'İbrahim Koç', N'5550000009', N'Pursaklar, Ankara', NULL),
    (N'Hatice Polat', N'5550000010', N'Keçiören, Ankara', NULL),
    (N'Ahmet Güneş', N'5550000011', N'Yenimahalle, Ankara', NULL),
    (N'Elif Yıldız', N'5550000012', N'Çankaya, Ankara', NULL);

INSERT INTO Urun (kategori_id, marka, model, seri_no, durum, aciklama, stok_durumu) VALUES
    (1, N'Samsung', N'Galaxy A52', N'SN-1001', N'İyi', NULL, N'Satıldı'),
    (1, N'Apple', N'iPhone 11', N'SN-1002', N'İyi', NULL, N'Satıldı'),
    (1, N'Xiaomi', N'Redmi Note 10', N'SN-1003', N'Orta', NULL, N'Satıldı'),
    (1, N'Apple', N'iPhone 12', N'SN-1004', N'Çok İyi', NULL, N'Satıldı'),
    (1, N'Samsung', N'Galaxy S21', N'SN-1005', N'İyi', NULL, N'Stokta'),
    (1, N'Huawei', N'P30', N'SN-1006', N'Orta', NULL, N'Satıldı'),
    (2, N'Lenovo', N'ThinkPad T480', N'SN-1007', N'İyi', NULL, N'Satıldı'),
    (2, N'HP', N'Pavilion 15', N'SN-1008', N'Orta', NULL, N'Satıldı'),
    (2, N'Asus', N'VivoBook 15', N'SN-1009', N'İyi', NULL, N'Stokta'),
    (2, N'Apple', N'MacBook Air 2017', N'SN-1010', N'Orta', NULL, N'Satıldı'),
    (2, N'Dell', N'Latitude 5490', N'SN-1011', N'İyi', NULL, N'Satıldı'),
    (3, N'-', N'Koltuk Takımı', NULL, N'İyi', NULL, N'Satıldı'),
    (3, N'-', N'Yemek Masası', NULL, N'Orta', NULL, N'Satıldı'),
    (3, N'-', N'Gardırop', NULL, N'İyi', NULL, N'Satıldı'),
    (3, N'-', N'TV Ünitesi', NULL, N'İyi', NULL, N'Stokta'),
    (4, N'Arçelik', N'Buzdolabı', N'SN-1016', N'İyi', NULL, N'Satıldı'),
    (4, N'Bosch', N'Çamaşır Makinesi', N'SN-1017', N'İyi', NULL, N'Stokta'),
    (4, N'Beko', N'Bulaşık Makinesi', N'SN-1018', N'Orta', NULL, N'Stokta'),
    (4, N'Vestel', N'Ankastre Fırın', N'SN-1019', N'İyi', NULL, N'Satıldı'),
    (5, N'Samsung', N'43 inç LED TV', N'SN-1020', N'İyi', NULL, N'Stokta'),
    (5, N'LG', N'50 inç Smart TV', N'SN-1021', N'Çok İyi', NULL, N'Satıldı'),
    (5, N'Vestel', N'32 inç TV', N'SN-1022', N'Orta', NULL, N'Stokta'),
    (6, N'Philips', N'Süpürge', N'SN-1023', N'İyi', NULL, N'Satıldı'),
    (6, N'Tefal', N'Airfryer', N'SN-1024', N'İyi', NULL, N'Satıldı');

INSERT INTO Alim (urun_id, satici_musteri_id, kaydeden_kullanici_id, alis_fiyati, alis_tarihi, notlar) VALUES
    (1, 5, 1, 3900, '2026-10-27', NULL),
    (2, 11, 2, 7350, '2026-10-11', NULL),
    (3, 1, 1, 3200, '2026-09-10', NULL),
    (4, 5, 1, 10450, '2026-09-19', NULL),
    (5, 9, 1, 8300, '2026-10-05', NULL),
    (6, 12, 1, 3100, '2026-09-26', NULL),
    (7, 2, 1, 11900, '2026-10-11', NULL),
    (8, 11, 1, 6750, '2026-10-25', NULL),
    (9, 8, 2, 9650, '2026-11-02', NULL),
    (10, 12, 2, 11800, '2026-09-17', NULL),
    (11, 3, 1, 8750, '2026-09-22', NULL),
    (12, 8, 1, 4950, '2026-10-31', NULL),
    (13, 1, 1, 2700, '2026-10-07', NULL),
    (14, 7, 1, 3850, '2026-10-28', NULL),
    (15, 1, 1, 1550, '2026-10-05', NULL),
    (16, 6, 2, 6200, '2026-09-09', NULL),
    (17, 8, 1, 6500, '2026-09-28', NULL),
    (18, 7, 2, 6950, '2026-11-03', NULL),
    (19, 1, 1, 3350, '2026-09-29', NULL),
    (20, 5, 1, 6000, '2026-11-01', NULL),
    (21, 12, 1, 6550, '2026-09-21', NULL),
    (22, 10, 2, 2450, '2026-11-05', NULL),
    (23, 9, 1, 850, '2026-10-19', NULL),
    (24, 1, 1, 1250, '2026-10-25', NULL);

INSERT INTO Satis (urun_id, alici_musteri_id, kaydeden_kullanici_id, satis_fiyati, satis_tarihi, odeme_sekli) VALUES
    (3, 12, 2, 2900, '2026-09-16', N'Kart'),
    (4, 9, 2, 13950, '2026-09-28', N'Nakit'),
    (10, 9, 1, 15350, '2026-09-30', N'Kart'),
    (11, 10, 1, 11450, '2026-10-01', N'Nakit'),
    (6, 4, 1, 4050, '2026-10-02', N'Nakit'),
    (16, 4, 1, 7450, '2026-10-04', N'Nakit'),
    (19, 5, 2, 3800, '2026-10-09', N'Kart'),
    (21, 5, 1, 8750, '2026-10-16', N'Nakit'),
    (13, 6, 2, 3600, '2026-10-18', N'Havale'),
    (23, 10, 2, 1100, '2026-10-29', N'Nakit'),
    (2, 4, 2, 9400, '2026-11-01', N'Nakit'),
    (7, 4, 1, 13900, '2026-11-04', N'Havale'),
    (8, 8, 2, 8850, '2026-11-08', N'Kart'),
    (1, 1, 2, 5250, '2026-11-10', N'Nakit'),
    (12, 12, 1, 6200, '2026-11-10', N'Nakit'),
    (14, 1, 2, 4300, '2026-11-10', N'Kart'),
    (24, 7, 1, 1600, '2026-11-10', N'Nakit');

INSERT INTO KasaHareketi (tarih, tutar, yon, alim_id, satis_id) VALUES
    ('2026-09-09', 6200, N'Çıkış', 16, NULL),
    ('2026-09-10', 3200, N'Çıkış', 3, NULL),
    ('2026-09-16', 2900, N'Giriş', NULL, 1),
    ('2026-09-17', 11800, N'Çıkış', 10, NULL),
    ('2026-09-19', 10450, N'Çıkış', 4, NULL),
    ('2026-09-21', 6550, N'Çıkış', 21, NULL),
    ('2026-09-22', 8750, N'Çıkış', 11, NULL),
    ('2026-09-26', 3100, N'Çıkış', 6, NULL),
    ('2026-09-28', 6500, N'Çıkış', 17, NULL),
    ('2026-09-28', 13950, N'Giriş', NULL, 2),
    ('2026-09-29', 3350, N'Çıkış', 19, NULL),
    ('2026-09-30', 15350, N'Giriş', NULL, 3),
    ('2026-10-01', 11450, N'Giriş', NULL, 4),
    ('2026-10-02', 4050, N'Giriş', NULL, 5),
    ('2026-10-04', 7450, N'Giriş', NULL, 6),
    ('2026-10-05', 8300, N'Çıkış', 5, NULL),
    ('2026-10-05', 1550, N'Çıkış', 15, NULL),
    ('2026-10-07', 2700, N'Çıkış', 13, NULL),
    ('2026-10-09', 3800, N'Giriş', NULL, 7),
    ('2026-10-11', 7350, N'Çıkış', 2, NULL),
    ('2026-10-11', 11900, N'Çıkış', 7, NULL),
    ('2026-10-16', 8750, N'Giriş', NULL, 8),
    ('2026-10-18', 3600, N'Giriş', NULL, 9),
    ('2026-10-19', 850, N'Çıkış', 23, NULL),
    ('2026-10-25', 6750, N'Çıkış', 8, NULL),
    ('2026-10-25', 1250, N'Çıkış', 24, NULL),
    ('2026-10-27', 3900, N'Çıkış', 1, NULL),
    ('2026-10-28', 3850, N'Çıkış', 14, NULL),
    ('2026-10-29', 1100, N'Giriş', NULL, 10),
    ('2026-10-31', 4950, N'Çıkış', 12, NULL),
    ('2026-11-01', 6000, N'Çıkış', 20, NULL),
    ('2026-11-01', 9400, N'Giriş', NULL, 11),
    ('2026-11-02', 9650, N'Çıkış', 9, NULL),
    ('2026-11-03', 6950, N'Çıkış', 18, NULL),
    ('2026-11-04', 13900, N'Giriş', NULL, 12),
    ('2026-11-05', 2450, N'Çıkış', 22, NULL),
    ('2026-11-08', 8850, N'Giriş', NULL, 13),
    ('2026-11-10', 5250, N'Giriş', NULL, 14),
    ('2026-11-10', 6200, N'Giriş', NULL, 15),
    ('2026-11-10', 4300, N'Giriş', NULL, 16),
    ('2026-11-10', 1600, N'Giriş', NULL, 17);

PRINT N'Ornek veriler eklendi.';
