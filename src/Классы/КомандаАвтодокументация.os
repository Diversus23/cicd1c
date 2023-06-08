﻿Перем Лог;

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт
    
	ТекстОписаниеКоманды = "Автоформирование документации по этому проекту CI/CD. Системная команда";
    ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, ТекстОписаниеКоманды);
    Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры

Функция ВыполнитьКоманду(Знач Параметры) Экспорт
    
	ВозможныйРезультат = МенеджерКомандПриложения.РезультатыКоманд();
	Лог = ПараметрыСистемы.ПолучитьЛог();
	Лог.Информация("Начало обновления документации");

	Текст = МенеджерКомандПриложения.ТекстовоеОписаниеКоманд();
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.УстановитьТекст(Текст);
	ТекстовыйДокумент.Записать("../COMMAND.md");

	Лог.Информация("Окончание обновления документации");

    Возврат ВозможныйРезультат.Успех;
    
КонецФункции