@echo off
SET /A a = 5 
SET /A b = 10 
SET /A c = %a% + %b% 
:loop
goto loop
