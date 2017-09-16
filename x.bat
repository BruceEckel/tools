@echo off
pushd .
cd %GIT_HOME%\AtomicKotlinExtractedExamples
call gradlew clean
call bb code extract
call gradlew build
cd Examples
popd
