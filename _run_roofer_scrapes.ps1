# One CSV per city: query roofer search anchored in Ontario, Canada via text + -geo
# Geo = approximate municipal center in Ontario (decimal degrees)
$ErrorActionPreference = "Stop"
$base = $PSScriptRoot

$jobs = @(
    @{ Q = "roofer near Kenora, Ontario, Canada"; F = "roofers_Kenora.csv"; Geo = "49.7670,-94.4894" }
    @{ Q = "roofer near Kingston, Ontario, Canada"; F = "roofers_Kingston.csv"; Geo = "44.2312,-76.4860" }
    @{ Q = "roofer near London, Ontario, Canada"; F = "roofers_London.csv"; Geo = "42.9849,-81.2453" }
    @{ Q = "roofer near Markham, Ontario, Canada"; F = "roofers_Markham.csv"; Geo = "43.8564,-79.3370" }
    @{ Q = "roofer near Mississauga, Ontario, Canada"; F = "roofers_Mississauga.csv"; Geo = "43.5890,-79.6441" }
    @{ Q = "roofer near Niagara Falls, Ontario, Canada"; F = "roofers_Niagara_Falls.csv"; Geo = "43.0896,-79.0849" }
    @{ Q = "roofer near Norfolk County, Ontario, Canada"; F = "roofers_Norfolk_County.csv"; Geo = "42.8334,-80.3030" }
    @{ Q = "roofer near North Bay, Ontario, Canada"; F = "roofers_North_Bay.csv"; Geo = "46.3091,-79.4608" }
    @{ Q = "roofer near Orillia, Ontario, Canada"; F = "roofers_Orillia.csv"; Geo = "44.6082,-79.4207" }
    @{ Q = "roofer near Oshawa, Ontario, Canada"; F = "roofers_Oshawa.csv"; Geo = "43.8971,-78.8658" }
    @{ Q = "roofer near Ottawa, Ontario, Canada"; F = "roofers_Ottawa.csv"; Geo = "45.4215,-75.6972" }
    @{ Q = "roofer near Owen Sound, Ontario, Canada"; F = "roofers_Owen_Sound.csv"; Geo = "44.5680,-80.9435" }
    @{ Q = "roofer near Pembroke, Ontario, Canada"; F = "roofers_Pembroke.csv"; Geo = "45.8267,-77.1101" }
    @{ Q = "roofer near Peterborough, Ontario, Canada"; F = "roofers_Peterborough.csv"; Geo = "44.3091,-78.3197" }
    @{ Q = "roofer near Pickering, Ontario, Canada"; F = "roofers_Pickering.csv"; Geo = "43.8384,-79.0868" }
    @{ Q = "roofer near Port Colborne, Ontario, Canada"; F = "roofers_Post_Colborne.csv"; Geo = "42.8864,-79.2521" }
    @{ Q = "roofer near Prince Edward County, Ontario, Canada"; F = "roofers_Prince_Edward_County.csv"; Geo = "44.0070,-77.1328" }
    @{ Q = "roofer near Quinte West, Ontario, Canada"; F = "roofers_Quinte_West.csv"; Geo = "44.0942,-77.5770" }
    @{ Q = "roofer near Richmond Hill, Ontario, Canada"; F = "roofers_Richmond_Hill.csv"; Geo = "43.8828,-79.4400" }
    @{ Q = "roofer near Sarnia, Ontario, Canada"; F = "roofers_Sarnia.csv"; Geo = "42.9745,-82.4066" }
    @{ Q = "roofer near Sault Ste. Marie, Ontario, Canada"; F = "roofers_Sault_Ste_Marie.csv"; Geo = "46.5218,-84.3461" }
    @{ Q = "roofer near St. Catharines, Ontario, Canada"; F = "roofers_St_Catherines.csv"; Geo = "43.1594,-79.2469" }
    @{ Q = "roofer near St. Thomas, Ontario, Canada"; F = "roofers_St_Thomas.csv"; Geo = "42.7777,-81.1826" }
    @{ Q = "roofer near Stratford, Ontario, Canada"; F = "roofers_Stratford.csv"; Geo = "43.3700,-80.9822" }
    @{ Q = "roofer near Temiskaming Shores, Ontario, Canada"; F = "roofers_Temiskaming_Shores.csv"; Geo = "47.1834,-79.8672" }
    @{ Q = "roofer near Thorold, Ontario, Canada"; F = "roofers_Thorold.csv"; Geo = "43.1168,-79.2001" }
    @{ Q = "roofer near Thunder Bay, Ontario, Canada"; F = "roofers_Thunder_Bay.csv"; Geo = "48.3809,-89.2477" }
    @{ Q = "roofer near Timmins, Ontario, Canada"; F = "roofers_Timmins.csv"; Geo = "48.4758,-81.3305" }
    @{ Q = "roofer near Toronto, Ontario, Canada"; F = "roofers_Toronto.csv"; Geo = "43.6532,-79.3832" }
    @{ Q = "roofer near Vaughan, Ontario, Canada"; F = "roofers_Vaughan.csv"; Geo = "43.8563,-79.5085" }
    @{ Q = "roofer near Waterloo, Ontario, Canada"; F = "roofers_Waterloo.csv"; Geo = "43.4643,-80.5204" }
    @{ Q = "roofer near Welland, Ontario, Canada"; F = "roofers_Welland.csv"; Geo = "42.9922,-79.2483" }
    @{ Q = "roofer near Windsor, Ontario, Canada"; F = "roofers_Windsor.csv"; Geo = "42.3149,-83.0364" }
    @{ Q = "roofer near Woodstock, Ontario, Canada"; F = "roofers_Woodstock.csv"; Geo = "43.1315,-80.7474" }
)

$queryFile = Join-Path $base "_gmaps_queries.txt"

Write-Host "Pulling Docker image (once)..."
docker pull gosom/google-maps-scraper
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$i = 0
foreach ($job in $jobs) {
    $i++
    $outPath = Join-Path $base $job.F
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
