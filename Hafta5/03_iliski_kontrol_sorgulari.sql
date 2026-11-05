-- Tasarimdaki tum iliskilerin calistigini gosteren kontrol sorgulari

-- K1: Urunun alistan satisa tum gecmisi (Urun-Kategori-Alim-Musteri-Kullanici-Satis iliskileri)
SELECT u.urun_id, k.kategori_adi, u.marka, u.model,
       ms.ad_soyad AS satici, a.alis_fiyati, a.alis_tarihi, ka.ad_soyad AS alimi_kaydeden,
       mb.ad_soyad AS alici,  s.satis_fiyati, s.satis_tarihi
FROM Urun u
JOIN Kategori k   ON k.kategori_id = u.kategori_id
JOIN Alim a       ON a.urun_id = u.urun_id
JOIN Musteri ms   ON ms.musteri_id = a.satici_musteri_id
JOIN Kullanici ka ON ka.kullanici_id = a.kaydeden_kullanici_id
LEFT JOIN Satis s    ON s.urun_id = u.urun_id
LEFT JOIN Musteri mb ON mb.musteri_id = s.alici_musteri_id
ORDER BY u.urun_id;

-- K2: Her kasa hareketinin hangi alim veya satisa bagli oldugu (KasaHareketi-Alim-Satis iliskileri)
SELECT h.hareket_id, h.tarih, h.yon, h.tutar,
       a.alim_id, s.satis_id
FROM KasaHareketi h
LEFT JOIN Alim a  ON a.alim_id  = h.alim_id
LEFT JOIN Satis s ON s.satis_id = h.satis_id
ORDER BY h.hareket_id;

-- K3: Tutarlilik kontrolu - kasa tutari islem tutariyla ayni mi? (0 satir donmelidir)
SELECT h.hareket_id
FROM KasaHareketi h
LEFT JOIN Alim a  ON a.alim_id  = h.alim_id
LEFT JOIN Satis s ON s.satis_id = h.satis_id
WHERE h.tutar <> COALESCE(a.alis_fiyati, s.satis_fiyati);

-- K4: Tutarlilik kontrolu - stok durumu satis kaydiyla uyumlu mu? (0 satir donmelidir)
SELECT u.urun_id
FROM Urun u
LEFT JOIN Satis s ON s.urun_id = u.urun_id
WHERE (s.satis_id IS NOT NULL AND u.stok_durumu <> N'Satıldı')
   OR (s.satis_id IS NULL     AND u.stok_durumu <> N'Stokta');
