$basics = Get-ChildItem | Where-Object {($_.name -like "Plains*") -or ($_.name -like "Island*") -or ($_.name -like "Swamp*") -or ($_.name -like "Mountain*") -or ($_.name -like "Forest*")} | Where-Object {$_.name -notlike "*Trooper*"}
$tokens = Get-ChildItem | Where-Object {($_.name -like "*Token*") -or ($_.name -like "*Emblem*") -or ($_.name -like "Crumb*")}
$dfc = Get-ChildItem | Where-Object {($_.name -like "Cryptic Hermit*") -or ($_.name -like "Anakin Dark*") -or ($_.name -like "Luke*") -or ($_.name -like "Chancellor*") -or ($_.name -like "*The Battle*")} | Where-Object {$_.name -notlike "*Emblem*"}

New-Item -Name "Cards" -ItemType "Directory"
New-Item -Name "Basics" -ItemType "Directory"
New-Item -Name "Tokens" -ItemType "Directory"
New-Item -Name "DFC" -ItemType "Directory"
New-Item -Name "PDF" -ItemType "Directory"
New-Item -Name "Montage" -ItemType "Directory" -Path .\Cards
New-Item -Name "Montage" -ItemType "Directory" -Path .\Basics
New-Item -Name "Montage" -ItemType "Directory" -Path .\Tokens
New-Item -Name "Montage" -ItemType "Directory" -Path .\DFC

foreach ($image in $basics)
{
    Move-Item $image -Destination .\Basics
}

foreach ($image in $tokens)
{
    Move-Item $image -Destination .\Tokens
}

foreach ($image in $dfc)
{
    Move-Item $image -Destination .\DFC
}

$cards = Get-ChildItem | Where-Object {$_.Extension -eq ".jpg"}
foreach ($image in $cards)
{
    Move-Item $image -Destination .\Cards
}

$sortedTokens = Get-ChildItem -Path .\Tokens
foreach ($token in $sortedTokens)
{
    if (($token.name -like "AT-AT*") -or ($token.name -like "B-Wing*"))
    {
        $i = 0
        While ($i -lt 1) 
        {
            $i += 1
            $NewName = Join-Path -Path $token.Directory -ChildPath ($token.BaseName + " ($i)" + $token.Extension)
            Copy-Item -Path $token.FullName -Destination $NewName
        }
    }

    elseif (($token.name -like "Gungan*") -or ($token.name -like "Royal Guard*"))
    {
        $i = 0
        While ($i -lt 3) 
        {
            $i += 1
            $NewName = Join-Path -Path $token.Directory -ChildPath ($token.BaseName + " ($i)" + $token.Extension)
            Copy-Item -Path $token.FullName -Destination $NewName
        }
    }

    elseif (($token.name -like "Rebel Soldier*") -or ($token.name -like "Tusken*") -or ($token.name -like "TIE*"))
    {
        $i = 0
        While ($i -lt 5) 
        {
            $i += 1
            $NewName = Join-Path -Path $token.Directory -ChildPath ($token.BaseName + " ($i)" + $token.Extension)
            Copy-Item -Path $token.FullName -Destination $NewName
        }
    }

    elseif (($token.name -like "Droid*") -or ($token.name -like "Ewok*") -or ($token.name -like "Trooper*"))
    {
        $i = 0
        While ($i -lt 6) 
        {
            $i += 1
            $NewName = Join-Path -Path $token.Directory -ChildPath ($token.BaseName + " ($i)" + $token.Extension)
            Copy-Item -Path $token.FullName -Destination $NewName
        }
    }

    elseif ($token.name -like "Meditate*")
    {
        $i = 0
        While ($i -lt 7) 
        {
            $i += 1
            $NewName = Join-Path -Path $token.Directory -ChildPath ($token.BaseName + " ($i)" + $token.Extension)
            Copy-Item -Path $token.FullName -Destination $NewName
        }
    }
}

$images = Get-ChildItem -Path .\Cards | Where-Object {$_.Extension -eq ".jpg"}
$i = 0
$k=1
while ($i -lt $images.count)
{
    $j=0
    $montage = @()
    while ($j -lt 9)
    {
        $montage += $images[$i].FullName
        $j++
        $i++
    }
    magick montage -geometry 750x1050 -tile 3x3 $montage .\Cards\Montage\montage$k.jpg
    $k++
}

$images = Get-ChildItem -Path .\Basics | Where-Object {$_.Extension -eq ".jpg"}
$i = 0
$k=1
while ($i -lt $images.count)
{
    $j=0
    $montage = @()
    while ($j -lt 9)
    {
        $montage += $images[$i].FullName
        $j++
        $i++
    }
    magick montage -geometry 750x1050 -tile 3x3 $montage .\Basics\Montage\montage$k.jpg
    $k++
}

