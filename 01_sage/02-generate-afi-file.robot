*** Settings ***
Documentation   Busqueda de trabajadores en SAGE
...             Generación de AFI para enviar a TGSS y 
...             Generación de XML para enviar a SEPE
Library         RPA.Desktop.Windows
Library         RPA.Desktop
Library         RPA.Robocloud.Items
Library         Collections

*** Keywords ***
Buscar Trabajador
    [Arguments]    ${trabajador}
    Sleep   1

*** Keywords ***
Generar AFI
    Mouse CLick     method=image  image=${CURDIR}${/}images${/}menuGenerarAFI.png    off_y=350
    Sleep           10
    Send Keys       {VK_CONTROL down} {F4} {VK_CONTROL up}    # Cerrar Ventana
    Sleep           2


*** Tasks ***
Generate AFI File
    Set Task Variables From Work Item
    @{temp_trabajadores}    Create List    @{EMPTY}

    FOR    ${trabajador}    IN    @{trabajadores}
        Buscar Trabajador       ${trabajador}
        Generar AFI

        ${ficheroNombre}=       Generar AFI             ${AppNom}   ${trabajador}
        Set To Dictionary       ${trabajador}           ficheroXML=${ficheroNombre}
        
        Append To List          ${temp_trabajadores}    ${trabajador}
        
    END

    Set Work Item Variable  trabajadores  ${temp_trabajadores}
    Save Work Item
    
    Log  Done.
