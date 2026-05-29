#Converts cards.xml to CSV compatible with importing into CubeCobra

$xml = [xml](Get-Content -Encoding UTF8 -Raw .\swc.xml)

$cardNodes = $xml.SelectNodes("//card")
$setNodes = $xml.SelectNodes("//set")
$setsNodes = $xml.SelectNodes("//sets")
$colorNodes = $xml.SelectNodes("//color")
$sideNodes = $xml.SelectNodes("//side")
$relatedNodes = $xml.SelectNodes("//related")

$dfcArray = @()
foreach($node in $cardNodes)
{
    if ($node.prop.type -like "Basic*"`
    -or $node.Name -like "*Token*"`
    -or $node.Name -like "*Emblem"`
    -or $node.Name -eq "TIE Fighter"`
    -or $node.Name -eq "Royal Guard"`
    -or $node.Name -eq "B-Wing"`
    -or $node.Name -eq "AT-AT"`
    -or $node.Name -eq "Crumb")
    {
        $node.ParentNode.RemoveChild($node) | Out-Null
    }
    
    if ($node.name -eq "Luke Skywalker"`
    -or $node.Name -eq "Yoda, Jedi Grand Master"`
    -or $node.Name -eq "Darth Sidious, Emperor"`
    -or $node.Name -eq "Darth Vader"`
    -or $node.Name -eq "Feed Your Anger"`
    -or $node.Name -eq "Planetary Shield Generator"`
    -or $node.Name -eq "Core Ship Obliteration"`
    -or $node.Name -eq "Echo Base"`
    -or $node.Name -eq "Embryo Chamber"`
    -or $node.Name -eq "Wookiee Militia"`
    -or $node.Name -eq "Journey Through the Core"`
    -or $node.Name -eq "Landing Pad"`
    -or $node.Name -eq "The First Galactic Empire"`
    -or $node.Name -eq "Trench Run")
    {
        $dfcArray += $node
        $node.ParentNode.RemoveChild($node) | Out-Null
    }
}

$cardNodes = $xml.SelectNodes("//card")
$cubeList = @()
foreach($node in $cardNodes)
{
    #if ($node.name -like "*é*")
    #{
    #    $node.name = $node.name.Replace("é", "e")
    #}

    $rarity = $node | Select @{n='rarity'; e={$_.set.rarity}}
    $picUrl = $node | Select @{n='picUrl'; e={$_.set.picUrl}}

    $rarityElement = $node.AppendChild($xml.CreateElement("rarity"))
    $rarityText = $xml.CreateTextNode($rarity.rarity)
    [void]$rarityElement.AppendChild($rarityText);

    $picUrlElement = $node.AppendChild($xml.CreateElement("picUrl"))
    $enElement = $picUrlElement.AppendChild($xml.CreateElement("en"))
    $enText = $xml.CreateTextNode($picUrl.picUrl)
    [void]$enElement.AppendChild($enText);

    if ($node.name -eq "Luke, Rebellious Youth"`
    -or $node.name -eq "Cryptic Hermit"`
    -or $node.name -eq "Chancellor Palpatine"`
    -or $node.name -eq "Anakin, Dark Apprentice"`
    -or $node.name -eq "The Battle of Coruscant"`
    -or $node.name -eq "The Battle of Endor"`
    -or $node.name -eq "The Battle of Geonosis"`
    -or $node.name -eq "The Battle of Hoth"`
    -or $node.name -eq "The Battle of Kamino"`
    -or $node.name -eq "The Battle of Kashyyyk"`
    -or $node.name -eq "The Battle of Naboo"`
    -or $node.name -eq "The Battle of Scarif"`
    -or $node.name -eq "The Battle of Utapau"`
    -or $node.name -eq "The Battle of Yavin")
    {
        foreach ($dfc in $dfcArray)
        {
            if ($node.related.innertext -eq $dfc.name)
            {
                $picUrl = $dfc | Select @{n='picUrl'; e={$_.set.picUrl}}
                $backElement = $node.AppendChild($xml.CreateElement("back"))

                $backPicUrlElement = $backElement.AppendChild($xml.CreateElement("backPicUrl"))
                $backEnElement = $backPicUrlElement.AppendChild($xml.CreateElement("backEn"))
                $backEnText = $xml.CreateTextNode($picUrl.picUrl)
                [void]$backEnElement.AppendChild($backEnText);
            }
        }   
    }
}

#$xml.Save(".\test.xml")

$outputArray = foreach ($card in $xml.cockatrice_carddatabase.cards.card)
{
    if ($card.back)
    {
        [PSCustomObject]@{
            "name" = $card.name
            "cmc" = $card.prop.cmc
            "type" = $card.prop.type
            "color" = $card.prop.colors
            "rarity" = $card.rarity
            "image URL" = $card.picURL.en
            "image Back URL" = $card.back.backPicUrl.BackEn
            "custom" = "TRUE"
        }
    }
    elseif ($card.prop.type -like "*Land*")
    {
        [PSCustomObject]@{
            "name" = $card.name
            "cmc" = $card.prop.cmc
            "type" = $card.prop.type
            "color" = $card.prop.coloridentity
            "rarity" = $card.rarity
            "image URL" = $card.picURL.en
            "image Back URL" = $card.back.backPicUrl.BackEn
            "custom" = "TRUE"
        }
    }
    else
    {
        [PSCustomObject]@{
            "name" = $card.name
            "cmc" = $card.prop.cmc
            "type" = $card.prop.type
            "color" = $card.prop.colors
            "rarity" = $card.rarity
            "image URL" = $card.picURL.en
            "image Back URL" = ""
            "custom" = "TRUE"
        }
    }
}
$OutPutArray | Export-csv -Encoding UTF8 -Path "C:\Users\Kevin\Desktop\CubeCobra.csv" -NoTypeInformation