$images = Get-ChildItem -Path .\Tokens | Where-Object {$_.Extension -eq ".jpg"}
$i = 0
$k=1
while ($i -lt $images.count)
{
    $j=0
    $montage = @()
    while ($j -lt 9)
    {
        $montage += $images[$i].FullName
        $j++
        $i++
    }
    magick montage -geometry 750x1050 -tile 3x3 $montage .\Tokens\Montage\montage$k.jpg
    $k++
}

Set-Location .\DFC
magick -size 750x1050 canvas:white blank.jpg
magick montage -geometry 750x1050 -tile 3x3 "Anakin Dark Apprentice.jpg" "Chancellor Palpatine.jpg" "Cryptic Hermit.jpg" "Luke Rebellious Youth.jpg" "The Battle of Coruscant.jpg" "The Battle of Endor.jpg" "The Battle of Geonosis.jpg" "The Battle of Hoth.jpg" "The Battle of Kamino.jpg" .\Montage\montage1.jpg
magick montage -geometry 750x1050 -tile 3x3 "Cryptic Hermit-Yoda Jedi Grand Master.jpg" "Chancellor Palpatine-Darth Sidious Emperor.jpg" "Anakin Dark Apprentice-Darth Vader.jpg" "The Battle of Endor-Planetary Shield Generator.jpg" "The Battle of Coruscant-Feed Your Anger.jpg" "Luke Rebellious Youth-Luke Skywalker.jpg" "The Battle of Kamino-Embryo Chamber.jpg" "The Battle of Hoth-Echo Base.jpg" "The Battle of Geonosis-Core Ship Obliteration.jpg" .\Montage\montage2.jpg
magick montage -geometry 750x1050 -tile 3x3 "The Battle of Kashyyyk.jpg" "The Battle of Naboo.jpg" "The Battle of Scarif.jpg" "The Battle of Utapau.jpg" "The Battle of Yavin.jpg" .\Montage\montage3.jpg
magick montage -geometry 750x1050 -tile 3x3 "The Battle of Scarif-Landing Pad.jpg" "The Battle of Naboo-Journey Through the Core.jpg" "The Battle of Kashyyyk-Wookiee Militia.jpg" "Blank.jpg" "The Battle of Yavin-Trench Run.jpg" "The Battle of Utapau-The First Galactic Empire.jpg" .\Montage\montage4.jpg
Set-Location ..

function ConvertToPdf($files, $outFile) 
{
    Add-Type -AssemblyName System.Drawing
    $files = @($files)
    if (!$outFile) 
    {
        $firstFile = $files[0] 
        if ($firstFile.FullName) 
        { 
            $firstFile = $firstFile.FullName 
        }
        $outFile = $firstFile.Substring(0, $firstFile.LastIndexOf(".")) + ".pdf"
    } else 
    {
        if (![System.IO.Path]::IsPathRooted($outFile)) 
        {
            $outFile = [System.IO.Path]::Combine((Get-Location).Path, $outFile)
        }
    }

    try 
    {
        $doc = [System.Drawing.Printing.PrintDocument]::new()
        $opt = $doc.PrinterSettings = [System.Drawing.Printing.PrinterSettings]::new()
        $opt.PrinterName = "Microsoft Print to PDF"
        $opt.PrintToFile = $true
        $opt.PrintFileName = $outFile

        $script:_pageIndex = 0
        $doc.add_PrintPage({
            param($sender, [System.Drawing.Printing.PrintPageEventArgs] $a)
            $file = $files[$script:_pageIndex]
            if ($file.FullName) {
                $file = $file.FullName
            }
            $script:_pageIndex = $script:_pageIndex + 1

            try 
            {
                $rect = new-object Drawing.Rectangle 40, 40, 718, 1003
                $image = [System.Drawing.Image]::FromFile($file)
                $a.Graphics.DrawImage($image, $rect)
                $a.HasMorePages = $script:_pageIndex -lt $files.Count
            }
            finally {
                $image.Dispose()
            }
        })

        $doc.PrintController = [System.Drawing.Printing.StandardPrintController]::new()

        $doc.Print()
        return $outFile
    }
    finally {
        if ($doc) { $doc.Dispose() }
    }
}

Set-Location .\Cards\Montage
ConvertToPdf (gi *.jpg| sort Name) ..\..\PDF\Cards.pdf

Set-Location ..\..\Basics\Montage
ConvertToPdf (gi *.jpg| sort Name) ..\..\PDF\Basics.pdf

Set-Location ..\..\Tokens\Montage
ConvertToPdf (gi *.jpg| sort Name) ..\..\PDF\Tokens.pdf

Set-Location ..\..\DFC\Montage
ConvertToPdf (gi *.jpg| sort Name) ..\..\PDF\DFC.pdf

Set-Location ..\..