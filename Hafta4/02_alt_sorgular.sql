-- VTYS II - 4. Hafta: Alt sorgu gerektiren ornek durumlar (SQL Server / T-SQL)
-- Once hafta-3 icindeki 01 ve 02 numarali dosyalar calistirilmis olmalidir.

-- A1: Ortalama kari asan satislar (skaler alt sorgu)
SELECT s.satis_id, u.marka, u.model,
       s.satis_fiyati - a.alis_fiyati AS kar
FROM Satis s
JOIN Alim a ON a.urun_id = s.urun_id
JOIN Urun u ON u.urun_id = s.urun_id
WHERE s.satis_fiyati - a.alis_fiyati >
      (SELECT AVG(s2.satis_fiyati - a2.alis_fiyati)
       FROM Satis s2
       JOIN Alim a2 ON a2.urun_id = s2.urun_id)
ORDER BY kar DESC;

-- A2: Hic satilmamis, stokta bekleyen urunler (NOT IN)
SELECT u.urun_id, u.marka, u.model, a.alis_fiyati, a.alis_tarihi
FROM Urun u
JOIN Alim a ON a.urun_id = u.urun_id
WHERE u.urun_id NOT IN (SELECT urun_id FROM Satis)
ORDER BY a.alis_tarihi;

-- A3: Kendi kategorisinin ortalama alis fiyatindan pahaliya alinan urunler (iliskili alt sorgu)
SELECT u.urun_id, u.marka, u.model, a.alis_fiyati
FROM Urun u
JOIN Alim a ON a.urun_id = u.urun_id
WHERE a.alis_fiyati >
      (SELECT AVG(a2.alis_fiyati)
       FROM Alim a2
       JOIN Urun u2 ON u2.urun_id = a2.urun_id
       WHERE u2.kategori_id = u.kategori_id)
ORDER BY a.alis_fiyati DESC;

-- A4: Hic satis yapilmamis kategoriler (NOT EXISTS)
SELECT k.kategori_adi
FROM Kategori k
WHERE NOT EXISTS
      (SELECT 1
       FROM Urun u
       JOIN Satis s ON s.urun_id = u.urun_id
       WHERE u.kategori_id = k.kategori_id)
ORDER BY k.kategori_adi;

