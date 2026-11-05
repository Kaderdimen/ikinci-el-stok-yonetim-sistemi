-- VTYS II - 4. Hafta: Is kurallarinin veritabaninda zorunlu kilinmasi (SQL Server / T-SQL)
-- Once hafta-3 icindeki 01_tablolari_olustur.sql ve 02_ornek_veri.sql calistirilmis olmalidir.
-- Not: Tarih karsilastirmasi gibi tablolar arasi kurallar 10. haftada TRIGGER ile eklenecektir.

-- IK3: Fiyatlar sifirdan buyuk olmalidir
ALTER TABLE Alim  ADD CONSTRAINT CK_Alim_Fiyat  CHECK (alis_fiyati  > 0);
ALTER TABLE Satis ADD CONSTRAINT CK_Satis_Fiyat CHECK (satis_fiyati > 0);
ALTER TABLE KasaHareketi ADD CONSTRAINT CK_Kasa_Tutar CHECK (tutar > 0);

-- IK9: Odeme sekli sabit listeden secilir
ALTER TABLE Satis ADD CONSTRAINT CK_Satis_Odeme
    CHECK (odeme_sekli IN (N'Nakit', N'Kart', N'Havale'));

-- Zaten 3. hafta tablolarinda olan kurallar:
--   IK1 / IK2: Alim.urun_id ve Satis.urun_id UNIQUE (bir urun bir kez alinir, en fazla bir kez satilir)
--   IK2: Urun.stok_durumu sadece 'Stokta' veya 'Satildi'
--   IK5: KasaHareketi.yon sadece 'Giris' veya 'Cikis'
