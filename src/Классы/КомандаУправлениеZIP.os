﻿Перем мДействие;

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт
	
	мДействие = НРег(ИмяКоманды);
	Если мДействие <> Перечисления.ДействияСАрхивом.Создание И мДействие <> Перечисления.ДействияСАрхивом.Распаковка Тогда
		ВызватьИсключение("Непредусмотренная команда");
	КонецЕсли;
	
	Если мДействие = Перечисления.ДействияСАрхивом.Создание Тогда
		ОписаниеДействия = "Создать zip-архив";
		ОписаниеПараметраFile = "Полное имя файла создаваемого zip-архива (обязательный)";
		ОписаниеПараметраPath =
			"Файлы и папки, включаемые в архив. Можно использовать разделитель "";"" или ""|"" и маски файлов (обязательный).
			| Примеры:
			|   ""C:\Path\File1.txt|C:\Path\Folder""
			|   ""C:\Path\*.txt;C:\Path\Folder\*.*""
			|   ""C:\Path\Folder""";
	Иначе
		ОписаниеДействия = "Распаковать zip-архив в директорию";
		ОписаниеПараметраFile = "Полное имя zip-архива (обязательный)";
		ОписаниеПараметраPath = "Директория куда необходимо распаковать архив (обязательный)";
	КонецЕсли;
	
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, ОписаниеДействия);
	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды,
		"-file",
		ОписаниеПараметраFile);
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды,
		"-path",
		ОписаниеПараметраPath);
	
КонецПроцедуры

Функция ВыполнитьКоманду(Знач Параметры) Экспорт
	Если мДействие = Перечисления.ДействияСАрхивом.Создание Тогда
		КодВозврата = ВыполнитьКомандуСоздание(Параметры);
	Иначе
		КодВозврата = ВыполнитьКомандуРаспаковка(Параметры);
	КонецЕсли;
	
	Возврат КодВозврата;
КонецФункции

Функция ВыполнитьКомандуСоздание(Знач Параметры)
	
	ВозможныйРезультат = МенеджерКомандПриложения.РезультатыКоманд();
	Лог = ПараметрыСистемы.ПолучитьЛог();
	Лог.Информация("Начало создания ZIP-архива");
	
	ИмяФайлаАрхива = Параметры["-file"];
	МаскаДобавляемыхФайлов = Параметры["-path"];
	
	Если ПустаяСтрока(ИмяФайлаАрхива) Тогда
		Лог.Ошибка("Не задано полое имя создаваемого zip-архива (-file)");
		Возврат ВозможныйРезультат.НеверныеПараметры;
	КонецЕсли;
	
	Если ПустаяСтрока(Параметры["-path"]) Тогда
		Лог.Ошибка("Не заданы файлы и папки для включения в архив (-path)");
		Возврат ВозможныйРезультат.НеверныеПараметры;
	КонецЕсли;
	
	ЗаписьZIP = Новый ЗаписьZipФайла(ИмяФайлаАрхива);
	РазделительФайлов = ?(Найти(МаскаДобавляемыхФайлов, "|") > 0, "|", ";");
	МассивФайловИПапок = СтроковыеФункции.РазложитьСтрокуВМассивПодстрок(МаскаДобавляемыхФайлов,
			РазделительФайлов, Истина, Истина);
	
	Для Каждого МаскаДобавляемогоФайлаПапки Из МассивФайловИПапок Цикл
		Лог.Информация("Добавление файла (каталога) <" + МаскаДобавляемогоФайлаПапки + ">");
		ЗаписьZIP.Добавить(МаскаДобавляемогоФайлаПапки,
			РежимСохраненияПутейZIP.СохранятьОтносительныеПути,
			РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
	КонецЦикла;
	ЗаписьZIP.Записать();
	
	Лог.Информация("Создание архива завершено");
	
	Возврат ВозможныйРезультат.Успех;
	
КонецФункции

Функция ВыполнитьКомандуРаспаковка(Знач Параметры)
	
	ВозможныйРезультат = МенеджерКомандПриложения.РезультатыКоманд();
	Лог = ПараметрыСистемы.ПолучитьЛог();
	Лог.Информация("Начало распаковки ZIP-архива");
	
	ИмяФайлаАрхива = Параметры["-file"];
	Путь = Параметры["-path"];
	
	Если ПустаяСтрока(ИмяФайлаАрхива) Тогда
		Лог.Ошибка("Не задано полое имя zip-архива (-file)");
		Возврат ВозможныйРезультат.НеверныеПараметры;
	КонецЕсли;
	
	Если ПустаяСтрока(Параметры["-path"]) Тогда
		Лог.Ошибка("Не задана директория для включения в архив (-path)");
		Возврат ВозможныйРезультат.НеверныеПараметры;
	КонецЕсли;
	
	ЧтениеZIP = Новый ЧтениеZipФайла(ИмяФайлаАрхива);
	ЧтениеZIP.ИзвлечьВсе(Путь, РежимВосстановленияПутейФайловZIP.Восстанавливать);
	
	Лог.Информация("Распаковка архива завершена");
	
	Возврат ВозможныйРезультат.Успех;
	
КонецФункции