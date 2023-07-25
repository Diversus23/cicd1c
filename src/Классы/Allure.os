﻿// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.ДобавитьКоманду("categories",
		"Формирует файл categories.json для Allure (настройки категории для каталога с отчетами Allure)",
		Новый AllureCategories());

    Команда.ДобавитьКоманду("environment",
		"Формирует файл environment.json для Allure (настройки окружения для каталога с отчетами Allure)",
		Новый AllureEnvironment());        

    Команда.ДобавитьКоманду("executors",
		"Формирует файл executors.json для Allure (настройки CI/CD для каталога с отчетами Allure)",
		Новый AllureExecutors());        
		
КонецПроцедуры // ОписаниеКоманды()

// Обработчик выполнения команды
//
// Параметры:
//   КомандаПриложения - КомандаПриложения - Выполняемая команда
//
Процедура ВыполнитьКоманду(Знач КомандаПриложения) Экспорт
    
    КомандаПриложения.ВывестиСправку();
    
КонецПроцедуры