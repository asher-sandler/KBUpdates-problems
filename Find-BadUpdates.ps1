Clear-Host
$csvFileName = "update.csv"

$csvcontent = get-content $csvFileName

# first two lines it is banner and header
$beginFromString=3
$i=1

$curComp = ""

$badupdatesLog = @()

$badupdatesLog += '"ServerName","Status","KB","Date","Title"'

$badUpdatesPerServer = @()

foreach ($line in $csvcontent){
   if ($i -ge $beginFromString){
       
	   $oUpd = "" | Select Computer,Title,Date, ResultCode, Operation, ServerSelection, UnmappedResultCode
	   $aUpd = $line.split(",")
	   $oUpd.Computer   = $aUpd[0].replace('"',"")
	   $oUpd.Title 		= $aUpd[1]
	   $oUpd.Date       = $aUpd[2].replace('"',"")
	   $oUpd.ResultCode = $aUpd[3]
	   $oUpd.Operation = $aUpd[4]
	   $oUpd.ServerSelection    = $aUpd[5]
	   $oUpd.UnmappedResultCode = $aUpd[6]
	   
	   if (($curComp -ne $oUpd.Computer) -or ($i -eq $csvcontent.count)){
	       foreach($bad in $badUpdatesPerServer){
		      if ($bad.contains("Bad Update")){
					$badupdatesLog += $bad
			  }
		   }
		   $curComp = $oUpd.Computer
		   $badUpdatesPerServer = @()
	   }
	   #$curComp
	   $title = $oUpd.Title
	   if ($oUpd.Title.contains("KB")){
	        $title  = $oUpd.Title.split("KB")[0].replace("(","").replace('"',"")
			$kbNumb = $oUpd.Title.split("KB")[2].split("")[0].replace(")","").replace('"',"")
	   }
	   else
	   {
			$kbNumb = $oUpd.Title
	   }
	   if ($oUpd.UnmappedResultCode.substring(1,1) -eq "-") # bad
	   {
	      # $oUpd.UnmappedResultCode.substring(1,1)
	      # $kbNumb
	      #find that is the first time
		  $found = $false
		  foreach($bad in $badUpdatesPerServer){
			if ($bad.contains($kbNumb)){
			   $found=$true
			   break
			}
		  }
		  # $found
		  if (!$found){
		    # $badUpdatesPerServer
			# read-host
		    $item = $curComp+",Bad Update,KB"+$kbNumb+","+$oUpd.Date+","+$title
			$badUpdatesPerServer += $item
		  }
	   }
	   else{
	      #find that is the first time
		  $found = $false
		  foreach($bad in $badUpdatesPerServer){
			if ($bad.contains($kbNumb)){
			   $found=$true
			   break
			}
		  }
		  if (!$found){
		    $item = $curComp+",Good Update,KB"+$kbNumb
			$badUpdatesPerServer += $item
		  }	       
	   }
	   
	   
	   
	  
	   
   }

   $i++
}


$badupdatesLog | out-file -filepath BadUpdates.csv -encoding UTF8
# $badupdatesLog | out-gridview
