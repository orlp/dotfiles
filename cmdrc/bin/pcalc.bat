@if "%1"=="" goto noarg

@python3 -c "from __future__ import print_function; from math import *; from collections import *; (lambda x=None: x is None or print(x))(%*)"

:noarg
@python3 -i "%~dp0\..\..\pcalc\setup_env.py"
