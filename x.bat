@echo off
cd %GIT_HOME%\AtomicKotlin
rem if exist %GIT_HOME%\AtomicKotlin\ExtractedExamples (
rem  bb code clean
rem )
if exist %GIT_HOME%\AtomicKotlin\ExtractedExamples (
  cd %GIT_HOME%\AtomicKotlin\ExtractedExamples
  rm -rf Examples
)
bb code extract
cd %GIT_HOME%\AtomicKotlin\ExtractedExamples
gradlew build
