@echo off
rem Licensed to the Apache Software Foundation (ASF) under one or more
rem contributor license agreements.  See the NOTICE file distributed with
rem this work for additional information regarding copyright ownership.
rem The ASF licenses this file to You under the Apache License, Version 2.0
rem (the "License"); you may not use this file except in compliance with
rem the License.  You may obtain a copy of the License at
rem
rem     http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.

setlocal enabledelayedexpansion

IF [%1] EQU [] (
	echo USAGE: %0 classname [opts]
	EXIT /B 1
)
rem Using pushd popd to set BASE_DIR to the absolute path 
pushd %~dp0..\..
set BASE_DIR=%CD%
popd
set CLASSPATH=

IF ["%SCALA_VERSION%"] EQU [""] (
	set SCALA_VERSION=2.8.0
)

rem Assume all dependencies have been packaged into one jar with sbt-assembly's task "assembly-package-dependency"
for %%i in (%BASE_DIR%\core\target\scala-%SCALA_VERSION%\*.jar) do (
	call :concat %%i
)

for %%i in (%BASE_DIR%\perf\target\scala-%SCALA_VERSION%\kafka*.jar) do (
	call :concat %%i
)

rem Classpath addition for release
for %%i in (%BASE_DIR%\libs\*.jar) do (
	call :concat %%i
)
for %%i in (%BASE_DIR%\kafka_*.jar) do (
	call :concat %%i
)


rem JMX settings
IF ["%KAFKA_JMX_OPTS%"] EQU [""] (
	set KAFKA_JMX_OPTS=-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false  -Dcom.sun.management.jmxremote.ssl=false
)

rem JMX port to use
IF ["%JMX_PORT%"] NEQ [""] (
	set KAFKA_JMX_OPTS=%KAFKA_JMX_OPTS% -Dcom.sun.management.jmxremote.port=%JMX_PORT%
)

rem Log4j settings
IF ["%KAFKA_LOG4J_OPTS%"] EQU [""] (
	set KAFKA_LOG4J_OPTS=-Dlog4j.configuration=file:%BASE_DIR%\config\tools-log4j.properties
)

rem Generic jvm settings you want to add
IF ["%KAFKA_OPTS%"] EQU [""] (
  set KAFKA_OPTS=
)


rem Which java to use
IF ["%JAVA_HOME%"] EQU [""] (
	set JAVA=java
) ELSE (
	set JAVA="%JAVA_HOME%/bin/java"
)

rem Memory options
IF ["%KAFKA_HEAP_OPTS%"] EQU [""] (
  set KAFKA_HEAP_OPTS=-Xmx256M
)

rem JVM performance options
IF ["%KAFKA_JVM_PERFORMANCE_OPTS%"] EQU [""] (
  set KAFKA_JVM_PERFORMANCE_OPTS=-server -XX:+UseCompressedOops -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+CMSScavengeBeforeRemark -XX:+DisableExplicitGC -Djava.awt.headless=true
)

set COMMAND=%JAVA% %KAFKA_HEAP_OPTS% %KAFKA_JVM_PERFORMANCE_OPTS% %KAFKA_JMX_OPTS% %KAFKA_LOG4J_OPTS% -cp %CLASSPATH% %KAFKA_OPTS% %*
rem echo.
rem echo %COMMAND%
rem echo.

%COMMAND%

goto :eof
:concat
set CLASSPATH=%CLASSPATH%;"%1"
