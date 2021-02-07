*** Settings ***
Documentation   Busqueda de trabajadores en SAGE
...             Generación de AFI para enviar a TGSS y 
...             Generación de XML para enviar a SEPE
Library         RPA.Desktop.Windows
# Library         RPA.Desktop
Library         RPA.Robocloud.Items
Library         Collections
Library         TreatFiles

*** Variables ***
${LOCATOR_IMPORT_CANCELAR}=     image:${CURDIR}${/}images${/}botonesFinalImportacion.png
${LOCATOR_IMPORT_ACEPTAR}=      image:${CURDIR}${/}images${/}botonesFinalImportacion.png

*** Keywords ***
Open Sage Despachos
    ${app}  Open Executable   "C:\\Program Files (x86)\\Sage\\Sage Despachos Connected\\DespachosFLc.exe"   Sage Despachos Connected    
    Wait For Element  id:12     timeout = 30    interval=1.5
    # Sleep   15s
    # RPA.Desktop.Windows.Wait For Element    image:${CURDIR}${/}images${/}SageDespachosLogin.png   timeout=20
    # Mouse CLick     method=image  image=${CURDIR}${/}images${/}SageDespachosLogin.png
    Mouse Click     id:12

    @{windows}    Get Window List
    FOR  ${window}  IN  @{windows}

        #${pid_nomina}=    ${window}[pid]
        ${result}   Evaluate    '${window}[title]' != '${EMPTY}' and '${window}[title]' == 'Sage Despachos Connected'
        ${appSage} =	Set Variable If	    ${result}	 ${window}[pid] 
        Exit For Loop If  ${result}
         
        Log     ${result}
    END
    
    Log     ${appSage}
    Log     ${app}
    [Return]    ${appSage}

*** Keywords ***
Seleccionar Empresa
    [Arguments]     ${app}  ${empresaID}
    Connect by pid     ${app}
    Send Keys       {VK_MENU down} E {VK_MENU up}
    Send Keys       ${empresaID}
    Send Keys       {ENTER}
    Send Keys       {ENTER}
    Send Keys       {ENTER}


*** Keywords ***
Seleccionar Modulo
    [Arguments]     ${app}  ${menu}
    Connect by pid     ${app}
    Mouse CLick     method=image  image=${CURDIR}${/}images${/}MenuModulo.png   off_x=-65
    
    FOR     ${i}    IN RANGE    8
        Send Keys   {UP}
    END
    
    FOR     ${i}    IN RANGE    ${menu}
        Send Keys   {DOWN}
    END

    Send Keys       {ENTER}



*** Keywords ***
Login Sage Despachos
    [Arguments]     ${app}
    Connect by pid     ${app}
    #Mouse Click  id:12
    Send Keys  Vasalto12345 {ENTER}

# +
*** Keywords ***
Acceder Menu Empleados
    Sleep           5
    Mouse CLick     method=image  image=${CURDIR}${/}images${/}menuEmpleados.png
    Send Keys       {DOWN}
    Send Keys       {DOWN}
    Send Keys       {ENTER}

*** Keywords ***
Acceder Menu Importaciones e Importar
    [Arguments]     ${app}
    Sleep           5
    Mouse CLick     method=image  image=${CURDIR}${/}images${/}menuImportacion.png
    Send Keys       {DOWN}
    Send Keys       {DOWN}
    Send Keys       {RIGHT}
    
    Send Keys       {ENTER}
    
    Sleep           5
 
    FOR     ${i}    IN RANGE    18
        Send Keys   {DOWN}
    END
    
    # Siguiente, siguiente ...
    Send Keys       {VK_MENU down} S {VK_MENU up}
    Send Keys       {VK_MENU down} S {VK_MENU up}

    Sleep           2
    Mouse CLick     method=image  image=${CURDIR}${/}images${/}botonEjecutar.png
    Sleep           30
    
    # Click en la pantalla principal para iniciar tabuladores hasta el boton Cancelar, Aceptar o Incidencias
    # RPA.Desktop.Click    coordinates:500,200

    # Cancelar son 3 TAB y un ENTER. Es comodo para probar y no subir el fichero
    # Apetar es un TAB mas, ya que el orden de los botones es primero Cancelar y luego Aceptar
    Send Keys       {TAB}
    Sleep           1
    Send Keys       {TAB}
    Sleep           1
    Send Keys       {TAB}
    Sleep           1
    Send Keys       {TAB}
    Sleep           1
    Send Keys       {ENTER}

    Connect by pid     ${app}
    Mouse Click    method=image    image=${CURDIR}${/}images${/}menuResultadoImportacion.png    off_y=25


*** Keywords ***
Buscar Trabajador
    [Arguments]    ${app}     ${trabajador}
    Connect by pid     ${app}
    Sleep   2
#    Mouse Click     id:11      Boton de filtradp
    Mouse CLick     method=image  image=${CURDIR}${/}images${/}pestanaEmpleados.png
    Sleep   1
    Send Keys       {VK_MENU down} V {VK_MENU up} T {ESC}    # Ver Todos
    Sleep   3

    # Buscador por NIF
    Connect by pid    ${app}
    Mouse CLick       method=image  image=${CURDIR}${/}images${/}pestanaEmpleados.png    off_y=100    off_x=-25    ctype=double
    Mouse CLick       method=image  image=${CURDIR}${/}images${/}pestanaEmpleados.png    off_y=100    off_x=-25    ctype=double
    Send Keys         {ENTER}
    Sleep             1
    Send Keys         {DEL}
    Sleep             1

