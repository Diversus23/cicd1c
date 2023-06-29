﻿// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.ДобавитьКоманду("clearcache",
		"Очистить локальный кэш базы 1С",
		Новый InfoBaseClearCache());

	Команда.ДобавитьКоманду("config",
		"Работа с конфигурацией 1С",
		Новый InfoBaseConfig());
	
	Команда.ДобавитьКоманду("create",
		"Создание информационной базы 1С",
		Новый InfoBaseCreate());

	Команда.ДобавитьКоманду("dump",
		"Выгрузка информационной базы 1С в DT-файл",
		Новый InfoBaseDump());

	Команда.ДобавитьКоманду("dumpformat",
		"Выгрузка информационной базы 1С в DT-файл в файл, с форматом имени, которое можно задать",
		Новый InfoBaseDumpFormat());

	Команда.ДобавитьКоманду("restore",
		"Загрузка информационной базы 1С из DT-файла",
		Новый InfoBaseRestore());

КонецПроцедуры // ОписаниеКоманды()

// Обработчик выполнения команды
//
// Параметры:
//   КомандаПриложения - КомандаПриложения - Выполняемая команда
//
Процедура ВыполнитьКоманду(Знач КомандаПриложения) Экспорт
    
    КомандаПриложения.ВывестиСправку();
    
КонецПроцедуры