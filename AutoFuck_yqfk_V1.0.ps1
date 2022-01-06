
param($username,$psw)

<#------获取PHPSESSID------#>
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36 Edg/96.0.1054.62"
$PHPSESSIDrespond=Invoke-WebRequest -UseBasicParsing -Uri "https://cas.dgut.edu.cn/home/Oauth/getToken/appid/yqfkdaka/state/%2Fhome.html" `
-WebSession $session `
-Headers @{
"Upgrade-Insecure-Requests"="1"
  "Accept"="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
  "Sec-Fetch-Site"="same-site"
  "Sec-Fetch-Mode"="navigate"
  "Sec-Fetch-Dest"="document"
  "sec-ch-ua"="`" Not A;Brand`";v=`"99`", `"Chromium`";v=`"96`", `"Microsoft Edge`";v=`"96`""
  "sec-ch-ua-mobile"="?0"
  "sec-ch-ua-platform"="`"Windows`""
  "Referer"="https://yqfk-daka.dgut.edu.cn/"
  "Accept-Encoding"="gzip, deflate, br"
  "Accept-Language"="zh-CN,zh;q=0.9"
}
function separatePHPSSESSID ($header){
Write-Host( $header -match 'PHPSESSID=[a-z,0-9]*;')
return $Matches[0]
}
$PHPSSESSID=(((separatePHPSSESSID  ($PHPSESSIDrespond.Headers.'Set-Cookie')).Split('='))[1]).Trimend(';')
$webcontent=$PHPSESSIDrespond.Content
$webcontent -match 'var token = "[a-z,0-9]*"'
if($Matches[0]){
$token = $Matches[0].Split('"')[1]
}
echo token=$token



<#--------------构建登录负载------------#>
$loginBody="username=" + $username+ "&password="+ $psw+ '&__token__='+ $token+ '&wechat_verify='
echo loginBody::$loginBody




<#---------登录---------#>
$logindata=("username="+$username+"&password="+$psw+"&__token__="+$token+"&wechat_verify=")
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36 Edg/96.0.1054.62"
$session.Cookies.Add((New-Object System.Net.Cookie("languageIndex", "0", "/", "cas.dgut.edu.cn")))
$session.Cookies.Add((New-Object System.Net.Cookie("last_oauth_appid", "yqfkdaka", "/", "cas.dgut.edu.cn")))
$session.Cookies.Add((New-Object System.Net.Cookie("last_oauth_state", "home", "/", "cas.dgut.edu.cn")))
$session.Cookies.Add((New-Object System.Net.Cookie("PHPSESSID",$PHPSSESSID , "/", "cas.dgut.edu.cn")))
$loginRespond=Invoke-WebRequest -UseBasicParsing -Uri "https://cas.dgut.edu.cn/home/Oauth/getToken/appid/yqfkdaka/state/%2Fhome.html" `
-Method "POST" `
-WebSession $session `
-Headers @{
"sec-ch-ua"="`" Not A;Brand`";v=`"99`", `"Chromium`";v=`"96`", `"Microsoft Edge`";v=`"96`""
  "Accept"="application/json, text/javascript, */*; q=0.01"
  "X-Requested-With"="XMLHttpRequest"
  "sec-ch-ua-mobile"="?0"
  "sec-ch-ua-platform"="`"Windows`""
  "Origin"="https://cas.dgut.edu.cn"
  "Sec-Fetch-Site"="same-origin"
  "Sec-Fetch-Mode"="cors"
  "Sec-Fetch-Dest"="empty"
  "Referer"="https://cas.dgut.edu.cn/home/Oauth/getToken/appid/yqfkdaka/state/%2Fhome.html"
  "Accept-Encoding"="gzip, deflate, br"
  "Accept-Language"="zh-CN,zh;q=0.9"
  #"Cookies"='languageIndex=0; last_oauth_appid=yqfkdaka; last_oauth_state=home; PHPSESSID='+ $PHPSSESSID 
} `
-ContentType "application/x-www-form-urlencoded; charset=UTF-8" `
-Body $logindata
echo 登录状态：($loginRespond.StatusCode)
$loginRespond -match 'token=[a-z,0-9,-]*'
<#--------------构建yqfktoken------------#>
$yqfktoken=$Matches[0].Split('=')[1]

$loginRespond -match 'token=[a-z,0-9,-]*'
<#--------------构建yqfktoken------------#>
$yqfktoken=$Matches[0].Split('=')[1]

<#---------------构建authbody-----------#>
$authBody="{`"token`":`""+$yqfktoken+"`",`"state`":`"home`"}"
<#------------------auth----------------#>
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36 Edg/96.0.1054.62"
$authRespond=Invoke-WebRequest -UseBasicParsing -Uri "https://yqfk-daka-api.dgut.edu.cn/auth" `
-Method "POST" `
-WebSession $session `
-Headers @{
"sec-ch-ua"="`" Not A;Brand`";v=`"99`", `"Chromium`";v=`"96`", `"Microsoft Edge`";v=`"96`""
  "Accept"="application/json, text/plain, */*"
  "sec-ch-ua-mobile"="?0"
  "sec-ch-ua-platform"="`"Windows`""
  "Origin"="https://yqfk-daka.dgut.edu.cn"
  "Sec-Fetch-Site"="same-site"
  "Sec-Fetch-Mode"="cors"
  "Sec-Fetch-Dest"="empty"
  "Referer"="https://yqfk-daka.dgut.edu.cn/"
  "Accept-Encoding"="gzip, deflate, br"
  "Accept-Language"="zh-CN,zh;q=0.9"
} `
-ContentType "application/json" `
-Body $authBody
$auth=$authRespond.Content.Split(':')[1].Split('`"')[1]
echo auth=$auth
<#----------------recordData-------------#>
$auth="Bearer "+$auth
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Mobile Safari/537.36 Edg/96.0.1054.62"
$recordDataRespond=Invoke-WebRequest -UseBasicParsing -Uri "https://yqfk-daka-api.dgut.edu.cn/record/" `
-WebSession $session `
-Headers @{
"sec-ch-ua"="`" Not A;Brand`";v=`"99`", `"Chromium`";v=`"96`", `"Microsoft Edge`";v=`"96`""
  "Accept"="application/json, text/plain, */*"
  "Authorization"=$auth
  "sec-ch-ua-mobile"="?1"
  "sec-ch-ua-platform"="`"Android`""
  "Origin"="https://yqfk-daka.dgut.edu.cn"
  "Sec-Fetch-Site"="same-site"
  "Sec-Fetch-Mode"="cors"
  "Sec-Fetch-Dest"="empty"
  "Referer"="https://yqfk-daka.dgut.edu.cn/"
  "Accept-Encoding"="gzip, deflate, br"
  "Accept-Language"="zh-CN,zh;q=0.9"
}
echo content=($recordDataRespond.Content)
$content=$recordDataRespond.Content
<#----------------构造表单-------------#>
Function separateValue($string1){

return $string1.Split(":")[1]
}
Function separateValueString($string1){
Write-Host  -foreground DarkBlue echo ---------------- $string1 -------------
$string1=$string1 -replace '\"\:','*'
return $string1.Split('*')[1]
}
Function separateSingleChar($keyname){
Write-Host  -foreground DarkBlue if($keyname -match '\\u[a-z,0-9]*'){

Write-Host  -foreground DarkBlue $regex = [regex]'\\u[a-z,0-9]*'
Write-Host  -foreground DarkBlue $group=$regex.Matches($key)

return $group
}
else {return $keyname}
}
Function findDataValue($keyname){
Write-Host  ($content -match ("`""+$keyname+"`":"+'*[\ ,\:,a-z,0-9,\\,\[,\],\-,\.]*,'))
return $Matches[0] 
}
Function findData($keyname){
Write-Host  ($content -match ("`""+$keyname+"`":"+'"*[\ ,\/,\:,a-z,0-9,\\,\[,\],\-]*"+,'))
return $Matches[0] 
}
Function findDataForm($key){
Write-Host ($content -match ("`""+$key+"`":"+'[\[\]\,0-9,\"]*\,'))
return $Matches[0]
}

function find1stBlancket($str){
for ($i=0;$a[$i] -ne ')';$i++){}
return $i
}
function insertBlancket($str){
for($i=0;$i -le $str.Length;$i++){
if ($str[$i] -eq 'x' ){
$str=$str.Insert($i+5,')')
$i=$i+4
}

}
return $str
}
Function replaceUtoChar($raw){
Write-Host  -foreground DarkBlue $raw
 if ($raw -match '\\u[a-z,0-9]*'){
 $a=($raw -replace "\\u",'$([char]0x')
  $a = insertBlancket $a
return $a
}
return $raw
}
<#
 (replaceUtoChar(separateValueString (findData 'username')))
 separateValue(findDataForm 'huji_region')
 #>
 $name= (replaceUtoChar(separateValueString (findData 'name')))
 $faculty_name =(replaceUtoChar(separateValueString (findData 'faculty_name')))
 $class_name= (replaceUtoChar(separateValueString (findData 'class_name')))
 $username=separateValueString(findData 'username')
 $card_number=separateValueString(findData 'card_number')
 $identity_type=separateValueString(findDataValue 'identity_type')
 $tel =separateValueString(findData 'tel')
 $body_temperature = separateValueString(findDataValue 'body_temperature')
 $body_temperature=$body_temperature.insert($body_temperature.Length-1,"`"").insert(0,"`"")
 $connect_person=(replaceUtoChar(separateValueString (findData 'connect_person')))
 $connect_tel = separateValueString(findData 'connect_tel')
 $recent_travel_situation= (replaceUtoChar(separateValueString (findData 'recent_travel_situation')))
 $focus_area=separateValueString(findData 'focus_area')
 $family_address_detail= (replaceUtoChar(separateValueString (findData 'family_address_detail')))
 $current_country=separateValueString(findData 'current_country')
 $current_province= separateValueString(findData 'current_province')
 $current_city= separateValueString(findData 'current_city')
 $current_district=separateValueString(findData 'current_district')
 $latest_acid_test =separateValueString(findData 'latest_acid_test')
 $huji_region=(separateValueString (findDataForm 'huji_region'))
 $family_region=(separateValueString (findDataForm 'family_region'))
 $jiguan_region=(separateValueString (findDataForm 'jiguan_region'))
 $current_region =(separateValueString (findDataForm 'current_region'))
 $huji_region_name=(replaceUtoChar(separateValueString (findData 'huji_region_name')))
 $family_region_name = (replaceUtoChar(separateValueString (findData 'family_region_name')))
 $jiguan_region_name = (replaceUtoChar(separateValueString (findData 'jiguan_region_name')))
 $current_region_name = (replaceUtoChar(separateValueString (findData 'current_region_name')))
 $card_type= separateValueString(findData 'card_type')
 $campus= separateValueString(findDataValue 'campus')
 $health_situation= separateValueString(findDataValue 'health_situation')
 $have_gone_important_area = separateValueString(findDataValue 'have_gone_important_area')


 $have_contact_hubei_people = separateValueString(findDataValue 'have_contact_hubei_people')
 $have_contact_illness_people =  separateValueString(findDataValue 'have_contact_illness_people')
 $have_isolation_in_dg  =  separateValueString(findDataValue 'have_isolation_in_dg')
 $is_in_dg = separateValueString(findDataValue 'is_in_dg')
 $have_go_out = separateValueString(findDataValue 'have_go_out')
 $is_specific_people =separateValueString(findDataValue 'is_specific_people')
 $health_code_status =separateValueString(findDataValue 'health_code_status')
 $in_controllerd_area = separateValueString(findDataValue 'in_controllerd_area')
 $completed_vaccination= separateValueString(findDataValue 'completed_vaccination')
 $is_in_school=separateValueString(findDataValue 'is_in_school')
 $have_stay_area = separateValueString(findDataValue 'have_stay_area')
 $family_situation = (separateValueString (findDataForm 'family_situation'))
 $gps_country = separateValueString(findData 'gps_country')
 $gps_province = separateValueString(findData 'gps_province')
 $gps_city  = separateValueString(findData 'gps_city')
 $gps_district=separateValueString(findData 'gps_district')
 $gps_country_name=(replaceUtoChar(separateValueString (findData 'gps_country_name')))
 $gps_province_name = (replaceUtoChar(separateValueString (findData 'gps_province_name')))
 $gps_city_name= (replaceUtoChar(separateValueString (findData 'gps_city_name')))
 $gps_district_name =(replaceUtoChar(separateValueString(findData 'gps_district_name')))
 $gps_address_name=(replaceUtoChar(separateValueString(findData 'gps_address_name')))

 $submitdata="{`"data`":{`"submit_time`":`""+ 
 $(Get-Date -Format 'yyyy-M-d')
 if($name){
 $submitdata=$submitdata+"`",`"name`":"+$name
 }
  if($faculty_name){
 $submitdata=$submitdata+"`"faculty_name`":"+$faculty_name
 }
   if($class_name){
 $submitdata=$submitdata+"`"class_name`":"+$class_name
 }
 if($username){
 $submitdata=$submitdata+"`"username`":"+$username
 }
 if($card_number){
 $submitdata=$submitdata+"`"card_number`":"+$card_number
 }
 if($identity_type){
 $submitdata=$submitdata+"`"identity_type`":"+$identity_type
 }
 if($tel){
 $submitdata=$submitdata+"`"tel`":"+$tel
 }
 if($body_temperature){
 $submitdata=$submitdata+"`"body_temperature`":"+$body_temperature
 }
 if($connect_person){
 $submitdata=$submitdata+"`"connect_person`":"+$connect_person
 }
 if($connect_tel){
 $submitdata=$submitdata+"`"connect_tel`":"+$connect_tel
 }
 if($recent_travel_situation){
 $submitdata=$submitdata+"`"recent_travel_situation`":"+$recent_travel_situation
 }
 if($focus_area){
 $submitdata=$submitdata+"`"focus_area`":"+$focus_area
 }
 if($family_address_detail){
 $submitdata=$submitdata+"`"family_address_detail`":"+$family_address_detail
 }
 if($current_country){
 $submitdata=$submitdata+"`"current_country`":"+$current_country
 }
 if($current_province){
 $submitdata=$submitdata+"`"current_province`":"+$current_province
 }
  if($current_city){
 $submitdata=$submitdata+"`"current_city`":"+$current_city
 }
 if($current_district){
 $submitdata=$submitdata+"`"current_district`":"+$current_district
 }
 if($latest_acid_test){
 $submitdata=$submitdata+"`"latest_acid_test`":"+$latest_acid_test
 }

  if($huji_region){
 $submitdata=$submitdata+"`"huji_region`":"+$huji_region
 }
 if($family_region){
 $submitdata=$submitdata+"`"family_region`":"+$family_region
 }
 if($jiguan_region){
 $submitdata=$submitdata+"`"jiguan_region`":"+$jiguan_region
 }
 if($current_region){
 $submitdata=$submitdata+"`"current_region`":"+$current_region
 }
 if($huji_region_name){
 $submitdata=$submitdata+"`"huji_region_name`":"+$huji_region_name
 }
 if($family_region_name){
 $submitdata=$submitdata+"`"family_region_name`":"+$family_region_name
 }
 if($jiguan_region_name){
 $submitdata=$submitdata+"`"jiguan_region_name`":"+$jiguan_region_name
 }
  if($current_region_name){
 $submitdata=$submitdata+"`"current_region_name`":"+$current_region_name
 }
 if($card_type){
 $submitdata=$submitdata+"`"card_type`":"+$card_type
 }
 if($campus){
 $submitdata=$submitdata+"`"campus`":"+$campus
 }
 if($health_situation){
 $submitdata=$submitdata+"`"health_situation`":"+$health_situation
 }
 if($have_gone_important_area){
 $submitdata=$submitdata+"`"have_gone_important_area`":"+$have_gone_important_area
 }

  if($have_contact_hubei_people){
 $submitdata=$submitdata+"`"have_contact_hubei_people`":"+$have_contact_hubei_people
 }
   if($have_contact_illness_people){
 $submitdata=$submitdata+"`"have_contact_illness_people`":"+$have_contact_illness_people
 }
 if($have_isolation_in_dg){
 $submitdata=$submitdata+"`"have_isolation_in_dg`":"+$have_isolation_in_dg
 }
 if($is_in_dg){
 $submitdata=$submitdata+"`"is_in_dg`":"+$is_in_dg
 }
 if($have_go_out){
 $submitdata=$submitdata+"`"have_go_out`":"+$have_go_out
 }
 if($is_specific_people){
 $submitdata=$submitdata+"`"is_specific_people`":"+$is_specific_people
 }
 if($health_code_status){
 $submitdata=$submitdata+"`"health_code_status`":"+$health_code_status
 }
  if($in_controllerd_area){
 $submitdata=$submitdata+"`"in_controllerd_area`":"+$in_controllerd_area
 }
 if($completed_vaccination){
 $submitdata=$submitdata+"`"completed_vaccination`":"+$completed_vaccination
 }
 if($is_in_school){
 $submitdata=$submitdata+"`"completed_vaccination`":"+$is_in_school
 }
 if($have_stay_area){
 $submitdata=$submitdata+"`"have_stay_area`":"+$have_stay_area
 }
 if($family_situation){
 $submitdata=$submitdata+"`"family_situation`":"+$family_situation
 }
 if($gps_country){
 $submitdata=$submitdata+"`"gps_country`":"+$gps_country
 }
 if($gps_province){
 $submitdata=$submitdata+"`"gps_province`":"+$gps_province
 }
 if($gps_city){
 $submitdata=$submitdata+"`"gps_city`":"+$gps_city
 }
 if($gps_district){
 $submitdata=$submitdata+"`"gps_district`":"+$gps_district
 }
  if($gps_country_name){
 $submitdata=$submitdata+"`"gps_country_name`":"+$gps_country_name
 }
 if($gps_province_name){
 $submitdata=$submitdata+"`"gps_province_name`":"+$gps_province_name
 }
 if($gps_city_name){
 $submitdata=$submitdata+"`"gps_city_name`":"+$gps_city_name
 }
 if($gps_district_name){
 $submitdata=$submitdata+"`"gps_district_name`":"+$gps_district_name
 }
 if($gps_address_name){
 $submitdata=$submitdata+"`"gps_address_name`":"+$gps_address_name
 }

 $submitdata=$submitdata+"}}"
 $submitdata = $submitdata -replace "`",}}",'"}}'
 
