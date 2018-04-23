
#Использовать cmdline
#Использовать "."

//*****************************************************************
Процедура ПоказатьСправкуПоКомандам()

	Сообщить("Библитека для работы с MS SQL SERVER
	|-------------------------------
	|Параметры: 
	| 
	| Режим работы (обязательный): 
	| 
	|   help			- Вывод справки
	|
	|   createdatabase	- Создает на сервере MS SQL новую базу данных.
	| 
	|   dropdatabase		- Удаляет базу данных с сервера MS SQL с указанным именем.
	| 
	|   setrecovery		- Изменяет модель восстановления базы данных из параметров подключения. Параметры:
	|     МодельВосстановления 	- модель восстановления, возможные значения:
	|				  1 или FULL
	|				  2 или BULK_LOGGED 
	|				  3 или SIMPLE		
	|
	|   backupdatabase	- Создает резервную копию базы данных из параметров подключения. Параметры:
	|     Каталог			- Путь к каталогу для хранения резревной копии. 
	|				  Задается относительно сервера MS SQL Server.
	|				  Если не задан используется каталог по умолчанию.
	|     ИмяФайла			- Имя файла резервной копии.
	|				  Если не задан, формируется автоматически в формате: ИмяБазы_2017_04_28_19_02_12.bak
	|     ТипРезервнойКопии 		- Тип резервной копии, возможные значения:
	|				  1 или FULL - Полная резервная копия
	|				  2 или DIFFERENTIAL - Разностная резервная копия
	|				  3 или LOG - Копия журнала транзакций
	|     ТолькоРезервноеКопирование - Флаг только резервного копирования, возможные значения:
	|				  1 или COPY_ONLY - Только резервное копирование
	|     СжиматьРезервныеКопии 	- Параметр сжатия резервной копии, возможные значения:
	|				  1 или COMPRESSION - Сжимать резевную копию
	|
	|   restoredatabas	- Восстанавливает базу данных из параметров подключения на указанную дату. Параметры:
	|     ВосстановлениеНаДату 	- Дата на котороую подбирается последовательность файлов
	|				  Если не указана, то берется текущая дата.
	|
	|   deletefile		- Удаляет файл на сервере MS SQL. Параметры команды:
	|     <ПолноеИмяФайла>		- Полное имя к файлу, который необходимо удалить.
	|
	|   shrinkfile		- Сжимает файлы базы данных из параметров подключения. Параметры:
	|     ТипФайла 			- Тип файла для сжатия, возможные значения:
	|				  0 или ROWS - Файл данных
	|				  1 или LOG - файл жураналов транзакций
	|     ОставитьМБ 		- Число МБ до которого сжимаются файлы. 
	|     				  Если не указан, сжимается до размера по умолчанию
	|     Обрезать 			- Параметр обрезки файла, возможные значения:
	|				  1 или TRUNCATEONLY 
	|				  0 или NOTRUNCATE
	|
	|   shrinkdatabase	- Сжимает базу данных из параметров подключения. Параметры:
	|     ОставитьПроцентов 		- Оставить зарезервированное место в %
	|     Обрезать			- Обрезать файл. Возможные значения:
	|    			 	  0 или NOTRUNCATE 
	|    			  	  1 или TRUNCATEONLY
	|
	| -server 		- (обязательный) Сетевой адрес MS SQL Server
	|
	| -uid 			- (обязательный) Имя пользователя для подключения к MS SQL Server
	|
	| -pwd 			- (обязательный) Пароль пользователя для подключения MS SQL Server
	|
	| -database		- (обязательный) Имя базы данных, в которой по умолчанию будут выполняться все запросы
	|");

КонецПроцедуры

//*****************************************************************
Функция РазобратьПараметры(АргументыКоманднойСтроки, ПараметрыПодключения)

	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	
	Парсер.ДобавитьПараметр("Режим");
	Парсер.ДобавитьПараметр("Параметр1");
	Парсер.ДобавитьПараметр("Параметр2");
	Парсер.ДобавитьПараметр("Параметр3");
	Парсер.ДобавитьПараметр("Параметр4");
	Парсер.ДобавитьПараметр("Параметр5");

	Парсер.ДобавитьИменованныйПараметр("-server");
	Парсер.ДобавитьИменованныйПараметр("-uid");
	Парсер.ДобавитьИменованныйПараметр("-pwd");
	Парсер.ДобавитьИменованныйПараметр("-database");

	ПараметрыЗапуска = Парсер.Разобрать(АргументыКоманднойСтроки);
	Если ПараметрыЗапуска = Неопределено или ПараметрыЗапуска.Количество() = 0 Тогда
		Сообщить("Некорректные аргументы командной строки");
		ПоказатьСправкуПоКомандам();
		Возврат Неопределено;
	КонецЕсли;

	РежимСтруктура = Новый Структура;
	РежимСтруктура.Вставить("Режим","");
	РежимСтруктура.Вставить("Параметр1","");
	РежимСтруктура.Вставить("Параметр2","");
	РежимСтруктура.Вставить("Параметр3","");
	РежимСтруктура.Вставить("Параметр4","");
	РежимСтруктура.Вставить("Параметр5","");
	Для Каждого Параметр ИЗ ПараметрыЗапуска Цикл

		Ключ = ВРег(Параметр.Ключ);

		Если Ключ = "РЕЖИМ" Тогда
			РежимСтруктура.Режим = Параметр.Значение;
		ИначеЕсли Ключ = "ПАРАМЕТР1" Тогда
			РежимСтруктура.Параметр1 = Параметр.Значение;
		ИначеЕсли Ключ = "ПАРАМЕТР2" Тогда
			РежимСтруктура.Параметр2 = Параметр.Значение;
		ИначеЕсли Ключ = "ПАРАМЕТР3" Тогда
			РежимСтруктура.Параметр3 = Параметр.Значение;
		ИначеЕсли Ключ = "ПАРАМЕТР4" Тогда
			РежимСтруктура.Параметр2 = Параметр.Значение;
		ИначеЕсли Ключ = "ПАРАМЕТР5" Тогда
			РежимСтруктура.Параметр2 = Параметр.Значение;
		ИначеЕсли Ключ = "-SERVER" Тогда
			ПараметрыПодключения.АдресСервераSQL = Параметр.Значение;
		ИначеЕсли Ключ = "-UID" Тогда
			ПараметрыПодключения.ИмяПользователяSQL = Параметр.Значение;
		ИначеЕсли Ключ = "-PWD" Тогда
			ПараметрыПодключения.ПарольПользователяSQL = Параметр.Значение;
		ИначеЕсли Ключ = "-DATABASE" Тогда
			ПараметрыПодключения.ИмяБазыДанныхSQL = Параметр.Значение;
		КонецЕсли;

	КонецЦикла;

	Если РежимСтруктура.Режим = "" Тогда
		Сообщить("Неопределен режим работы");
		ПоказатьСправкуПоКомандам();
		Возврат Неопределено;
	КонецЕсли;

	Возврат РежимСтруктура;

КонецФункции

//*****************************************************************
Процедура ВыполнитьКоманду(УправлениеMSSQL, РежимСтруктура)

	Если НЕ ЗначениеЗаполнено(РежимСтруктура) Тогда
		Возврат;
	КонецЕсли;

	Режим = ВРег(РежимСтруктура.Режим);
	Если НЕ ЗначениеЗаполнено(Режим) Тогда
		Возврат;
	КонецЕсли;

	Если Режим = "HELP" Тогда
		ПоказатьСправкуПоКомандам();
	ИначеЕсли Режим =  "CREATEDATABASE" Тогда
		
		// Создадим базу данных
		Если УправлениеMSSQL.СоздатьБД() Тогда
			Сообщить("СоздатьБД: УСПЕШНО");
		Иначе
			Сообщить("СоздатьБД: " + УправлениеMSSQL.ТекстОшибки);
		КонецЕсли;

	ИначеЕсли Режим =  "DROPDATABASE" Тогда

		// Удалим базу данных
		Если УправлениеMSSQL.УдалитьБД() Тогда
			Сообщить("УдалитьБД: УСПЕШНО");
		Иначе
			Сообщить("УдалитьБД: " + УправлениеMSSQL.ТекстОшибки);
		КонецЕсли;

	ИначеЕсли Режим =  "SETRECOVERY" Тогда

		// Сменим модель восстановления базы
		Если УправлениеMSSQL.ИзменитьМодельВосстановленияБД(РежимСтруктура.Параметр1) Тогда
			Сообщить("ИзменитьМодельВосстановленияБД: УСПЕШНО");
		Иначе
			Сообщить("ИзменитьМодельВосстановленияБД: " + УправлениеMSSQL.ТекстОшибки);
		КонецЕсли;

	ИначеЕсли Режим = "BACKUPDATABASE" Тогда

		// Сделаем резервную копию
		ПолноеИмяФайла = УправлениеMSSQL.СделатьРезервнуюКопиюБД(
			РежимСтруктура.Параметр1,
			РежимСтруктура.Параметр2,
			РежимСтруктура.Параметр3,
			РежимСтруктура.Параметр4,
			РежимСтруктура.Параметр5);
		Если ПолноеИмяФайла <> Неопределено Тогда
			Сообщить("СделатьРезервнуюКопиюБД: УСПЕШНО в " + ПолноеИмяФайла);
		Иначе
			Сообщить("СделатьРезервнуюКопиюБД: " + УправлениеMSSQL.ТекстОшибки);
		КонецЕсли;

	ИначеЕсли Режим = "RESTOREDATABASE" Тогда

		// Восстаноим базу на дату создания полной копии
		Если РежимСтруктура.Параметр1 = "" Тогда
			ТекДата = "";
		Иначе
			ТекДата = Дата(РежимСтруктура.Параметр1);
		КонецЕсли;
		Если УправлениеMSSQL.ВосстановитьБД(ТекДата) Тогда
			Сообщить("ВосстановитьБД: УСПЕШНО на дату " + ТекДата);
		Иначе
			Сообщить("ВосстановитьБД: " + УправлениеMSSQL.ТекстОшибки);
			БылиОшибки = Истина;
		КонецЕсли;

	ИначеЕсли Режим = "DELETEFILE" Тогда

		ИмяФайлаДляУдаления = РежимСтруктура.Параметр1;
		Если УправлениеMSSQL.УдалитьФайлНаСервере(ИмяФайлаДляУдаления) Тогда
			Сообщить("УдалитьФайлНаСервере: УСПЕШНО для " + ИмяФайлаДляУдаления);
		Иначе
			Сообщить("УдалитьФайлНаСервере: " + УправлениеMSSQL.ТекстОшибки);
		КонецЕсли;

	ИначеЕсли Режим = "SHRINKFILE" Тогда

		// Запустим сжатие файлов
		Если УправлениеMSSQL.СжатьФайлыБД(
			РежимСтруктура.Параметр1,
			РежимСтруктура.Параметр2,
			РежимСтруктура.Параметр3,
			РежимСтруктура.Параметр4) Тогда
			Сообщить("СжатьФайлыБД: УСПЕШНО");
		Иначе
			Сообщить("СжатьФайлыБД: " + УправлениеMSSQL.ТекстОшибки);
		КонецЕсли;

	ИначеЕсли Режим = "SHRINKDATABASE" Тогда

		// Запустим сжатие базы данных
		Если УправлениеMSSQL.СжатьБД(
			РежимСтруктура.Параметр1,
			РежимСтруктура.Параметр2) Тогда
			Сообщить("СжатьБД: УСПЕШНО");
		Иначе
			Сообщить("СжатьБД: " + УправлениеMSSQL.ТекстОшибки);
			БылиОшибки = Истина;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры


//*****************************************************************

// Создадим объект	
УправлениеMSSQL = Новый УправлениеMSSQL();

// Введем параметры
ПараметрыПодключения = УправлениеMSSQL.ПараметрыПодключения;

// Разбор параметров
РежимСтруктура = РазобратьПараметры(АргументыКоманднойСтроки, ПараметрыПодключения);

// Выполнение команды
ВыполнитьКоманду(УправлениеMSSQL, РежимСтруктура);

