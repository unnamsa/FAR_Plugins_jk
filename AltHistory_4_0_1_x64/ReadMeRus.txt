 Плагин для FAR - "Альтернативная история"
 Версия 4.0.2 от 24.09.2021


 Возможности и ограничения:

 + Все основные возможности стандартных историй FAR.
 + Фильтрация истории по введенной строке для ускорения поиска нужного
   элемента.
 + Ручное и автоматическое управление размером истории.
 + Очистка историй папок, просмотра и редактирования файлов от
   несуществующих более элементов или произвольных элементов.
 + Вызов историй с установленным фильтром из командной строки, что
   позволяет, например, вызывать плагин из пользовательского меню.
 + Копирование из историй папок, просмотра и редактирования в
   командную строку и буфер обмена с квотированием элементов, если в
   именах есть пробелы.
 + Переход из окна истории просмотра и редактирования к выбранному
   файлу.
 - Минимально необходимая версия FAR - 3.0 build 4414.

 Все подробности по использованию смотрите во встроенной справочной
 системе.


 Установка:

   Для установки создайте папку с любым именем в папке Far\Plugins,
 скопируйте туда файлы AltHistory.dll, *.lng, *.hlf из данного
 дистрибутива и перезагрузите FAR. Для более удобного использования
 плагина можно назначить его функциям горячие клавиши (скопируйте
 Config\AltHistory.lua из папки с распакованным дистрибутивом плагина,
 в %FARPROFILE%\Macros\scripts, чтобы переопределить клавиши вызова
 стандартных историй на альтернативные).

 Удаление:
   Удалите конфигурационный файл плагина
 %FARPROFILE%\PluginsData\FF8FC1AE-0F35-4134-9BAB-56D71B1D47B9.db, выйдите из
 FAR и сотрите папку с плагином,  которую Вы создали при установке, а также
 папку, в которой хранились файлы истории. Если Вы копировали AltHistory.lua в
 %FARPROFILE%\Macros\scripts, то удалите его.


 Последние версии плагина доступны по адресу:
   http://plugring.farmanager.com/plugin.php?pid=673
 Анонсы плагина:
   http://forum.farmanager.com/viewtopic.php?f=11&t=1602
 Обсуждение плагина:
   http://forum.farmanager.com/viewtopic.php?f=5&t=1608


    Лицензионное соглашение:

 (С) 2004-2021 SNSoft,  snsoft13[dog]rambler.ru

   Данный продукт поставляется КАК ЕСТЬ. Автор не несет никакой
 ответственности за ущерб, нанесенный в результате его использования.
   Продукт может распространяться СВОБОДНО при условии сохранения
 комплекта поставки и данного текста в неизменном виде.

   В продукте используются материалы из проекта с открытым исходным кодом
 Far Manager - https://www.farmanager.com - под следующей лицензией:

Copyright © 2011 Far Group
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of the authors may not be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR `AS IS' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
