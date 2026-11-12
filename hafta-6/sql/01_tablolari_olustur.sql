-- 6. Hafta: Tablolarin olusturulmasi (SQL Server / T-SQL)
-- Once 00_veritabani_olustur.sql calistirilmalidir.
-- Bu dosya tekrar calistirilabilir: mevcut tablolari silip bastan olusturur (veriler de silinir).
-- Tasarim 5. haftadaki ER diyagramiyla aynidir; fiziksel olusturma icin
-- birincil anahtarlar IDENTITY (otomatik artan) yapilmis, tarih alanlarina varsayilan deger eklenmistir.
-- Foreign key'lerde ON DELETE belirtilmemistir (NO ACTION): iliskili kaydi olan kayit silinemez.

USE IkinciElDB;

DROP TABLE IF EXISTS KasaHareketi;
DROP TABLE IF EXISTS Satis;
DROP TABLE IF EXISTS Alim;
DROP TABLE IF EXISTS Urun;
DROP TABLE IF EXISTS Musteri;
DROP TABLE IF EXISTS Kategori;
DROP TABLE IF EXISTS Kullanici;

CREATE TABLE Kullanici (
    kullanici_id    INT IDENTITY(1,1) PRIMARY KEY,
    ad_soyad        NVARCHAR(100) NOT NULL,
    kullanici_adi   NVARCHAR(50)  NOT NULL UNIQUE,
    parola_hash     NVARCHAR(200) NOT NULL,
    rol             NVARCHAR(20)  NOT NULL,
    CONSTRAINT CK_Kullanici_Rol CHECK (rol IN (N'Sahip', N'Personel'))
);

CREATE TABLE Kategori (
    kategori_id   INT IDENTITY(1,1) PRIMARY KEY,
    kategori_adi  NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Musteri (
    musteri_id  INT IDENTITY(1,1) PRIMARY KEY,
    ad_soyad    NVARCHAR(100) NOT NULL,
    telefon     NVARCHAR(20)  NOT NULL,
    adres       NVARCHAR(200) NULL,
    kimlik_no   NVARCHAR(11)  NULL
);

CREATE TABLE Urun (
    urun_id      INT IDENTITY(1,1) PRIMARY KEY,
    kategori_id  INT NOT NULL,
    marka        NVARCHAR(50)  NULL,
    model        NVARCHAR(50)  NULL,
    seri_no      NVARCHAR(50)  NULL,
    durum        NVARCHAR(20)  NULL,
    aciklama     NVARCHAR(200) NULL,
    stok_durumu  NVARCHAR(20)  NOT NULL CONSTRAINT DF_Urun_Stok DEFAULT N'Stokta',
    CONSTRAINT FK_Urun_Kategori FOREIGN KEY (kategori_id) REFERENCES Kategori(kategori_id),
    CONSTRAINT CK_Urun_Stok CHECK (stok_durumu IN (N'Stokta', N'Satıldı'))
);

-- Bir urun dukkana bir kez alinir (urun_id UNIQUE)
CREATE TABLE Alim (
    alim_id                INT IDENTITY(1,1) PRIMARY KEY,
    urun_id                INT NOT NULL UNIQUE,
    satici_musteri_id      INT NOT NULL,
    kaydeden_kullanici_id  INT NOT NULL,
    alis_fiyati            DECIMAL(10,2) NOT NULL,
    alis_tarihi            DATE NOT NULL CONSTRAINT DF_Alim_Tarih DEFAULT CAST(GETDATE() AS DATE),
    notlar                 NVARCHAR(200) NULL,
    CONSTRAINT FK_Alim_Urun      FOREIGN KEY (urun_id) REFERENCES Urun(urun_id),
    CONSTRAINT FK_Alim_Musteri   FOREIGN KEY (satici_musteri_id) REFERENCES Musteri(musteri_id),
    CONSTRAINT FK_Alim_Kullanici FOREIGN KEY (kaydeden_kullanici_id) REFERENCES Kullanici(kullanici_id),
    CONSTRAINT CK_Alim_Fiyat CHECK (alis_fiyati > 0)
);

-- Bir urun en fazla bir kez satilir (urun_id UNIQUE)
CREATE TABLE Satis (
    satis_id               INT IDENTITY(1,1) PRIMARY KEY,
    urun_id                INT NOT NULL UNIQUE,
    alici_musteri_id       INT NOT NULL,
    kaydeden_kullanici_id  INT NOT NULL,
    satis_fiyati           DECIMAL(10,2) NOT NULL,
    satis_tarihi           DATE NOT NULL CONSTRAINT DF_Satis_Tarih DEFAULT CAST(GETDATE() AS DATE),
    odeme_sekli            NVARCHAR(20) NOT NULL,
    CONSTRAINT FK_Satis_Urun      FOREIGN KEY (urun_id) REFERENCES Urun(urun_id),
    CONSTRAINT FK_Satis_Musteri   FOREIGN KEY (alici_musteri_id) REFERENCES Musteri(musteri_id),
    CONSTRAINT FK_Satis_Kullanici FOREIGN KEY (kaydeden_kullanici_id) REFERENCES Kullanici(kullanici_id),
    CONSTRAINT CK_Satis_Fiyat CHECK (satis_fiyati > 0),
    CONSTRAINT CK_Satis_Odeme CHECK (odeme_sekli IN (N'Nakit', N'Kart', N'Havale'))
);

-- Her hareket ya bir alima (Cikis) ya da bir satisa (Giris) bagli olmalidir
CREATE TABLE KasaHareketi (
    hareket_id  INT IDENTITY(1,1) PRIMARY KEY,
    tarih       DATE NOT NULL CONSTRAINT DF_Kasa_Tarih DEFAULT CAST(GETDATE() AS DATE),
    tutar       DECIMAL(10,2) NOT NULL,
    yon         NVARCHAR(10) NOT NULL,
    alim_id     INT NULL,
    satis_id    INT NULL,
    CONSTRAINT FK_Kasa_Alim  FOREIGN KEY (alim_id)  REFERENCES Alim(alim_id),
    CONSTRAINT FK_Kasa_Satis FOREIGN KEY (satis_id) REFERENCES Satis(satis_id),
    CONSTRAINT CK_Kasa_Tutar CHECK (tutar > 0),
    CONSTRAINT CK_Kasa_Yon CHECK (
        (yon = N'Çıkış' AND alim_id  IS NOT NULL AND satis_id IS NULL) OR
        (yon = N'Giriş' AND satis_id IS NOT NULL AND alim_id  IS NULL))
);

-- Bir alim veya satis icin en fazla bir kasa hareketi olabilir.
-- SQL Server'da UNIQUE kisiti tek bir NULL'a izin verdigi icin filtrelenmis benzersiz index kullanilir.
CREATE UNIQUE INDEX UX_Kasa_Alim  ON KasaHareketi(alim_id)  WHERE alim_id  IS NOT NULL;
CREATE UNIQUE INDEX UX_Kasa_Satis ON KasaHareketi(satis_id) WHERE satis_id IS NOT NULL;

PRINT N'7 tablo olusturuldu.';
