PATH=%PATH%;%WSDK81%\bin\x86;C:\Program Files\7-Zip;C:\Program Files (x86)\7-Zip

set VC_VERSION=1.24-Hotfix1-Preview
set SIGNINGPATH=%~dp0
cd %SIGNINGPATH%

call "..\..\doc\chm\create_chm.bat"

cd %SIGNINGPATH%

rem sign using SHA-1
signtool sign /v /sha1 1FE67EF0455A9CC11433542FEC0A86DDD644B405 /ac DigiCert_High_Assurance_MS_Cross_Cert.crt /fd sha1 /t http://timestamp.verisign.com/scripts/timestamp.dll "..\Release\Setup Files\veracrypt.sys" "..\Release\Setup Files\veracrypt-x64.sys"
signtool sign /v /sha1 1FE67EF0455A9CC11433542FEC0A86DDD644B405 /ac DigiCert_High_Assurance_Code_Signing_CA.cer /fd sha1 /t http://timestamp.verisign.com/scripts/timestamp.dll "..\Release\Setup Files\VeraCrypt.exe" "..\Release\Setup Files\VeraCrypt Format.exe" "..\Release\Setup Files\VeraCryptExpander.exe" "..\Release\Setup Files\VeraCrypt-x64.exe" "..\Release\Setup Files\VeraCrypt Format-x64.exe" "..\Release\Setup Files\VeraCryptExpander-x64.exe"

timeout /t 10

rem sign using SHA-256
signtool sign /v /sha1 04141E4EA6D9343CEC994F6C099DC09BDD8937C9 /ac GlobalSign_Root_CA_MS_Cross_Cert.crt /as /fd sha256 /tr http://timestamp.globalsign.com/?signature=sha2 /td SHA256 "..\Release\Setup Files\veracrypt.sys" "..\Release\Setup Files\veracrypt-x64.sys"
signtool sign /v /sha1 04141E4EA6D9343CEC994F6C099DC09BDD8937C9 /ac GlobalSign_SHA256_EV_CodeSigning_CA.cer /as /fd sha256 /tr http://timestamp.globalsign.com/?signature=sha2 /td SHA256 "..\Release\Setup Files\VeraCrypt.exe" "..\Release\Setup Files\VeraCrypt Format.exe" "..\Release\Setup Files\VeraCryptExpander.exe" "..\Release\Setup Files\VeraCrypt-x64.exe" "..\Release\Setup Files\VeraCrypt Format-x64.exe" "..\Release\Setup Files\VeraCryptExpander-x64.exe"


cd "..\Release\Setup Files\"

copy ..\..\LICENSE .
copy ..\..\License.txt .
copy ..\..\NOTICE .

del *.xml
rmdir /S /Q Languages
mkdir Languages
copy /V /Y ..\..\..\Translations\*.xml Languages\.
del Languages.zip
7z a -y Languages.zip Languages

rmdir /S /Q docs
mkdir docs\html\en
mkdir docs\EFI-DCS
copy /V /Y ..\..\..\doc\html\* docs\html\en\.
copy "..\..\..\doc\chm\VeraCrypt User Guide.chm" docs\.
copy "..\..\..\doc\EFI-DCS\*.pdf" docs\EFI-DCS\.

del docs.zip
7z a -y docs.zip docs

"VeraCrypt Setup.exe" /p
"VeraCrypt Portable.exe" /p

del LICENSE
del License.txt
del NOTICE
del "VeraCrypt User Guide.chm"

del Languages.zip
del docs.zip
rmdir /S /Q Languages
rmdir /S /Q docs

cd %SIGNINGPATH%

rem sign using SHA-1
signtool sign /v /sha1 1FE67EF0455A9CC11433542FEC0A86DDD644B405 /ac DigiCert_High_Assurance_Code_Signing_CA.cer /fd sha1 /t http://timestamp.verisign.com/scripts/timestamp.dll "..\Release\Setup Files\VeraCrypt Setup %VC_VERSION%.exe" "..\Release\Setup Files\VeraCrypt Portable %VC_VERSION%.exe"

timeout /t 10

rem sign using SHA-256
signtool sign /v /sha1 04141E4EA6D9343CEC994F6C099DC09BDD8937C9 /ac GlobalSign_SHA256_EV_CodeSigning_CA.cer /as /fd sha256 /tr http://timestamp.globalsign.com/?signature=sha2 /td SHA256 "..\Release\Setup Files\VeraCrypt Setup %VC_VERSION%.exe" "..\Release\Setup Files\VeraCrypt Portable %VC_VERSION%.exe"

pause
