-- 6. Hafta: Veritabaninin calisir durumda oldugunu gosteren kontrol sorgulari
-- Ekran goruntusu almak icin: her sorgu ayri sonuc sekmesinde (Results) gorunur.

USE IkinciElDB;

-- K1: Tablolar ve satir sayilari
SELECT t.name AS tablo, SUM(p.rows) AS satir_sayisi
FROM sys.tables t
JOIN sys.partitions p ON p.object_id = t.object_id AND p.index_id IN (0, 1)
GROUP BY t.name
ORDER BY t.name;

-- K2: Foreign key tanimlari
SELECT fk.name AS fk_adi,
       OBJECT_NAME(fk.parent_object_id) AS tablo,
       COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS kolon,
       OBJECT_NAME(fk.referenced_object_id) AS referans_tablo,
       COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS referans_kolon
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
ORDER BY tablo, fk_adi;

-- K3: CHECK kisitlari
SELECT OBJECT_NAME(parent_object_id) AS tablo, name AS kisit_adi, definition AS kosul
FROM sys.check_constraints
ORDER BY tablo, kisit_adi;

-- K4: Indexler (PK ve UNIQUE indexleri dahil)
SELECT OBJECT_NAME(i.object_id) AS tablo, i.name AS index_adi, i.type_desc AS tur,
       i.is_primary_key AS pk, i.is_unique AS benzersiz
FROM sys.indexes i
WHERE OBJECTPROPERTY(i.object_id, 'IsUserTable') = 1 AND i.name IS NOT NULL
ORDER BY tablo, index_adi;

-- K5: Tutarlilik - kasa tutari islem tutariyla ayni mi? (0 satir donmelidir)
SELECT h.hareket_id
FROM KasaHareketi h
LEFT JOIN Alim a  ON a.alim_id  = h.alim_id
LEFT JOIN Satis s ON s.satis_id = h.satis_id
WHERE h.tutar <> COALESCE(a.alis_fiyati, s.satis_fiyati);

-- K6: Tutarlilik - stok durumu satis kaydiyla uyumlu mu? (0 satir donmelidir)
SELECT u.urun_id
FROM Urun u
LEFT JOIN Satis s ON s.urun_id = u.urun_id
WHERE (s.satis_id IS NOT NULL AND u.stok_durumu <> N'Satıldı')
   OR (s.satis_id IS NULL     AND u.stok_durumu <> N'Stokta');

-- K7: Tutarlilik - satis tarihi alis tarihinden once olan kayit var mi? (0 satir donmelidir)
SELECT s.satis_id, a.alis_tarihi, s.satis_tarihi
FROM Satis s
JOIN Alim a ON a.urun_id = s.urun_id
WHERE s.satis_tarihi < a.alis_tarihi;

-- K8: Urunlerin alistan satisa tum gecmisi (ilk 10 kayit)
SELECT TOP 10 u.urun_id, k.kategori_adi, u.marka, u.model,
       ms.ad_soyad AS satici, a.alis_fiyati, a.alis_tarihi,
       mb.ad_soyad AS alici,  s.satis_fiyati, s.satis_tarihi, u.stok_durumu
FROM Urun u
JOIN Kategori k   ON k.kategori_id = u.kategori_id
JOIN Alim a       ON a.urun_id = u.urun_id
JOIN Musteri ms   ON ms.musteri_id = a.satici_musteri_id
LEFT JOIN Satis s    ON s.urun_id = u.urun_id
LEFT JOIN Musteri mb ON mb.musteri_id = s.alici_musteri_id
ORDER BY u.urun_id;
