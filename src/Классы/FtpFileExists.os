﻿#Область ПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
	
	РаботаFTP.ОписаниеКоманды(Команда);
	
	Команда.Опция("file f", "",
		"Имя файла на FTP-сервере, существование которого необходимо проверить (обязательный)")
		.ТСтрока();
		
КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	Лог = ПараметрыСистемы.Лог();
	ПараметрыКоманды = ПолучитьСтруктуруПараметров(Команда);	
	Существует = РаботаFTP.ФайлСуществует(ПараметрыКоманды.ИмяФайла, ПараметрыКоманды);
	Если Существует Тогда
		Лог.Информация("Файл <%1> существует на FTP-сервере", ПараметрыКоманды.ИмяФайла);
	Иначе
		ОбщегоНазначения.ЗавершениеРаботыОшибка("Файл <%1> не существует на FTP-сервере", ПараметрыКоманды.ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруПараметров(Знач Команда)
	
	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);
	ПараметрыКоманды = РаботаFTP.ПолучитьСтруктуруПараметровFTP(Команда);
	ПараметрыКоманды.Вставить("ИмяФайла", ЧтениеОпций.ЗначениеОпции("file", Истина));
	Возврат ПараметрыКоманды;
	
КонецФункции // ПолучитьСтруктуруПараметров()

#КонецОбласти // СлужебныеПроцедурыИФункции