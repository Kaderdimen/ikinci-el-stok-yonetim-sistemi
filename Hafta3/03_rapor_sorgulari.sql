-- 3. Hafta: Raporlama ihtiyaclari icin aggregate / GROUP BY sorgulari (SQL Server / T-SQL)

-- R1: Aylik satis, alis ve kar raporu
SELECT YEAR(s.satis_tarihi)  AS yil,
       MONTH(s.satis_tarihi) AS ay,
       COUNT(*)              AS satis_adedi,
       SUM(s.satis_fiyati)   AS toplam_satis,
       SUM(a.alis_fiyati)    AS toplam_alis,
       SUM(s.satis_fiyati - a.alis_fiyati) AS toplam_kar
FROM Satis s
JOIN Alim a ON a.urun_id = s.urun_id
GROUP BY YEAR(s.satis_tarihi), MONTH(s.satis_tarihi)
ORDER BY yil, ay;

-- R2: Kategoriye gore stok durumu ve stok maliyeti
SELECT k.kategori_adi,
       COUNT(*)           AS stoktaki_urun_adedi,
       SUM(a.alis_fiyati) AS stok_maliyeti
FROM Urun u
JOIN Kategori k ON k.kategori_id = u.kategori_id
JOIN Alim a     ON a.urun_id = u.urun_id
WHERE u.stok_durumu = N'Stokta'
GROUP BY k.kategori_adi
ORDER BY stok_maliyeti DESC;

-- R3: Kategoriye gore satis adedi ve ortalama kar
SELECT k.kategori_adi,
       COUNT(*) AS satilan_adet,
       AVG(s.satis_fiyati - a.alis_fiyati) AS ortalama_kar,
       MAX(s.satis_fiyati - a.alis_fiyati) AS en_yuksek_kar
FROM Satis s
JOIN Alim a     ON a.urun_id = s.urun_id
JOIN Urun u     ON u.urun_id = s.urun_id
JOIN Kategori k ON k.kategori_id = u.kategori_id
GROUP BY k.kategori_adi
HAVING COUNT(*) >= 1
ORDER BY ortalama_kar DESC;

-- R4: Gunluk kasa raporu
SELECT tarih,
       SUM(CASE WHEN yon = N'Giriş' THEN tutar ELSE 0 END)      AS toplam_giris,
       SUM(CASE WHEN yon = N'Çıkış' THEN tutar ELSE 0 END)      AS toplam_cikis,
       SUM(CASE WHEN yon = N'Giriş' THEN tutar ELSE -tutar END) AS net_kasa
FROM KasaHareketi
GROUP BY tarih
ORDER BY tarih;

-- R5: En cok islem yapan musteriler (en az 2 islem)
SELECT m.ad_soyad,
       COUNT(DISTINCT a.alim_id)  AS saticisi_oldugu_alim,
       COUNT(DISTINCT s.satis_id) AS alici_oldugu_satis
FROM Musteri m
LEFT JOIN Alim a  ON a.satici_musteri_id = m.musteri_id
LEFT JOIN Satis s ON s.alici_musteri_id  = m.musteri_id
GROUP BY m.musteri_id, m.ad_soyad
HAVING COUNT(DISTINCT a.alim_id) + COUNT(DISTINCT s.satis_id) >= 2
ORDER BY saticisi_oldugu_alim DESC;

-- R6: Odeme sekline gore satis toplami
SELECT odeme_sekli,
       COUNT(*)          AS satis_adedi,
       SUM(satis_fiyati) AS toplam_tutar,
       AVG(satis_fiyati) AS ortalama_tutar
FROM Satis
GROUP BY odeme_sekli
ORDER BY toplam_tutar DESC;