#    Type Keys         02878589R 
    Type Keys         ${trabajador}[numDocumento] 
    Sleep   1
    Send Keys         {ENTER}

    Sleep   2
    Send Keys       {VK_MENU down} P {VK_MENU up} M {ESC}    # Procesos Mantenimiento


*** Keywords ***
Generar AFI
    [Arguments]     ${app}     ${trabajador}
    ${nombreFicheroAFI}=    Set Variable    filenmaeAFI
    Connect by pid     ${app}
    Sleep    2
    Mouse CLick     method=image  image=${CURDIR}${/}images${/}menuGenerarAFI.png    off_y=350
    Sleep           2

    Send Keys       {VK_CONTROL down} N {VK_CONTROL up}    # Insertar Registro (Ctrl+N)
    Sleep           2
    Send Keys       {TAB} MA {TAB} 
    Send Keys       {VK_CONTROL down} C {VK_CONTROL up}    # Para copiar la fecha que sale por defecto
    Sleep           1
    Send Keys       ${trabajador}[fechaAlta]               # Introducimos la fecha de Alta
    Sleep           1

    Send Keys       {VK_CONTROL down} A {VK_CONTROL up}    # Aceptar Cambios (Ctrl+A)
    Sleep           1
    Send Keys       {DOWN}
    Send Keys       {DOWN}
    Send Keys       {DOWN}
    Sleep           1

    Send Keys       {VK_CONTROL down} V {VK_CONTROL up}    # Para pegar la fecha que sale por defecto
    Sleep           1

    Send Keys       {VK_CONTROL down} A {VK_CONTROL up}    # Aceptar Cambios (Ctrl+A) No entiendo porqué hay que pulsar dos veces

    Send Keys       {VK_CONTROL down} N {VK_CONTROL up}    # Para cerrar el Nuevo registro y que lo de por terminado
    Sleep           1
    Send Keys       {VK_CONTROL down} G {VK_CONTROL up}    # Generar Fichero AFI (Ctrl+G)
    Sleep           5
    # Salir
    Send Keys       {VK_MENU down} S {VK_MENU up}

    ${nombreFicheroAFI} =   get FileName    AFI

    
    [Return]        ${nombreFicheroAFI}    
}

*** Keywords ***
Generar XML
    [Arguments]     ${app}     ${trabajador}
    ${nombreFicheroXML}=    Set Variable    filenmaeXML

#    Mouse CLick     method=image  image=${CURDIR}${/}images${/}opcionDatosAfiliacion.png
    Sleep           2
    Mouse CLick     method=image  image=${CURDIR}${/}images${/}menuGenerarContrato.png    off_y=70
    Sleep           1
    Send Keys       {VK_MENU down} N {VK_MENU up}
    Sleep           10
    Send Keys       {VK_CONTROL down} {F4} {VK_CONTROL up}    # Cerrar Ventana
    Sleep           2
    
    Mouse CLick     method=image  image=${CURDIR}${/}images${/}menuGenerarContrato.png    off_y=95
    Sleep           20

    # Siguiente, siguiente ...
    Send Keys       {VK_MENU down} S {VK_MENU up}
    Sleep           0.5s
    Send Keys       {VK_MENU down} S {VK_MENU up}

    FOR     ${i}    IN RANGE    6
        Send Keys   {TAB}
        Sleep           0.5s
    END

    Send Keys       {ENTER}
    Sleep           2

    Send Keys       {VK_CONTROL down} G {VK_CONTROL up}    # Generar Fichero XML
    Sleep           2
    # Si, generar
    Send Keys       {VK_MENU down} S {VK_MENU up}

    Send Keys       {ESC}    # Cerrar Ventana
    Sleep           2


    ${nombreFicheroXML} =   get FileName    XML

    [Return]        ${nombreFicheroXML}


*** Keywords ***
Wait For Element Before Clicking
    [Arguments]    ${locator}    ${timeout}=5    ${offset_x}=0    ${offset_y}=0
    RPA.Desktop.Wait For Element     ${locator}  timeout=${timeout}
    RPA.Desktop.Click With Offset    ${locator}   x=${offset_x}    y=${offset_y}

*** Tasks ***
Minimal task
    ${appID}    Open Sage Despachos
    Login Sage Despachos    ${appID}
    Seleccionar Empresa     ${appID}    16
    Seleccionar Modulo      ${appID}    7
    Acceder Menu Importaciones e Importar    ${appID}
    Seleccionar Modulo      ${appID}    3
    Acceder Menu Empleados

    Set Task Variables From Work Item
    @{temp_trabajadores}    Create List    @{EMPTY}

    FOR    ${trabajador}    IN    @{trabajadores}
        Buscar Trabajador       ${appID}   ${trabajador}

        ${ficheroNombre}=       Generar AFI             ${appID}   ${trabajador}
        Set To Dictionary       ${trabajador}           ficheroAFI=${ficheroNombre}

        ${ficheroNombre}=       Generar XML             ${appID}   ${trabajador}
        Set To Dictionary       ${trabajador}           ficheroXML=${ficheroNombre}

        Append To List          ${temp_trabajadores}    ${trabajador}

        Sleep           5
        Send Keys       {VK_CONTROL down} {F4} {VK_CONTROL up}    # Cerrar Ventana
        
    END

    Set Work Item Variable  trabajadores  ${temp_trabajadores}
    Save Work Item

    Send Keys    {VK_CONTROL down} {F4} {VK_CONTROL up}    # Cerrar Lista de Empleados
    Sleep        2
    Send Keys    {VK_MENU down} {F4} {VK_MENU up}    # Cerrar SAGE


    Log  Done.
