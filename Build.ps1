
$SOURCE_FILES = ".\Scripts\Source\*.psc"

$FORCE_RECOMPILE = $false
$PAPYRUS_FOLDER = ".\PAPYRUS"

$LOG_LEVEL = 1

$STATUS_COMPILED_SUCCESS = 1
$STATUS_COMPILED_FAILED = 2
$STATUS_COMPILED_SKIPPED = 3

function Log {

    param (
        [int] $Level,
        [string] $msg,
        [object] $object
    )

    if ($Level -ge $LOG_LEVEL) {
        if($object) {
            Write-Host "$msg : $object"
        } else {
            Write-Host $msg
        }
    }
}

function GenerateDiffFile {
    param (
        $file1,
        $file2,
        $diffFile
    )

    $process = Start-Process -Wait -NoNewWindow -PassThru -FilePath "git.exe" -ArgumentList "diff --patch --no-index --output=`"$diffFile`" `"$file1`" `"$file2`""

    $ret = [PSCustomObject]@{
        command = "git diff"
        file = $diffFile
        ExitCode = $process.ExitCode
        Status = if($process.ExitCode -eq 1) {$STATUS_COMPILED_SUCCESS} else {$STATUS_COMPILED_FAILED}
    }
    $ret
}

function Compile {
    param (
        $file
    )
    Log -Level 1 -msg "Compile" -object $file
    $filePath = $file | Split-Path -Parent
    $sourceBaseDir = $filePath | Split-Path -Parent
    $projectBaseDir = $sourceBaseDir | Split-Path -Parent
    $includeFile = $projectBaseDir + "\include.txt"
    $flagsFile = Resolve-Path "$PAPYRUS_FOLDER\Flags.flg"
    [string]$include = $filePath
    if([System.IO.File]::Exists($includeFile)) {
        $lines = Get-Content -Path $includeFile
        foreach ( $line in $lines ) {
            $path = Resolve-Path "$PAPYRUS_FOLDER\$line"
            $include = [string]::Join(';', $include, $path)
            Log -Level 0 -msg "Include " -object $path
        }
    }

    $originalFile = $sourceBaseDir + "\source_original\" + $file.BaseName + ".psc"
    if([System.IO.File]::Exists($originalFile)) {
        $diffFile = $sourceBaseDir + "\diff\" + $file.BaseName + ".patch";
        $ret = GenerateDiffFile -file1 $originalFile -file2 $file -diffFile $diffFile
        if($ret.Status -ne $STATUS_COMPILED_SUCCESS) {
            return $ret
        }
    }
    
    $process = Start-Process -Wait -NoNewWindow -PassThru -FilePath "$PAPYRUS_FOLDER\PapyrusCompiler.exe" -ArgumentList "`"$file`" -o=`"$sourceBaseDir`" -i=`"$include`" -optimize -f=`"$flagsFile`""

    $ret = [PSCustomObject]@{
        command = "PapyrusCompiler"
        file = $file
        ExitCode = $process.ExitCode
        Status = if($process.ExitCode -eq 0) {$STATUS_COMPILED_SUCCESS} else {$STATUS_COMPILED_FAILED}
    }
    $ret
}

function CompileIfNewest {
    param (
        $file
    )

    $sourceBaseDir = $file | Split-Path -Parent | Split-Path -Parent
    $pexFile = $sourceBaseDir + "\" + $file.BaseName + ".pex"
    Log -Level 0 -msg "Pex file" -object $pexFile
    if($FORCE_RECOMPILE) {
        Log -Level 0 -msg "Compile by force" -object $file
        Compile -file $file
    } else {
        if([System.IO.File]::Exists($pexFile)) {
            $pexFile = Get-Item $pexFile
            if ($file.LastWriteTime -gt $pexFile.LastWriteTime) {
                Log -Level 0 -msg "Compile by modification date" -object $file
                Compile -file $file
            } else {
                Log -Level 0 -msg "Skip by modification date" -object $file
                [pscustomobject]@{Status = $STATUS_COMPILED_SKIPPED}
            }
        } else {
            Log -Level 0 -msg "Compile by not compiled yet" -object $file
            Compile -file $file
        }
    }
}

$pscFiles = Get-ChildItem -Path $SOURCE_FILES -Force -Recurse -Exclude $PAPYRUS_FOLDER

foreach ( $pscFile in $pscFiles )
{
    Log -Level 0 -msg "Process" -object $pscFile
    $ret = CompileIfNewest -file $pscFile
    if($ret.Status -eq $STATUS_COMPILED_FAILED) {
        Write-Host "---"
        Write-Host "Build failed:"
        Write-Host "!" $ret.file.Name
        Write-Host "    -" $ret.command $ret.file
        Log -Level 0 -msg "Process result" -object $ret
        Exit
    } else {
        Log -Level 0 -msg "Process result" -object $ret
    }
}