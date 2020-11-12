#$logfile = "KBs.log"

Clear-Host
$psot = @() # out object

get-content "servers.txt"| % {
try{
$objSession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session",$_))

$objSearcher= $objSession.CreateUpdateSearcher()

$colHistory = $objSearcher.QueryHistory(0, 100)



Foreach($objEntry in $colHistory) {
	$pso = "" | select Computer,Title,Date, ResultCode, Operation, ServerSelection, UnmappedResultCode
  
  $pso.Title = $objEntry.Title
  $pso.Date = $objEntry.Date
  $pso.ResultCode = $objEntry.ResultCode
  $pso.Operation = $objEntry.Operation
  $pso.ServerSelection = $objEntry.ServerSelection
  $pso.UnmappedResultCode = $objEntry.UnmappedResultCode
  
  $pso.computer = $_
  
	$psot += $pso
}



}
catch{

write-Host $Error -Foreground Yellow

}
finally{

}
}
#Start-Transcript -Path ".\$logfile" 
$psot | export-csv -path update.csv -encoding UTF8
#Stop-Transcript