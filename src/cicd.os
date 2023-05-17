#Использовать cmdline
#Использовать logos
#Использовать "."

Функция ПолучитьПарсерКоманднойСтроки()
    
    Парсер = Новый ПарсерАргументовКоманднойСтроки();    
    МенеджерКомандПриложения.ЗарегистрироватьКоманды(Парсер);    
    Возврат Парсер;
    
КонецФункции

Функция ВыполнениеКоманды()

    Лог = ПараметрыСистемы.Лог;

    ПараметрыЗапуска = РазобратьАргументыКоманднойСтроки();
    Если ПараметрыЗапуска = Неопределено ИЛИ ПараметрыЗапуска.Количество() = 0 Тогда
        Лог.Ошибка("Некорректные аргументы командной строки");
        МенеджерКомандПриложения.ПоказатьСправкуПоКомандам();
        Возврат 1;
    КонецЕсли;

    ПараметрыКоманды = Новый Соответствие;

    // ToDo Прочитать данные из файла настроек

	ТекущийКаталогПроекта = НайтиКаталогТекущегоПроекта("");
	ПараметрыСистемы.КорневойПутьПроекта = ТекущийКаталогПроекта;
    ПутьКФайлуНастроекПоУмолчанию = ОбъединитьПути(ПараметрыСистемы.КорневойПутьПроекта, 
        ПараметрыСистемы.ИмяФайлаНастроек());

    НастройкиИзФайла = ОбщегоНазначения.ПрочитатьНастройкиФайлJSON(ПараметрыСистемы.КорневойПутьПроекта,
        ПараметрыЗапуска.ЗначенияПараметров["-settings"], ПутьКФайлуНастроекПоУмолчанию);
        
    Если НастройкиИзФайла.Количество() > 0 Тогда
        ОбщегоНазначения.ДополнитьАргументыИзФайлаНастроек(ПараметрыЗапуска.Команда, ПараметрыКоманды, НастройкиИзФайла);
    КонецЕсли;

    // Вставляем данные после разбора аргументов командной строки
    Для Каждого КлючЗначение Из ПараметрыЗапуска.ЗначенияПараметров Цикл
        ПараметрыКоманды.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
    КонецЦикла;

    // Загрузка дополнительных параметров
    ПараметрыКоманды.Вставить("ДанныеПодключения", 
        ОбщегоНазначения.ДанныеПодключения(ПараметрыКоманды));         

    Возврат ВыполнитьКоманду(ПараметрыЗапуска.Команда, ПараметрыКоманды);
    
КонецФункции

Функция ВыполнитьКоманду(Знач ИмяКоманды, Знач ПараметрыКоманды)
	
	Команда = МенеджерКомандПриложения.ПолучитьКоманду(ИмяКоманды);
	Возврат Команда.ВыполнитьКоманду(ПараметрыКоманды);

КонецФункции

Функция РазобратьАргументыКоманднойСтроки()

    Парсер = ПолучитьПарсерКоманднойСтроки();    
    Возврат Парсер.Разобрать(АргументыКоманднойСтроки);

КонецФункции

Функция НайтиКаталогТекущегоПроекта(Знач Путь)
	Рез = "";
	Если ПустаяСтрока(Путь) Тогда
		Попытка
			Команда = Новый Команда;
			Команда.УстановитьСтрокуЗапуска("git rev-parse --show-toplevel");
			Команда.УстановитьПравильныйКодВозврата(0);
			Команда.Исполнить();
			Рез = СокрЛП(Команда.ПолучитьВывод());
		Исключение
			// некуда выдавать ошибку, логи еще не доступны
		КонецПопытки;
	Иначе
		Рез = Путь;
	КонецЕсли;
	Возврат Рез;
КонецФункции // НайтиКаталогТекущегоПроекта()

/////////////////////////////////////////////////////////////////////////

ПараметрыСистемы.Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
УровеньЛога = УровниЛога.Отладка;

Попытка
	КодВозврата = ВыполнениеКоманды();
	ВременныеФайлы.Удалить();
	ЗавершитьРаботу(КодВозврата);
Исключение
    ПараметрыСистемы.Лог.КритичнаяОшибка(ОписаниеОшибки());
    ВременныеФайлы.Удалить();
    ЗавершитьРаботу(МенеджерКомандПриложения.РезультатыКоманд().ОшибкаВремениВыполнения);
КонецПопытки;
