@echo off
cd %GIT_HOME%\ExtractedExamples
call gradlew clean
call bb code extract
call gradlew build
