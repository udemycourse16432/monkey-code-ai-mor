CREATE TABLE [dbo].[CustomerCartNotificationsToSend] (
    [counter]               INT      IDENTITY (1, 1) NOT NULL,
    [CustomerServerCounter] INT      NOT NULL,
    [DateTimeAdded]         DATETIME CONSTRAINT [DF_CustomerCartNotificationsToSend_DateTimeAdded] DEFAULT (getdate()) NOT NULL,
    [DateTimeSent]          DATETIME NULL,
    CONSTRAINT [PK_CustomerCartNotificationsToSend] PRIMARY KEY CLUSTERED ([counter] ASC)
);

