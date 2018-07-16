function Get-VLSMBreakdown {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Net.IPNetwork]$Network,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [array]$SubnetSize
    )

    function processRecord($net, $cidr, $type) {
        try {
            $subnets = @([System.Net.IPNetwork]::Subnet($net, $cidr))
            $outStack.Push(($subnets[0] | add-member -MemberType NoteProperty -Name type -Value $type -PassThru -Force))
            if ($subnets.count -gt 1) {
                for ($i = 1; $i -le $subnets.count - 1; $i++) {
                    $vlsmStack.Enqueue($subnets[$i])
                }
            }
            $true
        }
        catch {
            $vlsmStack.Enqueue($net)
            $false
        }
    }


    if (($SubnetSize | % {[PSCustomObject]$_} | Measure-Object -Property size -Sum).Sum -lt $Network.Usable) {
        #sort vlsmMasks
        $vlsmMasks = [System.Collections.Queue]::new();
        $SubnetSize | % {
            $length = 32 - [math]::Ceiling([math]::Log($_.size + 2, 2))
            [PSCustomObject]@{
                type   = $_.type;
                length = $length
            }
        } | sort -Property length | % {$vlsmMasks.Enqueue($_)}

        $vlsmStack = [System.Collections.Queue]::new()
        $outStack = [System.Collections.Stack]::new()
        $vlsmStack.Enqueue($Network)

        do {
            $failureCount = 0
            $v = $vlsmMasks.Dequeue()
            try {
                $current = $vlsmStack.Dequeue()
            }
            catch {
                write-verbose -Message "working stack is empty"
            }
            if (! (processRecord $current $v.length $v.type) ) { $vlsmMasks.Enqueue($v); $failureCount++}

            write-verbose ("VLSM MASKS`: " + $vlsmMasks.Count)
            write-verbose ("FAILURES`: " + $failureCount)

            if ($vlsmMasks.Count -eq $failureCount) {break} # when no records processed during a loop cycle
        } while ($vlsmMasks.Count -ne 0)

        write-verbose ("OUT STACK`: " + $outStack.Count)
        write-verbose ("SubnetSuize`: " + $SubnetSize.count)
        if ($outStack.count -lt $SubnetSize.count) {write-warning -message "subnetting failed"}
        $reserved = @([System.Net.IPNetwork]::Supernet($vlsmStack.ToArray()))
        $outStack
        $reserved | add-member -MemberType NoteProperty -Name type -Value "reserved" -PassThru -Force
    }
}