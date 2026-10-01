param(
    [string]$Url = "https://data.10jqka.com.cn/market/longhu/"
)

$ErrorActionPreference = "Stop"

function Convert-AmountToWan {
    param([string]$Value)

    $number = [double]($Value -replace "[^0-9.\-]", "")
    if ($Value -match "亿") {
        return $number * 10000
    }
    return $number
}

function Convert-CellText {
    param([string]$Html)

    $text = [regex]::Replace($Html, "<[^>]+>", " ")
    $text = [System.Net.WebUtility]::HtmlDecode($text)
    return [regex]::Replace($text, "\s+", " ").Trim()
}

$response = Invoke-WebRequest -UseBasicParsing -Uri $Url -Headers @{
    "User-Agent" = "Mozilla/5.0"
}
$html = $response.Content

$dates = [regex]::Matches($html, "20\d{2}[-/]\d{2}[-/]\d{2}") |
    ForEach-Object Value |
    Sort-Object -Unique

$tables = [regex]::Matches($html, "(?is)<table[^>]*>(.*?)</table>")
$summaryIndex = -1

for ($i = 0; $i -lt $tables.Count; $i++) {
    $tableText = Convert-CellText $tables[$i].Groups[1].Value
    if ($tableText -match "^代码 名称 现价 涨跌幅 成交金额 净买入额") {
        $summaryIndex = $i + 1
        break
    }
}

if ($summaryIndex -lt 0 -or $summaryIndex -ge $tables.Count) {
    throw "Could not locate the Tonghuashun Dragon-Tiger summary table."
}

$items = foreach ($row in [regex]::Matches(
    $tables[$summaryIndex].Groups[1].Value,
    "(?is)<tr[^>]*>(.*?)</tr>"
)) {
    $cells = @(
        [regex]::Matches($row.Groups[1].Value, "(?is)<td[^>]*>(.*?)</td>") |
            ForEach-Object { Convert-CellText $_.Groups[1].Value }
    )

    if ($cells.Count -ne 7) {
        continue
    }

    $period, $code, $name, $price, $change, $amount, $netBuy = $cells
    $isMainShanghaiOrShenzhen = $code -match "^(000|001|002|003|300|301|600|601|603|605)\d{3}$"

    if (
        $period -ne "" -or
        -not $isMainShanghaiOrShenzhen -or
        $name -match "ST|退市"
    ) {
        continue
    }

    $amountWan = Convert-AmountToWan $amount
    $netBuyWan = Convert-AmountToWan $netBuy

    if ($amountWan -eq 0) {
        continue
    }

    [pscustomobject]@{
        code = $code
        name = $name
        price = [double]$price
        change_pct = [double]($change -replace "%", "")
        transaction_amount_wan = [math]::Round($amountWan, 2)
        net_buy_wan = [math]::Round($netBuyWan, 2)
        net_buy_ratio_pct = [math]::Round(100 * $netBuyWan / $amountWan, 1)
    }
}

[pscustomobject]@{
    source = $Url
    dates_found = @($dates)
    count = @($items).Count
    stocks = @($items)
} | ConvertTo-Json -Depth 5

