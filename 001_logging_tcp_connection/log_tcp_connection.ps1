Set-StrictMode -Version Latest

$pInfo = $null

While($true) {
    Start-Sleep -Seconds 1

    #--- プロセス情報取得 (ユーザ名)
    $psInfo = (Get-Process -IncludeUserName)

    #--- プロセス情報取得 (コマンドライン)
    $psInfo2 = (Get-CimInstance win32_Process)

    #--- TCP コネクション情報取得 + プロセス情報
    $tcpCon = (Get-NetTCPConnection | Where-Object {
             $_.State -ne 'Listen' `
        -And $_.State -ne 'Bound' `
        -And $_.RemoteAddress -ne '127.0.0.1'
    } | ForEach-Object {
        $obj = $_
        $psDetail  = ($psInfo  | Where-Object {$_.Id        -eq $obj.OwningProcess} )
        $psDetail2 = ($psInfo2 | Where-Object {$_.ProcessId -eq $obj.OwningProcess} )
        $obj | Add-Member -MemberType NoteProperty -Name PsProcessName -Value $psDetail.ProcessName
        $obj | Add-Member -MemberType NoteProperty -Name PsUserName    -Value $psDetail.UserName
        $obj | Add-Member -MemberType NoteProperty -Name PsDescription -Value $psDetail.Description
        $obj | Add-Member -MemberType NoteProperty -Name PsCompany     -Value $psDetail.Company
        # $obj | Add-Member -MemberType NoteProperty -Name PsPath        -Value $psDetail.Path
        $obj | Add-Member -MemberType NoteProperty -Name PsCommandLine -Value $psDetail2.CommandLine
        $obj
    })

    #--- 前のデータと結合
    $pInfo = $tcpCon + $pInfo

    $outFileName = Join-Path $PSScriptRoot ((Get-Date).ToString("yyyyMMdd_HH") + "_tcp.txt")
    $pInfo | Select-Object -Unique -Property @(
        "RemoteAddress",
        "RemotePort",
        "State",
        "AppliedSetting",
        "OwningProcess",
        "PsProcessName",
        "PsUserName",
        "PsDescription",
        "PsCompany",
        "PsCommandLine"
    ) | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath $outFileName -Encoding utf8
}

