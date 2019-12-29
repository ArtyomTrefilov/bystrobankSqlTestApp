/*
 * 1. Выдать список названий всех книг в алфавитном порядке, стоимость которых строго меньше 100000
 */
SELECT name
FROM books
WHERE cost < 100000
ORDER BY name
/*
 * 2. Список имён ныне живущих авторов и количество их книг – детективов. (Название в таблице стилей - «Детективы»). 
 * Сортировать по количеству книг в порядке по-убыванию.
 */
SELECT a.name, COUNT(b.id) AS countBook
FROM authors a
	INNER JOIN books b ON a.id = b.authorid
	INNER JOIN styles c ON b.styleid = c.id
WHERE a.deathday is null AND c.name = 'Детектив'
GROUP BY a.id, a.name
ORDER BY countBook DESC
/*
 * 3. Выдать список самых дорогих книг каждого автора в каждом из жанров.
 */
 /*
  * Версия 1
  */
CREATE TABLE #max_book_cost (authorid int, styleid int, maxcost numeric(15,2))

INSERT INTO #max_book_cost(authorid, styleid, maxcost)
	SELECT authorid, styleid, MAX(cost)
	FROM books 
	GROUP BY authorid, styleid
	ORDER BY authorid, styleid, MAX(cost)

SELECT c.name AS bookName, a.name AS authorName, d.name AS styleName
FROM authors a
	INNER JOIN #max_book_cost b ON a.id = b.authorid
	INNER JOIN  books c ON b.authorid = c.authorid AND b.styleid = c.styleid AND  b.maxcost = c.cost
	INNER JOIN styles d ON b.styleid = d.id
GROUP BY c.name, a.name, d.name

DROP TABLE #max_book_cost
 /*
  * Версия 2
  */
SELECT c.name AS bookName, a.name AS authorName, d.name AS styleName
FROM authors a
	INNER JOIN (
		SELECT authorid, styleid, MAX(cost) AS maxcost
		FROM books 
		GROUP BY authorid, styleid
	) b ON a.id = b.authorid
	INNER JOIN  books c ON b.authorid = c.authorid AND b.styleid = c.styleid AND  b.maxcost = c.cost
	INNER JOIN styles d ON b.styleid = d.id
GROUP BY c.name, a.name, d.name
/*
 * 4. Вывести реестр количества выдачи книг (сколько раз выдавали и количество уникальных книг) по жанрам.
 */
/*
 * Версия 1 (выводит результат по всем жанрам)
 */ 
CREATE TABLE #tt(id int, countDeliv int, countDelivUniq int)

INSERT INTO #tt(id, countDeliv, countDelivUniq)
	SELECT c.id, COUNT(a.bookid), COUNT(DISTINCT a.bookid)
	FROM delivery a
		INNER JOIN books b ON a.bookid = b.id
		INNER JOIN styles c ON b.styleid = c.id
	GROUP BY b.styleid, c.id

SELECT a.name, ISNULL(#tt.countDeliv, 0) as countDeliv, ISNULL(#tt.countDelivUniq, 0) as countDelivUniq
FROM styles a
	LEFT JOIN #tt ON a.id = #tt.id
ORDER BY a.name

DROP TABLE #tt
/*
 * Версия 2 (выводит результат только по жанрам книг, которые выдавались)
 */
SELECT c.name, COUNT(a.bookid) AS countDeliv, COUNT(DISTINCT a.bookid) AS countDelivUniq
FROM delivery a
    INNER JOIN books b ON a.bookid = b.id
    INNER JOIN styles c ON b.styleid = c.id
GROUP BY b.styleid, c.name
/*
 * 5. Вывести список секций со свободными на текущий момент ячейками.(С учетом моей версии таблицы "Книги" (booksnew))
 */
SELECT a.id
FROM racks a 
	LEFT JOIN (
		SELECT rackid, COUNT(id) AS countid
		FROM booksnew
		GROUP BY rackid) b ON b.rackid = a.id AND  b.countid < a.maxcount
	LEFT JOIN (
		SELECT aa.id, COUNT(dd.bookid) AS countid1
		FROM racks aa
			INNER JOIN booksnew cc ON aa.id = cc.rackid
			INNER JOIN delivery dd ON cc.id = dd.bookid
		WHERE dd.returndate is null
		GROUP BY aa.id) c ON c.id = a.id AND countid1 = a.maxcount
WHERE b.rackid is not null OR c.id is not null
 