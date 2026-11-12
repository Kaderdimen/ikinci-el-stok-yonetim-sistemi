-- VTYS II Donem Projesi - Ikinci El Alim-Satim ve Stok Takip Sistemi
-- 6. Hafta: Veritabaninin olusturulmasi (SQL Server / T-SQL)
-- Bu dosya SQL Server Management Studio (SSMS) veya Azure Data Studio ile calistirilir.
-- Yetki gerekir: CREATE DATABASE (kendi bilgisayarinizdaki SQL Server'da genelde vardir).

USE master;
GO

IF DB_ID(N'IkinciElDB') IS NULL
BEGIN
    CREATE DATABASE IkinciElDB COLLATE Turkish_CI_AS;
    PRINT N'IkinciElDB veritabani olusturuldu.';
END
ELSE
    PRINT N'IkinciElDB zaten var; mevcut veritabani kullanilacak.';
GO

USE IkinciElDB;
GO

SELECT DB_NAME() AS aktif_veritabani, CAST(DATABASEPROPERTYEX(DB_NAME(), 'Collation') AS NVARCHAR(100)) AS collation;
GO
