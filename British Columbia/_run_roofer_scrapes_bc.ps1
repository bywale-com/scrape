# One CSV per city: roofer search in British Columbia, Canada via text + -geo
# Geo = approximate municipal center (decimal degrees)
param(
    [string]$StartFrom = "",
    [switch]$RetryEmptyOnly
)

$ErrorActionPreference = "Stop"
$base = $PSScriptRoot

$jobs = @(
    @{ Q = "roofer near Abbotsford, British Columbia, Canada"; F = "roofers_Abbotsford.csv"; Geo = "49.0574,-122.2525" }
    @{ Q = "roofer near Armstrong, British Columbia, Canada"; F = "roofers_Armstrong.csv"; Geo = "50.4481,-119.1964" }
    @{ Q = "roofer near Burnaby, British Columbia, Canada"; F = "roofers_Burnaby.csv"; Geo = "49.2488,-122.9805" }
    @{ Q = "roofer near Campbell River, British Columbia, Canada"; F = "roofers_Campbell_River.csv"; Geo = "50.0244,-125.2445" }
    @{ Q = "roofer near Castlegar, British Columbia, Canada"; F = "roofers_Castlegar.csv"; Geo = "49.3239,-117.6671" }
    @{ Q = "roofer near Chilliwack, British Columbia, Canada"; F = "roofers_Chilliwack.csv"; Geo = "49.1579,-121.9509" }
    @{ Q = "roofer near Colwood, British Columbia, Canada"; F = "roofers_Colwood.csv"; Geo = "48.4227,-123.4959" }
    @{ Q = "roofer near Coquitlam, British Columbia, Canada"; F = "roofers_Coquitlam.csv"; Geo = "49.2838,-122.7932" }
    @{ Q = "roofer near Courtenay, British Columbia, Canada"; F = "roofers_Courtenay.csv"; Geo = "49.6883,-124.9958" }
    @{ Q = "roofer near Cranbrook, British Columbia, Canada"; F = "roofers_Cranbrook.csv"; Geo = "49.5097,-115.7667" }
    @{ Q = "roofer near Dawson Creek, British Columbia, Canada"; F = "roofers_Dawson_Creek.csv"; Geo = "55.7598,-120.2403" }
    @{ Q = "roofer near Delta, British Columbia, Canada"; F = "roofers_Delta.csv"; Geo = "49.0847,-123.0587" }
    @{ Q = "roofer near Duncan, British Columbia, Canada"; F = "roofers_Duncan.csv"; Geo = "48.7787,-123.7080" }
    @{ Q = "roofer near Enderby, British Columbia, Canada"; F = "roofers_Enderby.csv"; Geo = "50.5507,-119.1397" }
    @{ Q = "roofer near Fernie, British Columbia, Canada"; F = "roofers_Fernie.csv"; Geo = "49.5042,-115.0628" }
    @{ Q = "roofer near Fort St. John, British Columbia, Canada"; F = "roofers_Fort_St_John.csv"; Geo = "56.2524,-120.8474" }
    @{ Q = "roofer near Grand Forks, British Columbia, Canada"; F = "roofers_Grand_Forks.csv"; Geo = "49.0333,-118.4422" }
    @{ Q = "roofer near Greenwood, British Columbia, Canada"; F = "roofers_Greenwood.csv"; Geo = "49.0915,-118.6771" }
    @{ Q = "roofer near Kamloops, British Columbia, Canada"; F = "roofers_Kamloops.csv"; Geo = "50.6745,-120.3273" }
    @{ Q = "roofer near Kelowna, British Columbia, Canada"; F = "roofers_Kelowna.csv"; Geo = "49.8880,-119.4960" }
    @{ Q = "roofer near Kimberley, British Columbia, Canada"; F = "roofers_Kimberley.csv"; Geo = "49.6833,-115.9833" }
    @{ Q = "roofer near Langford, British Columbia, Canada"; F = "roofers_Langford.csv"; Geo = "48.4506,-123.5079" }
    @{ Q = "roofer near Langley, British Columbia, Canada"; F = "roofers_Langley.csv"; Geo = "49.1044,-122.5824" }
    @{ Q = "roofer near Maple Ridge, British Columbia, Canada"; F = "roofers_Maple_Ridge.csv"; Geo = "49.2139,-122.6010" }
    @{ Q = "roofer near Merritt, British Columbia, Canada"; F = "roofers_Merritt.csv"; Geo = "50.1123,-120.7942" }
    @{ Q = "roofer near Mission, British Columbia, Canada"; F = "roofers_Mission.csv"; Geo = "49.1328,-122.3015" }
    @{ Q = "roofer near Nanaimo, British Columbia, Canada"; F = "roofers_Nanaimo.csv"; Geo = "49.1659,-123.9401" }
    @{ Q = "roofer near Nelson, British Columbia, Canada"; F = "roofers_Nelson.csv"; Geo = "49.5008,-117.2851" }
    @{ Q = "roofer near New Westminster, British Columbia, Canada"; F = "roofers_New_Westminster.csv"; Geo = "49.2057,-122.9110" }
    @{ Q = "roofer near North Vancouver, British Columbia, Canada"; F = "roofers_North_Vancouver.csv"; Geo = "49.3200,-123.0724" }
    @{ Q = "roofer near Parksville, British Columbia, Canada"; F = "roofers_Parksville.csv"; Geo = "49.3190,-124.3141" }
    @{ Q = "roofer near Penticton, British Columbia, Canada"; F = "roofers_Penticton.csv"; Geo = "49.4991,-119.5937" }
    @{ Q = "roofer near Pitt Meadows, British Columbia, Canada"; F = "roofers_Pitt_Meadows.csv"; Geo = "49.2167,-122.6892" }
    @{ Q = "roofer near Port Alberni, British Columbia, Canada"; F = "roofers_Port_Alberni.csv"; Geo = "49.2339,-124.8050" }
    @{ Q = "roofer near Port Coquitlam, British Columbia, Canada"; F = "roofers_Port_Coquitlam.csv"; Geo = "49.2621,-122.7805" }
    @{ Q = "roofer near Port Moody, British Columbia, Canada"; F = "roofers_Port_Moody.csv"; Geo = "49.2830,-122.8490" }
    @{ Q = "roofer near Powell River, British Columbia, Canada"; F = "roofers_Powell_River.csv"; Geo = "49.8356,-124.5247" }
    @{ Q = "roofer near Prince George, British Columbia, Canada"; F = "roofers_Prince_George.csv"; Geo = "53.9166,-122.7530" }
    @{ Q = "roofer near Prince Rupert, British Columbia, Canada"; F = "roofers_Prince_Rupert.csv"; Geo = "54.3120,-130.3270" }
    @{ Q = "roofer near Quesnel, British Columbia, Canada"; F = "roofers_Quesnel.csv"; Geo = "52.9784,-122.4931" }
    @{ Q = "roofer near Revelstoke, British Columbia, Canada"; F = "roofers_Revelstoke.csv"; Geo = "50.9978,-118.1958" }
    @{ Q = "roofer near Richmond, British Columbia, Canada"; F = "roofers_Richmond.csv"; Geo = "49.1666,-123.1336" }
    @{ Q = "roofer near Rossland, British Columbia, Canada"; F = "roofers_Rossland.csv"; Geo = "49.0788,-117.8025" }
    @{ Q = "roofer near Salmon Arm, British Columbia, Canada"; F = "roofers_Salmon_Arm.csv"; Geo = "50.7032,-119.3020" }
    @{ Q = "roofer near Surrey, British Columbia, Canada"; F = "roofers_Surrey.csv"; Geo = "49.1044,-122.8011" }
    @{ Q = "roofer near Terrace, British Columbia, Canada"; F = "roofers_Terrace.csv"; Geo = "54.5163,-128.6034" }
    @{ Q = "roofer near Trail, British Columbia, Canada"; F = "roofers_Trail.csv"; Geo = "49.0950,-117.7110" }
    @{ Q = "roofer near Vancouver, British Columbia, Canada"; F = "roofers_Vancouver.csv"; Geo = "49.2827,-123.1207" }
    @{ Q = "roofer near Vernon, British Columbia, Canada"; F = "roofers_Vernon.csv"; Geo = "50.2670,-119.2720" }
    @{ Q = "roofer near Victoria, British Columbia, Canada"; F = "roofers_Victoria.csv"; Geo = "48.4284,-123.3656" }
    @{ Q = "roofer near West Kelowna, British Columbia, Canada"; F = "roofers_West_Kelowna.csv"; Geo = "49.8350,-119.6376" }
    @{ Q = "roofer near White Rock, British Columbia, Canada"; F = "roofers_White_Rock.csv"; Geo = "49.0253,-122.8030" }
    @{ Q = "roofer near Williams Lake, British Columbia, Canada"; F = "roofers_Williams_Lake.csv"; Geo = "52.1415,-122.1445" }
)

