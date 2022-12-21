$o1 = 10
$o2 = 247
$o3list = @(10,20,30)
$o4list = @(0 .. 255)

foreach ($o3 in $o3list) {
    foreach ($o4 in $o4list) {
        $octets = @($o1, $o2, $o3, $o4)
        $ipaddr = $octets -Join '.'
        Write-Host ("A`t{0}`t{1}" -f ($octets -Join "`t"), $ipaddr)
    }
}
