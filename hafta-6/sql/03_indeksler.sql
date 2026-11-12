-- 6. Hafta: Indeksler (SQL Server / T-SQL)
-- Once 01_tablolari_olustur.sql calistirilmalidir. Dosya tekrar calistirilabilir.
-- PK ve UNIQUE kisitlari icin SQL Server indexi kendisi olusturur; burada ek indexler tanimlanir.

USE IkinciElDB;

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Urun_kategori' AND object_id = OBJECT_ID(N'Urun'))
    CREATE INDEX IX_Urun_kategori ON Urun (kategori_id);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Urun_stok_kategori' AND object_id = OBJECT_ID(N'Urun'))
    CREATE INDEX IX_Urun_stok_kategori ON Urun (stok_durumu, kategori_id) INCLUDE (marka, model, durum);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Urun_seri_no' AND object_id = OBJECT_ID(N'Urun'))
    CREATE INDEX IX_Urun_seri_no ON Urun (seri_no) WHERE seri_no IS NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Alim_tarih' AND object_id = OBJECT_ID(N'Alim'))
    CREATE INDEX IX_Alim_tarih ON Alim (alis_tarihi) INCLUDE (alis_fiyati);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Alim_satici' AND object_id = OBJECT_ID(N'Alim'))
    CREATE INDEX IX_Alim_satici ON Alim (satici_musteri_id);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Alim_kullanici' AND object_id = OBJECT_ID(N'Alim'))
    CREATE INDEX IX_Alim_kullanici ON Alim (kaydeden_kullanici_id);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Satis_tarih' AND object_id = OBJECT_ID(N'Satis'))
    CREATE INDEX IX_Satis_tarih ON Satis (satis_tarihi) INCLUDE (satis_fiyati, odeme_sekli);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Satis_alici' AND object_id = OBJECT_ID(N'Satis'))
    CREATE INDEX IX_Satis_alici ON Satis (alici_musteri_id);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Satis_kullanici' AND object_id = OBJECT_ID(N'Satis'))
    CREATE INDEX IX_Satis_kullanici ON Satis (kaydeden_kullanici_id);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Kasa_tarih' AND object_id = OBJECT_ID(N'KasaHareketi'))
    CREATE INDEX IX_Kasa_tarih ON KasaHareketi (tarih) INCLUDE (tutar, yon);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Musteri_ad' AND object_id = OBJECT_ID(N'Musteri'))
    CREATE INDEX IX_Musteri_ad ON Musteri (ad_soyad);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Musteri_telefon' AND object_id = OBJECT_ID(N'Musteri'))
    CREATE INDEX IX_Musteri_telefon ON Musteri (telefon);

PRINT N'Indexler olusturuldu.';