function replaceChar($str){

$regex=[regex]'\$\([\char\][a-z,0-9]*\)'
$group=$regex.Matches($str)

foreach($i in $group){
Write-Host( $i.Value -match '0x[a-z,0-9]*')
$value=[char][int]$Matches[0]
$strP=$i.Value -replace '\[','\[' 
$strP=$strP  -replace '\]','\]' 
$strP=$strP  -replace '\(','\('
$strP=$strP  -replace '\)','\)'  
$strP=$strP  -replace '\$','\$'  
$str=$str -replace $strP,$value

} 

return $str
}
function replaceHex2Int($s){
$regex=[regex]'0x[0-9,a-f]{4}'
$group=$regex.Matches($s)
foreach($i in $group){
 $val= [string][int]$i.Value
 $s=$s -replace $i.Value,$val
} 
return $s
}


$submitdata= (replaceHex2Int $submitdata)-replace '\\/','/'
<#$submitdata = ((replaceChar $submitdata) -replace '\\/','/')#>
#$submitdata=ConvertTo-Json $submitdata
echo $submitdata 
<#----------------发送数据-------------#>

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36 Edg/96.0.1054.62"
Invoke-WebRequest -UseBasicParsing -Uri "https://yqfk-daka-api.dgut.edu.cn/record/" `
-Method "POST" `
-WebSession $session `
-Headers @{
"sec-ch-ua"="`" Not A;Brand`";v=`"99`", `"Chromium`";v=`"96`", `"Microsoft Edge`";v=`"96`""
  "Accept"="application/json, text/plain, */*"
  "Authorization"=$auth
  "sec-ch-ua-mobile"="?0"
  "sec-ch-ua-platform"="`"Windows`""
  "Origin"="https://yqfk-daka.dgut.edu.cn"
  "Sec-Fetch-Site"="same-site"
  "Sec-Fetch-Mode"="cors"
  "Sec-Fetch-Dest"="empty"
  "Referer"="https://yqfk-daka.dgut.edu.cn/"
  "Accept-Encoding"="gzip, deflate, br"
  "Accept-Language"="zh-CN,zh;q=0.9"
} `
-ContentType "application/json" `
-Body  ([System.Text.Encoding]::UTF8.GetBytes($submitdata))
