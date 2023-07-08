﻿#Область ПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
    
	Команда.Опция("from src path f", "",
		"Указывает расположение и имена файлов, которые требуется скопировать (обязательный)")
		.ТСтрока();

	Команда.Опция("to dst destination t", "",
		"Расположение или имена новых файлов (обязательный)")
		.ТСтрока();

	Команда.Опция("move delsrc m", "", 
		"Флаг выполнения перемещение файлов (удалить источник после копирования) (не обязательный)")
		.Флаговый();

	Текст = СтрШаблон("%1 %2",
		"Флаг рекурсивного копирования файлов (необязательный).",
		"По умолчанию копированием и перемещение выполняется только с указанной директории");
	Команда.Опция("recursive r", "", Текст)
		.ТБулево();

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	Лог = ПараметрыСистемы.Лог();
	ПараметрыКоманды = ПолучитьСтруктуруПараметров(Команда);
	Лог.Информация("Начало копирования файлов из %1 в %2", ПараметрыКоманды.Источник, ПараметрыКоманды.Приемник);
	Результат = ФайловыеОперации.КопироватьФайлы(ПараметрыКоманды.Источник,
		ПараметрыКоманды.Приемник,
		ПараметрыКоманды.Рекурсивно,
		ПараметрыКоманды.Переместить);
	Если Результат = Ложь Тогда
		ОбщегоНазначения.ЗавершениеРаботыОшибка("Ошибка копирования файлов");
	КонецЕсли;
    
КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруПараметров(Знач Команда)

	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);	
	ВыводОтладочнойИнформации = ЧтениеОпций.ЗначениеОпции("verbose");	
	ПараметрыСистемы.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("Источник", ЧтениеОпций.ЗначениеОпции("from", Истина));
	ПараметрыКоманды.Вставить("Приемник", ЧтениеОпций.ЗначениеОпции("to", Истина));
	ПараметрыКоманды.Вставить("Переместить", ЧтениеОпций.ЗначениеОпции("move", Ложь));
	ПараметрыКоманды.Переместить = ЗначениеЗаполнено(ПараметрыКоманды.Переместить);
	ПараметрыКоманды.Вставить("Рекурсивно", ЧтениеОпций.ЗначениеОпции("recursive", Ложь));
	ПараметрыКоманды.Рекурсивно = ЗначениеЗаполнено(ПараметрыКоманды.Переместить);
	
	Возврат ПараметрыКоманды; 

КонецФункции // ПолучитьСтруктуруПараметров()

#КонецОбласти // СлужебныеПроцедурыИФункции