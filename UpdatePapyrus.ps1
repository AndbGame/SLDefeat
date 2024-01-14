$PAPYRUS_FOLDER = ".\PAPYRUS"

if(Test-Path -Path $PAPYRUS_FOLDER) {
    Start-Process -Wait -NoNewWindow -PassThru -WorkingDirectory $PAPYRUS_FOLDER -FilePath "git" -ArgumentList "pull"
} else {
    Start-Process -Wait -NoNewWindow -PassThru -FilePath "git" -ArgumentList "clone git@github.com:AndrejAndb/SLDefeatPapyrus.git $PAPYRUS_FOLDER"
}