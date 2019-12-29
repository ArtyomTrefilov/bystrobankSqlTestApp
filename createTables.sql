/*Таблицы БД*/
/*
 * Таблица "Авторы" 
 */
CREATE TABLE [authors](
	[id] [int] IDENTITY(1,1) NOT NULL CONSTRAINT [prim_authors_id] PRIMARY KEY,
	[name] [varchar](150) NOT NULL,
	[birthday] [datetime] NOT NULL,
	[deathday] [datetime] NULL
)
/*
 * Таблица "Книги" (по ТЗ)
 */
CREATE TABLE [books](
	[id] [int] IDENTITY(1,1) NOT NULL CONSTRAINT [prim_books_id] PRIMARY KEY,
	[name] [varchar](150) NOT NULL,
	[authorid] [int] NOT NULL,
	[styleid] [int] NULL,
	[cost] [numeric](15, 2) NOT NULL
)
ALTER TABLE [books]  WITH CHECK ADD  CONSTRAINT [foreign_books_authorid] FOREIGN KEY([authorid])
REFERENCES [authors] ([id])
ON DELETE CASCADE

ALTER TABLE [books] CHECK CONSTRAINT [foreign_books_authorid]

ALTER TABLE [books]  WITH CHECK ADD  CONSTRAINT [foreign_books_styleid] FOREIGN KEY([styleid])
REFERENCES [styles] ([id])
ON DELETE SET NULL

ALTER TABLE [books] CHECK CONSTRAINT [foreign_books_styleid]

/*
 * Таблица "Книги" (моя версия)
 */
CREATE TABLE [booksnew](
	[id] [int] IDENTITY(1,1) NOT NULL CONSTRAINT [prim_booksnew_id] PRIMARY KEY,
	[name] [varchar](150) NOT NULL,
	[authorid] [int] NOT NULL,
	[styleid] [int] NULL,
	[rackid] [int] NULL,
	[cost] [numeric](15, 2) NOT NULL
)

ALTER TABLE [booksnew]  WITH CHECK ADD  CONSTRAINT [foreign_booksnew_authorid] FOREIGN KEY([authorid])
REFERENCES [authors] ([id])
ON DELETE CASCADE

ALTER TABLE [booksnew] CHECK CONSTRAINT [foreign_booksnew_authorid]

ALTER TABLE [booksnew]  WITH CHECK ADD  CONSTRAINT [foreign_booksnew_rackid] FOREIGN KEY([rackid])
REFERENCES [racks] ([id])
ON DELETE SET NULL

ALTER TABLE [booksnew] CHECK CONSTRAINT [foreign_booksnew_rackid]

ALTER TABLE [booksnew]  WITH CHECK ADD  CONSTRAINT [foreign_booksnew_styleid] FOREIGN KEY([styleid])
REFERENCES [styles] ([id])
ON DELETE SET NULL

ALTER TABLE [booksnew] CHECK CONSTRAINT [foreign_booksnew_styleid]
/*
 * Таблица "Выдача книг"
 */
CREATE TABLE [delivery](
	[id] [int] IDENTITY(1,1) NOT NULL CONSTRAINT [prim_delivery_id] PRIMARY KEY,
	[deliverydate] [datetime] NOT NULL,
	[bookid] [int] NOT NULL,
	[subscriberid] [int] NOT NULL,
	[returndate] [datetime] NULL
)

ALTER TABLE [delivery]  WITH CHECK ADD  CONSTRAINT [foreign_delivery_bookid] FOREIGN KEY([bookid])
REFERENCES [books] ([id])
ON DELETE CASCADE

ALTER TABLE [delivery] CHECK CONSTRAINT [foreign_delivery_bookid]

ALTER TABLE [delivery]  WITH CHECK ADD  CONSTRAINT [foreign_delivery_subscriberid] FOREIGN KEY([subscriberid])
REFERENCES [subscribers] ([id])
ON DELETE CASCADE

ALTER TABLE [delivery] CHECK CONSTRAINT [foreign_delivery_subscriberid]

ALTER TABLE [delivery] ADD  DEFAULT (getdate()) FOR [deliverydate]
/*
 * Таблица "Размещение книг"
 */
CREATE TABLE [placement](
	[rackid] [int] NOT NULL,
	[bookid] [int] NOT NULL,
 CONSTRAINT [prim_placement_rackid_bookid] PRIMARY KEY CLUSTERED 
(
	[rackid] ASC,
	[bookid] ASC
)
)

ALTER TABLE [placement]  WITH CHECK ADD  CONSTRAINT [foreign_placement_bookid] FOREIGN KEY([bookid])
REFERENCES [books] ([id])
ON DELETE CASCADE

ALTER TABLE [placement] CHECK CONSTRAINT [foreign_placement_bookid]

ALTER TABLE [placement]  WITH CHECK ADD  CONSTRAINT [foreign_placement_rackid] FOREIGN KEY([rackid])
REFERENCES [racks] ([id])
ON DELETE CASCADE

ALTER TABLE [placement] CHECK CONSTRAINT [foreign_placement_rackid]
/*
 * Таблица "Стойки"
 */
CREATE TABLE [racks](
	[id] [int] IDENTITY(1,1) NOT NULL CONSTRAINT [prim_racks_id] PRIMARY KEY,
	[rackno] [varchar](10) NOT NULL,
	[name] [varchar](150) NOT NULL,
	[section] [smallint] NOT NULL,
	[maxcount] [smallint] NOT NULL
 )
/*
 * Таблица "Стили"
 */
CREATE TABLE [styles](
	[id] [int] IDENTITY(1,1) NOT NULL CONSTRAINT [prim_styles_id] PRIMARY KEY,
	[name] [varchar](150) NOT NULL
 )
/*
 * Таблица "Абоненты"
 */ 
CREATE TABLE [subscribers](
	[id] [int] IDENTITY(1,1) NOT NULL CONSTRAINT [prim_subscribers_id] PRIMARY KEY,
	[name] [varchar](150) NOT NULL
)









