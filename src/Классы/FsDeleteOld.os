﻿#Область ПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
    
	Команда.Опция("path p", "",
		"Локальный каталог (обязательный)")
		.ТСтрока();

	Команда.Опция("mask m", "",
		"Маска файлов. По умолчанию ""*"" (не обязательный)")
		.ТСтрока();

	Команда.Опция("count c", "",
		"Количество файлов, которые необходимо оставить. По умолчанию 7 (не обязательный)")
		.ТЧисло();

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	Лог = ПараметрыСистемы.Лог();
	ПараметрыКоманды = ПолучитьСтруктуруПараметров(Команда);
	УдалитьСтарыеФайлы(ПараметрыКоманды);
    
КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруПараметров(Знач Команда)

	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);	
	ВыводОтладочнойИнформации = ЧтениеОпций.ЗначениеОпции("verbose");	
	ПараметрыСистемы.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("Каталог", ЧтениеОпций.ЗначениеОпции("path", Истина));
	ПараметрыКоманды.Вставить("Маска", ЧтениеОпций.ЗначениеОпции("mask", Ложь, "*"));
	ПараметрыКоманды.Вставить("Количество", ЧтениеОпций.ЗначениеОпции("count", Ложь, 7));
	Возврат ПараметрыКоманды; 

КонецФункции // ПолучитьСтруктуруПараметров()

Процедура УдалитьСтарыеФайлы(Знач Параметры)
		
	Лог = ПараметрыСистемы.Лог();
	Лог.Информация("Начало удаления устаревших файлов");
	МассивФайлов = НайтиФайлы(Параметры.Каталог, Параметры.Маска);	

	Если МассивФайлов.Количество() > Параметры.Количество Тогда

		ТЗ = Новый ТаблицаЗначений;
		ТЗ.Колонки.Добавить("ИмяФайла");
		ТЗ.Колонки.Добавить("ПоследняяДатаИзменения");
		Для Каждого Файл Из МассивФайлов Цикл
			СтрокаТЗ 						= ТЗ.Добавить();
			СтрокаТЗ.ИмяФайла				= Файл.ПолноеИмя;
			СтрокаТЗ.ПоследняяДатаИзменения = Файл.ПолучитьВремяИзменения();				
		КонецЦикла;

		ТЗ.Сортировать("ПоследняяДатаИзменения Убыв");

		КоличествоУдаленных = 0;
		Пока ТЗ.Количество() > Параметры.Количество Цикл
			Попытка
				ИмяФайла = ТЗ[ТЗ.Количество() - 1].ИмяФайла;
				УдалитьФайлы(ИмяФайла);
				ТЗ.Удалить(ТЗ.Количество() - 1);
				КоличествоУдаленных = КоличествоУдаленных + 1;
				Лог.Информация("Удален: <%1>", ИмяФайла);
			Исключение
				ОбщегоНазначения.ЗавершениеРаботыОшибка("Произошла ошибка при удалении файла <%1>: %2", 
					ИмяФайла, ОписаниеОшибки());
			КонецПопытки;
		КонецЦикла;

		Лог.Информация("Всего удалено файлов: %1", КоличествоУдаленных);

	КонецЕсли;

	Лог.Информация("Завершение удаления устаревших файлов");
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции