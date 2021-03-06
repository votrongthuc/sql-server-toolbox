USE tempdb
GO
DROP TABLE IF EXISTS dbo.ImplicitConversionTesting
DROP TABLE IF EXISTS dbo.ImplicitConversionTesting2
GO
GO
CREATE TABLE dbo.ImplicitConversionTesting (
	[ID] [int] IDENTITY (1,1) NOT NULL,
	[SomeVarchar] [varchar](50) NOT NULL,
	[SomeNVarchar] [nvarchar](50) NOT NULL,
	[SomeID] [int] NOT NULL,
	[SomeDate][datetime2](7)
	CONSTRAINT PK_Implicit PRIMARY KEY (ID)
)
INSERT INTO dbo.ImplicitConversionTesting (SomeVarchar, SomeNVarchar, SomeID, SomeDate) 
VALUES ('Whatever',N'Whatever',123,'1/1/2018')
GO
--Include actual execution plan
SELECT *
  FROM dbo.ImplicitConversionTesting
  WHERE SomeID like '1%' --implicit conversion 
  --WHERE left(SomeID,1) = 3 --implicit conversion 
  --WHERE SomeDate like N'1/1/2018' --implicit conversion
  --WHERE SomeVarchar like N'What%' --implicit conversion
  --WHERE SomeNVarchar like 'What%' --no implicit conversion
GO

INSERT INTO dbo.ImplicitConversionTesting (SomeVarchar, SomeNVarchar, SomeID, SomeDate) 
SELECT SomeVarchar, SomeNVarchar, SomeID, SomeDate from 
dbo.ImplicitConversionTesting 
GO 15
INSERT INTO dbo.ImplicitConversionTesting (SomeVarchar, SomeNVarchar, SomeID, SomeDate) 
VALUES ('Needle',N'Needle',123,'1/1/2018')
GO
INSERT INTO dbo.ImplicitConversionTesting (SomeVarchar, SomeNVarchar, SomeID, SomeDate) 
SELECT SomeVarchar, SomeNVarchar, SomeID, SomeDate from 
dbo.ImplicitConversionTesting 
GO

 SET STATISTICS TIME ON;

  declare @eedle varchar(50) = 'Needle'

SELECT SomeNVarchar
  FROM dbo.ImplicitConversionTesting t
  WHERE SomeNVarchar = @eedle OPTION (RECOMPILE)-- implicit conversion, converts "up" to Nvarchar OK

SELECT SomeVarchar
  FROM dbo.ImplicitConversionTesting t
  WHERE SomeVarchar = @eedle OPTION (RECOMPILE) --no implicit conversion 

  declare @needle nvarchar(50) = N'Needle'

SELECT SomeVarchar
  FROM dbo.ImplicitConversionTesting t
  WHERE SomeVarchar = @needle OPTION (RECOMPILE)-- implicit conversion 

  SELECT SomeNVarchar
  FROM dbo.ImplicitConversionTesting t
  WHERE SomeNVarchar = @needle OPTION (RECOMPILE) --no implicit conversion, but notice the higher timing


GO
 SET STATISTICS TIME OFF;

DROP TABLE IF EXISTS #ImplicitConversionTesting
