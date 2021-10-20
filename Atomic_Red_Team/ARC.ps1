cls
######################################################################
############################  IMPORTS  ###############################
######################################################################

######################################################################
##########################  VARIABLES  ###############################
######################################################################
$ARCPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$AtomicFolder = $ARCPath + "\Atomics"
$LogFolder = $ARCPath + "\Logs"
######################################################################
########################  PREPARACION  ###############################
######################################################################
cd $ARCPAth
######################################################################
############################  MENUS  #################################
######################################################################
function Show-Menu-Initial
{     
    cls
	Write-Host "           .---.        .-----------"
    Write-Host "          /     \  __  /    ------  "
    Write-Host "         / /     \(..)/    -----    "
    Write-Host "        //////   ' \/ `   ---       "
    Write-Host "       //// / // :    : ---         "
    Write-Host "      // /   /  /`    '--           "
    Write-Host "     //          //..\\             "
    Write-Host "    /       ====UU====UU====        "
    Write-Host "                '//||\\`ATOMIC RED CANARY - CONSOLE"
    Write-Host "=============================================================="
    Write-Host "U: Pulsa 'U' para Instalar/Actualizar ARC."
    Write-Host "L: Pulsa 'L' para listar Resumen tecnicas"
    Write-Host "D: Pulsa 'D' para listar Detalles de tecnicas"
    Write-Host "R: Pulsa 'R' para ejecutar una tecnica"
    Write-Host "C: Pulsa 'C' para hacer un Cleanup de una tecnica"
    Write-Host "Q: Pulsa 'Q' para salir."
    Write-Host "=============================================================="
}

######################################################################
###########################  FUNCIONES  ##############################
######################################################################

######################################################################
#################   ATOMIC RED CANARY API   ##########################
######################################################################
function Install-FrameworkandFolder()
{   
    $RutaInstalador = $ARCPath + "\install-atomicredteam.ps1"
    IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing); Install-AtomicRedTeam -getAtomics -Force -InstallPath $ARCPath
}

function ListTechniquesBrief([String] $Technique)
{
    $ModuleAtomic = $ARCPath + "\invoke-atomicredteam" + "\Invoke-AtomicRedTeam.psd1"
    Import-Module $ModuleAtomic -Force
    Invoke-AtomicTest $Technique -ShowDetailsBrief -Path $AtomicFolder
} 

function ListTechniquesDetails([String] $Technique)
{
    $ModuleAtomic = $ARCPath + "\invoke-atomicredteam" + "\Invoke-AtomicRedTeam.psd1"
    Import-Module $ModuleAtomic -Force
    Invoke-AtomicTest $Technique -ShowDetails -Path $AtomicFolder
} 

function RunTechnique([String] $Technique)
{
    $ModuleAtomic = $ARCPath + "\invoke-atomicredteam" + "\Invoke-AtomicRedTeam.psd1"
    $LogFile = $LogFolder + "\log_" + $Technique + "_" + (Get-Date -Format "yyyyMMddHHmm") + ".csv"
    Import-Module $ModuleAtomic -Force
    Invoke-AtomicTest $Technique -Path $AtomicFolder -GetPrereqs
    Invoke-AtomicTest $Technique -Path $AtomicFolder -CheckPrereqs
    Invoke-AtomicTest $Technique -Path $AtomicFolder -ExecutionLogPath $LogFile -Confirm:$false
} 

function CleanTechnique([String] $Technique)
{
    $ModuleAtomic = $ARCPath + "\invoke-atomicredteam" + "\Invoke-AtomicRedTeam.psd1"
    $LogFile = $LogFolder + "\log_" + $Technique + "_" + (Get-Date -Format "yyyyMMddHHmm") + ".csv"
    Import-Module $ModuleAtomic -Force
    Invoke-AtomicTest $Technique -Path $AtomicFolder -ExecutionLogPath $LogFile -Cleanup
} 

function OcultaBarraProgreso()
{    
    Write-Progress -Activity "ARC" -Status "Ready" -Completed
}

######################################################################
############################  MAIN  ##################################
######################################################################

do
{
     Show-Menu-Initial
     $input = Read-Host "Selecciona una opción"
     switch ($input)
     {
        'U' {
            cls
            Install-FrameworkandFolder
            Continue
        } 'L' {
            cls
            $Techn = Read-Host "Indique Tecnica a listar o 'All' para todas:"
            cls
            ListTechniquesBrief -Technique $Techn
            OcultaBarraProgreso
            pause
        } 'D' {
            cls
            $Techn = Read-Host "Indique Tecnica a listar:"
            cls
            ListTechniquesDetails -Technique $Techn
            OcultaBarraProgreso
            pause
        } 'R' {
            cls
            $Techn = Read-Host "Indique Tecnica a ejecutar:"
            cls
            RunTechnique -Technique $Techn
            OcultaBarraProgreso
            pause
        } 'C' {
            cls
            $Techn = Read-Host "Indique Tecnica a limpiar:"
            cls
            CleanTechnique -Technique $Techn
            OcultaBarraProgreso
            pause
        } 'q' {
            cls
            exit
        }
     }
}until ($input -eq 'q')


######################################################################
######################################################################
######################################################################
