CREATE TABLE [dbo].[HintTestTable] (
    [HintOriginal] NVARCHAR (250) NULL,
    [Hint]         NVARCHAR (250) NULL,
    [Word1]        NVARCHAR (50)  NULL,
    [Word2]        NVARCHAR (50)  NULL,
    [Word3]        NVARCHAR (50)  NULL,
    [Word4]        NVARCHAR (50)  NULL,
    [Word5]        NVARCHAR (50)  NULL,
    [Word6]        NVARCHAR (50)  NULL,
    [Word7]        NVARCHAR (50)  NULL,
    [Word8]        NVARCHAR (50)  NULL,
    [Word9]        NVARCHAR (50)  NULL,
    [Word10]       NVARCHAR (50)  NULL,
    [Word11]       NVARCHAR (50)  NULL,
    [Word12]       NVARCHAR (50)  NULL,
    [Word13]       NVARCHAR (50)  NULL,
    [Word14]       NVARCHAR (50)  NULL,
    [Word15]       NVARCHAR (50)  NULL,
    [counter]      INT            IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_HintTestTable] PRIMARY KEY CLUSTERED ([counter] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200409-135638]
    ON [dbo].[HintTestTable]([Word1] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200409-135702]
    ON [dbo].[HintTestTable]([Word2] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200409-135713]
    ON [dbo].[HintTestTable]([Word3] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200409-135726]
    ON [dbo].[HintTestTable]([Word4] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200409-135739]
    ON [dbo].[HintTestTable]([Word5] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200409-135748]
    ON [dbo].[HintTestTable]([Word6] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200409-135802]
    ON [dbo].[HintTestTable]([Word7] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200409-135811]
    ON [dbo].[HintTestTable]([Word8] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200409-135819]
    ON [dbo].[HintTestTable]([Word9] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200409-135828]
    ON [dbo].[HintTestTable]([Word10] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200409-135841]
    ON [dbo].[HintTestTable]([Word11] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200409-135851]
    ON [dbo].[HintTestTable]([Word12] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200409-135901]
    ON [dbo].[HintTestTable]([Word13] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200409-135910]
    ON [dbo].[HintTestTable]([Word14] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200409-135920]
    ON [dbo].[HintTestTable]([Word15] ASC);

