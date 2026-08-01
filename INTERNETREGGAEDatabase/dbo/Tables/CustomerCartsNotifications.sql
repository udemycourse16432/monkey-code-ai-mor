CREATE TABLE [dbo].[CustomerCartsNotifications] (
    [CustomerServerCounter] INT      NOT NULL,
    [EmailDate]             DATETIME NOT NULL,
    [counter]               INT      IDENTITY (1, 1) NOT NULL
);

