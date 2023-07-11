﻿#Использовать logos

// Лог системы
Перем Лог;

#Область ПрограммныйИнтерфейс

// Проверяет установку EDT
//
// Возвращаемое значение:
//	Булево - EDT установлено
//
Функция ПроверитьУстановкуRing() Экспорт

	Возврат ЗначениеЗаполнено(ОбщегоНазначения.НайтиПриложениеВСистеме("ring"));

КонецФункции

// Проверяет установку Java
//
// Возвращаемое значение:
//	Булево - Java установлено
//
Функция ПроверитьУстановкуJava() Экспорт

	Возврат ЗначениеЗаполнено(ОбщегоНазначения.НайтиПриложениеВСистеме("java"));

КонецФункции

// Экспортирует проект EDT в формат XML 1С
//
// Параметры:
//  Параметры    - Структура     - структура для экспорта
//		* КаталогПроекта - Строка - Каталог исходников EDT
//		* КаталогЭкспорта - Строка - Каталог куда надо экспортировать
//		* КаталогПространства - Строка - Каталог пространства EDT
//		* ВерсияEDT - Строка - версия EDT
//
Процедура ЭкспортВXML1C(Знач Параметры) Экспорт
	
	Лог = ПараметрыСистемы.Лог();
	Лог.Информация("Начало экспорта проекта 1C:Enterprise Development Tools в XML-файлы конфигурации 1С:Предприятия");

	Если НЕ ПроверитьУстановкуRing() Тогда
		ОбщегоНазначения.ЗавершениеРаботыОшибка("Не найдена установленная утилита ring");
	КонецЕсли;

	// ring edt@%env.EDT_VERSION% workspace export
	//	--project "%system.teamcity.build.workingDir%\it"
	//	--configuration-files "%system.teamcity.build.workingDir%\build\config"
	//	--workspace-location "%system.teamcity.build.workingDir%"
	
	// Обязательное удаления слешей в конце пути
	КаталогПроекта = ФайловыеОперации.УдалитьПоследнийРазделительПути(Параметры.КаталогПроекта);
	КаталогЭкспорта = ФайловыеОперации.УдалитьПоследнийРазделительПути(Параметры.КаталогЭкспорта);
	КаталогПространства = Параметры.КаталогПространства;
	УдалитьКаталогПространства = Ложь;
	Если НЕ ЗначениеЗаполнено(КаталогПространства) Тогда
		КаталогПространства = ФайловыеОперации.ОбеспечитьВременныйКаталог();
		УдалитьКаталогПространства = Истина;
	КонецЕсли;
	КаталогПространства = ФайловыеОперации.УдалитьПоследнийРазделительПути(КаталогПространства);

	Массив = Новый Массив();
	Массив.Добавить("ring");
	Если ЗначениеЗаполнено(Параметры.ВерсияEDT) Тогда
		Массив.Добавить("edt@" + Параметры.ВерсияEDT);
	Иначе
		Массив.Добавить("edt");
	КонецЕсли;
	Массив.Добавить("workspace export");
	Массив.Добавить("--project");
	Массив.Добавить("""" + КаталогПроекта + """");
	Массив.Добавить("--configuration-files");
	Массив.Добавить("""" + КаталогЭкспорта + """");
	Массив.Добавить("--workspace-location");
	Массив.Добавить("""" + КаталогПространства + """");

	ФайловыеОперации.ОбеспечитьПустойКаталог(КаталогЭкспорта);
	
	СтрокаЗапуска = СтрСоединить(Массив, " ");
	Лог.Информация("Выполняем команду:
					|================
					|%1
					|================", СтрокаЗапуска);
	
	КодВозврата = 0;
	ЗапуститьПриложение(СтрокаЗапуска, , Истина, КодВозврата);

	// Анализируем есть ли файл
	ТекстСОшибкой = "";
	ФайлКонфигурации = ОбъединитьПути(КаталогЭкспорта, "Configuration.xml");
	Если НЕ ФайловыеОперации.ФайлСуществует(ФайлКонфигурации) Тогда
		ФайлЛогов = ОбъединитьПути(КаталогПространства, ".metadata", ".log");
		ТекстСОшибкой = "Нет информации";
		Если ФайловыеОперации.ФайлСуществует(ФайлЛогов) Тогда
			ТекстСОшибкой = ФайловыеОперации.ПрочитатьТекстФайла(ФайлЛогов);
		КонецЕсли;
	КонецЕсли;

	Если УдалитьКаталогПространства Тогда
		Лог.Информация("Удаление временного каталога пространства");
		УдалитьФайлы(КаталогПространства);
		Лог.Информация("Временный каталог пространства удален");
	КонецЕсли;

	Если НЕ ПустаяСтрока(ТекстСОшибкой) Тогда
		ОбщегоНазначения.ЗавершениеРаботыОшибка("Экспорт проекта выполнен с ошибками. Проверьте параметр --edtversion.
												|Информация лога:
												|%1", ТекстСОшибкой);
	Иначе
		Лог.Информация("Экспорт проекта выполнен успешно");
	КонецЕсли;

КонецПроцедуры

// Получает из проекта EDT версию конфигурации.
//
// Параметры:
//	КаталогПроекта - Строка - Каталог исходников EDT
//
// Возвращаемое значение:
//	Строка - строка с версией. Пример: 3.1.16.6
//
Функция ВерсияКонфигурацииИзПроекта(Знач КаталогПроекта) Экспорт

	Описание = ОписаниеКонфигурацииИзПроекта(КаталогПроекта);
	Возврат Описание.Версия;

КонецФункции

// Получает структуру описания конфигуарции из проекта EDT
//
// Параметры:
//	КаталогПроекта - Строка - Каталог исходников EDT
//
// Возвращаемое значение:
//	Структура - описание конфигурации
//		Версия - Строка - строка с версией. Пример: 3.1.16.6
//
Функция ОписаниеКонфигурацииИзПроекта(Знач КаталогПроекта) Экспорт

	Результат = Новый Структура();

	Файлы = НайтиФайлы(КаталогПроекта, "Configuration.mdo", Истина);
	Для Каждого мФайл Из Файлы Цикл
		Если мФайл.ЭтоФайл() Тогда
			Текст = ФайловыеОперации.ПрочитатьТекстФайла(мФайл.ПолноеИмя);

			ШаблоныВерсий = Новый Массив;
			ШаблоныВерсий.Добавить("\d+\.\d+\.\d+\.\d+");
			ШаблоныВерсий.Добавить("\d+\.\d+\.\d+");
			ШаблоныВерсий.Добавить("\d+\.\d+");
			ШаблоныВерсий.Добавить("\d+");

			Файлы = НайтиФайлы(КаталогПроекта, "Configuration.mdo", Истина);
			Для Каждого мФайл Из Файлы Цикл
				Если мФайл.ЭтоФайл() Тогда
					Текст = ФайловыеОперации.ПрочитатьТекстФайла(мФайл.ПолноеИмя);

					// Версия
					Для Каждого Шаблон Из ШаблоныВерсий Цикл
						ШаблонВерсии = СтрШаблон("<version>(%1)<\/version>", Шаблон);
						Массив = ОбщегоНазначения.НайтиПоРегулярномуВыражению(Текст, ШаблонВерсии);
						Если Массив.Количество() > 1 Тогда				
							Результат.Вставить("Версия", Массив[1]);
							Прервать;
						КонецЕсли;
					КонецЦикла;

					// Имя
					Массив = ОбщегоНазначения.НайтиПоРегулярномуВыражению(Текст, "<name>(.*)<\/name>");
					Если Массив.Количество() > 1 Тогда				
						Результат.Вставить("Имя", Массив[1]);
					КонецЕсли;

					// Поставщик
					Массив = ОбщегоНазначения.НайтиПоРегулярномуВыражению(Текст, "<vendor>(.*)<\/vendor>");
					Если Массив.Количество() > 1 Тогда				
						Результат.Вставить("Поставщик", ПреобразоватьСтроку(Массив[1]));
					КонецЕсли;

					// Синоним конфигурации
					// Очень коряво сделано... Надо переделать регулярное выражение
					Результат.Вставить("Синонимы", Новый Массив);					
					ЧастьТекст = Лев(Текст, СтрНайти(Текст, "<version>"));
					Массив = ОбщегоНазначения.НайтиПоРегулярномуВыражению(ЧастьТекст, 					
						"<synonym>[\s\S]*?<key>(.*)<\/key>[\s\S]*?<value>(.*)<\/value>[\s\S]*?<\/synonym>");
					Если Массив.Количество() > 1 Тогда
						Индекс = 1;
						Пока Индекс < Массив.Количество() Цикл
							Синоним = Новый Структура("Язык, Синоним", Массив[Индекс], Массив[Индекс + 1]);
							Результат.Синонимы.Добавить(Синоним);
							Индекс = Индекс + 3;
						КонецЦикла;
					КонецЕсли;					

				КонецЕсли;
			КонецЦикла;			

		КонецЕсли;
	КонецЦикла;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПреобразоватьСтроку(Знач Строка)

	Результат = СтрЗаменить(Строка, "&quot;", """");
	Возврат Результат;

КонецФункции

#КонецОбласти

Лог = ПараметрыСистемы.Лог();