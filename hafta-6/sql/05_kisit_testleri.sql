-- 6. Hafta: Kisitlarin (constraint) calistigini gosteren testler
-- Her test hatali bir islem dener; veritabani bu islemi REDDETMELIDIR.
-- Tum testler bir transaction icinde calisir ve en sonda geri alinir (ROLLBACK): veriler degismez.
-- Sonuclar 'Messages' sekmesinde gorunur. Not: reddedilen eklemeler IDENTITY sayacini ilerletebilir (id'lerde bosluk kalir); bu normaldir.

USE IkinciElDB;

BEGIN TRAN;

DECLARE @u INT;  -- gecici test urunu (alimi/satisi yok)
INSERT INTO Urun (kategori_id, marka, model) VALUES (1, N'TEST', N'TEST');
SET @u = SCOPE_IDENTITY();

-- T1: Negatif alis fiyati (CHECK)
BEGIN TRY
    INSERT INTO Alim (urun_id, satici_musteri_id, kaydeden_kullanici_id, alis_fiyati, alis_tarihi) VALUES (@u, 1, 1, -500, '2026-11-10');
    PRINT N'T1 KABUL EDILDI (sorun var!): Negatif alis fiyati (CHECK)';
END TRY
BEGIN CATCH
    PRINT N'T1 reddedildi (dogru): Negatif alis fiyati (CHECK)  ->  ' + ERROR_MESSAGE();
END CATCH;

-- T2: Ayni urunun ikinci kez alinmasi (UNIQUE)
BEGIN TRY
    INSERT INTO Alim (urun_id, satici_musteri_id, kaydeden_kullanici_id, alis_fiyati, alis_tarihi) VALUES (1, 1, 1, 1000, '2026-11-10');
    PRINT N'T2 KABUL EDILDI (sorun var!): Ayni urunun ikinci kez alinmasi (UNIQUE)';
END TRY
BEGIN CATCH
    PRINT N'T2 reddedildi (dogru): Ayni urunun ikinci kez alinmasi (UNIQUE)  ->  ' + ERROR_MESSAGE();
END CATCH;

-- T3: Gecersiz odeme sekli (CHECK)
BEGIN TRY
    INSERT INTO Satis (urun_id, alici_musteri_id, kaydeden_kullanici_id, satis_fiyati, satis_tarihi, odeme_sekli) VALUES (@u, 1, 1, 1000, '2026-11-10', N'Bitcoin');
    PRINT N'T3 KABUL EDILDI (sorun var!): Gecersiz odeme sekli (CHECK)';
END TRY
BEGIN CATCH
    PRINT N'T3 reddedildi (dogru): Gecersiz odeme sekli (CHECK)  ->  ' + ERROR_MESSAGE();
END CATCH;

-- T4: Olmayan urune satis (FOREIGN KEY)
BEGIN TRY
    INSERT INTO Satis (urun_id, alici_musteri_id, kaydeden_kullanici_id, satis_fiyati, satis_tarihi, odeme_sekli) VALUES (999999, 1, 1, 1000, '2026-11-10', N'Nakit');
    PRINT N'T4 KABUL EDILDI (sorun var!): Olmayan urune satis (FOREIGN KEY)';
END TRY
BEGIN CATCH
    PRINT N'T4 reddedildi (dogru): Olmayan urune satis (FOREIGN KEY)  ->  ' + ERROR_MESSAGE();
END CATCH;

-- T5: Hem alima hem satisa bagli kasa hareketi (CHECK)
BEGIN TRY
    INSERT INTO KasaHareketi (tarih, tutar, yon, alim_id, satis_id) VALUES ('2026-11-10', 100, N'Giriş', 1, 1);
    PRINT N'T5 KABUL EDILDI (sorun var!): Hem alima hem satisa bagli kasa hareketi (CHECK)';
END TRY
BEGIN CATCH
    PRINT N'T5 reddedildi (dogru): Hem alima hem satisa bagli kasa hareketi (CHECK)  ->  ' + ERROR_MESSAGE();
END CATCH;

-- T6: Ayni kullanici adinin tekrari (UNIQUE)
BEGIN TRY
    INSERT INTO Kullanici (ad_soyad, kullanici_adi, parola_hash, rol) VALUES (N'Test', N'sahip', N'x', N'Personel');
    PRINT N'T6 KABUL EDILDI (sorun var!): Ayni kullanici adinin tekrari (UNIQUE)';
END TRY
BEGIN CATCH
    PRINT N'T6 reddedildi (dogru): Ayni kullanici adinin tekrari (UNIQUE)  ->  ' + ERROR_MESSAGE();
END CATCH;

-- T7: Satilmis urunun ikinci kez satilmasi (UNIQUE)
BEGIN TRY
    INSERT INTO Satis (urun_id, alici_musteri_id, kaydeden_kullanici_id, satis_fiyati, satis_tarihi, odeme_sekli) SELECT TOP 1 urun_id, 1, 1, 1000, '2026-11-10', N'Nakit' FROM Satis;
    PRINT N'T7 KABUL EDILDI (sorun var!): Satilmis urunun ikinci kez satilmasi (UNIQUE)';
END TRY
BEGIN CATCH
    PRINT N'T7 reddedildi (dogru): Satilmis urunun ikinci kez satilmasi (UNIQUE)  ->  ' + ERROR_MESSAGE();
END CATCH;

-- T8: Urunu olan kategorinin silinmesi (FOREIGN KEY)
BEGIN TRY
    DELETE FROM Kategori WHERE kategori_id = 1;
    PRINT N'T8 KABUL EDILDI (sorun var!): Urunu olan kategorinin silinmesi (FOREIGN KEY)';
END TRY
BEGIN CATCH
    PRINT N'T8 reddedildi (dogru): Urunu olan kategorinin silinmesi (FOREIGN KEY)  ->  ' + ERROR_MESSAGE();
END CATCH;

ROLLBACK TRAN;
PRINT N'Testler bitti; tum degisiklikler geri alindi.';