$queryFile = Join-Path $base "_gmaps_queries.txt"

Write-Host "Pulling Docker image (once)..."
docker pull gosom/google-maps-scraper
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$i = 0
foreach ($job in $jobs) {
    $i++
    $outPath = Join-Path $base $job.F

    if ($StartFrom -and ($job.F -ne $StartFrom)) {
        continue
    }
    if ($StartFrom -and ($job.F -eq $StartFrom)) {
        $StartFrom = ""
    }

    if ($RetryEmptyOnly -and (Test-Path $outPath)) {
        $existing = Get-Item $outPath
        if (-not $existing.PSIsContainer -and $existing.Length -gt 0) {
            Write-Host "[$i/$($jobs.Count)] Skipping completed file $($job.F)"
            continue
        }
    }

    [System.IO.File]::WriteAllText($queryFile, $job.Q + "`n", [System.Text.UTF8Encoding]::new($false))
    if ((Test-Path $outPath) -and (Get-Item $outPath).PSIsContainer) {
        Remove-Item -Recurse -Force $outPath
    }
    if (-not (Test-Path $outPath)) {
        "" | Out-File -FilePath $outPath -Encoding ascii -NoNewline
    }

    Write-Host "[$i/$($jobs.Count)] $($job.F) :: $($job.Q) [@$($job.Geo)]"
    docker rm gmaps-scraper 2>$null | Out-Null

    docker run `
        --name gmaps-scraper `
        -v gmaps-playwright-cache:/opt `
        -v "${queryFile}:/queries.txt" `
        -v "${outPath}:/results.csv" `
        gosom/google-maps-scraper `
        -input /queries.txt `
        -results /results.csv `
        -exit-on-inactivity 20m `
        -depth 10 `
        -lang en `
        -geo "$($job.Geo)"

    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Docker exited with code $LASTEXITCODE for $($job.F)"
    }
}

Remove-Item -Force $queryFile -ErrorAction SilentlyContinue
Write-Host "Done. CSV files are in: $base"
