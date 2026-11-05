-- VTYS II Donem Projesi - Ikinci El Alim-Satim ve Stok Takip Sistemi
-- 3. Hafta: Taslak tablo yapisi (SQL Server / T-SQL)
-- Not: Tablo yapisi taslaktir, 5. haftadaki ER diyagramina gore guncellenecektir.

DROP TABLE IF EXISTS KasaHareketi;
DROP TABLE IF EXISTS Satis;
DROP TABLE IF EXISTS Alim;
DROP TABLE IF EXISTS Urun;
DROP TABLE IF EXISTS Musteri;
DROP TABLE IF EXISTS Kategori;

CREATE TABLE Kategori (
    kategori_id   INT PRIMARY KEY,
    kategori_adi  NVARCHAR(50) NOT NULL
);

CREATE TABLE Musteri (
    musteri_id  INT PRIMARY KEY,
    ad_soyad    NVARCHAR(100) NOT NULL,
    telefon     NVARCHAR(20)
);

CREATE TABLE Urun (
    urun_id      INT PRIMARY KEY,
    kategori_id  INT NOT NULL,
    marka        NVARCHAR(50),
    model        NVARCHAR(50),
    seri_no      NVARCHAR(50),
    durum        NVARCHAR(20),
    stok_durumu  NVARCHAR(20) NOT NULL DEFAULT N'Stokta',
    CONSTRAINT FK_Urun_Kategori FOREIGN KEY (kategori_id) REFERENCES Kategori(kategori_id),
    CONSTRAINT CK_Urun_Stok CHECK (stok_durumu IN (N'Stokta', N'Satıldı'))
);

-- Bir urun dukkana bir kez alinir: urun_id UNIQUE
CREATE TABLE Alim (
    alim_id            INT PRIMARY KEY,
    urun_id            INT NOT NULL UNIQUE,
    satici_musteri_id  INT NOT NULL,
    alis_fiyati        DECIMAL(10,2) NOT NULL,
    alis_tarihi        DATE NOT NULL,
    CONSTRAINT FK_Alim_Urun    FOREIGN KEY (urun_id) REFERENCES Urun(urun_id),
    CONSTRAINT FK_Alim_Musteri FOREIGN KEY (satici_musteri_id) REFERENCES Musteri(musteri_id)
);

-- Bir urun en fazla bir kez satilir: urun_id UNIQUE
CREATE TABLE Satis (
    satis_id           INT PRIMARY KEY,
    urun_id            INT NOT NULL UNIQUE,
    alici_musteri_id   INT NOT NULL,
    satis_fiyati       DECIMAL(10,2) NOT NULL,
    satis_tarihi       DATE NOT NULL,
    odeme_sekli        NVARCHAR(20),
    CONSTRAINT FK_Satis_Urun    FOREIGN KEY (urun_id) REFERENCES Urun(urun_id),
    CONSTRAINT FK_Satis_Musteri FOREIGN KEY (alici_musteri_id) REFERENCES Musteri(musteri_id)
);

CREATE TABLE KasaHareketi (
    hareket_id  INT PRIMARY KEY,
    tarih       DATE NOT NULL,
    tutar       DECIMAL(10,2) NOT NULL,
    yon         NVARCHAR(10) NOT NULL,
    alim_id     INT NULL,
    satis_id    INT NULL,
    CONSTRAINT FK_Kasa_Alim  FOREIGN KEY (alim_id)  REFERENCES Alim(alim_id),
    CONSTRAINT FK_Kasa_Satis FOREIGN KEY (satis_id) REFERENCES Satis(satis_id),
    CONSTRAINT CK_Kasa_Yon CHECK (yon IN (N'Giriş', N'Çıkış'))
);
