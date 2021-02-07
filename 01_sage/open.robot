# -*- coding: utf-8 -*-
*** Settings ***
Documentation   Busqueda de trabajadores en SAGE
...             Generación de AFI para enviar a TGSS y 
...             Generación de XML para enviar a SEPE
Library         RPA.Desktop.Windows    WITH NAME    Windows
Library         RPA.Desktop            WITH NAME    Desktop
Library         RPA.Robocloud.Items
Library         Collections

*** Variables ***
${LOCATOR_IMPORT_CANCELAR}=     image:${CURDIR}${/}images${/}botonesFinalImportacion.png
${LOCATOR_IMPORT_ACEPTAR}=      image:${CURDIR}${/}images${/}botonesFinalImportacion.png

*** Keywords ***
Open Sage Despachos
    ${app}  Open Executable   "C:\\Program Files (x86)\\Sage\\Sage Despachos Connected\\DespachosFLc.exe"   Sage Despachos Connected    
    
    Desktop.Wait For Element    image:"${CURDIR}${/}images${/}SageDespachosLogin.png"   timeout=20
    Windows.Mouse CLick     method=image  image=${CURDIR}${/}images${/}SageDespachosLogin.png


*** Tasks ***
Minimal task
    Open Sage Despachos


