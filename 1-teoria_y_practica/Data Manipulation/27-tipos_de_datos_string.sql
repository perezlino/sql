-- ======================================================
-- ================== TIPOS DATOS STRING ================
-- ======================================================

/*  char - ASCII - 1 byte
    varchar - ASCII - 1 byte
    nchar - UNICODE - 2 byte
    nvarchar - UNICODE - 2byte  */


-- ===============
-- === VARCHAR ===
-- ===============

DECLARE @string AS VARCHAR(20)
SET @string = ''
SELECT @string 'String', LEN(@string) 'Len', DATALENGTH(@string) 'Datalength'

-- |--------------|---------------|---------------|
-- |    String    |      Len      |   Datalength  |
-- |--------------|---------------|---------------|
-- |              |       0       |       0       |
-- |--------------|---------------|---------------|

DECLARE @string AS VARCHAR(20)
SET @string = 'Alfonso'
SELECT @string 'String', LEN(@string) 'Len', DATALENGTH(@string) 'Datalength'

-- |--------------|---------------|---------------|
-- |    String    |      Len      |   Datalength  |
-- |--------------|---------------|---------------|
-- |   Alfonso    |       7       |       7       |
-- |--------------|---------------|---------------|

DECLARE @string AS VARCHAR(20)
SET @string = 'Alfonsoꝕ' -- Le agregamos un simbolo que no pertenece a ASCII
SELECT @string 'String', LEN(@string) 'Len', DATALENGTH(@string) 'Datalength'

-- |--------------|---------------|---------------|
-- |    String    |      Len      |   Datalength  |
-- |--------------|---------------|---------------|
-- |   Alfonso?   |       8       |       8       |
-- |--------------|---------------|---------------|


-- ============================================================================================
-- ============================================================================================

/* ============
   === CHAR ===
   ============ */

DECLARE @string AS CHAR(20)
SET @string = ''
SELECT @string 'string', LEN(@string) 'Len', DATALENGTH(@string) 'Datalength'

-- |--------------|---------------|---------------|
-- |    String    |      Len      |   Datalength  |
-- |--------------|---------------|---------------|
-- |              |       0       |       20      |
-- |--------------|---------------|---------------|

DECLARE @string AS CHAR(20)
SET @string = 'Alfonso'
SELECT @string 'string', LEN(@string) 'Len', DATALENGTH(@string) 'Datalength'

-- |--------------|---------------|---------------|
-- |    String    |      Len      |   Datalength  |
-- |--------------|---------------|---------------|
-- |   Alfonso    |       7       |       20      |
-- |--------------|---------------|---------------|

DECLARE @string AS CHAR(20)
SET @string = 'Alfonsoꝕ'
SELECT @string 'string', LEN(@string) 'Len', DATALENGTH(@string) 'Datalength'

-- |--------------|---------------|---------------|
-- |    String    |      Len      |   Datalength  |
-- |--------------|---------------|---------------|
-- |   Alfonso?   |       8       |       20      |
-- |--------------|---------------|---------------|


-- ============================================================================================
-- ============================================================================================

/* ================
   === NVARCHAR ===
   ================ */

DECLARE @string AS NVARCHAR(20)
SET @string = ''
SELECT @string 'string', LEN(@string) 'Len', DATALENGTH(@string) 'Datalength'

-- |--------------|---------------|---------------|
-- |    String    |      Len      |   Datalength  |
-- |--------------|---------------|---------------|
-- |              |       0       |       0       |
-- |--------------|---------------|---------------|

DECLARE @string AS NVARCHAR(20)
SET @string = 'Alfonso'
SELECT @string 'string', LEN(@string) 'Len', DATALENGTH(@string) 'Datalength'

-- |--------------|---------------|---------------|
-- |    String    |      Len      |   Datalength  |
-- |--------------|---------------|---------------|
-- |   Alfonso    |       7       |       14      |
-- |--------------|---------------|---------------|

DECLARE @string AS NVARCHAR(20)
SET @string = N'Alfonsoﮜ'  -- Anteponemos una N para que el caracter UNICODE pueda imprimirse
SELECT @string 'string', LEN(@string) 'Len', DATALENGTH(@string) 'Datalength'

-- Alfonsoﮜ  --> Asi deberia aparecer en el campo 'string'

-- |--------------|---------------|---------------|
-- |    String    |      Len      |   Datalength  |
-- |--------------|---------------|---------------|
-- |   Alfonso    |       8       |       16      |
-- |--------------|---------------|---------------|


-- ============================================================================================
-- ============================================================================================

/* =============
   === NCHAR ===
   ============= */

DECLARE @string AS NCHAR(20)
SET @string = ''
SELECT @string 'string', LEN(@string) 'Len', DATALENGTH(@string) 'Datalength'

-- |--------------|---------------|---------------|
-- |    String    |      Len      |   Datalength  |
-- |--------------|---------------|---------------|
-- |              |       0       |       40      |
-- |--------------|---------------|---------------|

DECLARE @string AS NCHAR(20)
SET @string = 'Alfonso'
SELECT @string 'string', LEN(@string) 'Len', DATALENGTH(@string) 'Datalength'

-- |--------------|---------------|---------------|
-- |    String    |      Len      |   Datalength  |
-- |--------------|---------------|---------------|
-- |   Alfonso    |       7       |       40      |
-- |--------------|---------------|---------------|

DECLARE @string AS NCHAR(20)
SET @string = N'Alfonsoﮜ' -- Anteponemos una N para que el caracter UNICODE pueda imprimirse
SELECT @string 'string', LEN(@string) 'Len', DATALENGTH(@string) 'Datalength'

-- Alfonsoﮜ  --> Asi deberia aparecer en el campo 'string'

-- |--------------|---------------|---------------|
-- |    String    |      Len      |   Datalength  |
-- |--------------|---------------|---------------|
-- |   Alfonso    |       8       |       40      |
-- |--------------|---------------|---------------|