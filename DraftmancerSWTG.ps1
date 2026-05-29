#Converts cards.xml to JSON compatible with draftmancer.com, and appends a cube list for use with the same site.

$xml = [xml](Get-Content -Raw .\swc.xml)

$cardNodes = $xml.SelectNodes("//card")
$setNodes = $xml.SelectNodes("//set")
$setsNodes = $xml.SelectNodes("//sets")
$colorNodes = $xml.SelectNodes("//color")
$ptNodes = $xml.SelectNodes("//pt")
$tablerowNodes = $xml.SelectNodes("//tablerow")
$sideNodes = $xml.SelectNodes("//side")
$relatedNodes = $xml.SelectNodes("//related")
$textNodes = $xml.SelectNodes("//text")

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
    if ($node.name -like "*é*")
    {
        $node.name = $node.name.Replace("é", "e")
    }

    $rarity = $node | Select @{n='rarity'; e={$_.set.rarity}}
    $picUrl = $node | Select @{n='picUrl'; e={$_.set.picUrl}}
    $node.text = $node.text  -replace "\n","\n" -replace "â€`”","-" -replace "`"","\`"" -replace "â€¢","•"

    if ($node.prop.type -like "Legendary Creature*")
    {
        $initialType = $node.prop.type
        $typeWords = $initialType.Split(" ")
        $node.prop.type = "Legendary Creature"
        
        $count = 0
        $subtypes = @()
        foreach ($word in $typewords)
        {
            if ($count -gt 2)
            {
                $subtypes += $word
            }
            $count++
        }
    }
    elseif ($node.prop.type -like "Legendary Artifact Creature*")
    {
        $initialType = $node.prop.type
        $typeWords = $initialType.Split(" ")
        $node.prop.type = "Legendary Artifact Creature"

        $count = 0
        $subtypes = @()
        foreach ($word in $typewords)
        {
            if ($count -gt 3)
            {
                $subtypes += $word
            }
            $count++
        }
    }
    elseif ($node.prop.type -like "Legendary Artifact Land*")
    {
        $initialType = $node.prop.type
        $typeWords = $initialType.Split(" ")
        $node.prop.type = "Legendary Artifact Land"

        $count = 0
        $subtypes = @()
        foreach ($word in $typewords)
        {
            if ($count -gt 3)
            {
                $subtypes += $word
            }
            $count++
        }
    }
    elseif ($node.prop.type -like "Artifact Creature*")
    {
        $initialType = $node.prop.type
        $typeWords = $initialType.Split(" ")
        $node.prop.type = "Artifact Creature"

        $count = 0
        $subtypes = @()
        foreach ($word in $typewords)
        {
            if ($count -gt 2)
            {
                $subtypes += $word
            }
            $count++
        }
    }
    elseif ($node.prop.type -like "Legendary Planeswalker*")
    {
        $initialType = $node.prop.type
        $typeWords = $initialType.Split(" ")
        $node.prop.type = "Legendary Planeswalker"

        $count = 0
        $subtypes = @()
        foreach ($word in $typewords)
        {
            if ($count -gt 2)
            {
                $subtypes += $word
            }
            $count++
        }
    }
    else
    {
        $initialType = $node.prop.type
        $typeWords = $initialType.Split(" ")
        $node.prop.type = $typeWords[0]
        
        $count = 0
        $subtypes = @()
        foreach ($word in $typewords)
        {
            if ($count -gt 1)
            {
                $subtypes += $word
            }
            $count++
        }
    }
        
    $rarityElement = $node.AppendChild($xml.CreateElement("rarity"))
    $rarityText = $xml.CreateTextNode($rarity.rarity)
    [void]$rarityElement.AppendChild($rarityText);

    $picUrlElement = $node.AppendChild($xml.CreateElement("picUrl"))
    $enElement = $picUrlElement.AppendChild($xml.CreateElement("en"))
    $enText = $xml.CreateTextNode($picUrl.picUrl)
    [void]$enElement.AppendChild($enText);

    if ($subtypes.Count -eq 1)
    {
        $subtypes += ""
    }
    if ($subtypes.Count -gt 0)
    {
        foreach ($subtypeItem in $subtypes)
        {
            $subtypesElement = $node.AppendChild($xml.CreateElement("subtypes"))
            $subtypesText = $xml.CreateTextNode($subtypeItem)
            [void]$subtypesElement.AppendChild($subtypesText);
        }
    }

    $cubeList += "1 " + $node.name

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

                $nameElement = $backElement.AppendChild($xml.CreateElement("name"))
                $nameText = $xml.CreateTextNode($dfc.Name)
                [void]$nameElement.AppendChild($nameText);

                $powerElement = $backElement.AppendChild($xml.CreateElement("power"))
                $powerText = $xml.CreateTextNode(($dfc.prop.pt -split "/")[0])
                [void]$powerElement.AppendChild($powerText);

                $toughnessElement = $backElement.AppendChild($xml.CreateElement("toughness"))
                $toughnessText = $xml.CreateTextNode(($dfc.prop.pt -split "/")[1])
                [void]$toughnessElement.AppendChild($toughnessText);

                $loyaltyElement = $backElement.AppendChild($xml.CreateElement("loyalty"))
                $loyaltyText = $xml.CreateTextNode($dfc.prop.loyalty)
                [void]$loyaltyElement.AppendChild($loyaltyText);

                $oracleElement = $backElement.AppendChild($xml.CreateElement("oracle"))
                $oracleText = $xml.CreateTextNode(($dfc.text -replace "\n","\n" -replace "â€`”","-" -replace "`"","\`""))
                [void]$oracleElement.AppendChild($oracleText);

                $backPicUrlElement = $backElement.AppendChild($xml.CreateElement("backPicUrl"))
                $backEnElement = $backPicUrlElement.AppendChild($xml.CreateElement("backEn"))
                $backEnText = $xml.CreateTextNode($picUrl.picUrl)
                [void]$backEnElement.AppendChild($backEnText);

                if ($dfc.prop.type -like "Legendary*")
                {
                    $initialType = $dfc.prop.type
                    $typeWords = $initialType.Split(" ")
                    $dfc.prop.type = "Legendary Planeswalker"

                    $count = 0
                    $subtypes = @()
                    foreach ($word in $typewords)
                    {
                        if ($count -gt 2)
                        {
                            $subtypes += $word
                        }
                        $count++
                    }
                }
                else
                {
                    $initialType = $dfc.prop.type
                    $typeWords = $initialType.Split(" ")
                    $dfc.prop.type = $typeWords[0]

                    $count = 0
                    $subtypes = @()
                    foreach ($word in $typewords)
                    {
                        if ($count -gt 1)
                        {
                            $subtypes += $word
                        }
                        $count++
                    }
                }

                $typeElement = $backElement.AppendChild($xml.CreateElement("type"))
                $typeText = $xml.CreateTextNode($dfc.prop.type)
                [void]$typeElement.AppendChild($typeText);


                if ($subtypes.Count -eq 1)
                {
                    $subtypes += ""
                }
                if ($subtypes.Count -gt 0)
                {
                    foreach ($subtypeItem in $subtypes)
                    {

                        $subtypesElement = $backElement.AppendChild($xml.CreateElement("subtypes"))
                        $subtypesText = $xml.CreateTextNode($subtypeItem)
                        [void]$subtypesElement.AppendChild($subtypesText);
                    }
                }
            }
        }   
    }
}

#$xml.Save(".\test.xml")

$array = foreach ($card in $xml.cockatrice_carddatabase.cards.card)
{
    if ($card.back)
        {
        $prop = [ordered]@{
            'name' = $card.name
            'mana_cost' = $card.prop.manacost
            'type' = $card.prop.type
            'subtypes' = $card.subtypes
            'power' = ($card.prop.pt -split "/")[0]
            'toughness' = if($card.prop.pt){($card.prop.pt -split "/")[1]}else{""}
            'oracle_text' = $card.text
            'loyalty' = if($card.prop.defense){$card.prop.defense}else{""}
            'rarity' = $card.rarity
            'image_uris' = @{
                'en' = $card.picUrl.en
            }
            'back' = [ordered]@{ 
                'name' = $card.back.name
                'type' = $card.back.type
                'power' = $card.back.power
                'toughness' = if($card.back.pt){($card.back.pt -split "/")[1]}else{""}
                'oracle_text' = $card.back.oracle
                'subtypes' = $card.back.subtypes
                'loyalty' = $card.back.loyalty
                'image_uris' = @{
                    'en' = $card.back.backPicUrl.BackEn
                }
            }
        }
    }
    elseif ($card.subtypes -and $card.prop.manacost)
    {
        $prop = [ordered]@{
            'name' = $card.name
            'mana_cost' = $card.prop.manacost
            'type' = $card.prop.type
            'subtypes' = $card.subtypes
            'power' = ($card.prop.pt -split "/")[0]
            'toughness' = if($card.prop.pt){($card.prop.pt -split "/")[1]}else{""}
            'oracle_text' = $card.text
            'rarity' = $card.rarity
            'image_uris' = @{
                'en' = $card.picUrl.en
            }
        }
    }
    elseif ($card.subtypes)
    {
            $prop = [ordered]@{
            'name' = $card.name
            'mana_cost' = ""
            'type' = $card.prop.type
            'subtypes' = $card.subtypes
            'power' = ($card.prop.pt -split "/")[0]
            'toughness' = if($card.prop.pt){($card.prop.pt -split "/")[1]}else{""}
            'oracle_text' = $card.text
            'rarity' = $card.rarity
            'image_uris' = @{
                'en' = $card.picUrl.en
            }
        }
    }
    elseif ($card.prop.manacost)
    {
        $prop = [ordered]@{
            'name' = $card.name
            'mana_cost' = $card.prop.manacost
            'type' = $card.prop.type
            'power' = ($card.prop.pt -split "/")[0]
            'toughness' = if($card.prop.pt){($card.prop.pt -split "/")[1]}else{""}
            'oracle_text' = $card.text
            'rarity' = $card.rarity
            'image_uris' = @{
                'en' = $card.picUrl.en
            }
        }
    }
    else
    {
        $prop = [ordered]@{
            'name' = $card.name
            'mana_cost' = ""
            'type' = $card.prop.type
            'power' = ($card.prop.pt -split "/")[0]
            'toughness' = if($card.prop.pt){($card.prop.pt -split "/")[1]}else{""}
            'oracle_text' = $card.text
            'rarity' = $card.rarity
            'image_uris' = @{
                'en' = $card.picUrl.en
            }
        }
    }
    New-Object -Type PSCustomObject -Property $prop
}

$array | ConvertTo-Json -Depth 3 | % { [System.Text.RegularExpressions.Regex]::Unescape($_) } | Set-Content -Path ".\Draftmancer.txt" -Encoding Unicode
Add-Content ".\Draftmancer.txt" "[MainSlot(15)]"
Add-Content ".\Draftmancer.txt" $cubeList
@("[CustomCards]") + (Get-Content ".\Draftmancer.txt") | Set-Content ".\Draftmancer.txt" -Encoding Unicode