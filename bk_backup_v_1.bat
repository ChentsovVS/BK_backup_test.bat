rem батник для проверки и бэкапирования станций BK
rem копирует необходимые данные (каталоги, сеть, имя пк) для дальнейшего восстановления
rem или пишет в лог.  
rem определяем переменные, создаем каталоги

powershell test-path c:\tmp_backup\ > set /p testpath=""
	if "testpath"=="false" 
		echo "folder tmp_backup not found" 
	else 
		del c:\tmp_backup
		echo "folder tmp_backup found, deleting dir"

set ucs=C:\UCS
set atol="C:\Program Files"

mkdir c:\tmp_backup\ | set tmp_dir=c:\tmp_backup

echo %date% > %tmp_dir%\tmp.txt
echo %date% > %tmp_dir%\log.txt
echo %date% > %tmp_dir%\xcopy_err.txt
echo %date% > %tmp_dir%\ipconfig.txt
echo %date% > %tmp_dir%\PCName.txt

set tmp=%tmp_dir%\tmp.txt
set log=%tmp_dir%\log.txt
set xcopy_err=%tmp_dir%\xcopy_err
set ipconf=%tmp_dir%\ipconfig.txt
set pcname=%tmp_dir%\PCName.txt

rem делаем проверку через powershell наличия каталога в директории и либо копируем либо нет

powershell test-path %atol%\Atol > set /p buffer="" 
	if "buffer"=="false"
		echo "folder atol not found, lookin it in path C:\Program Files\Atol" >%log% 
		set /p backup_dir=""  rem просто введи название каталога (пример - BK0494-ter1) 
		mkdir D:\%backup_dir% 
		 
	
	else
		mkdir D:\%backup_dir%\atol
		mkdir D:\%backup_dir%\atol814
		xcopy /e /h "C:\program files\atol" "D:\%backup_dir%\atol" 2> %log%
		xcopy /e /h "C:\program files\atol814" "D:\%backup_dir%\atol814" 2>> %log%
		dir d:\%backup_dir%\atol\
		dir d:\%backup_dir%\atol814\
	
ipconfig > %ipconf% 
%computername% > %pcname% 
xcopy /e /h "C:\UCS" "D:\%backup_dir%" 1> %xcopy_err% 2>&1
xcopy /e /h "%tmp_dir%\" "d:\%backup_dir%\"
dir D:\%backup_dir%\UCS\ 
findstr "0" %xcopy_err% 

break 

rem testpath - проверка наличия директории tmp_backup и удаление ее (если есть) 
rem ucs - каталог октуда берем данные, atol - каталог проверяющейся на наличие папки
rem tmp_dir - каталог файлов необхдимых для работы батника, tmp - временный файл. что то вроде отправнй точки, будем закидывать сюда данные по проверкам 
rem log - файл своего рода лог. сюда будет писаться действия файла, xcopy_err - вывод для ошибок xcopy
rem ipconf - файл вывода ifconfig - бэкап сети. pcname - файл вывода pcname - бэкап имени пк 
rem buffer - переменная для вывода true\false на наличие директории, backup_dir - папка бэкапа. вводится вручную 
