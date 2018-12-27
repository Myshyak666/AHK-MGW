; SAMP UDF
SendMessage, 0x50,, 0x4190419,, A
class JSON
{
	Decode(jsonStr){

		; Create the COM object we'll use to decode the string
		SC := ComObjCreate("ScriptControl")
		SC.Language := "JScript"
		ComObjError(false)

		; This next part is a JScript (similar to JavaScript), not AHK, just FYI
		; This does the actual parsing
		jsCode =
		(
		function arrangeForAhkTraversing(obj){
			if(obj instanceof Array){
				for(var i=0 ; i<obj.length ; ++i)
					obj[i] = arrangeForAhkTraversing(obj[i]) ;
				return ['array',obj] ;f
			}else if(obj instanceof Object){
				var keys = [], values = [] ;
				for(var key in obj){
					keys.push(key) ;
					values.push(arrangeForAhkTraversing(obj[key])) ;
				}
				return ['object',[keys,values]] ;
			}else
				return [typeof obj,obj] ;
		}
		)

		; Decode the JSON into an array (call the JS function above) using the COM object, then return an AHK object
		SC.ExecuteStatement(jsCode "; obj=" jsonStr)
		return this.convertJScriptObjToAhks( SC.Eval("arrangeForAhkTraversing(obj)") )
	}

	Encode(obj){
		str := ""
		array := true
		for k in obj {
			if (k == A_Index)
				continue
			array := false
			break
		}
		for a, b in obj
			str .= (array ? "" : """" a """: ") . (IsObject(b) ? this.Encode(b) : """" b """") . ", "
		str := RTrim(str, " ,")
		return (array ? "[" str "]" : "{" str "}")
	}

	convertJScriptObjToAhks(jsObj){
		if(jsObj[0]="object"){
			obj := {}, keys := jsObj[1][0], values := jsObj[1][1]
			loop % keys.length
				obj[keys[A_INDEX-1]] := this.convertJScriptObjToAhks( values[A_INDEX-1] )
			return obj
		}else if(jsObj[0]="array"){
			array := []
			loop % jsObj[1].length
				array.insert(this.convertJScriptObjToAhks( jsObj[1][A_INDEX-1] ))
			return array
		}else
			return jsObj[1]
	}
}
global ADDR_SET_POSITION                    := 0xB7CD98
global ADDR_SET_POSITION_OFFSET             := 0x14
global ADDR_SET_POSITION_X_OFFSET           := 0x30
global ADDR_SET_POSITION_Y_OFFSET           := 0x34
global ADDR_SET_POSITION_Z_OFFSET           := 0x38
global ADDR_SET_INTERIOR_OFFSET             := 0xB72914
global SAMP_SZIP_OFFSET                     := 0x20
global SAMP_INFO_SETTINGS_OFFSET            := 0x3C5
global SAMP_DIALOG_LINENUMBER_OFFSET        := 0x140
global ERROR_OK                             := 0
global ERROR_PROCESS_NOT_FOUND              := 1
global ERROR_OPEN_PROCESS                   := 2
global ERROR_INVALID_HANDLE                 := 3
global ERROR_MODULE_NOT_FOUND               := 4
global ERROR_ENUM_PROCESS_MODULES           := 5
global ERROR_ZONE_NOT_FOUND                 := 6
global ERROR_CITY_NOT_FOUND                 := 7
global ERROR_READ_MEMORY                    := 8
global ERROR_WRITE_MEMORY                   := 9
global ERROR_ALLOC_MEMORY                   := 10
global ERROR_FREE_MEMORY                    := 11
global ERROR_WAIT_FOR_OBJECT                := 12
global ERROR_CREATE_THREAD                  := 13
global ADDR_ZONECODE                        := 0xA49AD4
global ADDR_POSITION_X                      := 0xB6F2E4
global ADDR_POSITION_Y                      := 0xB6F2E8
global ADDR_POSITION_Z                      := 0xB6F2EC
global ADDR_CPED_PTR                        := 0xB6F5F0
global ADDR_CPED_HPOFF                      := 0x540
global ADDR_CPED_ARMOROFF                   := 0x548
global ADDR_CPED_MONEY                      := 0x0B7CE54
global ADDR_CPED_INTID                      := 0xA4ACE8
global ADDR_CPED_SKINIDOFF                  := 0x22
global ADDR_VEHICLE_PTR                     := 0xBA18FC
global ADDR_VEHICLE_HPOFF                   := 0x4C0
global ADDR_VEHICLE_DOORSTATE               := 0x4F8
global ADDR_VEHICLE_ENGINESTATE             := 0x428
global ADDR_VEHICLE_SIRENSTATE              := 0x1069
global ADDR_VEHICLE_SIRENSTATE2             := 0x1300
global ADDR_VEHICLE_LIGHTSTATE              := 0x584
global ADDR_VEHICLE_MODEL                   := 0x22
global ADDR_VEHICLE_TYPE                    := 0x590
global ADDR_VEHICLE_DRIVER                  := 0x460
global ADDR_VEHICLE_X                       := 0x44
global ADDR_VEHICLE_Y                       := 0x48
global ADDR_VEHICLE_Z                       := 0x4C
global oAirplaneModels := [417, 425, 447, 460, 469, 476, 487, 488, 497, 511, 512, 513, 519, 520, 548, 553, 563, 577, 592, 593]
global oBikeModels := [481,509,510]
global ovehicleNames := ["Landstalker","Bravura","Buffalo","Linerunner","Perrenial","Sentinel","Dumper","Firetruck","Trashmaster","Stretch","Manana","Infernus","Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi","Washington","Bobcat","Whoopee","BFInjection","Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie","Stallion","Rumpo","RCBandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder","Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley'sRCVan","Skimmer","PCJ-600","Faggio","Freeway","RCBaron","RCRaider","Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR-350","Walton","Regina","Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","NewsChopper","Rancher","FBIRancher","Virgo","Greenwood","Jetmax","Hotring","Sandking","BlistaCompact","PoliceMaverick","Boxvillde","Benson","Mesa","RCGoblin","HotringRacerA","HotringRacerB","BloodringBanger","Rancher","SuperGT","Elegant","Journey","Bike","MountainBike","Beagle","Cropduster","Stunt","Tanker","Roadtrain","Nebula","Majestic","Buccaneer","Shamal","hydra","FCR-900","NRG-500","HPV1000","CementTruck","TowTruck","Fortune","Cadrona","FBITruck","Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent","Bullet","Clover","Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster","Monster","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RCTiger","Flash","Tahoma","Savanna","Bandito","FreightFlat","StreakCarriage","Kart","Mower","Dune","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","NewsVan","Tug","Trailer","Emperor","Wayfarer","Euros","Hotdog","Club","FreightBox","Trailer","Andromada","Dodo","RCCam","Launch","PoliceCar","PoliceCar","PoliceCar","PoliceRanger","Picador","S.W.A.T","Alpha","Phoenix","GlendaleShit","SadlerShit","Luggage","Luggage","Stairs","Boxville","Tiller","UtilityTrailer"]
global oweaponNames := ["Fist","Brass Knuckles","Golf Club","Nightstick","Knife","Baseball Bat","Shovel","Pool Cue","Katana","Chainsaw","Purple Dildo","Dildo","Vibrator","Silver Vibrator","Flowers","Cane","Grenade","Tear Gas","Molotov Cocktail", "", "", "", "9mm","Silenced 9mm","21Desert Eagle","Shotgun","Sawnoff Shotgun","Combat Shotgun","Micro SMG/Uzi","MP5","AK-47","M4","Tec-9","Country Rifle","Sniper Rifle","RPG","HS Rocket","Flamethrower","Minigun","Satchel Charge","Detonator","Spraycan","Fire Extinguisher","Camera","Night Vis Goggles","Thermal Goggles","Parachute"]
global oradiostationNames := ["Playback FM", "K Rose", "K-DST", "Bounce FM", "SF-UR", "Radio Los Santos", "Radio X", "CSR 103.9", "K-JAH West", "Master Sounds 98.3", "WCTR Talk Radio", "User Track Player", "Radio Off"]
global oweatherNames := ["EXTRASUNNY_LA", "SUNNY_LA", "EXTRASUNNY_SMOG_LA", "SUNNY_SMOG_LA", "CLOUDY_LA", "SUNNY_SF", "EXTRASUNNY_SF", "CLOUDY_SF", "RAINY_SF", "FOGGY_SF", "SUNNY_VEGAS", "EXTRASUNNY_VEGAS", "CLOUDY_VEGAS", "EXTRASUNNY_COUNTRYSIDE", "SUNNY_COUNTRYSIDE", "CLOUDY_COUNTRYSIDE", "RAINY_COUNTRYSIDE", "EXTRASUNNY_DESERT", "SUNNY_DESERT", "SANDSTORM_DESERT", "UNDERWATER", "EXTRACOLOURS_1", "EXTRACOLOURS_2"]
Global oWeaponIdForModel := {1:331, 2:333, 3:334, 4:335, 5:336, 6:337, 7:338, 8:339, 9:341, 10:321, 11:322, 12:323, 13:324, 14:325, 15:326, 16:342, 17:343, 18:344, 22:346, 23:347, 24:348, 25:349, 26:350, 27:351, 28:352, 29:353, 30:355, 31:356, 32:372, 33:357, 34:358, 35:359, 36:360, 37:361, 38:362, 39:363, 40:364, 41:365, 42:366, 43:367, 44:368, 45:369, 46:371}
global ADDR_SAMP_INCHAT_PTR                 := 0x21a10c
global ADDR_SAMP_INCHAT_PTR_OFF             := 0x55
global ADDR_SAMP_USERNAME                   := 0x219A6F
global FUNC_SAMP_SENDCMD                    := 0x65c60
global FUNC_SAMP_SENDSAY                    := 0x57f0
global FUNC_SAMP_ADDTOCHATWND               := 0x64520
global ADDR_SAMP_CHATMSG_PTR                := 0x21a0e4
global FUNC_SAMP_SHOWGAMETEXT               := 0x9c2c0
global FUNC_SAMP_PLAYAUDIOSTR               := 0x62da0
global FUNC_SAMP_STOPAUDIOSTR               := 0x629a0
global DIALOG_STYLE_MSGBOX			        := 0
global DIALOG_STYLE_INPUT 			        := 1
global DIALOG_STYLE_LIST			        := 2
global DIALOG_STYLE_PASSWORD		        := 3
global DIALOG_STYLE_TABLIST			        := 4
global DIALOG_STYLE_TABLIST_HEADERS	        := 5
global SAMP_DIALOG_STRUCT_PTR				:= 0x21A0B8
global SAMP_DIALOG_PTR1_OFFSET				:= 0x1C
global SAMP_DIALOG_LINES_OFFSET 			:= 0x44C
global SAMP_DIALOG_INDEX_OFFSET				:= 0x443
global SAMP_DIALOG_BUTTON_HOVERING_OFFSET	:= 0x465
global SAMP_DIALOG_BUTTON_CLICKED_OFFSET	:= 0x466
global SAMP_DIALOG_PTR2_OFFSET 				:= 0x20
global SAMP_DIALOG_LINECOUNT_OFFSET			:= 0x150
global SAMP_DIALOG_OPEN_OFFSET				:= 0x28
global SAMP_DIALOG_STYLE_OFFSET				:= 0x2C
global SAMP_DIALOG_ID_OFFSET				:= 0x30
global SAMP_DIALOG_TEXT_PTR_OFFSET			:= 0x34
global SAMP_DIALOG_CAPTION_OFFSET			:= 0x40
global FUNC_SAMP_SHOWDIALOG				 	:= 0x6B9C0
global FUNC_SAMP_CLOSEDIALOG				:= 0x6C040
global FUNC_UPDATESCOREBOARD                := 0x8A10
global SAMP_INFO_OFFSET                     := 0x21A0F8
global ADDR_SAMP_CRASHREPORT 				:= 0x5CF2C
global SAMP_PPOOLS_OFFSET                   := 0x3CD
global SAMP_PPOOL_PLAYER_OFFSET             := 0x18
global SAMP_SLOCALPLAYERID_OFFSET           := 0x4
global SAMP_ISTRLEN_LOCALPLAYERNAME_OFFSET  := 0x1A
global SAMP_SZLOCALPLAYERNAME_OFFSET        := 0xA
global SAMP_PSZLOCALPLAYERNAME_OFFSET       := 0xA
global SAMP_PREMOTEPLAYER_OFFSET            := 0x2E
global SAMP_ISTRLENNAME___OFFSET            := 0x1C
global SAMP_SZPLAYERNAME_OFFSET             := 0xC
global SAMP_PSZPLAYERNAME_OFFSET            := 0xC
global SAMP_ILOCALPLAYERPING_OFFSET         := 0x26
global SAMP_ILOCALPLAYERSCORE_OFFSET        := 0x2A
global SAMP_IPING_OFFSET                    := 0x28
global SAMP_ISCORE_OFFSET                   := 0x24
global SAMP_ISNPC_OFFSET                    := 0x4
global SAMP_PLAYER_MAX                      := 1004
global SAMP_KILLSTAT_OFFSET                 := 0x21A0EC
global multVehicleSpeed_tick                := 0
global CheckpointCheck 						:= 0xC7DEEA
global rmaddrs 								:= [0xC7DEC8, 0xC7DECC, 0xC7DED0]
global SIZE_SAMP_CHATMSG                    := 0xFC
global hGTA                                 := 0x0
global dwGTAPID                             := 0x0
global dwSAMP                               := 0x0
global pMemory                              := 0x0
global pParam1                              := 0x0
global pParam2                              := 0x0
global pParam3                              := 0x0
global pParam4                              := 0x0
global pParam5                              := 0x0
global pInjectFunc                          := 0x0
global nZone                                := 1
global nCity                                := 1
global bInitZaC                             := 0
global iRefreshScoreboard                   := 0
global oScoreboardData                      := ""
global iRefreshHandles                      := 0
global iUpdateTick                          := 2500
getWeaponAmmo(ByRef Ammo := "", ByRef Clip := "", slot := -1)
{
    if(!checkHandles())
    return -1
    if(!CPed := readDWORD(hGTA, ADDR_CPED_PTR))
    return -1
    if slot not between 0 and 12
    {
        VarSetCapacity(slot, 1)
        DllCall("ReadProcessMemory", "UInt", hGTA, "UInt", CPed + 0x718, "Str", slot, "UInt", 1, "UInt*", 0)
        slot := NumGet(slot, 0, "short")
        if slot >= 12544
        slot -= 12544
    }
    struct := CPed + 0x5AC
    VarSetCapacity(Ammo, 4)
    VarSetCapacity(Clip, 4)
    DllCall("ReadProcessMemory", "UInt", hGTA, "UInt", struct + (0x1C * slot), "Str", Ammo, "UInt", 4, "UInt*", 0)
    DllCall("ReadProcessMemory", "UInt", hGTA, "UInt", struct + (0x1C * slot) - 0x4, "Str", Clip, "UInt", 4, "UInt*", 0)
    Ammo := NumGet(Ammo, 0, "int")
    Clip := NumGet(Clip, 0, "int")
    return Ammo
}
GetCameraRotation() {
    If(!checkHandles())
    return -1
    return readFloat(hGTA, 0xB6F178)
}
NightVision(value) {
    If(!checkHandles())
    return false
    If(value)
    writeMemory(hGTA, 0xC402B8, 0x1)
    else writeMemory(hGTA, 0xC402B8, 0x0)
}
setCarNitro() {
    If(!checkHandles())
    return -1
    return writeMemory(hGTA, 0x969165, 0x1)
}
ThermalVision(value) {
    If(!checkHandles())
    return false
    If(value)
    writeMemory(hGTA, 0xC402B9, 0x1)
    else writeMemory(hGTA, 0xC402B9, 0x0)
}
UnderWaterDrive(value) {
    If(!checkHandles())
    return false
    If(value)
    writeMemory(hGTA, 0x6C2759, 0x1)
    else writeMemory(hGTA, 0x6C2759, 0x0)
}
WaterDrive(value) {
    If(!checkHandles())
    return false
    If(value) {
        writeMemory(hGTA, 0x969152, 0x1)
    } else {
        writeMemory(hGTA, 0x969152, 0x0)
    }
}
GetGravity() {
    If(!checkHandles())
    return -1
    return readFloat(hGTA, 0x863984)
}
SetGravity(value) {
    If(!checkHandles())
    return -1
    writeMemory(hGTA, 0x863984, value, 4, "float")
}
UnlockFps(status) {
    if(!checkHandles())
    return false
    if (status = 1) {
        dwSAMP := getModuleBaseAddress("samp.dll", hGTA)
        writeMemory(hGTA, dwSAMP + 0x9D9D0, 1347550997, 4, "UInt")
    }
    if (status = 0) {
        dwSAMP := getModuleBaseAddress("samp.dll", hGTA)
        writeMemory(hGTA, dwSAMP + 0x9D9D0, 4294417384, 4, "UInt")
    }
    return
}
AntiPause() {
    if(!checkHandles())
    return false
    writeBytes(hGTA, 0x747FB6, "01")
    writeBytes(hGTA, 0x74805A, "01")
    writeBytes(hGTA, 0x74542B, "90909090909090")
    writeBytes(hGTA, 0x74542C, "90909090909090")
    writeBytes(hGTA, 0x74542D, "909090909090")
    return
}
WallHack(tog := -1)
{
    if(!checkHandles())
    return -1
    byte := readMem(hGTA, dwSAMP + 0x70F1A, 1, "byte")
    if((tog == -1 && byte == 232) || tog == true || tog == 1) {
        writeBytes(hGTA, dwSAMP + 0x70F1A, "9090909090")
        writeBytes(hGTA, dwSAMP + 0x6FE0A, "9090909090")
        writeBytes(hGTA, dwSAMP + 0x70E24, "909090909090")
        writeBytes(hGTA, dwSAMP + 0x6FD14, "909090909090")
        return true
    } else if((tog == -1 && byte == 144) || !tog) {
        writeBytes(hGTA, dwSAMP + 0x70F1A, "E8B1AD0300")
        writeBytes(hGTA, dwSAMP + 0x6FE0A, "E8C1BE0300")
        writeBytes(hGTA, dwSAMP + 0x70E24, "0F8A71010000")
        writeBytes(hGTA, dwSAMP + 0x6FD14, "0F8A50010000")
        return false
    }
    return -1
}
getGameScreenWidthHeight() {
    if(!checkHandles())
    return false
    Width := readDword(hGTA, 0xC9C040)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    Height := readDword(hGTA, 0xC9C044)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    ErrorLevel := ERROR_OK
    return [Width, Height]
}
GetWeaponIDforModel(model)
{
    for iID, iModelId in oWeaponIdForModel
    if (iModelId == model)
    return iID
    return 0
}
setDialogIndex(index)
{
    dwPointer := getDialogStructPtr()
    if (ErrorLevel || !dwPointer)
    return false
    dwPointer := readDWORD(hGTA, dwPointer + SAMP_DIALOG_PTR2_OFFSET)
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    return writeMemory(hGTA, dwPointer + 0x143, index - 1, 1, "Byte")
}
IsLineOfSightClear(startX,startY,startZ,endX,endY,endZ,bCheckBuildings, bCheckVehicles, bCheckPeds, bCheckObjects, bCheckDummies, bSeeThroughStuff, bIgnoreSomeObjectsForCamera) {
    if(!checkHandles())
    return 0
    dwFunc := 0x56A490
    dwLen := 59
    VarSetCapacity(injectData, dwLen, 0)
    VarSetCapacity(vectors, 24, 0)
    NumPut(startX, vectors, 0, "Float")
    NumPut(startY, vectors, 4, "Float")
    NumPut(startZ, vectors, 8, "Float")
    NumPut(endX, vectors, 12, "Float")
    NumPut(endY, vectors, 16, "Float")
    NumPut(endZ, vectors, 20, "Float")
    writeRaw(hGTA, pParam1, &vectors, 24)
    NumPut(0x68, injectData, 0, "UChar")
    NumPut(bIgnoreSomeObjectsForCamera, injectData, 1, "UInt")
    NumPut(0x68, injectData, 5, "UChar")
    NumPut(bSeeThroughStuff, injectData, 6, "UInt")
    NumPut(0x68, injectData, 10, "UChar")
    NumPut(bCheckDummies, injectData, 11, "UInt")
    NumPut(0x68, injectData, 15, "UChar")
    NumPut(bCheckObjects, injectData, 16, "UInt")
    NumPut(0x68, injectData, 20, "UChar")
    NumPut(bCheckPeds, injectData, 21, "UInt")
    NumPut(0x68, injectData, 25, "UChar")
    NumPut(bCheckVehicles, injectData, 26, "UInt")
    NumPut(0x68, injectData, 30, "UChar")
    NumPut(bCheckBuildings, injectData, 31, "UInt")
    NumPut(0x68, injectData, 35, "UChar")
    NumPut(pParam1+12, injectData, 36, "UInt")
    NumPut(0x68, injectData, 40, "UChar")
    NumPut(pParam1, injectData, 41, "UInt")
    NumPut(0xE8, injectData, 45, "UChar")
    offset := dwFunc - (pInjectFunc + 50)
    NumPut(offset, injectData, 46, "UInt")
    NumPut(0xA2, injectData, 50, "UChar")
    NumPut(pParam2, injectData, 51, "UInt")
    NumPut(0xC483, injectData, 55, "UShort")
    NumPut(0x24, injectData, 57, "UChar")
    NumPut(0xC3, injectData, 58, "UChar")
    writeRaw(hGTA, pInjectFunc, &injectData, dwLen)
    if(ErrorLevel)
    return 0
    hThread := createRemoteThread(hGTA, 0, 0, pInjectFunc, 0, 0, 0)
    if(ErrorLevel)
    return 0
    waitForSingleObject(hThread, 0xFFFFFFFF)
    closeProcess(hThread)
    return (readDWORD(hGTA, pParam2) ? 1 : 0)
}
IsPlayerVisible(ped)
{
    If(!checkHandles())
    return false
    dwFunc := 0x536BC0
    dwLen := 16
    VarSetCapacity(injectData, dwLen, 0)
    NumPut(0xB9, injectData, 0, "UChar")
    NumPut(ped, injectData, 1, "UInt")
    NumPut(0xE8, injectData, 5, "UChar")
    offset := dwFunc - (pInjectFunc + 10)
    NumPut(offset, injectData, 6, "Int")
    NumPut(0xA2, injectData, 10, "UChar")
    NumPut(pParam1, injectData, 11, "Int")
    NumPut(0xC3, injectData, 15, "UChar")
    writeRaw(hGTA, pInjectFunc, &injectData, dwLen)
    hThread := createRemoteThread(hGTA, 0, 0, pInjectFunc, 0, 0, 0)
    waitForSingleObject(hThread, 0xFFFFFFFF)
    closeProcess(hThread)
    return readMem(hGTA, pParam1, 1, "UChar")
}
curl(method, adress, package := "", user_agent := "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.110 Safari/537.36 u01-05", error_log := 0, time_out := 0)
{
	if (GetOSVersion() == 7)
	{
		RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp, DefaultSecureProtocols, 2560
		RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp, DefaultSecureProtocols, 2560
	}
	if (!RegExMatch(adress, "^http[s]?:\/\/.*\..*$"))
		return error_log ? "Invalid URL adress (#1)" : false
	else if (!DllCall("Wininet.dll\InternetGetConnectedState", "Str", 0x20, "Int", 0))
		return error_log ? "Not internet connection (#2)" : false
	try
	{
		temp_package := ""
		for k, v in package
			temp_package .= (A_Index > 1 ? "&" : (method == "POST" ? "" : "?")) k "=" (IsObject(v) ? JSON.Encode(v) : v)
		http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		http.Open(method, adress (method != "POST" ? temp_package : ""), false)
		http.SetRequestHeader("Referer", adress)
		http.SetRequestHeader("User-Agent", user_agent)
		http.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
		http.SetRequestHeader("Pragma", "no-cache")
		http.SetRequestHeader("Cache-Control", "no-cache, no-store")
		http.SetRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT")
		http.Send((method == "POST" ? temp_package : ""))
		http.WaitForResponse(time_out ? time_out : 0)
		if (!StrLen(http.ResponseText))
			return error_log ? "Empty response (#3)" : false
		else
		{
			if (http.Status !== 200)
				return error_log ? http.Status "(" http.StatusText ") (#4)" : false
			else
			{
				ResponseText := RegExReplace(http.ResponseText, "<br>", "`n")
				ResponseText := RegExReplace(ResponseText, "<t>", "`t")
				ResponseText := RegExReplace(ResponseText, "<br \/>", "`n")
				return ResponseText
			}
		}
	}
	catch e
		return error_log ? e.message "(#5)" : false
}

get(url, user_agent := "", time_out := 5)
{
	if (!user_agent)
		user_agent := "Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 YaBrowser/17.6.1.744 Yowser/2.5 Safari/537.36"
	loop 5
	{
		ComObjError(false)
		whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET", url)
		whr.WaitForResponse(time_out)
		whr.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
		whr.SetRequestHeader("User-Agent", user_agent)
		whr.Send()
		if(!strlen(whr.ResponseText))
			continue

		ResponseText := RegExReplace(whr.ResponseText, "<br>", "`n")
		ResponseText := RegExReplace(ResponseText, "<t>", "`t")
		ResponseText := RegExReplace(ResponseText, "<br \/>", "`n")
		return ResponseText
	}
}
post(url, send := "", user_agent := "", result := 0, time_out := 5)
{
	if (!user_agent)
		user_agent := "Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 YaBrowser/17.6.1.744 Yowser/2.5 Safari/537.36"
    try
    {
        hObject := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        hObject.Open("POST", url)
        hObject.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
        hObject.SetRequestHeader("User-Agent", user_agent)
        hObject.Send(send)
        hObject.WaitForResponse(time_out)
    }
    catch ex
        return 0
    if (!result)
        return 1
    else if (result)
    {
		ResponseText := RegExReplace(hObject.ResponseText, "<br>", "`n")
		ResponseText := RegExReplace(ResponseText, "<t>", "`t")
		ResponseText := RegExReplace(ResponseText, "<br \/>", "`n")
        return ResponseText
    }
}
GetResultCurl(str) 
{ 
if (RegExMatch(str, "<JSON_RESULT>(.*)</JSON_RESULT>", out_pars)) 
return out_pars1 
return 
}
getTargetPlayerHealth(player)
{
    if(!checkHandles())
    return 0
    if (player is integer) and (player >= 0) and (player <= 999)
    player := getPedById(player)
    if(!player)
    return 0
    return readMem(hGTA, player + 0x540, 2, "byte")
}
getTargetPlayerArmour(player)
{
    if(!checkHandles())
    return 0
    if (player is integer) and (player >= 0) and (player <= 999)
    player := getPedById(player)
    if(!player)
    return 0
    return readMem(hGTA, player + 0x548, 2, "byte")
}
getTargetPlayerWeaponModel(player)
{
    if(!checkHandles())
    return 0
    if (player is integer) and (player >= 0) and (player <= 999)
    player := getPedById(player)
    if(!player)
    return 0
    model := readMem(hGTA, player + 0x740, 2, "byte")
    if(model == 65535)
    return 0
    return model
}
CJ()
{
    if(!checkHandles())
    return false
    SIZE := 5
    dwFunc := dwSAMP + 0x15860
    offset := dwFunc - (pInjectFunc + SIZE)
    VarSetCapacity(inject, SIZE + 1, 0)
    NumPut(0xE8, inject, 0, "UChar")
    NumPut(offset, inject, 1, "Int")
    NumPut(0xC3, inject, 5, "UChar")
    writeRaw(hGTA, pInjectFunc, &inject, SIZE + 1)
    hThread := createRemoteThread(hGTA, 0, 0, pInjectFunc, 0, 0, 0)
    waitForSingleObject(hThread, 0xFFFFFFFF)
    closeProcess(hThread)
    return true
}
getChatLineColor(line := 0, isHex := true) {
    if(!checkHandles())
    return -1
    dwAddress := readDWORD(hGTA, dwSAMP + ADDR_SAMP_CHATMSG_PTR)
    if ErrorLevel
    return -1
    clAddress := dwAddress + 0x152 + ((99-line) * 0xFC) + 0xD4
    if ErrorLevel
    return -1
    color := readMem(hGTA, clAddress, 3, "byte")
    if ErrorLevel
    return -1
    if isHex
    return inttohex(color)
    return color
}
setChatLineColor(color, line := 0) {
    if(!checkHandles())
    return false
    if color is not integer
    {
        while(substr(color, 1, 1) == "0")
        color := substr(color, 2)
        color := "0x" color
        if strlen(color) != 8
        return false
    } else if(color > 16777215)
    return false
    dwAddress := readDWORD(hGTA, dwSAMP + ADDR_SAMP_CHATMSG_PTR)
    if ErrorLevel
    return false
    clAddress := dwAddress + 0x152 + ((99-line) * 0xFC) + 0xD4
    if ErrorLevel
    return false
    writeMemory(hGTA, clAddress, color, 3, "byte")
    if ErrorLevel
    return false
sendinput {f7 3}
    return true
}
getChatLineTimestamp(line := 0, unixtime := true) {
    if(!checkHandles())
    return -1
    dwAddress := readDWORD(hGTA, dwSAMP + ADDR_SAMP_CHATMSG_PTR)
    if ErrorLevel
    return -1
    tsAddress := dwAddress + 0x152 + ((99-line) * 0xFC) - 0x20
    if ErrorLevel
    return -1
    timestamp := readMem(hGTA, tsAddress, 4, "int")
    if ErrorLevel
    return -1
    if unixtime
    return timestamp
    s = 1970
    s += timestamp,s
    return [ substr(s, 9, 2) , substr(s, 11, 2) , substr(s, 13, 2) , substr(s, 7, 2) , substr(s, 5, 2) , substr(s, 1, 4) ]
}
setChatLineTimestamp(timestamp, line := 0) {
    if(!checkHandles())
    return false
    if timestamp is float
    timestamp := floor(timestamp)
    if substr(timestamp, 1, 1) == "+" or substr(timestamp, 1, 1) == "-"
    timestamp := getChatLineTimestamp(line) + timestamp
    if timestamp is not integer
    return false
    dwAddress := readDWORD(hGTA, dwSAMP + ADDR_SAMP_CHATMSG_PTR)
    if ErrorLevel
    return false
    tsAddress := dwAddress + 0x152 + ((99-line) * 0xFC) - 0x20
    if ErrorLevel
    return false
    writeMemory(hGTA, tsAddress, timestamp, 4, "int")
    if ErrorLevel
    return -1
sendinput {f7 3}
    return true
}
NOP_SetPlayerPos(tog := -1)
{
    if(!checkHandles())
    return -1
    dwAddress := dwSAMP+0x15970
    byte := readMem(hGTA, dwAddress, 1, "byte")
    if((tog == -1 && byte != 195) || tog == true || tog == 1)
    {
        writeBytes(hGTA, dwAddress, "C390")
        return true
    } else if((tog == -1 && byte == 195) || !tog)
    {
        writeBytes(hGTA, dwAddress, "E910")
        return false
    }
    return -1
}
removeChatLine(line := 0)
{
    if(!checkHandles())
    return false
    if(!dwAddress := readDWORD(hGTA, dwSAMP + ADDR_SAMP_CHATMSG_PTR))
    return false
    loop % 100 - line
    {
        a := ""
        dwLine := dwAddress + 0x132 + ( (99 - A_Index - line) * 0xFC )
        loop 0xFC
        {
            byte := substr(inttohex(Memory_ReadByte(hGTA, dwLine++)), 3)
            a .= (strlen(byte) == 1 ? "0" : "") byte
        }
        dwLine := dwAddress + 0x132 + ( (100 - A_Index - line) * 0xFC )
        writeBytes(hGTA, dwLine, a)
    }
sendinput {f7 3}
    return true
}
getChatLineEx(line := 0) {
    if(!checkHandles())
    return
    dwPtr := dwSAMP + ADDR_SAMP_CHATMSG_PTR
    dwAddress := readDWORD(hGTA, dwPtr)
    if(ErrorLevel)
    return
    msg := readString(hGTA, dwAddress + 0x152 + ( (99-line) * 0xFC), 0xFC)
    if(ErrorLevel)
    return
    return msg
}
PrintLow(text, time) {
    if(!checkHandles())
    return -1
    dwFunc := 0x69F1E0
    callwithparams(hGta, dwFunc, [["s",text], ["i", time], ["i", 1], ["i", 1]], true)
}
getChatState(state := -1)
{
    if(!checkHandles())
    return false
    dwAddr := readDWORD(hGTA, dwSAMP + ADDR_SAMP_CHATMSG_PTR) + 8
    if state between 0 and 2
    {
        writeByte(hGTA, dwAddr, state)
    sendinput {f7 3}
    }
    return Memory_ReadByte(hGTA, dwAddr)
}
GetBonePosition(ped,boneId){
    callWithParamsBonePos(0x5E4280, [["i", ped],["i", pParamBonePos1],["i",boneId],["i", 1]], false, true)
    return [readFloat(hGTA, pParamBonePos1), readFloat(hGTA, pParamBonePos1 + 4), readFloat(hGTA, pParamBonePos1 + 8)]
}
callWithParamsBonePos(dwFunc, aParams, bCleanupStack = true,  thiscall = false) {
    validParams := 0
    i := aParams.MaxIndex()
    dwLen := i * 5 + 5 + 1
    if(bCleanupStack)
    dwLen += 3
    VarSetCapacity(injectData, i * 5 + 5 + 3 + 1, 0)
    i_ := 1
    while(i > 0) {
        if(aParams[i][1] != "") {
            dwMemAddress := 0x0
            if(aParams[i][1] == "p") {
                dwMemAddress := aParams[i][2]
            } else if(aParams[i][1] == "s") {
                if(i_>3)
                return false
                dwMemAddress := pParamBonePos%i_%
                writeString(hGTA,dwMemAddress, aParams[i][2])
                if(ErrorLevel)
                return false
                i_ += 1
            } else if(aParams[i][1] == "i") {
                dwMemAddress := aParams[i][2]
            } else {
                return false
            }
            NumPut((thiscall && i == 1 ? 0xB9 : 0x68), injectData, validParams * 5, "UChar")
            NumPut(dwMemAddress, injectData, validParams * 5 + 1, "UInt")
            validParams += 1
        }
        i -= 1
    }
    offset := dwFunc - ( pInjectFuncBonePos + validParams * 5 + 5 )
    NumPut(0xE8, injectData, validParams * 5, "UChar")
    NumPut(offset, injectData, validParams * 5 + 1, "Int")
    if(bCleanupStack) {
        NumPut(0xC483, injectData, validParams * 5 + 5, "UShort")
        NumPut(validParams*4, injectData, validParams * 5 + 7, "UChar")
        NumPut(0xC3, injectData, validParams * 5 + 8, "UChar")
    } else {
        NumPut(0xC3, injectData, validParams * 5 + 5, "UChar")
    }
    writeRaw(hGTA, pInjectFuncBonePos, &injectData, dwLen)
    if(ErrorLevel)
    return false
    hThread := createRemoteThread(hGTA, 0, 0, pInjectFuncBonePos, 0, 0, 0)
    if(ErrorLevel)
    return false
    waitForSingleObject(hThread, 0xFFFFFFFF)
    closeProcess(hThread)
    return true
}
getVehicleMaxPassengers()
{
    if(!checkHandles())
    return -1
    if(!CVeh := readDWORD(hGTA, ADDR_VEHICLE_PTR))
    return -1
    return readMem(hGTA, CVeh + 0x488, 1, "byte")
}
getVehiclePassenger(place)
{
    if(!checkHandles())
    return -1
    if(!CVeh := readDWORD(hGTA, ADDR_VEHICLE_PTR))
    return -1
    return readDWORD(hGTA, CVeh + 0x460 + (place * 4))
}
getVehiclePassengerId(place)
{
    CPed := getVehiclePassenger(place)
    return getIdByPed(CPed)
}
getLastDamagePed(ByRef Ped := "", ByRef Weapon := "")
{
    if(!checkHandles())
    return -1
    if(!CPed := readDWORD(hGTA, ADDR_CPED_PTR))
    return -1
    if(!dwPed := readDWORD(hGTA, CPed + 0x764))
    return -1
    Ped := getIdByPed(dwPed)
    Weapon := readMem(hGTA, CPed + 0x760, 4, "int")
    return Ped
}
getKillStat(ByRef IsEnabled := "")
{
    if(!checkHandles())
    return false
    a := []
    klist := readDWORD(hGTA, dwSAMP + 0x21A0EC)
    isEnabled := readMem(hGTA, klist, 4, "int")
    klist += 4
    loop 5
    {
        szKiller := readString(hGTA, klist, 25)
        szVictim := readString(hGTA, (klist += 25), 25)
        clKillerColor := inttohex(readMem(hGTA, (klist += 25), 4, "uint"))
        clVictimColor := inttohex(readMem(hGTA, (klist += 4), 4, "uint"))
        byteType := Memory_ReadByte(hGTA, (klist += 4))
        klist++
        a.Insert([szKiller, szVictim, clKillerColor, clVictimColor, byteType])
    }
    return a
}
setFireImmunity(state)
{
    if(!checkHandles())
    return
    writeMemory(hGTA, 0xB7CEE6, (state ? 1 : 0), 1, "byte")
}
setInfiniteRun(state)
{
    if(!checkHandles())
    return
    writeMemory(hGTA, 0xB7CEE4, (state ? 1 : 0), 1, "byte")
}
isMarkerSetup()
{
    if(!checkHandles())
    return -1
    return readMem(hGTA, 0xBA6774, 1, "byte")
}
multVehicleSpeed(MultValue := 1.01, SleepTime := 10, MaxSpeedX := 2.0, MaxSpeedY := 2.0)
{
    if(multVehicleSpeed_tick + SleepTime > A_TickCount)
    return false
    multVehicleSpeed_tick := A_TickCount
    if(!checkHandles())
    return false
    if(!dwAddr := readDWORD(hGTA, ADDR_VEHICLE_PTR))
    return false
    if(!MultValue)
    {
        writeFloat(hGTA, dwAddr + ADDR_VEHICLE_X, 0.0)
        writeFloat(hGTA, dwAddr + ADDR_VEHICLE_Y, 0.0)
        return true
    }
    fSpeedX := readMem(hGTA, dwAddr + ADDR_VEHICLE_X, 4, "float")
    fSpeedY := readMem(hGTA, dwAddr + ADDR_VEHICLE_Y, 4, "float")
    if(abs(fSpeedX) <= MaxSpeedX)
    writeFloat(hGTA, dwAddr + ADDR_VEHICLE_X, fSpeedX * MultValue)
    if(abs(fSpeedY) <= MaxSpeedY)
    writeFloat(hGTA, dwAddr + ADDR_VEHICLE_Y, fSpeedY * MultValue)
    return true
}
togglekillstat(state)
{
    if(!checkHandles())
    return false
    dwKillptr := readDWORD(hGTA, dwSAMP + SAMP_KILLSTAT_OFFSET)
    if(ErrorLevel || dwKillptr == 0) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    writeBytes(hGTA, dwKillptr, state)
    if(ErrorLevel) {
        ErrorLevel := ERROR_WRITE_MEMORY
        return -1
    }
    return true
}
setkillstatwidth(width)
{
    if(!checkHandles())
    return false
    dwKillptr := readDWORD(hGTA, dwSAMP + SAMP_KILLSTAT_OFFSET)
    if(ErrorLevel || dwKillptr == 0) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    writeBytes(hGTA, dwKillptr + 0x133, width)
    if(ErrorLevel) {
        ErrorLevel := ERROR_WRITE_MEMORY
        return false
    }
    return true
}
movekillstat(x)
{
    if(!checkHandles())
    return false
    dwKillptr := readDWORD(hGTA, dwSAMP + SAMP_KILLSTAT_OFFSET)
    if(ErrorLevel || dwKillptr == 0) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    writeBytes(hGTA, dwKillptr + 0x12B, x)
    if(ErrorLevel) {
        ErrorLevel := ERROR_WRITE_MEMORY
        return false
    }
    return true
}
setdistkillstat(int)
{
    if(!checkHandles())
    return false
    dwKillptr := readDWORD(hGTA, dwSAMP + SAMP_KILLSTAT_OFFSET)
    if(ErrorLevel || dwKillptr == 0) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    writeBytes(hGTA, dwKillptr + 0x12F, int)
    if(ErrorLevel) {
        ErrorLevel := ERROR_WRITE_MEMORY
        return false
    }
    return true
}
getWeaponSlotById(id)
{
    if id between 2 and 9
    slot := 1
    if id between 10 and 15
    slot := 10
    if id in 16,17,18,39
    slot := 8
    if id between 22 and 24
    slot := 2
    if id between 25 and 27
    slot := 3
    if id in 28,29,32
    slot := 4
    if id in 30,31
    slot := 5
    if id in 33,34
    slot := 6
    if id between 35 and 38
    slot := 7
    if id == 40
    slot := 12
    if id between 41 and 43
    slot := 9
    if id between 44 and 46
    slot := 11
}
isPlayerCrouch()
{
    if(!checkHandles())
    return -1
    if(!CPed := readDWORD(hGTA, ADDR_CPED_PTR))
    return -1
    state := readMem(hGTA, CPed + 0x46F, 1, "byte")
    if(state == 132)
    return 1
    if(state == 128)
    return 0
    return -1
}
setDialogState(tog)
{
    if(!checkHandles())
    return false
    dwPointer := getDialogStructPtr()
    if(ErrorLevel || !dwPointer)
    return false
    writeMemory(hGTA, dwPointer + 0x28, (tog ? 1 : 0), 1, "byte")
    if(!tog)
Send {f6}{esc}
    return true
}
toggleObjectDrawMode(tog := -1)
{
    if(!checkHandles())
    return -1
    byte := readMem(hGTA, dwSAMP + 0x69529, 1, "byte")
    if((tog == -1 && byte == 15) || tog == true || tog == 1)
    {
        writeBytes(hGTA, dwSAMP + 0x69529, "909090909090")
        return true
    } else if((tog == -1 && byte == 144) || !tog)
    {
        writeBytes(hGTA, dwSAMP + 0x69529, "0F84AE000000")
    Send {f6}{esc}
        return false
    }
    return -1
}
blurlevel(level := -1)
{
    if(!checkHandles())
    return -1
    if level between 0 and 255
    writeMemory(hGTA, 0x8D5104, level, 1, "byte")
    blur := readMem(hGTA, 0x8D5104, 1, "byte")
    return blur
}
toggleNoDamageByWeapon(tog := -1)
{
    if(!checkHandles())
    return -1
    byte := readMem(hGTA, 0x60A5BA, 1, "byte")
    if((tog == -1 && byte == 216) || tog == true || tog == 1)
    {
        writeBytes(hGTA, 0x60A5BA, "909090")
        return true
    } else if((tog == -1 && byte == 144) || !tog)
    {
        writeBytes(hGTA, 0x60A5BA, "D95E18")
        return false
    }
    addChatMessageEx(0xCC0000, "only for gta_sa.exe 1.0 us")
    return -1
}
toggleInvulnerability(tog := -1)
{
    if(!checkHandles())
    return -1
    byte := readMem(hGTA, 0x60A5BA, 1, "byte")
    if((tog == -1 && byte == 217) || tog == true || tog == 1)
    {
        writeBytes(hGTA, 0x4B3314, "909090")
        return true
    } else if((tog == -1 && byte == 144) || !tog)
    {
        writeBytes(hGTA, 0x4B3314, "D86504")
        return false
    }
    addChatMessageEx(0xCC0000, "only for gta_sa.exe 1.0 us")
    return -1
}
gmpatch()
{
    if(!checkHandles())
    return false
    a := writeMemory(hGTA, 0x4B35A0, 0x560CEC83, 4, "int")
    b := writeMemory(hGTA, 0x4B35A4, 0xF18B, 2, "byte")
    return (a && b)
}
toggleUnlimitedAmmo(tog := -1)
{
    if(!checkHandles())
    return -1
    byte := readMem(hGTA, 0x7428E6, 1, "byte")
    if((tog == -1 && byte == 255) || tog == true || tog == 1)
    {
        writeBytes(hGTA, 0x7428E6, "909090")
        return true
    } else if((tog == -1 && byte == 144) || !tog)
    {
        writeBytes(hGTA, 0x7428E6, "FF4E0C")
        return false
    }
    addChatMessageEx(0xCC0000, "only for gta_sa.exe 1.0 us")
    return -1
}
toggleNoReload(tog := -1)
{
    if(!checkHandles())
    return -1
    byte := readMem(hGTA, 0x7428B0, 1, "byte")
    if((tog == -1 && byte == 137) || tog == true || tog == 1)
    {
        writeBytes(hGTA, 0x7428B0, "909090")
        return true
    } else if((tog == -1 && byte == 144) || !tog)
    {
        writeBytes(hGTA, 0x7428B0, "894608")
        return false
    }
    addChatMessageEx(0xCC0000, "only for gta_sa.exe 1.0 us")
    return -1
}
toggleNoRecoil(tog := -1)
{
    if(!checkHandles())
    return -1
    byte := readMem(hGTA, 0x740450, 1, "byte")
    if((tog == -1 && byte == 216) || tog == true || tog == 1)
    {
        writeBytes(hGTA, 0x740450, "90909090909090909090")
        return true
    } else if((tog == -1 && byte == 144) || !tog)
    {
        writeBytes(hGTA, 0x740450, "D80D3C8B8500D84C241C")
        return false
    }
    addChatMessageEx(0xCC0000, "only for gta_sa.exe 1.0 us")
    return -1
}
toggleAntiBikeFall(tog := -1)
{
    if(!checkHandles())
    return -1
    byte := readMem(hGTA, 0x4BA3B9, 1, "byte")
    if((tog == -1 && byte == 15) || tog == true || tog == 1)
    {
        writeBytes(hGTA, 0x4BA3B9, "E9A703000090")
        return true
    } else if((tog == -1 && byte == 233) || !tog)
    {
        writeBytes(hGTA, 0x4BA3B9, "0F84A6030000")
        return false
    }
    addChatMessageEx(0xCC0000, "only for gta_sa.exe 1.0 us")
    return -1
}
toggleAntiCarEject(tog := -1)
{
    if(!checkHandles())
    return -1
    byte := readMem(hGTA, dwSAMP + 0x146E0, 1, "byte")
    if((tog == -1 && byte == 233) || tog == true || tog == 1)
    {
        writeBytes(hGTA, dwSAMP + 0x146E0, "C390909090")
        return true
    } else if((tog == -1 && byte == 195) || !tog)
    {
        writeBytes(hGTA, dwSAMP + 0x146E0, "E9D7722700")
        return false
    }
    return -1
}
toggleNoAnimations(tog := -1)
{
    if(!checkHandles())
    return -1
    byte := readMem(hGTA, dwSAMP + 0x16FA0, 1, "byte")
    if((tog == -1 && byte == 85) || tog == true || tog == 1)
    {
        writeMemory(hGTA, dwSAMP + 0x16FA0, 0xC3, 1, "byte")
        return true
    } else if((tog == -1 && byte == 195) || !tog)
    {
        writeMemory(hGTA, dwSAMP + 0x16FA0, 0x55, 1, "byte")
        return false
    }
    return -1
}
toggleMotionBlur(tog := -1)
{
    if(!checkHandles())
    return -1
    byte := readMem(hGTA, 0x704E8A, 1, "byte")
    if((tog == -1 && byte == 144) || tog == true || tog == 1)
    {
        writeBytes(hGTA, 0x704E8A, "E811E2FFFF")
        return true
    } else if((tog == -1 && byte == 232) || !tog)
    {
        writeBytes(hGTA, 0x704E8A, "9090909090")
        return false
    }
    addChatMessageEx(0xCC0000, "only for gta_sa.exe 1.0 us")
    return -1
}
writeBytes(handle, address, bytes)
{
    length := strlen(bytes) / 2
    VarSetCapacity(toInject, length, 0)
    Loop %length%
    {
        byte := "0x" substr(bytes, ((A_Index - 1) * 2) + 1, 2)
        NumPut(byte, toInject, A_Index - 1, "uchar")
    }
    return writeRaw(handle, address, &toInject, length)
}
setPlayerFreeze(status) {
    if(!checkHandles())
    return -1
    dwCPed := readDWORD(hGTA, 0xB6F5F0)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    dwAddr := dwCPed + 0x42
    writeString(hGTA, dwAddr, status)
    if(ErrorLevel) {
        ErrorLevel := ERROR_WRITE_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return true
}
getPlayerAnim()
{
    if(!checkHandles())
    return false
    dwPointer := readDWORD(hGTA, dwSAMP + 0x13D190)
    anim := readMem(hGTA, dwPointer + 0x2F4C, 2, "byte")
    return anim
}
setPlayerHealth(amount) {
    if(!checkHandles())
    return -1
    dwCPedPtr := readDWORD(hGTA, ADDR_CPED_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    dwAddr := dwCPedPtr + ADDR_CPED_HPOFF
    writeFloat(hGTA, dwAddr, amount)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return true
}
setPlayerArmor(amount) {
    if(!checkHandles())
    return -1
    dwCPedPtr := readDWORD(hGTA, ADDR_CPED_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    dwAddr := dwCPedPtr + ADDR_CPED_ARMOROFF
    writeFloat(hGTA, dwAddr, amount)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return true
}
setVehicleHealth(amount) {
    if(!checkHandles())
    return -1
    dwVehPtr := readDWORD(hGTA, ADDR_VEHICLE_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    dwAddr := dwVehPtr + ADDR_VEHICLE_HPOFF
    writeFloat(hGTA, dwAddr, amount)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return true
}
getDialogIndex() {
    dwPointer := getDialogStructPtr()
    if (ErrorLevel || !dwPointer)
    return false
    dwPointer := readDWORD(hGTA, dwPointer + SAMP_DIALOG_PTR2_OFFSET)
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    index := readMem(hGTA, dwPointer + 0x143, 1, "Byte")
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    ErrorLevel := ERROR_OK
    return index + 1
}
isDialogButtonSelected(btn := 1) {
    dwPointer := getDialogStructPtr()
    if (ErrorLevel || !dwPointer)
    return false
    dwPointer := readDWORD(hGTA, dwPointer + SAMP_DIALOG_PTR2_OFFSET)
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    offset := (btn == 1 ? 0x165 : 0x2C5)
    sel := readMem(hGTA, dwPointer + offset, 1, "Byte")
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    ErrorLevel := ERROR_OK
    return sel
}
ProcessExist(Name){
	Process,Exist,%Name%
	return Errorlevel
}
getServerHour() {
    if(!checkHandles())
    return -1
    dwGTA := getModuleBaseAddress("gta_sa.exe", hGTA)
    Hour := readMem(hGTA, 0xB70153, 1, "Int")
    if (Hour <= 9) {
        FixHour = 0%Hour%
        return FixHour
    }
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return Hour
}
getsexbyskin(skin)
{
    if skin in 1,2,3,4,5,6,7,8,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,32,33,34,35,36,37,42,43,44,45,46,47,48,49,50,51,52,57,58,59,60,61,62,66,67,68,70,71,72,73,79,80,81,82,83,84,86,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,132,133,134,135,136,137,142,143,144,146,147,149,153,154,155,156,158,159,160,161,162,163,164,165,166,167,168,170,171,173,174,175,176,177,179,180,181,182,183,184,185,186,187,188,189,200,202,203,204,206,208,209,210,212,213,217,220,221,222,223,227,228,229,230,234,235,236,239,240,241,242,247,248,249,250,252,253,254,255,258,259,260,261,262,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,299,300,301,302,303,304,305,310,311
    return 1
    if skin in 9,10,11,12,13,31,38,39,40,41,53,54,55,56,63,64,65,69,75,76,77,85,87,88,89,90,91,92,93,129,130,131,138,139,140,141,143,144,145,148,150,151,152,157,169,172,178,190,191,192,193,194,195,196,197,198,199,201,205,207,211,214,215,216,218,219,224,225,226,231,232,233,237,238,243,244,245,246,251,256,257,263,298,306,307,308,309
    return 2
    else
    return 0
}
set_player_armed_weapon_to(weaponid)
{
    c := getPlayerWeaponId()
    WinGet, gtapid, List, GTA:SA:MP
    SendMessage, 0x50,, 0x4090409,, GTA:SA:MP
    Loop
    {
    ControlSend,, {E down}, ahk_id %gtapid1%
        Sleep, 5
    ControlSend,, {E up}, ahk_id %gtapid1%
        if(getPlayerWeaponId() == c || getPlayerWeaponId() == weaponid)
        break
    }
}
getZoneByName(zName, ByRef CurZone ) {
    if ( bInitZaC == 0 )
    {
        initZonesAndCities()
        bInitZaC := 1
    }
    Loop % nZone-1
    {
        if (zone%A_Index%_name == zName)
        {
            ErrorLevel := ERROR_OK
            CurZone[1] := zone%A_Index%_name
            CurZone[2] := %A_Index%
            CurZone[3,1,1] := zone%A_Index%_x1
            CurZone[3,1,2] := zone%A_Index%_y1
            CurZone[3,1,3] := zone%A_Index%_z1
            CurZone[3,2,1] := zone%A_Index%_x2
            CurZone[3,2,2] := zone%A_Index%_y2
            CurZone[3,2,3] := zone%A_Index%_z2
            return true
        }
    }
    ErrorLevel := ERROR_ZONE_NOT_FOUND
    return "Unknown"
}
getCenterPointToZone(zName, ByRef PointPos) {
    getZoneByName(zName, CurZone)
    PointPos[1] := 125 + CurZone[3,1,1]
    PointPos[2] := 125 + CurZone[3,1,2]
    return true
}
getDialogLineNumber() {
    dwPointer := getDialogStructPtr()
    if (ErrorLevel || !dwPointer)
    return 0
    dwPointer := readDWORD(hGTA, dwPointer + SAMP_DIALOG_PTR2_OFFSET)
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    count := readMem(hGTA, dwPointer + SAMP_DIALOG_LINENUMBER_OFFSET, 4, "UInt")
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    return count//16777216+1
}
getServerMinute() {
    if(!checkHandles())
    return -1
    dwGTA := getModuleBaseAddress("gta_sa.exe", hGTA)
    Minute := readMem(hGTA, 0xB70152, 1, "Int")
    if (Minute <= 9) {
        FixMinute = 0%Minute%
        return FixMinute
    }
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return Minute
}
getCameraCoordinates() {
    if(!checkHandles())
    return false
    fX := readFloat(hGTA, 0xB6F9CC)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    fY := readFloat(hGTA, 0xB6F9D0)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    fZ := readFloat(hGTA, 0xB6F9D4)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    ErrorLevel := ERROR_OK
    return [fX, fY, fZ]
}
getPlayerPosById(dwId) {
    dwId += 0
    dwId := Floor(dwId)
    if(dwId < 0 || dwId >= SAMP_PLAYER_MAX)
    return ""
    if(iRefreshScoreboard+iUpdateTick > A_TickCount)
    {
        if(oScoreboardData[dwId])
        {
            if(oScoreboardData[dwId].HasKey("PED"))
            return getPedCoordinates(oScoreboardData[dwId].PED)
            if(oScoreboardData[dwId].HasKey("MPOS"))
            return oScoreboardData[dwId].MPOS
        }
        return ""
    }
    if(!updateOScoreboardData())
    return ""
    if(oScoreboardData[dwId])
    {
        if(oScoreboardData[dwId].HasKey("PED"))
        return getPedCoordinates(oScoreboardData[dwId].PED)
        if(oScoreboardData[dwId].HasKey("MPOS"))
        return oScoreboardData[dwId].MPOS
    }
    return ""
}
HexToDecOne(Hex)
{
    if (InStr(Hex, "0x") != 1)
    Hex := "0x" Hex
    return, Hex + 0
}
HexToDecTwo(hex)
{
    VarSetCapacity(dec, 66, 0), val := DllCall("msvcrt.dll\_wcstoui64", "Str", hex, "UInt", 0, "UInt", 16, "CDECL Int64"), DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", dec, "UInt", 10, "CDECL")
    return dec
}
hex2rgb(CR)
{
    NumPut((InStr(CR, "#") ? "0x" SubStr(CR, 2) : "0x") SubStr(CR, -5), (V := "000000"))
    return NumGet(V, 2, "UChar") "," NumGet(V, 1, "UChar") "," NumGet(V, 0, "UChar")
}
rgb2hex(R, G, B, H := 1)
{
    static U := A_IsUnicode ? "_wcstoui64" : "_strtoui64"
    static V := A_IsUnicode ? "_i64tow"    : "_i64toa"
    rgb := ((R << 16) + (G << 8) + B)
    H := ((H = 1) ? "#" : ((H = 2) ? "0x" : ""))
    VarSetCapacity(S, 66, 0)
    value := DllCall("msvcrt.dll\" U, "Str", rgb , "UInt", 0, "UInt", 10, "CDECL Int64")
    DllCall("msvcrt.dll\" V, "Int64", value, "Str", S, "UInt", 16, "CDECL")
    return H S
}
GetCoordsSamp(ByRef ResX, ByRef ResY)
{
    MouseGetPos, PosX, PosY
    PosXProc := PosX * 100 / A_ScreenWidth
    PosYProc := PosY * 100 / A_ScreenHeight
    ResX := PosXProc * 8
    ResY := PosYProc * 6
}
getVehicleIdServer(address=0x13C298, datatype="int", length=4, offset=0)
{
    if (isPlayerDriver() != "-1" or isPlayerInAnyVehicle() != "0")
    {
        Process, Exist, gta_sa.exe
        PID_GTA := ErrorLevel
        VarSetCapacity(me32, 548, 0)
        NumPut(548, me32)
        snapMod := DllCall("CreateToolhelp32Snapshot", "Uint", 0x00000008, "Uint", PID_GTA)
        If (snapMod = -1)
        Return 0
        If (DllCall("Module32First", "Uint", snapMod, "Uint", &me32))
        {
            Loop
            {
                If (!DllCall("lstrcmpi", "Str", "samp.dll", "UInt", &me32 + 32)) {
                    DllCall("CloseHandle", "UInt", snapMod)
                    key:= NumGet(&me32 + 20)
                    WinGet, PID_SAMP, PID, GTA:SA:MP
                    hwnd_samp := DllCall("OpenProcess","Uint",0x1F0FFF,"int",0,"int", PID_SAMP)
                    VarSetCapacity(readvalue,length, 0)
                    DllCall("ReadProcessMemory","Uint",hwnd_samp,"Uint",key+address+offset,"Str",readvalue,"Uint",length,"Uint *",0)
                    finalvalue := NumGet(readvalue,0,datatype)
                    DllCall("CloseHandle", "int", hwnd_samp)
                    return finalvalue
                }
            }
            Until !DllCall("Module32Next", "Uint", snapMod, "UInt", &me32)
        }
        DllCall("CloseHandle", "Uint", snapMod)
    }
    else
    Return 0
}
setPlayerName(playerid, newnick) {
    if(!checkHandles() || !strlen(newnick))
    return 0
    dwAddress := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET)
    if(ErrorLevel || dwAddress==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    dwAddress := readDWORD(hGTA, dwAddress + SAMP_PPOOLS_OFFSET)
    if(ErrorLevel || dwAddress==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    dwPlayers := readDWORD(hGTA, dwAddress + SAMP_PPOOL_PLAYER_OFFSET)
    if(ErrorLevel || dwPlayers==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    dwRemoteplayer := readDWORD(hGTA, dwPlayers+SAMP_PREMOTEPLAYER_OFFSET+playerid*4)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    if(dwRemoteplayer==0)
    return 0
    dwTemp := readMem(hGTA, dwRemoteplayer + SAMP_ISTRLENNAME___OFFSET, 4, "Int")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    sUsername := ""
    if(dwTemp <= 0xf)
    {
        sUsername := readString(hGTA, dwRemoteplayer+SAMP_SZPLAYERNAME_OFFSET, 16)
        if(ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
        writeString(hGTA, dwRemoteplayer+SAMP_SZPLAYERNAME_OFFSET, newnick)
    }
    else {
        dwAddress := readDWORD(hGTA, dwRemoteplayer + SAMP_PSZPLAYERNAME_OFFSET)
        if(ErrorLevel || dwAddress==0) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
        sUsername := readString(hGTA, dwAddress, 25)
        if(ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
        writeString(hGTA, dwAddress, newnick)
    }
    ErrorLevel := ERROR_OK
    return 1
}
HexToDec(str)
{
    local newStr := ""
static comp := {0:0, 1:1, 2:2, 3:3, 4:4, 5:5, 6:6, 7:7, 8:8, 9:9, "a":10, "b":11, "c":12, "d":13, "e":14, "f":15}
    StringLower, str, str
    str := RegExReplace(str, "^0x|[^a-f0-9]+", "")
    Loop, % StrLen(str)
    newStr .= SubStr(str, (StrLen(str)-A_Index)+1, 1)
    newStr := StrSplit(newStr, "")
    local ret := 0
    for i,char in newStr
    ret += comp[char]*(16**(i-1))
    return ret
}
addChatMessageEx(Color, wText) {
    wText := "" wText
    if(!checkHandles())
    return false
    VarSetCapacity(data2, 4, 0)
    NumPut(HexToDec(Color),data2,0,"Int")
    Addrr := readDWORD(hGTA, dwSAMP+ADDR_SAMP_CHATMSG_PTR)
    VarSetCapacity(data1, 4, 0)
    NumPut(readDWORD(hGTA, Addrr + 0x12A), data1,0,"Int")
    WriteRaw(hGTA, Addrr + 0x12A, &data2, 4)
    dwFunc := dwSAMP + FUNC_SAMP_ADDTOCHATWND
    dwChatInfo := readDWORD(hGTA, dwSAMP + ADDR_SAMP_CHATMSG_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    callWithParams(hGTA, dwFunc, [["p", dwChatInfo], ["s", wText]], true)
    WriteRaw(hGTA, Addrr + 0x12A, &data1, 4)
    ErrorLevel := ERROR_OK
    return true
}
connect(IP) {
    setIP(IP)
    restartGameEx()
    disconnectEx()
    Sleep 1000
    setrestart()
    Return
}
WriteProcessMemory(title,addresse,wert,size)
{
    VarSetCapacity(idvar,32,0)
    VarSetCapacity(processhandle,32,0)
    VarSetCapacity(value, 32, 0)
    NumPut(wert,value,0,Uint)
    address=%addresse%
    WinGet ,idvar,PID,%title%
    processhandle:=DllCall("OpenProcess","Uint",0x38,"int",0,"int",idvar)
    Bvar:=DllCall("WriteProcessMemory","Uint",processhandle,"Uint",address+0,"Uint",&value,"Uint",size,"Uint",0)
}
setCoordinates(x, y, z, Interior) {
    if(!checkHandles())
    return False
    dwAddress := readMem(hGTA, ADDR_SET_POSITION)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        Return False
    }
    dwAddress := readMem(hGTA, dwAddress + ADDR_SET_POSITION_OFFSET)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        Return False
    }
    Sleep 100
    writeByte(hGTA, ADDR_SET_INTERIOR_OFFSET, Interior)
    if(ErrorLevel) {
        ErrorLevel := ERROR_WRITE_MEMORY
        Return False
    }
    writeFloat(hGTA, dwAddress + ADDR_SET_POSITION_X_OFFSET, x)
    if(ErrorLevel) {
        ErrorLevel := ERROR_WRITE_MEMORY
        Return False
    }
    writeFloat(hGTA, dwAddress + ADDR_SET_POSITION_Y_OFFSET, y)
    if(ErrorLevel) {
        ErrorLevel := ERROR_WRITE_MEMORY
        Return False
    }
    writeFloat(hGTA, dwAddress + ADDR_SET_POSITION_Z_OFFSET, z)
    if(ErrorLevel) {
        ErrorLevel := ERROR_WRITE_MEMORY
        Return False
    }
    Return True
}
colorhud(colorhud)
{
    VarSetCapacity(idvar,32,0)
    VarSetCapacity(processhandle,32,0)
    VarSetCapacity(value, 32, 0)
    NumPut(colorhud,value,0,Uint)
    address=0xBAB230
    WinGet ,idvar,PID,GTA:SA:MP
    processhandle:=DllCall("OpenProcess","Uint",0x38,"int",0,"int",idvar)
    Bvar:=DllCall("WriteProcessMemory","Uint",processhandle,"Uint",address+0,"Uint",&value,"Uint","4","Uint",0)
}
setIP(IP) {
    if(!checkHandles())
    return False
    dwAddress := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET)
    if(ErrorLevel || dwAddress==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return False
    }
    writeString(hGTA, dwAddress + SAMP_SZIP_OFFSET, IP)
    if(ErrorLevel) {
        ErrorLevel := ERROR_WRITE_MEMORY
        return False
    }
    return True
}
setUsername(Username) {
    if(!checkHandles())
    return False
    dwAddress := dwSAMP + ADDR_SAMP_USERNAME
    writeString(hGTA, dwAddress, Username)
    if(ErrorLevel) {
        ErrorLevel := ERROR_WRITE_MEMORY
        return False
    }
    ErrorLevel := ERROR_OK
    return True
}
setChatLine(line, msg) {
    if(!checkHandles())
    return -1
    dwPtr := dwSAMP + ADDR_SAMP_CHATMSG_PTR
    dwAddress := readDWORD(hGTA,dwPtr)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    writeString(hGTA, dwAddress + 0x152 + ( (99-line) * 0xFC), msg)
    if(ErrorLevel) {
        ErrorLevel := ERROR_WRITE_MEMORY
        return -1
    }
sendinput {f7 3}
    ErrorLevel := ERROR_OK
    return True
}
getTagNameDistance() {
    if(!checkHandles())
    return -1
    dwSAMPInfo := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    dwSAMPInfoSettings := readDWORD(hGTA, dwSAMPInfo + SAMP_INFO_SETTINGS_OFFSET)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    distance := readFloat(hGTA, dwSAMPInfoSettings + 0x27)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return distance
}
setTagNameDistance(status, distance) {
    if(!checkHandles())
    return -1
    status := status ? 1 : 0
    dwSAMPInfo := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    dwSAMPInfoSettings := readDWORD(hGTA, dwSAMPInfo + SAMP_INFO_SETTINGS_OFFSET)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    writeByte(hGTA, dwSAMPInfoSettings + 0x38, 1)
    if(ErrorLevel) {
        ErrorLevel := ERROR_WRITE_MEMORY
        return -1
    }
    writeByte(hGTA, dwSAMPInfoSettings + 0x2F, status)
    if(ErrorLevel) {
        ErrorLevel := ERROR_WRITE_MEMORY
        return -1
    }
    writeFloat(hGTA, dwSAMPInfoSettings + 0x27, distance)
    if(ErrorLevel) {
        ErrorLevel := ERROR_WRITE_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return
}
setTime(hour)
{
    if(!checkHandles())
    return
    VarSetCapacity(nop, 6, 0)
    Loop 6 {
        NumPut(0x90, nop, A_INDEX-1, "UChar")
    }
    writeRaw(hGTA, 0x52D168, &nop, 6)
    VarSetCapacity(time, 1, 0)
    NumPut(hour, time, 0, "Int")
    writeRaw(hGTA, 0xB70153, &time, 1)
}
setWeather(id)
{
    if(!checkHandles())
    return
    VarSetCapacity(weather, 1, 0)
    NumPut(id, weather, 0, "Int")
    writeRaw(hGTA, 0xC81320, &weather, 1)
    if(ErrorLevel)
    return false
    return true
}
getSkinID() {
    if(!checkHandles())
    return -1
    dwAddress := readDWORD(hGTA, 0xB6F3B8)
    if(ErrorLevel || dwAddress==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    id := readMem(hGTA, dwAddress + 0x22, 2, "UShort")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return id
}
getDialogTitle()
{
    if(!checkHandles())
    return ""
    dwAddress := readDWORD(hGTA, dwSAMP + 0x21A0B8)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    text := readString(hGTA, dwAddress + 0x40, 128)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    ErrorLevel := ERROR_OK
    return text
}
getPlayerColor(id)
{
    id += 0
    if(!checkHandles())
    return -1
    color := readDWORD(hGTA, dwSAMP + 0x216378 + 4*id)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    return color
}
setPlayerColor(id,color)
{
    id += 0
    color +=0
    if(!checkHandles())
    return
    VarSetCapacity(bla, 4, 0)
    NumPut(color,bla,0,"UInt")
    writeRaw(hGTA, dwSAMP + 0x216378 + 4*id, &bla, 4)
}
colorToStr(color)
{
    color += 0
    color >>= 8
    color &= 0xffffff
    SetFormat, IntegerFast, hex
    color += 0
    color .= ""
    StringTrimLeft, color, color, 2
    SetFormat, IntegerFast, d
    if (StrLen(color) == 5)
    color := "0"color
return "{" color "}"
}
GetInterior()
{
    dwAddress := readDWORD(hGTA, ADDR_SET_INTERIOR_OFFSET)
    if (ErrorLevel || dwAddress == 0) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    return true
}
getWeaponId()
{
    If(!checkHandles())
    return 0
    c := readDWORD(hGTA, ADDR_CPED_PTR)
    If(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    id := readMem(hGTA, c + 0x740)
    If(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    return id
}
writeFloat(hProcess, dwAddress, wFloat) {
    if(!hProcess) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return false
    }
    wFloat := FloatToHex(wFloat)
    dwRet := DllCall(   "WriteProcessMemory", "UInt", hProcess, "UInt", dwAddress, "UInt *", wFloat, "UInt", 4, "UInt *", 0)
    ErrorLevel := ERROR_OK
    return true
}
writeByte(hProcess, dwAddress, wInt) {
    if(!hProcess) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return false
    }
    wInt := IntToHex(wInt)
    dwRet := DllCall(     "WriteProcessMemory", "UInt", hProcess, "UInt", dwAddress, "UInt *", wInt, "UInt", 1, "UInt *", 0)
}
FloatToHex(value) {
    format := A_FormatInteger
    SetFormat, Integer, H
    result := DllCall("MulDiv", Float, value, Int, 1, Int, 1, UInt)
    SetFormat, Integer, %format%
    return, result
}
IntToHex(int)
{
    CurrentFormat := A_FormatInteger
    SetFormat, integer, hex
    int += 0
    SetFormat, integer, %CurrentFormat%
    return int
}
disconnectEx() {
    if(!checkHandles())
    return 0
    dwAddress := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET)
    if(ErrorLevel || dwAddress==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    dwAddress := readDWORD(hGTA, dwAddress + 0x3c9)
    if(ErrorLevel || dwAddress==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ecx := dwAddress
    dwAddress := readDWORD(hGTA, dwAddress)
    if(ErrorLevel || dwAddress==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    VarSetCapacity(injectData, 24, 0)
    NumPut(0xB9, injectData, 0, "UChar")
    NumPut(ecx, injectData, 1, "UInt")
    NumPut(0xB8, injectData, 5, "UChar")
    NumPut(dwAddress, injectData, 6, "UInt")
    NumPut(0x68, injectData, 10, "UChar")
    NumPut(0, injectData, 11, "UInt")
    NumPut(0x68, injectData, 15, "UChar")
    NumPut(500, injectData, 16, "UInt")
    NumPut(0x50FF, injectData, 20, "UShort")
    NumPut(0x08, injectData, 22, "UChar")
    NumPut(0xC3, injectData, 23, "UChar")
    writeRaw(hGTA, pInjectFunc, &injectData, 24)
    if(ErrorLevel)
    return false
    hThread := createRemoteThread(hGTA, 0, 0, pInjectFunc, 0, 0, 0)
    if(ErrorLevel)
    return false
    waitForSingleObject(hThread, 0xFFFFFFFF)
    closeProcess(hThread)
    return true
}
setrestart()
{
    VarSetCapacity(old, 4, 0)
    dwAddress := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET)
    if(ErrorLevel || dwAddress==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    NumPut(9,old,0,"Int")
    writeRaw(hGTA, dwAddress + 957, &old, 4)
}
restartGameEx() {
    if(!checkHandles())
    return -1
    dwAddress := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET)
    if(ErrorLevel || dwAddress==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    dwFunc := dwSAMP + 0xA060
    VarSetCapacity(injectData, 11, 0)
    NumPut(0xB9, injectData, 0, "UChar")
    NumPut(dwAddress, injectData, 1, "UInt")
    NumPut(0xE8, injectData, 5, "UChar")
    offset := dwFunc - (pInjectFunc + 10)
    NumPut(offset, injectData, 6, "Int")
    NumPut(0xC3, injectData, 10, "UChar")
    writeRaw(hGTA, pInjectFunc, &injectData, 11)
    if(ErrorLevel)
    return false
    hThread := createRemoteThread(hGTA, 0, 0, pInjectFunc, 0, 0, 0)
    if(ErrorLevel)
    return false
    waitForSingleObject(hThread, 0xFFFFFFFF)
    closeProcess(hThread)
    return true
}
isPlayerInStreamById(player_id, radius := 150)
{
    NAME := ""
    check := []
    p := getStreamedInPlayersInfo()
    if (!p)
    return 0
    For i, o in p
    {
        if (Floor(getDist(getCoordinates(), o.POS)) <= radius)
        {
            NAME .= o.NAME ", "
        }
    }
    if (IsObject(player_id))
    {
        for k, v in player_id
        {
            i := 0
            Loop, Parse, % NAME, % ",", % " ,.`n`r"
            {
                if (A_LoopField == getPlayerNameById(v))
                {
                    i := 1
                    break
                }
            }
            if (i)
            check[v] := i
            else
            check[v] := i
        }
        return check
    }
    else if (!IsObject(player_id))
    {
        if (!getPlayerNameById(player_id))
        return 0
        i := 0
        Loop, Parse, % NAME, % ",", % " ,.`n`r"
        {
            if (A_LoopField == getPlayerNameById(player_id))
            return 1
        }
        return 0
    }
}
IsSAMPAvailable() {
    if(!checkHandles())
    return false
    dwChatInfo := readDWORD(hGTA, dwSAMP + ADDR_SAMP_CHATMSG_PTR)
    if(dwChatInfo == 0 || dwChatInfo == "ERROR")
    {
        return false
    }
    else
    {
        return true
    }
}
IsChatActive() {
    if(!checkHandles())
    return -1
    dwInputInfo := readDWORD(hGTA, dwSAMP + SAMP_CHAT_SHOW)
    dwInputBox := readDWORD(hGTA, dwInputInfo + 8)
    byteChatActive := readMem(hGTA, dwInputBox + 4, 1)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    return byteChatActive
}
isInChat() {
    if(!checkHandles())
    return -1
    dwPtr := dwSAMP + ADDR_SAMP_INCHAT_PTR
    dwAddress := readDWORD(hGTA, dwPtr) + ADDR_SAMP_INCHAT_PTR_OFF
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    dwInChat := readDWORD(hGTA, dwAddress)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    if(dwInChat > 0) {
        return true
    } else {
        return false
    }
}
getUsername() {
    if(!checkHandles())
    return ""
    dwAddress := dwSAMP + ADDR_SAMP_USERNAME
    sUsername := readString(hGTA, dwAddress, 25)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    ErrorLevel := ERROR_OK
    return sUsername
}
getId() {
    s:=getUsername()
    return getPlayerIdByName(s)
}
SendChat(wText) {
    wText := "" wText
    if(!checkHandles())
    return false
    dwFunc:=0
    if(SubStr(wText, 1, 1) == "/") {
        dwFunc := dwSAMP + FUNC_SAMP_SENDCMD
    } else {
        dwFunc := dwSAMP + FUNC_SAMP_SENDSAY
    }
    callWithParams(hGTA, dwFunc, [["s", wText]], false)
    ErrorLevel := ERROR_OK
    return true
}
ProcessReadMemory(address, processIDorName, type := "Int", numBytes := 4) {
    VarSetCapacity(buf, numBytes, 0)
    Process Exist, %processIDorName%
    if !processID := ErrorLevel
    return -1
    if !processHandle := DllCall("OpenProcess", "Int", 24, "UInt", 0, "UInt", processID, "Ptr")
    throw Exception("Failed to open process.`n`nError code:`t" . A_LastError)
    result := DllCall("ReadProcessMemory", "Ptr", processHandle, "Ptr", address, "Ptr", &buf, "Ptr", numBytes, "PtrP", numBytesRead, "UInt")
    if !DllCall("CloseHandle", "Ptr", processHandle, "UInt") && !result
    throw Exception("Failed to close process handle.`n`nError code:`t" . A_LastError)
    if !result
    throw Exception("Failed to read process memory.`n`nError code:`t" . A_LastError)
    if !numBytesRead
    throw Exception("Read 0 bytes from the`n`nprocess:`t" . processIDorName . "`naddress:`t" . address)
    return (type = "Str") ? StrGet(&buf, numBytes) : NumGet(buf, type)
}
ProcessWriteMemory(data, address, processIDorName, type := "Int", numBytes := 4) {
    VarSetCapacity(buf, numBytes, 0)
    (type = "Str") ? StrPut(data, &buf, numBytes) : NumPut(data, buf, type)
    Process Exist, %processIDorName%
    if !processID := ErrorLevel
    return
    if !processHandle := DllCall("OpenProcess", "Int", 40, "UInt", 0, "UInt", processID, "Ptr")
    throw Exception("Failed to open process.`n`nError code:`t" . A_LastError)
    result := DllCall("WriteProcessMemory", "Ptr", processHandle, "Ptr", address, "Ptr", &buf, "Ptr", numBytes, "UInt", 0, "UInt")
    if !DllCall("CloseHandle", "Ptr", processHandle, "UInt") && !result
    throw Exception("Failed to close process handle.`n`nError code:`t" . A_LastError)
    if !result
    return
    return result
}
addChatMessage(wText) {
    wText := "" wText
    if(!checkHandles())
    return false
    dwFunc := dwSAMP + FUNC_SAMP_ADDTOCHATWND
    dwChatInfo := readDWORD(hGTA, dwSAMP + ADDR_SAMP_CHATMSG_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    callWithParams(hGTA, dwFunc, [["p", dwChatInfo], ["s", wText]], true)
    ErrorLevel := ERROR_OK
    return true
}
showGameText(wText, dwTime, dwSize) {
    wText := "" wText
    dwTime += 0
    dwTime := Floor(dwTime)
    dwSize += 0
    dwSize := Floor(dwSize)
    if(!checkHandles())
    return false
    dwFunc := dwSAMP + FUNC_SAMP_SHOWGAMETEXT
    callWithParams(hGTA, dwFunc, [["s", wText], ["i", dwTime], ["i", dwSize]], false)
    ErrorLevel := ERROR_OK
    return true
}
playAudioStream(wUrl) {
    wUrl := "" wUrl
    if(!checkHandles())
    return false
    dwFunc := dwSAMP + FUNC_SAMP_PLAYAUDIOSTR
    patchRadio()
    callWithParams(hGTA, dwFunc, [["s", wUrl], ["i", 0], ["i", 0], ["i", 0], ["i", 0], ["i", 0]], false)
    unPatchRadio()
    ErrorLevel := ERROR_OK
    return true
}
stopAudioStream() {
    if(!checkHandles())
    return false
    dwFunc := dwSAMP + FUNC_SAMP_STOPAUDIOSTR
    patchRadio()
    callWithParams(hGTA, dwFunc, [["i", 1]], false)
    unPatchRadio()
    ErrorLevel := ERROR_OK
    return true
}
patchRadio()
{
    if(!checkHandles())
    return false
    VarSetCapacity(nop, 4, 0)
    NumPut(0x90909090,nop,0,"UInt")
    dwFunc := dwSAMP + FUNC_SAMP_PLAYAUDIOSTR
    writeRaw(hGTA, dwFunc, &nop, 4)
    writeRaw(hGTA, dwFunc+4, &nop, 1)
    dwFunc := dwSAMP + FUNC_SAMP_STOPAUDIOSTR
    writeRaw(hGTA, dwFunc, &nop, 4)
    writeRaw(hGTA, dwFunc+4, &nop, 1)
    return true
}
unPatchRadio()
{
    if(!checkHandles())
    return false
    VarSetCapacity(old, 4, 0)
    dwFunc := dwSAMP + FUNC_SAMP_PLAYAUDIOSTR
    NumPut(0x74003980,old,0,"UInt")
    writeRaw(hGTA, dwFunc, &old, 4)
    NumPut(0x39,old,0,"UChar")
    writeRaw(hGTA, dwFunc+4, &old, 1)
    dwFunc := dwSAMP + FUNC_SAMP_STOPAUDIOSTR
    NumPut(0x74003980,old,0,"UInt")
    writeRaw(hGTA, dwFunc, &old, 4)
    NumPut(0x09,old,0,"UChar")
    writeRaw(hGTA, dwFunc+4, &old, 1)
    return true
}
blockChatInput() {
    if(!checkHandles())
    return false
    VarSetCapacity(nop, 2, 0)
    dwFunc := dwSAMP + FUNC_SAMP_SENDSAY
    NumPut(0x04C2,nop,0,"Short")
    writeRaw(hGTA, dwFunc, &nop, 2)
    dwFunc := dwSAMP + FUNC_SAMP_SENDCMD
    writeRaw(hGTA, dwFunc, &nop, 2)
    return true
}
unBlockChatInput() {
    if(!checkHandles())
    return false
    VarSetCapacity(nop, 2, 0)
    dwFunc := dwSAMP + FUNC_SAMP_SENDSAY
    NumPut(0xA164,nop,0,"Short")
    writeRaw(hGTA, dwFunc, &nop, 2)
    dwFunc := dwSAMP + FUNC_SAMP_SENDCMD
    writeRaw(hGTA, dwFunc, &nop, 2)
    return true
}
getServerName() {
    if(!checkHandles())
    return -1
    dwAdress := readMem(hGTA, dwSAMP + 0x21A0F8, 4, "int")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    if(!dwAdress)
    return -1
    ServerName := readString(hGTA, dwAdress + 0x121, 200)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return ServerName
}
getServerIP() {
    if(!checkHandles())
    return -1
    dwAdress := readMem(hGTA, dwSAMP + 0x21A0F8, 4, "int")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    if(!dwAdress)
    return -1
    ServerIP := readString(hGTA, dwAdress + 0x20, 100)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return ServerIP
}
getServerPort() {
    if(!checkHandles())
    return -1
    dwAdress := readMem(hGTA, dwSAMP + 0x21A0F8, 4, "int")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    if(!dwAdress)
    return -1
    ServerPort := readMem(hGTA, dwAdress + 0x225, 4, "int")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return ServerPort
}
getWeatherID() {
    if(!checkHandles())
    return -1
    dwGTA := getModuleBaseAddress("gta_sa.exe", hGTA)
    WeatherID := readMem(hGTA, 0xC81320, 2, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return WeatherID
}
getWeatherName() {
    if(isPlayerInAnyVehicle() == 0)
    return -1
    if(id >= 0 && id < 23)
    {
        return oweatherNames[id-1]
    }
    return ""
}
isTargetDriverbyId(dwId)
{
    if(!checkHandles())
    return -1
    dwPedPointer := getPedById(dwId)
    dwAddrVPtr := getVehiclePointerByPed(dwPedPointer)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    dwVal := readDWORD(hGTA, dwAddrVPtr + ADDR_VEHICLE_DRIVER)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return (dwVal == dwPedPointer)
}
getTargetPed() {
    if(!checkHandles())
    return 0
    dwAddress := readDWORD(hGTA, 0xB6F3B8)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    if(!dwAddress)
    return 0
    dwAddress := readDWORD(hGTA, dwAddress+0x79C)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return dwAddress
}
calcScreenCoors(fX,fY,fZ)
{
    if(!checkHandles())
    return false
    dwM := 0xB6FA2C
    m_11 := readFloat(hGTA, dwM + 0*4)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    m_12 := readFloat(hGTA, dwM + 1*4)
    m_13 := readFloat(hGTA, dwM + 2*4)
    m_21 := readFloat(hGTA, dwM + 4*4)
    m_22 := readFloat(hGTA, dwM + 5*4)
    m_23 := readFloat(hGTA, dwM + 6*4)
    m_31 := readFloat(hGTA, dwM + 8*4)
    m_32 := readFloat(hGTA, dwM + 9*4)
    m_33 := readFloat(hGTA, dwM + 10*4)
    m_41 := readFloat(hGTA, dwM + 12*4)
    m_42 := readFloat(hGTA, dwM + 13*4)
    m_43 := readFloat(hGTA, dwM + 14*4)
    dwLenX := readDWORD(hGTA, 0xC17044)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    dwLenY := readDWORD(hGTA, 0xC17048)
    frX := fZ * m_31 + fY * m_21 + fX * m_11 + m_41
    frY := fZ * m_32 + fY * m_22 + fX * m_12 + m_42
    frZ := fZ * m_33 + fY * m_23 + fX * m_13 + m_43
    fRecip := 1.0/frZ
    frX *= fRecip * dwLenX
    frY *= fRecip * dwLenY
    if(frX<=dwLenX && frY<=dwLenY && frZ>1)
    return [frX,frY,frZ]
}
ConvertCarColor(Color)
{
    ArrayRGB := ["0xF5F5F5FF", "0x2A77A1FF", "0x840410FF", "0x263739FF", "0x86446EFF", "0xD78E10FF", "0x4C75B7FF", "0xBDBEC6FF", "0x5E7072FF", "0x46597AFF", "0x656A79FF", "0x5D7E8DFF", "0x58595AFF", "0xD6DAD6FF", "0x9CA1A3FF", "0x335F3FFF", "0x730E1AFF", "0x7B0A2AFF", "0x9F9D94FF", "0x3B4E78FF", "0x732E3EFF", "0x691E3BFF", "0x96918CFF", "0x515459FF", "0x3F3E45FF", "0xA5A9A7FF", "0x635C5AFF", "0x3D4A68FF", "0x979592FF", "0x421F21FF", "0x5F272BFF", "0x8494ABFF", "0x767B7CFF", "0x646464FF", "0x5A5752FF", "0x252527FF", "0x2D3A35FF", "0x93A396FF", "0x6D7A88FF", "0x221918FF", "0x6F675FFF", "0x7C1C2AFF", "0x5F0A15FF", "0x193826FF", "0x5D1B20FF", "0x9D9872FF", "0x7A7560FF", "0x989586FF", "0xADB0B0FF", "0x848988FF", "0x304F45FF", "0x4D6268FF", "0x162248FF", "0x272F4BFF", "0x7D6256FF", "0x9EA4ABFF", "0x9C8D71FF", "0x6D1822FF", "0x4E6881FF", "0x9C9C98FF", "0x917347FF", "0x661C26FF", "0x949D9FFF", "0xA4A7A5FF", "0x8E8C46FF", "0x341A1EFF", "0x6A7A8CFF", "0xAAAD8EFF", "0xAB988FFF", "0x851F2EFF", "0x6F8297FF", "0x585853FF", "0x9AA790FF", "0x601A23FF", "0x20202CFF", "0xA4A096FF", "0xAA9D84FF", "0x78222BFF", "0x0E316DFF", "0x722A3FFF", "0x7B715EFF", "0x741D28FF", "0x1E2E32FF", "0x4D322FFF", "0x7C1B44FF", "0x2E5B20FF", "0x395A83FF", "0x6D2837FF", "0xA7A28FFF", "0xAFB1B1FF", "0x364155FF", "0x6D6C6EFF", "0x0F6A89FF", "0x204B6BFF", "0x2B3E57FF", "0x9B9F9DFF", "0x6C8495FF", "0x4D8495FF", "0xAE9B7FFF", "0x406C8FFF", "0x1F253BFF", "0xAB9276FF", "0x134573FF", "0x96816CFF", "0x64686AFF", "0x105082FF", "0xA19983FF", "0x385694FF", "0x525661FF", "0x7F6956FF", "0x8C929AFF", "0x596E87FF", "0x473532FF", "0x44624FFF", "0x730A27FF", "0x223457FF", "0x640D1BFF", "0xA3ADC6FF", "0x695853FF", "0x9B8B80FF", "0x620B1CFF", "0x5B5D5EFF", "0x624428FF", "0x731827FF", "0x1B376DFF", "0xEC6AAEFF", "0x000000FF"]
    ArrayRGBNew := ["0x177517FF", "0x210606FF", "0x125478FF", "0x452A0DFF", "0x571E1EFF", "0x010701FF", "0x25225AFF", "0x2C89AAFF", "0x8A4DBDFF", "0x35963AFF", "0xB7B7B7FF", "0x464C8DFF", "0x84888CFF", "0x817867FF", "0x817A26FF", "0x6A506FFF", "0x583E6FFF", "0x8CB972FF", "0x824F78FF", "0x6D276AFF", "0x1E1D13FF", "0x1E1306FF", "0x1F2518FF", "0x2C4531FF", "0x1E4C99FF", "0x2E5F43FF", "0x1E9948FF", "0x1E9999FF", "0x999976FF", "0x7C8499FF", "0x992E1EFF", "0x2C1E08FF", "0x142407FF", "0x993E4DFF", "0x1E4C99FF", "0x198181FF", "0x1A292AFF", "0x16616FFF", "0x1B6687FF", "0x6C3F99FF", "0x481A0EFF", "0x7A7399FF", "0x746D99FF", "0x53387EFF", "0x222407FF", "0x3E190CFF", "0x46210EFF", "0x991E1EFF", "0x8D4C8DFF", "0x805B80FF", "0x7B3E7EFF", "0x3C1737FF", "0x733517FF", "0x781818FF", "0x83341AFF", "0x8E2F1CFF", "0x7E3E53FF", "0x7C6D7CFF", "0x020C02FF", "0x072407FF", "0x163012FF", "0x16301BFF", "0x642B4FFF", "0x368452FF", "0x999590FF", "0x818D96FF", "0x99991EFF", "0x7F994CFF", "0x839292FF", "0x788222FF", "0x2B3C99FF", "0x3A3A0BFF", "0x8A794EFF", "0x0E1F49FF", "0x15371CFF", "0x15273AFF", "0x375775FF", "0x060820FF", "0x071326FF", "0x20394BFF", "0x2C5089FF", "0x15426CFF", "0x103250FF", "0x241663FF", "0x692015FF", "0x8C8D94FF", "0x516013FF", "0x090F02FF", "0x8C573AFF", "0x52888EFF", "0x995C52FF", "0x99581EFF", "0x993A63FF", "0x998F4EFF", "0x99311EFF", "0x0D1842FF", "0x521E1EFF", "0x42420DFF", "0x4C991EFF", "0x082A1DFF", "0x96821DFF", "0x197F19FF", "0x3B141FFF", "0x745217FF", "0x893F8DFF", "0x7E1A6CFF", "0x0B370BFF", "0x27450DFF", "0x071F24FF", "0x784573FF", "0x8A653AFF", "0x732617FF", "0x319490FF", "0x56941DFF", "0x59163DFF", "0x1B8A2FFF", "0x38160BFF", "0x041804FF", "0x355D8EFF", "0x2E3F5BFF", "0x561A28FF", "0x4E0E27FF", "0x706C67FF", "0x3B3E42FF", "0x2E2D33FF", "0x7B7E7DFF", "0x4A4442FF", "0x28344EFF"]
    if (Color > 0) and (Color < 128)
    RGB := ArrayRGB[Color]
    if (Color > 127) and (Color < 256)
    {
        RGB := ArrayRGBNew[Color + 127]
    }
    StringLeft, RGBTemp, RGB, 8
    StringRight, RGB, RGBTemp, 6
    if Color = 0
    RGB := "000000"
    return RGB
}
getPedById(dwId) {
    dwId += 0
    dwId := Floor(dwId)
    if(dwId < 0 || dwId >= SAMP_PLAYER_MAX)
    return 0
    if(iRefreshScoreboard+iUpdateTick > A_TickCount)
    {
        if(oScoreboardData[dwId])
        {
            if(oScoreboardData[dwId].HasKey("PED"))
            return oScoreboardData[dwId].PED
        }
        return 0
    }
    if(!updateOScoreboardData())
    return 0
    if(oScoreboardData[dwId])
    {
        if(oScoreboardData[dwId].HasKey("PED"))
        return oScoreboardData[dwId].PED
    }
    return 0
}
getIdByPed(dwPed) {
    dwPed += 0
    dwPed := Floor(dwPed)
    if(!dwPed)
    return -1
    if(iRefreshScoreboard+iUpdateTick > A_TickCount)
    {
        For i, o in oScoreboardData
        {
            if(o.HasKey("PED"))
            {
                if(o.PED==dwPed)
                return i
            }
        }
        return -1
    }
    if(!updateOScoreboardData())
    return -1
    For i, o in oScoreboardData
    {
        if(o.HasKey("PED"))
        {
            if(o.PED==dwPed)
            return i
        }
    }
    return -1
}
IsInAFK() {
    res := ProcessReadMemory(0xBA6748 + 0x5C, "gta_sa.exe")
    if (res==-1)
    return -1
    WinGet, win, MinMax, GTA:SA:MP
    if ((res=0) and (win=-1)) or res=1
    return 1
    return 0
}
getStreamedInPlayersInfo() {
    r:=[]
    if(iRefreshScoreboard+iUpdateTick > A_TickCount)
    {
        For i, o in oScoreboardData
        {
            if(o.HasKey("PED"))
            {
                p := getPedCoordinates(o.PED)
                if(p)
                {
                    o.POS := p
                    r[i] := o
                }
            }
        }
        return r
    }
    if(!updateOScoreboardData())
    return ""
    For i, o in oScoreboardData
    {
        if(o.HasKey("PED"))
        {
            p := getPedCoordinates(o.PED)
            if(p)
            {
                o.POS := p
                r[i] := o
            }
        }
    }
    return r
}
callFuncForAllStreamedInPlayers(cfunc,dist=0x7fffffff) {
    cfunc := "" cfunc
    dist += 0
    if(!IsFunc(cfunc))
    return false
    p := getStreamedInPlayersInfo()
    if(!p)
    return false
    if(dist<0x7fffffff)
    {
        lpos := getCoordinates()
        if(!lpos)
        return false
        For i, o in p
        {
            if(dist>getDist(lpos,o.POS))
            %cfunc%(o)
        }
    }
    else
    {
        For i, o in p
        %cfunc%(o)
    }
    return true
}
getDist(pos1,pos2) {
    if(!pos1 || !pos2)
    return 0
    return Sqrt((pos1[1]-pos2[1])*(pos1[1]-pos2[1])+(pos1[2]-pos2[2])*(pos1[2]-pos2[2])+(pos1[3]-pos2[3])*(pos1[3]-pos2[3]))
}
getClosestPlayerPed() {
    dist := 0x7fffffff
    p := getStreamedInPlayersInfo()
    if(!p)
    return -1
    lpos := getCoordinates()
    if(!lpos)
    return -1
    id := -1
    For i, o in p
    {
        t:=getDist(lpos,o.POS)
        if(t<dist)
        {
            dist := t
            id := i
        }
    }
    PED := getPedById(id)
    return PED
}
getClosestPlayerId() {
    dist := 0x7fffffff
    p := getStreamedInPlayersInfo()
    if(!p)
    return -1
    lpos := getCoordinates()
    if(!lpos)
    return -1
    id := -1
    For i, o in p
    {
        t:=getDist(lpos,o.POS)
        if(t<dist)
        {
            dist := t
            id := i
        }
    }
    return id
}
CountOnlinePlayers() {
    if(!checkHandles())
    return -1
    dwOnline := readDWORD(hGTA, dwSAMP + 0x21A0B4)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    dwAddr := dwOnline + 0x4
    OnlinePlayers := readDWORD(hGTA, dwAddr)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return OnlinePlayers
}
getPedCoordinates(dwPED) {
    dwPED += 0
    dwPED := Floor(dwPED)
    if(!dwPED)
    return ""
    if(!checkHandles())
    return ""
    dwAddress := readDWORD(hGTA, dwPED + 0x14)
    if(ErrorLevel || dwAddress==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    fX := readFloat(hGTA, dwAddress + 0x30)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    fY := readFloat(hGTA, dwAddress + 0x34)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    fZ := readFloat(hGTA, dwAddress + 0x38)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    ErrorLevel := ERROR_OK
    return [fX, fY, fZ]
}
getTargetPos(dwId) {
    dwId += 0
    dwId := Floor(dwId)
    if(dwId < 0 || dwId >= SAMP_PLAYER_MAX)
    return ""
    if(iRefreshScoreboard+iUpdateTick > A_TickCount)
    {
        if(oScoreboardData[dwId])
        {
            if(oScoreboardData[dwId].HasKey("PED"))
            return getPedCoordinates(oScoreboardData[dwId].PED)
            if(oScoreboardData[dwId].HasKey("MPOS"))
            return oScoreboardData[dwId].MPOS
        }
        return ""
    }
    if(!updateOScoreboardData())
    return ""
    if(oScoreboardData[dwId])
    {
        if(oScoreboardData[dwId].HasKey("PED"))
        return getPedCoordinates(oScoreboardData[dwId].PED)
        if(oScoreboardData[dwId].HasKey("MPOS"))
        return oScoreboardData[dwId].MPOS
    }
    return ""
}
getTargetPlayerSkinIdByPed(dwPED) {
    if(!checkHandles())
    return -1
    dwAddr := dwPED + ADDR_CPED_SKINIDOFF
    SkinID := readMem(hGTA, dwAddr, 2, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return SkinID
}
getTargetPlayerSkinIdById(dwId) {
    if(!checkHandles())
    return -1
    dwPED := getPedById(dwId)
    dwAddr := dwPED + ADDR_CPED_SKINIDOFF
    SkinID := readMem(hGTA, dwAddr, 2, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return SkinID
}
NearPlayerInCar(dist)
{
    TempDist := 100000
    if(!p := getStreamedInPlayersInfo())
    return false
    if(!lpos := getCoordinates())
    return false
    for i, o in p
    {
        t := getDist(lpos, o.POS)
        if(t <= dist)
        {
            if(t < TempDist && t > 5 && isTargetInAnyVehiclebyId(o.ID))
            TempId := i, TempDist := t
        }
    }
    return TempId
}
getVehiclePointerByPed(dwPED) {
    dwPED += 0
    dwPED := Floor(dwPED)
    if(!dwPED)
    return 0
    if(!checkHandles())
    return 0
    dwAddress := readDWORD(hGTA, dwPED + 0x58C)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return dwAddress
}
getVehiclePointerById(dwId) {
    if(!dwId)
    return 0
    if(!checkHandles())
    return 0
    dwPed_By_Id := getPedById(dwId)
    dwAddress := readDWORD(hGTA, dwPed_By_Id + 0x58C)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return dwAddress
}
isTargetInAnyVehicleByPed(dwPED)
{
    if(!checkHandles())
    return -1
    dwVehiclePointer := getVehiclePointerByPed(dwPedPointer)
    if(dwVehiclePointer > 0)
    {
        return 1
    }
    else if(dwVehiclePointer <= 0)
    {
        return 0
    }
    else
    {
        return -1
    }
}
isTargetInAnyVehiclebyId(dwId)
{
    if(!checkHandles())
    return -1
    dwPedPointer := getPedById(dwId)
    dwVehiclePointer := getVehiclePointerByPed(dwPedPointer)
    if(dwVehiclePointer > 0)
    {
        return 1
    }
    else if(dwVehiclePointer <= 0)
    {
        return 0
    }
    else
    {
        return -1
    }
}
getTargetVehicleHealthByPed(dwPed) {
    if(!checkHandles())
    return -1
    dwVehPtr := getVehiclePointerByPed(dwPed)
    dwAddr := dwVehPtr + ADDR_VEHICLE_HPOFF
    fHealth := readFloat(hGTA, dwAddr)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return Round(fHealth)
}
getTargetVehicleHealthById(dwId) {
    if(!checkHandles())
    return -1
    dwVehPtr := getVehiclePointerById(dwId)
    dwAddr := dwVehPtr + ADDR_VEHICLE_HPOFF
    fHealth := readFloat(hGTA, dwAddr)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return Round(fHealth)
}
getTargetVehicleTypeByPed(dwPED) {
    if(!checkHandles())
    return 0
    dwAddr := getVehiclePointerByPed(dwPED)
    if(!dwAddr)
    return 0
    cVal := readMem(hGTA, dwAddr + ADDR_VEHICLE_TYPE, 1, "Char")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    if(!cVal)
    {
        mid := getVehicleModelId()
        Loop % oAirplaneModels.MaxIndex()
        {
            if(oAirplaneModels[A_Index]==mid)
            return 5
        }
        return 1
    }
    else if(cVal==5)
    return 2
    else if(cVal==6)
    return 3
    else if(cVal==9)
    {
        mid := getVehicleModelId()
        Loop % oBikeModels.MaxIndex()
        {
            if(oBikeModels[A_Index]==mid)
            return 6
        }
        return 4
    }
    return 0
}
getTargetVehicleTypeById(dwId) {
    if(!checkHandles())
    return 0
    dwAddr := getVehiclePointerById(dwId)
    if(!dwAddr)
    return 0
    cVal := readMem(hGTA, dwAddr + ADDR_VEHICLE_TYPE, 1, "Char")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    if(!cVal)
    {
        mid := getVehicleModelId()
        Loop % oAirplaneModels.MaxIndex()
        {
            if(oAirplaneModels[A_Index]==mid)
            return 5
        }
        return 1
    }
    else if(cVal==5)
    return 2
    else if(cVal==6)
    return 3
    else if(cVal==9)
    {
        mid := getVehicleModelId()
        Loop % oBikeModels.MaxIndex()
        {
            if(oBikeModels[A_Index]==mid)
            return 6
        }
        return 4
    }
    return 0
}
getTargetVehicleModelIdByPed(dwPED) {
    if(!checkHandles())
    return 0
    dwAddr := getVehiclePointerByPed(dwPED)
    if(!dwAddr)
    return 0
    sVal := readMem(hGTA, dwAddr + ADDR_VEHICLE_MODEL, 2, "Short")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return sVal
}
getTargetVehicleModelIdById(dwId) {
    if(!checkHandles())
    return 0
    dwAddr := getVehiclePointerById(dwId)
    if(!dwAddr)
    return 0
    sVal := readMem(hGTA, dwAddr + ADDR_VEHICLE_MODEL, 2, "Short")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return sVal
}
getTargetVehicleModelNameByPed(dwPED) {
    id := getTargetVehicleModelIdByPed(dwPED)
    if(id > 400 && id < 611)
    {
        return ovehicleNames[id-399]
    }
    return ""
}
getTargetVehicleModelNameById(dwId) {
    id := getTargetVehicleModelIdById(dwId)
    if(id > 400 && id < 611)
    {
        return ovehicleNames[id-399]
    }
    return ""
}
getTargetVehicleLightStateByPed(dwPED) {
    if(!checkHandles())
    return -1
    dwAddr := getVehiclePointerByPed(dwPED)
    if(!dwAddr)
    return -1
    dwVal := readMem(hGTA, dwAddr + ADDR_VEHICLE_LIGHTSTATE, 1, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return (dwVal>0)
}
getTargetVehicleLightStateById(dwId) {
    if(!checkHandles())
    return -1
    dwAddr := getVehiclePointerById(dwId)
    if(!dwAddr)
    return -1
    dwVal := readMem(hGTA, dwAddr + ADDR_VEHICLE_LIGHTSTATE, 1, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return (dwVal>0)
}
getTargetVehicleLockStateByPed(dwPED) {
    if(!checkHandles())
    return -1
    dwAddr := getVehiclePointerByPed(dwPED)
    if(!dwAddr)
    return -1
    dwVal := readDWORD(hGTA, dwAddr + ADDR_VEHICLE_DOORSTATE)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return (dwVal==2)
}
getTargetVehicleLockStateById(dwId) {
    if(!checkHandles())
    return -1
    dwAddr := getVehiclePointerById(dwId)
    if(!dwAddr)
    return -1
    dwVal := readDWORD(hGTA, dwAddr + ADDR_VEHICLE_DOORSTATE)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return (dwVal==2)
}
getTargetVehicleColor1byPed(dwPED) {
    if(!checkHandles())
    return 0
    dwAddr := getVehiclePointerByPed(dwPED)
    if(!dwAddr)
    return 0
    sVal := readMem(hGTA, dwAddr + 1076, 1, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return sVal
}
getTargetVehicleColor1byId(dwId) {
    if(!checkHandles())
    return 0
    dwAddr := getVehiclePointerById(dwId)
    if(!dwAddr)
    return 0
    sVal := readMem(hGTA, dwAddr + 1076, 1, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return sVal
}
getTargetVehicleColor2byPed(dwPED) {
    if(!checkHandles())
    return 0
    dwAddr := getVehiclePointerByPed(dwPED)
    if(!dwAddr)
    return 0
    sVal := readMem(hGTA, dwAddr + 1077, 1, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return sVal
}
getTargetVehicleColor2byId(dwId) {
    if(!checkHandles())
    return 0
    dwAddr := getVehiclePointerById(dwId)
    if(!dwAddr)
    return 0
    sVal := readMem(hGTA, dwAddr + 1077, 1, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return sVal
}
getTargetVehicleSpeedByPed(dwPED) {
    if(!checkHandles())
    return -1
    dwAddr := getVehiclePointerByPed(dwPED)
    fSpeedX := readMem(hGTA, dwAddr + ADDR_VEHICLE_X, 4, "float")
    fSpeedY := readMem(hGTA, dwAddr + ADDR_VEHICLE_Y, 4, "float")
    fSpeedZ := readMem(hGTA, dwAddr + ADDR_VEHICLE_Z, 4, "float")
    fVehicleSpeed :=  sqrt((fSpeedX * fSpeedX) + (fSpeedY * fSpeedY) + (fSpeedZ * fSpeedZ))
    fVehicleSpeed := (fVehicleSpeed * 100) * 1.43
    return fVehicleSpeed
}
getTargetVehicleSpeedById(dwId) {
    if(!checkHandles())
    return -1
    dwAddr := getVehiclePointerById(dwId)
    fSpeedX := readMem(hGTA, dwAddr + ADDR_VEHICLE_X, 4, "float")
    fSpeedY := readMem(hGTA, dwAddr + ADDR_VEHICLE_Y, 4, "float")
    fSpeedZ := readMem(hGTA, dwAddr + ADDR_VEHICLE_Z, 4, "float")
    fVehicleSpeed :=  sqrt((fSpeedX * fSpeedX) + (fSpeedY * fSpeedY) + (fSpeedZ * fSpeedZ))
    fVehicleSpeed := (fVehicleSpeed * 100) * 1.43
    return fVehicleSpeed
}
getPlayerNameById(dwId) {
    dwId += 0
    dwId := Floor(dwId)
    if(dwId < 0 || dwId >= SAMP_PLAYER_MAX)
    return ""
    if(iRefreshScoreboard+iUpdateTick > A_TickCount)
    {
        if(oScoreboardData[dwId])
        return oScoreboardData[dwId].NAME
        return ""
    }
    if(!updateOScoreboardData())
    return ""
    if(oScoreboardData[dwId])
    return oScoreboardData[dwId].NAME
    return ""
}
getPlayerIdByName(wName) {
    wName := "" wName
    if(StrLen(wName) < 1 || StrLen(wName) > 24)
    return -1
    if(iRefreshScoreboard+iUpdateTick > A_TickCount)
    {
        For i, o in oScoreboardData
        {
            if(InStr(o.NAME,wName)==1)
            return i
        }
        return -1
    }
    if(!updateOScoreboardData())
    return -1
    For i, o in oScoreboardData
    {
        if(InStr(o.NAME,wName)==1)
        return i
    }
    return -1
}
getPlayerScoreById(dwId) {
    dwId += 0
    dwId := Floor(dwId)
    if(dwId < 0 || dwId >= SAMP_PLAYER_MAX)
    return ""
    if(iRefreshScoreboard+iUpdateTick > A_TickCount)
    {
        if(oScoreboardData[dwId])
        return oScoreboardData[dwId].SCORE
        return ""
    }
    if(!updateOScoreboardData())
    return ""
    if(oScoreboardData[dwId])
    return oScoreboardData[dwId].SCORE
    return ""
}
getPlayerPingById(dwId) {
    dwId += 0
    dwId := Floor(dwId)
    if(dwId < 0 || dwId >= SAMP_PLAYER_MAX)
    return -1
    if(iRefreshScoreboard+iUpdateTick > A_TickCount)
    {
        if(oScoreboardData[dwId])
        return oScoreboardData[dwId].PING
        return -1
    }
    if(!updateOScoreboardData())
    return -1
    if(oScoreboardData[dwId])
    return oScoreboardData[dwId].PING
    return -1
}
isNPCById(dwId) {
    dwId += 0
    dwId := Floor(dwId)
    if(dwId < 0 || dwId >= SAMP_PLAYER_MAX)
    return -1
    if(iRefreshScoreboard+iUpdateTick > A_TickCount)
    {
        if(oScoreboardData[dwId])
        return oScoreboardData[dwId].ISNPC
        return -1
    }
    if(!updateOScoreboardData())
    return -1
    if(oScoreboardData[dwId])
    return oScoreboardData[dwId].ISNPC
    return -1
}
updateScoreboardDataEx() {
    if(!checkHandles())
    return false
    dwAddress := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET)
    if(ErrorLevel || dwAddress==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    dwFunc := dwSAMP + FUNC_UPDATESCOREBOARD
    VarSetCapacity(injectData, 11, 0)
    NumPut(0xB9, injectData, 0, "UChar")
    NumPut(dwAddress, injectData, 1, "UInt")
    NumPut(0xE8, injectData, 5, "UChar")
    offset := dwFunc - (pInjectFunc + 10)
    NumPut(offset, injectData, 6, "Int")
    NumPut(0xC3, injectData, 10, "UChar")
    writeRaw(hGTA, pInjectFunc, &injectData, 11)
    if(ErrorLevel)
    return false
    hThread := createRemoteThread(hGTA, 0, 0, pInjectFunc, 0, 0, 0)
    if(ErrorLevel)
    return false
    waitForSingleObject(hThread, 0xFFFFFFFF)
    closeProcess(hThread)
    return true
}
updateOScoreboardData() {
    if(!checkHandles())
    return 0
    oScoreboardData := []
    if(!updateScoreboardDataEx())
    return 0
    iRefreshScoreboard := A_TickCount
    dwAddress := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET)
    if(ErrorLevel || dwAddress==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    dwAddress := readDWORD(hGTA, dwAddress + SAMP_PPOOLS_OFFSET)
    if(ErrorLevel || dwAddress==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    dwPlayers := readDWORD(hGTA, dwAddress + SAMP_PPOOL_PLAYER_OFFSET)
    if(ErrorLevel || dwPlayers==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    wID := readMem(hGTA, dwPlayers + SAMP_SLOCALPLAYERID_OFFSET, 2, "Short")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    dwPing := readMem(hGTA, dwPlayers + SAMP_ILOCALPLAYERPING_OFFSET, 4, "Int")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    dwScore := readMem(hGTA, dwPlayers + SAMP_ILOCALPLAYERSCORE_OFFSET, 4, "Int")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    dwTemp := readMem(hGTA, dwPlayers + SAMP_ISTRLEN_LOCALPLAYERNAME_OFFSET, 4, "Int")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    sUsername := ""
    if(dwTemp <= 0xf) {
        sUsername := readString(hGTA, dwPlayers + SAMP_SZLOCALPLAYERNAME_OFFSET, 16)
        if(ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
    }
    else {
        dwAddress := readDWORD(hGTA, dwPlayers + SAMP_PSZLOCALPLAYERNAME_OFFSET)
        if(ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
        sUsername := readString(hGTA, dwAddress, 25)
        if(ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
    }
    oScoreboardData[wID] := Object("NAME", sUsername, "ID", wID, "PING", dwPing, "SCORE", dwScore, "ISNPC", 0)
    Loop, % SAMP_PLAYER_MAX
    {
        i := A_Index-1
        dwRemoteplayer := readDWORD(hGTA, dwPlayers+SAMP_PREMOTEPLAYER_OFFSET+i*4)
        if(ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
        if(dwRemoteplayer==0)
        continue
        dwPing := readMem(hGTA, dwRemoteplayer + SAMP_IPING_OFFSET, 4, "Int")
        if(ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
        dwScore := readMem(hGTA, dwRemoteplayer + SAMP_ISCORE_OFFSET, 4, "Int")
        if(ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
        dwIsNPC := readMem(hGTA, dwRemoteplayer + SAMP_ISNPC_OFFSET, 4, "Int")
        if(ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
        dwTemp := readMem(hGTA, dwRemoteplayer + SAMP_ISTRLENNAME___OFFSET, 4, "Int")
        if(ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
        sUsername := ""
        if(dwTemp <= 0xf)
        {
            sUsername := readString(hGTA, dwRemoteplayer+SAMP_SZPLAYERNAME_OFFSET, 16)
            if(ErrorLevel) {
                ErrorLevel := ERROR_READ_MEMORY
                return 0
            }
        }
        else {
            dwAddress := readDWORD(hGTA, dwRemoteplayer + SAMP_PSZPLAYERNAME_OFFSET)
            if(ErrorLevel || dwAddress==0) {
                ErrorLevel := ERROR_READ_MEMORY
                return 0
            }
            sUsername := readString(hGTA, dwAddress, 25)
            if(ErrorLevel) {
                ErrorLevel := ERROR_READ_MEMORY
                return 0
            }
        }
        o := Object("NAME", sUsername, "ID", i, "PING", dwPing, "SCORE", dwScore, "ISNPC", dwIsNPC)
        oScoreboardData[i] := o
        dwRemoteplayerData := readDWORD(hGTA, dwRemoteplayer + 0x0)
        if(ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
        if(dwRemoteplayerData==0)
        continue
        dwAddress := readDWORD(hGTA, dwRemoteplayerData + 489)
        if(ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
        if(dwAddress)
        {
            ix := readMem(hGTA, dwRemoteplayerData + 493, 4, "Int")
            if(ErrorLevel) {
                ErrorLevel := ERROR_READ_MEMORY
                return 0
            }
            iy := readMem(hGTA, dwRemoteplayerData + 497, 4, "Int")
            if(ErrorLevel) {
                ErrorLevel := ERROR_READ_MEMORY
                return 0
            }
            iz := readMem(hGTA, dwRemoteplayerData + 501, 4, "Int")
            if(ErrorLevel) {
                ErrorLevel := ERROR_READ_MEMORY
                return 0
            }
            o.MPOS := [ix, iy, iz]
        }
        dwpSAMP_Actor := readDWORD(hGTA, dwRemoteplayerData + 0x0)
        if(ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
        if(dwpSAMP_Actor==0)
        continue
        dwPed := readDWORD(hGTA, dwpSAMP_Actor + 676)
        if(ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
        if(dwPed==0)
        continue
        o.PED := dwPed
        fHP := readFloat(hGTA, dwRemoteplayerData + 444)
        if(ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
        fARMOR := readFloat(hGTA, dwRemoteplayerData + 440)
        if(ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return 0
        }
        o.HP := fHP
        o.ARMOR := fARMOR
    }
    ErrorLevel := ERROR_OK
    return 1
}
GetChatLine(Line, ByRef Output, timestamp=0, color=0){
    chatindex := 0
    FileRead, file, %A_MyDocuments%\GTA San Andreas User Files\SAMP\chatlog.txt
    loop, Parse, file, `n, `r
    {
        if(A_LoopField)
        chatindex := A_Index
    }
    loop, Parse, file, `n, `r
    {
        if(A_Index = chatindex - line){
            output := A_LoopField
            break
        }
    }
    file := ""
    if(!timestamp)
output := RegExReplace(output, "U)^\[\d{2}:\d{2}:\d{2}\]")
    if(!color)
output := RegExReplace(output, "Ui)\{[a-f0-9]{6}\}")
    return
}
getPlayerHealth() {
    if(!checkHandles())
    return -1
    dwCPedPtr := readDWORD(hGTA, ADDR_CPED_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    dwAddr := dwCPedPtr + ADDR_CPED_HPOFF
    fHealth := readFloat(hGTA, dwAddr)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return Round(fHealth)
}
getPlayerArmor() {
    if(!checkHandles())
    return -1
    dwCPedPtr := readDWORD(hGTA, ADDR_CPED_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    dwAddr := dwCPedPtr + ADDR_CPED_ARMOROFF
    fHealth := readFloat(hGTA, dwAddr)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return Round(fHealth)
}
getPlayerInteriorId() {
    if(!checkHandles())
    return -1
    iid := readMem(hGTA, ADDR_CPED_INTID, 4, "Int")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return iid
}
getPlayerSkinID() {
    if(!checkHandles())
    return -1
    dwCPedPtr := readDWORD(hGTA, ADDR_CPED_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    dwAddr := dwCPedPtr + ADDR_CPED_SKINIDOFF
    SkinID := readMem(hGTA, dwAddr, 2, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return SkinID
}
getPlayerMoney() {
    if(!checkHandles())
    return ""
    money := readMem(hGTA, ADDR_CPED_MONEY, 4, "Int")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    ErrorLevel := ERROR_OK
    return money
}
getPlayerWanteds() {
    if(!checkHandles())
    return -1
    dwPtr := 0xB7CD9C
    dwPtr := readDWORD(hGTA, dwPtr)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    Wanteds := readDWORD(hGTA, dwPtr)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return Wanteds
}
getPlayerWeaponId() {
    if(!checkHandles())
    return 0
    WaffenId := readMem(hGTA, 0xBAA410, 4, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    return WaffenId
}
getPlayerWeaponName() {
    id := getPlayerWeaponId()
    if(id >= 0 && id < 44)
    {
        return oweaponNames[id+1]
    }
    return ""
}
getPlayerState() {
    if(!checkHandles())
    return -1
    dwCPedPtr := readDWORD(hGTA, ADDR_CPED_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    State := readDWORD(hGTA, dwCPedPtr + 0x530)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return State
}
IsPlayerInMenu() {
    if(!checkHandles())
    return -1
    IsInMenu := readMem(hGTA, 0xBA67A4, 4, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return IsInMenu
}
getPlayerMapPosX() {
    if(!checkHandles())
    return -1
    MapPosX := readFloat(hGTA, 0xBA67B8)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return MapPosX
}
getPlayerMapPosY() {
    if(!checkHandles())
    return -1
    MapPosY := readFloat(hGTA, 0xBA67BC)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return MapPosY
}
getPlayerMapZoom() {
    if(!checkHandles())
    return -1
    MapZoom := readFloat(hGTA, 0xBA67AC)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return MapZoom
}
IsPlayerFreezed() {
    if(!checkHandles())
    return -1
    dwGTA := getModuleBaseAddress("gta_sa.exe", hGTA)
    IPF := readMem(hGTA, dwGTA + 0x690495, 2, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return IPF
}
isPlayerInAnyVehicle()
{
    if(!checkHandles())
    return -1
    dwVehPtr := readDWORD(hGTA, ADDR_VEHICLE_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    return (dwVehPtr > 0)
}
isPlayerDriver() {
    if(!checkHandles())
    return -1
    dwAddr := readDWORD(hGTA, ADDR_VEHICLE_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    if(!dwAddr)
    return -1
    dwCPedPtr := readDWORD(hGTA, ADDR_CPED_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    dwVal := readDWORD(hGTA, dwAddr + ADDR_VEHICLE_DRIVER)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return (dwVal==dwCPedPtr)
}
getVehicleHealth() {
    if(!checkHandles())
    return -1
    dwVehPtr := readDWORD(hGTA, ADDR_VEHICLE_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    dwAddr := dwVehPtr + ADDR_VEHICLE_HPOFF
    fHealth := readFloat(hGTA, dwAddr)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return Round(fHealth)
}
getVehicleType() {
    if(!checkHandles())
    return 0
    dwAddr := readDWORD(hGTA, ADDR_VEHICLE_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    if(!dwAddr)
    return 0
    cVal := readMem(hGTA, dwAddr + ADDR_VEHICLE_TYPE, 1, "Char")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    if(!cVal)
    {
        mid := getVehicleModelId()
        Loop % oAirplaneModels.MaxIndex()
        {
            if(oAirplaneModels[A_Index]==mid)
            return 5
        }
        return 1
    }
    else if(cVal==5)
    return 2
    else if(cVal==6)
    return 3
    else if(cVal==9)
    {
        mid := getVehicleModelId()
        Loop % oBikeModels.MaxIndex()
        {
            if(oBikeModels[A_Index]==mid)
            return 6
        }
        return 4
    }
    return 0
}
getVehicleModelId() {
    if(!checkHandles())
    return 0
    dwAddr := readDWORD(hGTA, ADDR_VEHICLE_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    if(!dwAddr)
    return 0
    sVal := readMem(hGTA, dwAddr + ADDR_VEHICLE_MODEL, 2, "Short")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return sVal
}
getVehicleModelName() {
    id:=getVehicleModelId()
    if(id > 400 && id < 611)
    {
        return ovehicleNames[id-399]
    }
    return ""
}
getVehicleLightState() {
    if(!checkHandles())
    return -1
    dwAddr := readDWORD(hGTA, ADDR_VEHICLE_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    if(!dwAddr)
    return -1
    dwVal := readMem(hGTA, dwAddr + ADDR_VEHICLE_LIGHTSTATE, 1, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return (dwVal>0)
}
getVehicleEngineState() {
    if(!checkHandles())
    return -1
    dwAddr := readDWORD(hGTA, ADDR_VEHICLE_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    if(!dwAddr)
    return -1
    cVal := readMem(hGTA, dwAddr + ADDR_VEHICLE_ENGINESTATE, 1, "Char")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return (cVal==24 || cVal==56 || cVal==88 || cVal==120)
}
getVehicleSirenState() {
    if(!checkHandles())
    return -1
    dwAddr := readDWORD(hGTA, ADDR_VEHICLE_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    if(!dwAddr)
    return -1
    cVal := readMem(hGTA, dwAddr + ADDR_VEHICLE_SIRENSTATE, 1, "Char")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return (cVal==-48)
}
getVehicleLockState() {
    if(!checkHandles())
    return -1
    dwAddr := readDWORD(hGTA, ADDR_VEHICLE_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    if(!dwAddr)
    return -1
    dwVal := readDWORD(hGTA, dwAddr + ADDR_VEHICLE_DOORSTATE)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return (dwVal==2)
}
getVehicleColor1() {
    if(!checkHandles())
    return 0
    dwAddr := readDWORD(hGTA, 0xBA18FC)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    if(!dwAddr)
    return 0
    sVal := readMem(hGTA, dwAddr + 1076, 1, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return sVal
}
getVehicleColor2() {
    if(!checkHandles())
    return 0
    dwAddr := readDWORD(hGTA, 0xBA18FC)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    if(!dwAddr)
    return 0
    sVal := readMem(hGTA, dwAddr + 1077, 1, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return sVal
}
getVehicleSpeed() {
    if(!checkHandles())
    return -1
    dwAddr := readDWORD(hGTA, ADDR_VEHICLE_PTR)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    fSpeedX := readMem(hGTA, dwAddr + ADDR_VEHICLE_X, 4, "float")
    fSpeedY := readMem(hGTA, dwAddr + ADDR_VEHICLE_Y, 4, "float")
    fSpeedZ := readMem(hGTA, dwAddr + ADDR_VEHICLE_Z, 4, "float")
    fVehicleSpeed :=  sqrt((fSpeedX * fSpeedX) + (fSpeedY * fSpeedY) + (fSpeedZ * fSpeedZ))
    fVehicleSpeed := (fVehicleSpeed * 100) * 1.43
    return fVehicleSpeed
}
getPlayerRadiostationID() {
    if(!checkHandles())
    return -1
    if(isPlayerInAnyVehicle() == 0)
    return -1
    dwGTA := getModuleBaseAddress("gta_sa.exe", hGTA)
    RadioStationID := readMem(hGTA, dwGTA + 0x4CB7E1, 1, "byte")
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    return RadioStationID
}
getPlayerRadiostationName() {
    if(isPlayerInAnyVehicle() == 0)
    return -1
    id := getPlayerRadiostationID()
    if(id == 0)
    return -1
    if(id >= 0 && id < 14)
    {
        return oradiostationNames[id]
    }
    return ""
}
setCheckpoint(fX, fY, fZ, fSize ) {
    if(!checkHandles())
    return false
    dwFunc := dwSAMP + 0x9D340
    dwAddress := readDWORD(hGTA, dwSAMP + ADDR_SAMP_INCHAT_PTR)
    if(ErrorLevel || dwAddress==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    VarSetCapacity(buf, 16, 0)
    NumPut(fX, buf, 0, "Float")
    NumPut(fY, buf, 4, "Float")
    NumPut(fZ, buf, 8, "Float")
    NumPut(fSize, buf, 12, "Float")
    writeRaw(hGTA, pParam1, &buf, 16)
    dwLen := 31
    VarSetCapacity(injectData, dwLen, 0)
    NumPut(0xB9, injectData, 0, "UChar")
    NumPut(dwAddress, injectData, 1, "UInt")
    NumPut(0x68, injectData, 5, "UChar")
    NumPut(pParam1+12, injectData, 6, "UInt")
    NumPut(0x68, injectData, 10, "UChar")
    NumPut(pParam1, injectData, 11, "UInt")
    NumPut(0xE8, injectData, 15, "UChar")
    offset := dwFunc - (pInjectFunc + 20)
    NumPut(offset, injectData, 16, "Int")
    NumPut(0x05C7, injectData, 20, "UShort")
    NumPut(dwAddress+0x24, injectData, 22, "UInt")
    NumPut(1, injectData, 26, "UInt")
    NumPut(0xC3, injectData, 30, "UChar")
    writeRaw(hGTA, pInjectFunc, &injectData, dwLen)
    if(ErrorLevel)
    return false
    hThread := createRemoteThread(hGTA, 0, 0, pInjectFunc, 0, 0, 0)
    if(ErrorLevel)
    return false
    waitForSingleObject(hThread, 0xFFFFFFFF)
    closeProcess(hThread)
    ErrorLevel := ERROR_OK
    return true
}
disableCheckpoint()
{
    if(!checkHandles())
    return false
    dwAddress := readDWORD(hGTA, dwSAMP + ADDR_SAMP_INCHAT_PTR)
    if(ErrorLevel || dwAddress==0) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    VarSetCapacity(enablecp, 4, 0)
    NumPut(0,enablecp,0,"Int")
    writeRaw(hGTA, dwAddress+0x24, &enablecp, 4)
    ErrorLevel := ERROR_OK
    return true
}
IsMarkerCreated(){
    If(!checkHandles())
    return false
    active := readMem(hGTA, CheckpointCheck, 1, "byte")
    If(!active)
    return 0
    else return 1
}
CoordsFromRedmarker(){
    if(!checkhandles())
    return false
    for i, v in rmaddrs
    f%i% := readFloat(hGTA, v)
    return [f1, f2, f3]
}
getCoordinates() {
    if(!checkHandles())
    return ""
    fX := readFloat(hGTA, ADDR_POSITION_X)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    fY := readFloat(hGTA, ADDR_POSITION_Y)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    fZ := readFloat(hGTA, ADDR_POSITION_Z)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    ErrorLevel := ERROR_OK
    return [fX, fY, fZ]
}
GetPlayerPos(ByRef fX,ByRef fY,ByRef fZ) {
    if(!checkHandles())
    return 0
    fX := readFloat(hGTA, ADDR_POSITION_X)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    fY := readFloat(hGTA, ADDR_POSITION_Y)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    fZ := readFloat(hGTA, ADDR_POSITION_Z)
    if(ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
}
getDialogStructPtr() {
    if (!checkHandles()) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return false
    }
    dwPointer := readDWORD(hGTA, dwSAMP + SAMP_DIALOG_STRUCT_PTR)
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    ErrorLevel := ERROR_OK
    return dwPointer
}
isDialogOpen() {
    dwPointer := getDialogStructPtr()
    if (ErrorLevel || !dwPointer)
    return false
    dwIsOpen := readMem(hGTA, dwPointer + SAMP_DIALOG_OPEN_OFFSET, 4, "UInt")
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    ErrorLevel := ERROR_OK
    return dwIsOpen ? true : false
}
getDialogStyle() {
    dwPointer := getDialogStructPtr()
    if (ErrorLevel || !dwPointer)
    return -1
    style := readMem(hGTA, dwPointer + SAMP_DIALOG_STYLE_OFFSET, 4, "UInt")
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return style
}
getDialogID() {
    dwPointer := getDialogStructPtr()
    if (ErrorLevel || !dwPointer)
    return -1
    id := readMem(hGTA, dwPointer + SAMP_DIALOG_ID_OFFSET, 4, "UInt")
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    ErrorLevel := ERROR_OK
    return id
}
setDialogID(id) {
    dwPointer := getDialogStructPtr()
    if (ErrorLevel || !dwPointer)
    return false
    writeMemory(hGTA, dwPointer + SAMP_DIALOG_ID_OFFSET, id, "UInt", 4)
    if (ErrorLevel) {
        ErrorLevel := ERROR_WRITE_MEMORY
        return false
    }
    ErrorLevel := ERROR_OK
    return true
}
getDialogCaption() {
    dwPointer := getDialogStructPtr()
    if (ErrorLevel || !dwPointer)
    return ""
    text := readString(hGTA, dwPointer + SAMP_DIALOG_CAPTION_OFFSET, 64)
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    ErrorLevel := ERROR_OK
    return text
}
GetOSVersion() 
{ 
VarSetCapacity(v,148), NumPut(148,v) 
DllCall("GetVersionEx", "uint", &v) 
os := NumGet(v,4) "." NumGet(v,8) "." SubStr("0000" NumGet(v,12), -3) 
if (RegExMatch(os, "^(\d+)\.(\d+)", out_pars)) 
{ 
if (out_pars1 == 10) 
Return 10 
else if (out_pars1 == 6 && out_pars2 > 1) 
Return 8 
return 7 
} 
Return 7 
}
getDialogTextSize(dwAddress) {
    i := 0
    Loop, 4096 {
        i := A_Index - 1
        byte := Memory_ReadByte(hGTA, dwAddress + i)
        if (!byte)
        break
    }
    return i
}
getDialogText() {
    dwPointer := getDialogStructPtr()
    if (ErrorLevel || !dwPointer)
    return ""
    dwPointer := readDWORD(hGTA, dwPointer + SAMP_DIALOG_TEXT_PTR_OFFSET)
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    text := readString(hGTA, dwPointer, 4096)
    if (ErrorLevel) {
        text := readString(hGTA, dwPointer, getDialogTextSize(dwPointer))
        if (ErrorLevel) {
            ErrorLevel := ERROR_READ_MEMORY
            return ""
        }
    }
    ErrorLevel := ERROR_OK
    return text
}
getDialogLineCount() {
    dwPointer := getDialogStructPtr()
    if (ErrorLevel || !dwPointer)
    return 0
    dwPointer := readDWORD(hGTA, dwPointer + SAMP_DIALOG_PTR2_OFFSET)
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    count := readMem(hGTA, dwPointer + SAMP_DIALOG_LINECOUNT_OFFSET, 4, "UInt")
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return count
}
getDialogLine__(index) {
    if (getDialogLineCount > index)
    return ""
    dwPointer := getDialogStructPtr()
    if (ErrorLevel || !dwPointer)
    return ""
    dwPointer := readDWORD(hGTA, dwPointer + SAMP_DIALOG_PTR1_OFFSET)
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    dwPointer := readDWORD(hGTA, dwPointer + SAMP_DIALOG_LINES_OFFSET)
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return ""
    }
    dwLineAddress := readDWORD(hGTA, dwPointer + (index - 1) * 0x4)
    line := readString(hGTA, dwLineAddress, 128)
    ErrorLevel := ERROR_OK
    return line
}
getDialogLine(index) {
    lines := getDialogLines()
    if (index > lines.Length())
    return ""
    if (getDialogStyle() == DIALOG_STYLE_TABLIST_HEADERS)
    index++
    return lines[index]
}
getDialogLines() {
    text := getDialogText()
    if (text == "")
    return -1
    lines := StrSplit(text, "`n")
    return lines
}
getDialogLines__() {
    count := getDialogLineCount()
    dwPointer := getDialogStructPtr()
    if (ErrorLevel || !dwPointer)
    return -1
    dwPointer := readDWORD(hGTA, dwPointer + SAMP_DIALOG_PTR1_OFFSET)
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    dwPointer := readDWORD(hGTA, dwPointer + SAMP_DIALOG_LINES_OFFSET)
    if (ErrorLevel) {
        ErrorLevel := ERROR_READ_MEMORY
        return -1
    }
    lines := []
    Loop %count% {
        dwLineAddress := readDWORD(hGTA, dwPointer + (A_Index - 1) * 0x4)
        lines[A_Index] := readString(hGTA, dwLineAddress, 128)
    }
    ErrorLevel := ERROR_OK
    return lines
}
showDialog(style, caption, text, button1, button2 := "", id := 1) {
    style += 0
    style := Floor(style)
    id += 0
    id := Floor(id)
    caption := "" caption
    text := "" text
    button1 := "" button1
    button2 := "" button2
    if (id < 0 || id > 32767 || style < 0 || style > 5 || StrLen(caption) > 64 || StrLen(text) > 4096 || StrLen(button1) > 10 || StrLen(button2) > 10)
    return false
    if (!checkHandles())
    return false
    dwFunc := dwSAMP + FUNC_SAMP_SHOWDIALOG
    sleep 200
    dwAddress := readDWORD(hGTA, dwSAMP + SAMP_DIALOG_STRUCT_PTR)
    if (ErrorLevel || !dwAddress) {
        ErrorLevel := ERROR_READ_MEMORY
        return false
    }
    writeString(hGTA, pParam5, caption)
    if (ErrorLevel)
    return false
    writeString(hGTA, pParam1, text)
    if (ErrorLevel)
    return false
    writeString(hGTA, pParam5 + 512, button1)
    if (ErrorLevel)
    return false
    writeString(hGTA, pParam5+StrLen(caption) + 1, button2)
    if (ErrorLevel)
    return false
    dwLen := 5 + 7 * 5 + 5 + 1
    VarSetCapacity(injectData, dwLen, 0)
    NumPut(0xB9, injectData, 0, "UChar")
    NumPut(dwAddress, injectData, 1, "UInt")
    NumPut(0x68, injectData, 5, "UChar")
    NumPut(1, injectData, 6, "UInt")
    NumPut(0x68, injectData, 10, "UChar")
    NumPut(pParam5 + StrLen(caption) + 1, injectData, 11, "UInt")
    NumPut(0x68, injectData, 15, "UChar")
    NumPut(pParam5 + 512, injectData, 16, "UInt")
    NumPut(0x68, injectData, 20, "UChar")
    NumPut(pParam1, injectData, 21, "UInt")
    NumPut(0x68, injectData, 25, "UChar")
    NumPut(pParam5, injectData, 26, "UInt")
    NumPut(0x68, injectData, 30, "UChar")
    NumPut(style, injectData, 31, "UInt")
    NumPut(0x68, injectData, 35, "UChar")
    NumPut(id, injectData, 36, "UInt")
    NumPut(0xE8, injectData, 40, "UChar")
    offset := dwFunc - (pInjectFunc + 45)
    NumPut(offset, injectData, 41, "Int")
    NumPut(0xC3, injectData, 45, "UChar")
    writeRaw(hGTA, pInjectFunc, &injectData, dwLen)
    if (ErrorLevel)
    return false
    hThread := createRemoteThread(hGTA, 0, 0, pInjectFunc, 0, 0, 0)
    if (ErrorLevel)
    return false
    waitForSingleObject(hThread, 0xFFFFFFFF)
    closeProcess(hThread)
    return true
}
initZonesAndCities() {
    AddCity("Las Venturas", 685.0, 476.093, -500.0, 3000.0, 3000.0, 500.0)
    AddCity("San Fierro", -3000.0, -742.306, -500.0, -1270.53, 1530.24, 500.0)
    AddCity("San Fierro", -1270.53, -402.481, -500.0, -1038.45, 832.495, 500.0)
    AddCity("San Fierro", -1038.45, -145.539, -500.0, -897.546, 376.632, 500.0)
    AddCity("Los Santos", 480.0, -3000.0, -500.0, 3000.0, -850.0, 500.0)
    AddCity("Los Santos", 80.0, -2101.61, -500.0, 1075.0, -1239.61, 500.0)
    AddCity("Tierra Robada", -1213.91, 596.349, -242.99, -480.539, 1659.68, 900.0)
    AddCity("Red County", -1213.91, -768.027, -242.99, 2997.06, 596.349, 900.0)
    AddCity("Flint County", -1213.91, -2892.97, -242.99, 44.6147, -768.027, 900.0)
    AddCity("Whetstone", -2997.47, -2892.97, -242.99, -1213.91, -1115.58, 900.0)
    AddZone("Avispa Country Club", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169)
    AddZone("Easter Bay Airport", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406)
    AddZone("Avispa Country Club", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700)
    AddZone("Easter Bay Airport", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406)
    AddZone("Garcia", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000)
    AddZone("Shady Cabin", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000)
    AddZone("East Los Santos", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916)
    AddZone("LVA Freight Depot", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916)
    AddZone("Blackfield Intersection", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916)
    AddZone("Avispa Country Club", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100)
    AddZone("Temple", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916)
    AddZone("Unity Station", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508)
    AddZone("LVA Freight Depot", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916)
    AddZone("Los Flores", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916)
    AddZone("Starfish Casino", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916)
    AddZone("Easter Bay Chemicals", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000)
    AddZone("Downtown Los Santos", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916)
    AddZone("Esplanade East", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000)
    AddZone("Market Station", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874)
    AddZone("Linden Station", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406)
    AddZone("Montgomery Intersection", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000)
    AddZone("Frederick Bridge", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000)
    AddZone("Yellow Bell Station", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074)
    AddZone("Downtown Los Santos", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916)
    AddZone("Jefferson", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916)
    AddZone("Mulholland", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916)
    AddZone("Avispa Country Club", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000)
    AddZone("Jefferson", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916)
    AddZone("Julius Thruway West", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916)
    AddZone("Jefferson", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916)
    AddZone("Julius Thruway North", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916)
    AddZone("Rodeo", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916)
    AddZone("Cranberry Station", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000)
    AddZone("Downtown Los Santos", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916)
    AddZone("Redsands West", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916)
    AddZone("Little Mexico", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916)
    AddZone("Blackfield Intersection", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916)
    AddZone("Los Santos International", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916)
    AddZone("Beacon Hill", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511)
    AddZone("Rodeo", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916)
    AddZone("Richman", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916)
    AddZone("Downtown Los Santos", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916)
    AddZone("The Strip", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916)
    AddZone("Downtown Los Santos", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916)
    AddZone("Blackfield Intersection", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916)
    AddZone("Conference Center", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916)
    AddZone("Montgomery", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000)
    AddZone("Foster Valley", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000)
    AddZone("Blackfield Chapel", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916)
    AddZone("Los Santos International", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916)
    AddZone("Mulholland", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916)
    AddZone("Yellow Bell Gol Course", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916)
    AddZone("The Strip", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916)
    AddZone("Jefferson", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916)
    AddZone("Mulholland", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916)
    AddZone("Aldea Malvada", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000)
    AddZone("Las Colinas", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916)
    AddZone("Las Colinas", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916)
    AddZone("Richman", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916)
    AddZone("LVA Freight Depot", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916)
    AddZone("Julius Thruway North", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916)
    AddZone("Willowfield", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916)
    AddZone("Julius Thruway North", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916)
    AddZone("Temple", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916)
    AddZone("Little Mexico", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916)
    AddZone("Queens", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000)
    AddZone("Las Venturas Airport", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500)
    AddZone("Richman", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916)
    AddZone("Temple", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916)
    AddZone("East Los Santos", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916)
    AddZone("Julius Thruway East", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916)
    AddZone("Willowfield", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916)
    AddZone("Las Colinas", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916)
    AddZone("Julius Thruway East", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916)
    AddZone("Rodeo", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916)
    AddZone("Las Brujas", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000)
    AddZone("Julius Thruway East", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916)
    AddZone("Rodeo", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916)
    AddZone("Vinewood", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916)
    AddZone("Rodeo", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916)
    AddZone("Julius Thruway North", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916)
    AddZone("Downtown Los Santos", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916)
    AddZone("Rodeo", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916)
    AddZone("Jefferson", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916)
    AddZone("Hampton Barns", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000)
    AddZone("Temple", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916)
    AddZone("Kincaid Bridge", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916)
    AddZone("Verona Beach", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916)
    AddZone("Commerce", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916)
    AddZone("Mulholland", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916)
    AddZone("Rodeo", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916)
    AddZone("Mulholland", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916)
    AddZone("Mulholland", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916)
    AddZone("Julius Thruway South", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916)
    AddZone("Idlewood", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916)
    AddZone("Ocean Docks", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916)
    AddZone("Commerce", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916)
    AddZone("Julius Thruway North", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916)
    AddZone("Temple", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916)
    AddZone("Glen Park", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916)
    AddZone("Easter Bay Airport", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000)
    AddZone("Martin Bridge", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000)
    AddZone("The Strip", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916)
    AddZone("Willowfield", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916)
    AddZone("Marina", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916)
    AddZone("Las Venturas Airport", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916)
    AddZone("Idlewood", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916)
    AddZone("Esplanade East", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000)
    AddZone("Downtown Los Santos", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916)
    AddZone("The Mako Span", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000)
    AddZone("Rodeo", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916)
    AddZone("Pershing Square", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916)
    AddZone("Mulholland", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916)
    AddZone("Gant Bridge", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000)
    AddZone("Las Colinas", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916)
    AddZone("Mulholland", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916)
    AddZone("Julius Thruway North", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916)
    AddZone("Commerce", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916)
    AddZone("Rodeo", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916)
    AddZone("Roca Escalante", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916)
    AddZone("Rodeo", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916)
    AddZone("Market", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916)
    AddZone("Las Colinas", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916)
    AddZone("Mulholland", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916)
    AddZone("King's", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000)
    AddZone("Redsands East", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916)
    AddZone("Downtown", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000)
    AddZone("Conference Center", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916)
    AddZone("Richman", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916)
    AddZone("Ocean Flats", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000)
    AddZone("Greenglass College", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916)
    AddZone("Glen Park", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916)
    AddZone("LVA Freight Depot", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916)
    AddZone("Regular Tom", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000)
    AddZone("Verona Beach", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916)
    AddZone("East Los Santos", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916)
    AddZone("Caligula's Palace", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916)
    AddZone("Idlewood", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916)
    AddZone("Pilgrim", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916)
    AddZone("Idlewood", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916)
    AddZone("Queens", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000)
    AddZone("Downtown", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000)
    AddZone("Commerce", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916)
    AddZone("East Los Santos", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916)
    AddZone("Marina", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916)
    AddZone("Richman", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916)
    AddZone("Vinewood", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916)
    AddZone("East Los Santos", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916)
    AddZone("Rodeo", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916)
    AddZone("Easter Tunnel", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000)
    AddZone("Rodeo", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916)
    AddZone("Redsands East", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916)
    AddZone("The Clown's Pocket", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916)
    AddZone("Idlewood", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916)
    AddZone("Montgomery Intersection", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000)
    AddZone("Willowfield", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916)
    AddZone("Temple", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916)
    AddZone("Prickle Pine", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916)
    AddZone("Los Santos International", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916)
    AddZone("Garver Bridge", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916)
    AddZone("Garver Bridge", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916)
    AddZone("Kincaid Bridge", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916)
    AddZone("Kincaid Bridge", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916)
    AddZone("Verona Beach", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916)
    AddZone("Verdant Bluffs", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916)
    AddZone("Vinewood", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916)
    AddZone("Vinewood", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916)
    AddZone("Commerce", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916)
    AddZone("Market", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916)
    AddZone("Rockshore West", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916)
    AddZone("Julius Thruway North", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916)
    AddZone("East Beach", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916)
    AddZone("Fallow Bridge", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000)
    AddZone("Willowfield", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916)
    AddZone("Chinatown", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000)
    AddZone("El Castillo del Diablo", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000)
    AddZone("Ocean Docks", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916)
    AddZone("Easter Bay Chemicals", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000)
    AddZone("The Visage", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916)
    AddZone("Ocean Flats", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000)
    AddZone("Richman", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916)
    AddZone("Green Palms", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000)
    AddZone("Richman", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916)
    AddZone("Starfish Casino", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916)
    AddZone("East Beach", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916)
    AddZone("Jefferson", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916)
    AddZone("Downtown Los Santos", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916)
    AddZone("Downtown Los Santos", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916)
    AddZone("Garver Bridge", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385)
    AddZone("Julius Thruway South", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916)
    AddZone("East Los Santos", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916)
    AddZone("Greenglass College", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916)
    AddZone("Las Colinas", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916)
    AddZone("Mulholland", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916)
    AddZone("Ocean Docks", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916)
    AddZone("East Los Santos", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916)
    AddZone("Ganton", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916)
    AddZone("Avispa Country Club", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000)
    AddZone("Willowfield", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916)
    AddZone("Esplanade North", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000)
    AddZone("The High Roller", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916)
    AddZone("Ocean Docks", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916)
    AddZone("Last Dime Motel", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916)
    AddZone("Bayside Marina", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000)
    AddZone("King's", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000)
    AddZone("El Corona", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916)
    AddZone("Blackfield Chapel", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916)
    AddZone("The Pink Swan", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916)
    AddZone("Julius Thruway West", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916)
    AddZone("Los Flores", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916)
    AddZone("The Visage", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916)
    AddZone("Prickle Pine", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916)
    AddZone("Verona Beach", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916)
    AddZone("Robada Intersection", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916)
    AddZone("Linden Side", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916)
    AddZone("Ocean Docks", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916)
    AddZone("Willowfield", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916)
    AddZone("King's", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000)
    AddZone("Commerce", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916)
    AddZone("Mulholland", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916)
    AddZone("Marina", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916)
    AddZone("Battery Point", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000)
    AddZone("The Four Dragons Casino", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916)
    AddZone("Blackfield", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916)
    AddZone("Julius Thruway North", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916)
    AddZone("Yellow Bell Gol Course", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916)
    AddZone("Idlewood", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916)
    AddZone("Redsands West", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916)
    AddZone("Doherty", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000)
    AddZone("Hilltop Farm", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000)
    AddZone("Las Barrancas", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000)
    AddZone("Pirates in Men's Pants", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916)
    AddZone("City Hall", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000)
    AddZone("Avispa Country Club", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000)
    AddZone("The Strip", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916)
    AddZone("Hashbury", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000)
    AddZone("Los Santos International", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916)
    AddZone("Whitewood Estates", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916)
    AddZone("Sherman Reservoir", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916)
    AddZone("El Corona", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916)
    AddZone("Downtown", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000)
    AddZone("Foster Valley", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000)
    AddZone("Las Payasadas", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000)
    AddZone("Valle Ocultado", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000)
    AddZone("Blackfield Intersection", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916)
    AddZone("Ganton", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916)
    AddZone("Easter Bay Airport", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000)
    AddZone("Redsands East", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916)
    AddZone("Esplanade East", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385)
    AddZone("Caligula's Palace", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916)
    AddZone("Royal Casino", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916)
    AddZone("Richman", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916)
    AddZone("Starfish Casino", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916)
    AddZone("Mulholland", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916)
    AddZone("Downtown", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000)
    AddZone("Hankypanky Point", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000)
    AddZone("K.A.C.C. Military Fuels", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916)
    AddZone("Harry Gold Parkway", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916)
    AddZone("Bayside Tunnel", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916)
    AddZone("Ocean Docks", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916)
    AddZone("Richman", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916)
    AddZone("Randolph Industrial Estate", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916)
    AddZone("East Beach", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916)
    AddZone("Flint Water", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916)
    AddZone("Blueberry", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000)
    AddZone("Linden Station", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916)
    AddZone("Glen Park", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916)
    AddZone("Downtown", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000)
    AddZone("Redsands West", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916)
    AddZone("Richman", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916)
    AddZone("Gant Bridge", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000)
    AddZone("Lil' Probe Inn", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000)
    AddZone("Flint Intersection", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916)
    AddZone("Las Colinas", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916)
    AddZone("Sobell Rail Yards", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916)
    AddZone("The Emerald Isle", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916)
    AddZone("El Castillo del Diablo", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000)
    AddZone("Santa Flora", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000)
    AddZone("Playa del Seville", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916)
    AddZone("Market", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916)
    AddZone("Queens", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000)
    AddZone("Pilson Intersection", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916)
    AddZone("Spinybed", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916)
    AddZone("Pilgrim", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916)
    AddZone("Blackfield", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916)
    AddZone("'The Big Ear'", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000)
    AddZone("Dillimore", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000)
    AddZone("El Quebrados", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000)
    AddZone("Esplanade North", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000)
    AddZone("Easter Bay Airport", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000)
    AddZone("Fisher's Lagoon", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000)
    AddZone("Mulholland", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916)
    AddZone("East Beach", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916)
    AddZone("San Andreas Sound", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000)
    AddZone("Shady Creeks", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000)
    AddZone("Market", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916)
    AddZone("Rockshore West", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916)
    AddZone("Prickle Pine", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916)
    AddZone("Easter Basin", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000)
    AddZone("Leafy Hollow", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000)
    AddZone("LVA Freight Depot", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916)
    AddZone("Prickle Pine", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916)
    AddZone("Blueberry", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000)
    AddZone("El Castillo del Diablo", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000)
    AddZone("Downtown", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000)
    AddZone("Rockshore East", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916)
    AddZone("San Fierro Bay", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000)
    AddZone("Paradiso", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000)
    AddZone("The Camel's Toe", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916)
    AddZone("Old Venturas Strip", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916)
    AddZone("Juniper Hill", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000)
    AddZone("Juniper Hollow", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000)
    AddZone("Roca Escalante", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916)
    AddZone("Julius Thruway East", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916)
    AddZone("Verona Beach", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916)
    AddZone("Foster Valley", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000)
    AddZone("Arco del Oeste", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000)
    AddZone("Fallen Tree", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000)
    AddZone("The Farm", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981)
    AddZone("The Sherman Dam", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000)
    AddZone("Esplanade North", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000)
    AddZone("Financial", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000)
    AddZone("Garcia", -2411.220, -222.589, -1.14, -2173.040, 265.243, 200.000)
    AddZone("Montgomery", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000)
    AddZone("Creek", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916)
    AddZone("Los Santos International", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916)
    AddZone("Santa Maria Beach", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916)
    AddZone("Mulholland Intersection", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916)
    AddZone("Angel Pine", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000)
    AddZone("Verdant Meadows", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000)
    AddZone("Octane Springs", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000)
    AddZone("Come-A-Lot", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916)
    AddZone("Redsands West", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916)
    AddZone("Santa Maria Beach", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916)
    AddZone("Verdant Bluffs", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916)
    AddZone("Las Venturas Airport", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916)
    AddZone("Flint Range", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000)
    AddZone("Verdant Bluffs", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916)
    AddZone("Palomino Creek", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000)
    AddZone("Ocean Docks", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916)
    AddZone("Easter Bay Airport", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000)
    AddZone("Whitewood Estates", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916)
    AddZone("Calton Heights", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000)
    AddZone("Easter Basin", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000)
    AddZone("Los Santos Inlet", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916)
    AddZone("Doherty", -2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000)
    AddZone("Mount Chiliad", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083)
    AddZone("Fort Carson", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000)
    AddZone("Foster Valley", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000)
    AddZone("Ocean Flats", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000)
    AddZone("Fern Ridge", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000)
    AddZone("Bayside", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000)
    AddZone("Las Venturas Airport", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916)
    AddZone("Blueberry Acres", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000)
    AddZone("Palisades", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000)
    AddZone("North Rock", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000)
    AddZone("Hunter Quarry", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761)
    AddZone("Los Santos International", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916)
    AddZone("Missionary Hill", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000)
    AddZone("San Fierro Bay", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000)
    AddZone("Restricted Area", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000)
    AddZone("Mount Chiliad", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083)
    AddZone("Mount Chiliad", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083)
    AddZone("Easter Bay Airport", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000)
    AddZone("The Panopticon", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000)
    AddZone("Shady Creeks", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000)
    AddZone("Back o Beyond", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000)
    AddZone("Mount Chiliad", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083)
    AddZone("Tierra Robada", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000)
    AddZone("Flint County", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000)
    AddZone("Whetstone", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000)
    AddZone("Bone County", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000)
    AddZone("Tierra Robada", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000)
    AddZone("San Fierro", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000)
    AddZone("Las Venturas", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000)
    AddZone("Red County", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000)
    AddZone("Los Santos", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000)
}
calculateZone(posX, posY, posZ) {
    if ( bInitZaC == 0 )
    {
        initZonesAndCities()
        bInitZaC := 1
    }
    Loop % nZone-1
    {
        if (posX >= zone%A_Index%_x1) && (posY >= zone%A_Index%_y1) && (posZ >= zone%A_Index%_z1) && (posX <= zone%A_Index%_x2) && (posY <= zone%A_Index%_y2) && (posZ <= zone%A_Index%_z2)
        {
            ErrorLevel := ERROR_OK
            return zone%A_Index%_name
        }
    }
    ErrorLevel := ERROR_ZONE_NOT_FOUND
    return "Unknown"
}
calculateCity(posX, posY, posZ) {
    if ( bInitZaC == 0 )
    {
        initZonesAndCities()
        bInitZaC := 1
    }
    smallestCity := "Unknown"
    currentCitySize := 0
    smallestCitySize := 0
    Loop % nCity-1
    {
        if (posX >= city%A_Index%_x1) && (posY >= city%A_Index%_y1) && (posZ >= city%A_Index%_z1) && (posX <= city%A_Index%_x2) && (posY <= city%A_Index%_y2) && (posZ <= city%A_Index%_z2)
        {
            currentCitySize := ((city%A_Index%_x2 - city%A_Index%_x1) * (city%A_Index%_y2 - city%A_Index%_y1) * (city%A_Index%_z2 - city%A_Index%_z1))
            if (smallestCity == "Unknown") || (currentCitySize < smallestCitySize)
            {
                smallestCity := city%A_Index%_name
                smallestCitySize := currentCitySize
            }
        }
    }
    if(smallestCity == "Unknown") {
        ErrorLevel := ERROR_CITY_NOT_FOUND
    } else {
        ErrorLevel := ERROR_OK
    }
    return smallestCity
}
AddZone(sName, x1, y1, z1, x2, y2, z2) {
    global
    zone%nZone%_name := sName
    zone%nZone%_x1 := x1
    zone%nZone%_y1 := y1
    zone%nZone%_z1 := z1
    zone%nZone%_x2 := x2
    zone%nZone%_y2 := y2
    zone%nZone%_z2 := z2
    nZone := nZone + 1
}
AddCity(sName, x1, y1, z1, x2, y2, z2) {
    global
    city%nCity%_name := sName
    city%nCity%_x1 := x1
    city%nCity%_y1 := y1
    city%nCity%_z1 := z1
    city%nCity%_x2 := x2
    city%nCity%_y2 := y2
    city%nCity%_z2 := z2
    nCity := nCity + 1
}
IsPlayerInRangeOfPoint(_posX, _posY, _posZ, _posRadius)
{
    GetPlayerPos(posX, posY, posZ)
    X := posX -_posX
    Y := posY -_posY
    Z := posZ -_posZ
    if(((X < _posRadius) && (X > -_posRadius)) && ((Y < _posRadius) && (Y > -_posRadius)) && ((Z < _posRadius) && (Z > -_posRadius)))
    return TRUE
    return FALSE
}
IsPlayerInRangeOfPoint2D(_posX, _posY, _posRadius)
{
    GetPlayerPos(posX, posY, posZ)
    X := posX - _posX
    Y := posY - _posY
    if(((X < _posRadius) && (X > -_posRadius)) && ((Y < _posRadius) && (Y > -_posRadius)))
    return TRUE
    return FALSE
}
getPlayerZone()
{
    aktPos := getCoordinates()
    return calculateZone(aktPos[1], aktPos[2], aktPos[3])
}
getPlayerCity()
{
    aktPos := getCoordinates()
    return calculateCity(aktPos[1], aktPos[2], aktPos[3])
}
AntiCrash(){
    If(!checkHandles())
    return false
    cReport := ADDR_SAMP_CRASHREPORT
    writeMemory(hGTA, dwSAMP + cReport, 0x90909090, 4)
    cReport += 0x4
    writeMemory(hGTA, dwSAMP + cReport, 0x90, 1)
    cReport += 0x9
    writeMemory(hGTA, dwSAMP + cReport, 0x90909090, 4)
    cReport += 0x4
    writeMemory(hGTA, dwSAMP + cReport, 0x90, 1)
}
writeMemory(hProcess,address,writevalue,length=4, datatype="int") {
    if(!hProcess) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return false
    }
    VarSetCapacity(finalvalue,length, 0)
    NumPut(writevalue,finalvalue,0,datatype)
    dwRet :=  DllCall(  "WriteProcessMemory", "Uint",hProcess, "Uint",address, "Uint",&finalvalue, "Uint",length, "Uint",0)
    if(dwRet == 0) {
        ErrorLevel := ERROR_WRITE_MEMORY
        return false
    }
    ErrorLevel := ERROR_OK
    return true
}
checkHandles() {
    if(iRefreshHandles+500>A_TickCount)
    return true
    iRefreshHandles:=A_TickCount
    if(!refreshGTA() || !refreshSAMP() || !refreshMemory()) {
        return false
    } else {
        return true
    }
    return true
}
refreshGTA() {
    newPID := getPID("GTA:SA:MP")
    if(!newPID) {
        if(hGTA) {
            virtualFreeEx(hGTA, pMemory, 0, 0x8000)
            closeProcess(hGTA)
            hGTA := 0x0
        }
        dwGTAPID := 0
        hGTA := 0x0
        dwSAMP := 0x0
        pMemory := 0x0
        return false
    }
    if(!hGTA || (dwGTAPID != newPID)) {
        hGTA := openProcess(newPID)
        if(ErrorLevel) {
            dwGTAPID := 0
            hGTA := 0x0
            dwSAMP := 0x0
            pMemory := 0x0
            return false
        }
        dwGTAPID := newPID
        dwSAMP := 0x0
        pMemory := 0x0
        return true
    }
    return true
}
refreshSAMP() {
    if(dwSAMP)
    return true
    dwSAMP := getModuleBaseAddress("samp.dll", hGTA)
    if(!dwSAMP)
    return false
    return true
}
refreshMemory() {
    if(!pMemory) {
        pMemory     := virtualAllocEx(hGTA, 6144, 0x1000 | 0x2000, 0x40)
        if(ErrorLevel) {
            pMemory := 0x0
            return false
        }
        pParam1     := pMemory
        pParam2     := pMemory + 1024
        pParam3     := pMemory + 2048
        pParam4     := pMemory + 3072
        pParam5     := pMemory + 4096
        pInjectFunc := pMemory + 5120
    }
    return true
}
getPID(szWindow) {
    local dwPID := 0
    WinGet, dwPID, PID, %szWindow%
    return dwPID
}
openProcess(dwPID, dwRights = 0x1F0FFF) {
    hProcess := DllCall("OpenProcess", "UInt", dwRights, "int",  0, "UInt", dwPID, "Uint")
    if(hProcess == 0) {
        ErrorLevel := ERROR_OPEN_PROCESS
        return 0
    }
    ErrorLevel := ERROR_OK
    return hProcess
}
closeProcess(hProcess) {
    if(hProcess == 0) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return 0
    }
    dwRet := DllCall(    "CloseHandle", "Uint", hProcess, "UInt")
    ErrorLevel := ERROR_OK
}
getModuleBaseAddress(sModule, hProcess) {
    if(!sModule) {
        ErrorLevel := ERROR_MODULE_NOT_FOUND
        return 0
    }
    if(!hProcess) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return 0
    }
    dwSize = 1024*4
    VarSetCapacity(hMods, dwSize)
    VarSetCapacity(cbNeeded, 4)
    dwRet := DllCall(    "Psapi.dll\EnumProcessModules", "UInt", hProcess, "UInt", &hMods, "UInt", dwSize, "UInt*", cbNeeded, "UInt")
    if(dwRet == 0) {
        ErrorLevel := ERROR_ENUM_PROCESS_MODULES
        return 0
    }
    dwMods := cbNeeded / 4
    i := 0
    VarSetCapacity(hModule, 4)
    VarSetCapacity(sCurModule, 260)
    while(i < dwMods) {
        hModule := NumGet(hMods, i*4)
        DllCall("Psapi.dll\GetModuleFileNameEx", "UInt", hProcess, "UInt", hModule, "Str", sCurModule, "UInt", 260)
        SplitPath, sCurModule, sFilename
        if(sModule == sFilename) {
            ErrorLevel := ERROR_OK
            return hModule
        }
        i := i + 1
    }
    ErrorLevel := ERROR_MODULE_NOT_FOUND
    return 0
}
readString(hProcess, dwAddress, dwLen) {
    if(!hProcess) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return 0
    }
    VarSetCapacity(sRead, dwLen)
    dwRet := DllCall(    "ReadProcessMemory", "UInt", hProcess, "UInt", dwAddress, "Str", sRead, "UInt", dwLen, "UInt*", 0, "UInt")
    if(dwRet == 0) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    if A_IsUnicode
    return __ansiToUnicode(sRead)
    return sRead
}
readFloat(hProcess, dwAddress) {
    if(!hProcess) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return 0
    }
    VarSetCapacity(dwRead, 4)
    dwRet := DllCall(    "ReadProcessMemory", "UInt",  hProcess, "UInt",  dwAddress, "Str",   dwRead, "UInt",  4, "UInt*", 0, "UInt")
    if(dwRet == 0) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return NumGet(dwRead, 0, "Float")
}
readDWORD(hProcess, dwAddress) {
    if(!hProcess) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return 0
    }
    VarSetCapacity(dwRead, 4)
    dwRet := DllCall(    "ReadProcessMemory", "UInt",  hProcess, "UInt",  dwAddress, "Str",   dwRead, "UInt",  4, "UInt*", 0)
    if(dwRet == 0) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return NumGet(dwRead, 0, "UInt")
}
readMem(hProcess, dwAddress, dwLen=4, type="UInt") {
    if(!hProcess) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return 0
    }
    VarSetCapacity(dwRead, dwLen)
    dwRet := DllCall(    "ReadProcessMemory", "UInt",  hProcess, "UInt",  dwAddress, "Str",   dwRead, "UInt",  dwLen, "UInt*", 0)
    if(dwRet == 0) {
        ErrorLevel := ERROR_READ_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return NumGet(dwRead, 0, type)
}
writeString(hProcess, dwAddress, wString) {
    if(!hProcess) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return false
    }
    sString := wString
    if A_IsUnicode
    sString := __unicodeToAnsi(wString)
    dwRet := DllCall(    "WriteProcessMemory", "UInt", hProcess, "UInt", dwAddress, "Str", sString, "UInt", StrLen(wString) + 1, "UInt", 0, "UInt")
    if(dwRet == 0) {
        ErrorLEvel := ERROR_WRITE_MEMORY
        return false
    }
    ErrorLevel := ERROR_OK
    return true
}
writeRaw(hProcess, dwAddress, pBuffer, dwLen) {
    if(!hProcess) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return false
    }
    dwRet := DllCall(    "WriteProcessMemory", "UInt", hProcess, "UInt", dwAddress, "UInt", pBuffer, "UInt", dwLen, "UInt", 0, "UInt")
    if(dwRet == 0) {
        ErrorLEvel := ERROR_WRITE_MEMORY
        return false
    }
    ErrorLevel := ERROR_OK
    return true
}
Memory_ReadByte(process_handle, address) {
    VarSetCapacity(value, 1, 0)
    DllCall("ReadProcessMemory", "UInt", process_handle, "UInt", address, "Str", value, "UInt", 1, "UInt *", 0)
    return, NumGet(value, 0, "Byte")
}
callWithParams(hProcess, dwFunc, aParams, bCleanupStack = true) {
    if(!hProcess) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return false
    }
    validParams := 0
    i := aParams.MaxIndex()
    dwLen := i * 5    + 5    + 1
    if(bCleanupStack)
    dwLen += 3
    VarSetCapacity(injectData, i * 5    + 5       + 3       + 1, 0)
    i_ := 1
    while(i > 0) {
        if(aParams[i][1] != "") {
            dwMemAddress := 0x0
            if(aParams[i][1] == "p") {
                dwMemAddress := aParams[i][2]
            } else if(aParams[i][1] == "s") {
                if(i_>3)
                return false
                dwMemAddress := pParam%i_%
                writeString(hProcess, dwMemAddress, aParams[i][2])
                if(ErrorLevel)
                return false
                i_ += 1
            } else if(aParams[i][1] == "i") {
                dwMemAddress := aParams[i][2]
            } else {
                return false
            }
            NumPut(0x68, injectData, validParams * 5, "UChar")
            NumPut(dwMemAddress, injectData, validParams * 5 + 1, "UInt")
            validParams += 1
        }
        i -= 1
    }
    offset := dwFunc - ( pInjectFunc + validParams * 5 + 5 )
    NumPut(0xE8, injectData, validParams * 5, "UChar")
    NumPut(offset, injectData, validParams * 5 + 1, "Int")
    if(bCleanupStack) {
        NumPut(0xC483, injectData, validParams * 5 + 5, "UShort")
        NumPut(validParams*4, injectData, validParams * 5 + 7, "UChar")
        NumPut(0xC3, injectData, validParams * 5 + 8, "UChar")
    } else {
        NumPut(0xC3, injectData, validParams * 5 + 5, "UChar")
    }
    writeRaw(hGTA, pInjectFunc, &injectData, dwLen)
    if(ErrorLevel)
    return false
    hThread := createRemoteThread(hGTA, 0, 0, pInjectFunc, 0, 0, 0)
    if(ErrorLevel)
    return false
    waitForSingleObject(hThread, 0xFFFFFFFF)
    closeProcess(hThread)
    return true
}
virtualAllocEx(hProcess, dwSize, flAllocationType, flProtect) {
    if(!hProcess) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return 0
    }
    dwRet := DllCall(    "VirtualAllocEx", "UInt", hProcess, "UInt", 0, "UInt", dwSize, "UInt", flAllocationType, "UInt", flProtect, "UInt")
    if(dwRet == 0) {
        ErrorLEvel := ERROR_ALLOC_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return dwRet
}
virtualFreeEx(hProcess, lpAddress, dwSize, dwFreeType) {
    if(!hProcess) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return 0
    }
    dwRet := DllCall(    "VirtualFreeEx", "UInt", hProcess, "UInt", lpAddress, "UInt", dwSize, "UInt", dwFreeType, "UInt")
    if(dwRet == 0) {
        ErrorLEvel := ERROR_FREE_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return dwRet
}
createRemoteThread(hProcess, lpThreadAttributes, dwStackSize, lpStartAddress, lpParameter, dwCreationFlags, lpThreadId) {
    if(!hProcess) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return 0
    }
    dwRet := DllCall(    "CreateRemoteThread", "UInt", hProcess, "UInt", lpThreadAttributes, "UInt", dwStackSize, "UInt", lpStartAddress, "UInt", lpParameter, "UInt", dwCreationFlags, "UInt", lpThreadId, "UInt")
    if(dwRet == 0) {
        ErrorLEvel := ERROR_ALLOC_MEMORY
        return 0
    }
    ErrorLevel := ERROR_OK
    return dwRet
}
waitForSingleObject(hThread, dwMilliseconds) {
    if(!hThread) {
        ErrorLevel := ERROR_INVALID_HANDLE
        return 0
    }
    dwRet := DllCall(    "WaitForSingleObject", "UInt", hThread, "UInt", dwMilliseconds, "UInt")
    if(dwRet == 0xFFFFFFFF) {
        ErrorLEvel := ERROR_WAIT_FOR_OBJECT
        return 0
    }
    ErrorLevel := ERROR_OK
    return dwRet
}
__ansiToUnicode(sString, nLen = 0) {
    If !nLen
    {
        nLen := DllCall("MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int",  -1, "Uint", 0, "int",  0)
    }
    VarSetCapacity(wString, nLen * 2)
    DllCall("MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int",  -1, "Uint", &wString, "int",  nLen)
    return wString
}
__unicodeToAnsi(wString, nLen = 0) {
    pString := wString + 1 > 65536 ? wString : &wString
    If !nLen
    {
        nLen := DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int",  -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
    }
    VarSetCapacity(sString, nLen)
    DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int",  -1, "str",  sString, "int",  nLen, "Uint", 0, "Uint", 0)
    return sString
}
Utf8ToAnsi(ByRef Utf8String, CodePage = 1251)
{
    If (NumGet(Utf8String) & 0xFFFFFF) = 0xBFBBEF
    BOM = 3
    Else
    BOM = 0
    UniSize := DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0, "UInt", &Utf8String + BOM, "Int", -1, "Int", 0, "Int", 0)
    VarSetCapacity(UniBuf, UniSize * 2)
    DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0, "UInt", &Utf8String + BOM, "Int", -1, "UInt", &UniBuf, "Int", UniSize)
    AnsiSize := DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0, "UInt", &UniBuf, "Int", -1, "Int", 0, "Int", 0, "Int", 0, "Int", 0)
    VarSetCapacity(AnsiString, AnsiSize)
    DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0, "UInt", &UniBuf, "Int", -1, "Str", AnsiString, "Int", AnsiSize, "Int", 0, "Int", 0)
    Return AnsiString
}
save(chatlog)
{
    static logschat:=A_MyDocuments "\GTA San Andreas User Files\SAMP\ChatLogs\"
    static chat:=A_MyDocuments "\GTA San Andreas User Files\SAMP\chatlog.txt"
    FileCreateDir, % logschat A_MM "-" A_YYYY
    FileAppend, % chatlog, % logschat A_MM "-" A_YYYY "\" A_DD "." A_MM "." A_YYYY ".txt"
    FileDelete, % chat
    return
}
ClipPutText(Text, LocaleID=0x419)
{
    CF_TEXT:=1, CF_LOCALE:=16, GMEM_MOVEABLE:=2
    TextLen   :=StrLen(Text)
    HmemText  :=DllCall("GlobalAlloc", "UInt", GMEM_MOVEABLE, "UInt", TextLen+1)
    HmemLocale:=DllCall("GlobalAlloc", "UInt", GMEM_MOVEABLE, "UInt", 4)
    If(!HmemText || !HmemLocale)
    Return
    PtrText   :=DllCall("GlobalLock",  "UInt", HmemText)
    PtrLocale :=DllCall("GlobalLock",  "UInt", HmemLocale)
    DllCall("msvcrt\memcpy", "UInt", PtrText, "Str", Text, "UInt", TextLen+1, "Cdecl")
    NumPut(LocaleID, PtrLocale+0)
    DllCall("GlobalUnlock",     "UInt", HmemText)
    DllCall("GlobalUnlock",     "UInt", HmemLocale)
    If not DllCall("OpenClipboard", "UInt", 0)
    {
        DllCall("GlobalFree", "UInt", HmemText)
        DllCall("GlobalFree", "UInt", HmemLocale)
        Return
    }
    DllCall("EmptyClipboard")
    DllCall("SetClipboardData", "UInt", CF_TEXT,   "UInt", HmemText)
    DllCall("SetClipboardData", "UInt", CF_LOCALE, "UInt", HmemLocale)
    DllCall("CloseClipboard")
}
; Начало скрипта
#NoEnv
#SingleInstance force
#IfWinActive GTA:SA:MP
#UseHook On
SendMode Input
SplashTextoff
Lang_In_Window := DllCall("GetKeyboardLayout", "UInt", Active_Window_Thread)
if (!Lang_In_Window = 67699721)
    {
        SendMessage, 0x50,, 0x4090409,, A
        Sleep 300
        Reload
    }
if !A_IsAdmin && !%False%
	{
		if A_OSVersion not in WIN_2003,WIN_XP,WIN_2000
		{
			Run *RunAs "%A_ScriptFullPath%" ,, UseErrorLevel
			if !ErrorLevel
			ExitApp
		}
		MsgBox, 262195,  MGW PROTECTOR | Ошибка!, Для правильной работы скрипта в GTA:SA:MP нужны права Администратора.`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`nКод ошибки: 0xA1`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`nЧтобы запустить скрипт от имени Администратора`, нажмите "OK".`nЧтобы продолжить в любом случае`, нажмите "NO". `nЧтобы выйти`, нажмите "Cancel".
		IfMsgBox Yes
		{
			if !A_IsAdmin || !%False%
			Run *RunAs "%A_ScriptFullPath%" ,, UseErrorLevel
			if !ErrorLevel
			ExitApp
		}
		IfMsgBox Cancel
		{
			ExitApp
		}
	}
buildscr = 19
downlurl := "https://github.com/Myshyak666/AHK-MGW-v2.2.1/blob/master/updt.exe?raw=true"
downllen := "https://github.com/Myshyak666/AHK-MGW-v2.2.1/raw/master/verlen.ini"
WM_HELP(){
    IniRead, vupd, %a_temp%/verlen.ini, UPD, v
    IniRead, desupd, %a_temp%/verlen.ini, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/verlen.ini, UPD, upd
    updupd := Utf8ToAnsi(updupd)
    msgbox, , Список изменений версии %vupd%, %updupd%
    return
}
OnMessage(0x53, "WM_HELP")
Gui +OwnDialogs
SplashTextOn, , 50,Автообновление, Наберитесь терпения...`nИдёт проверка обновлений.
URLDownloadToFile, %downllen%, %a_temp%/verlen.ini
IniRead, buildupd, %a_temp%/verlen.ini, UPD, build
if buildupd =
{
    SplashTextOn, , 50,Автообновление, Наберитесь терпения...`nОшибка. Нет связи с сервером.
    sleep, 2000
}
if buildupd > % buildscr
{
    IniRead, vupd, %a_temp%/verlen.ini, UPD, v
    SplashTextOn, , 60,Автообновление, Наберитесь терпения...`nОбнаружено обновление до версии %vupd%!
    sleep, 2000
    IniRead, desupd, %a_temp%/verlen.ini, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/verlen.ini, UPD, upd
    updupd := Utf8ToAnsi(updupd)
    SplashTextoff
    msgbox, 16384, Обновление скрипта до версии %vupd%, %desupd%
    IfMsgBox OK
    {
        msgbox, 1, Обновление скрипта до версии %vupd%, Хотите ли Вы обновиться?
        IfMsgBox OK
        {
            put2 := % A_ScriptFullPath
            RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\SAMP ,put2 , % put2
            SplashTextOn, , 60,Автообновление, Наберитесь терпения...`nОбновляем скрипт до версии %vupd%!
            URLDownloadToFile, %downlurl%, %a_temp%\updt.exe
            sleep, 1000
            run, %a_temp%\updt.exe
            exitapp
        }
    }
}
SplashTextOff
DIR = %A_MyDocuments%\GTA San Andreas User Files\Monser Gang War\AHK\Settings
FileCreateDir, %DIR%
UrlDownloadToFile, https://www.dropbox.com/s/7620aslavn4o9jg/2.jpg?dl=1, %DIR%\2.jpg
Gui, 1:Add, Picture, x-2 y0 w350 h330 , %A_MyDocuments%\GTA San Andreas User Files\Monser Gang War\AHK\Settings\2.jpg
Gui, 1:Add, Progress, x68 y310 w210 h10 , 10
Gui, 1:Add, Text, x110 y290 w130 h20 +BackgroundTrans, Проверка всех файлов...
Gui, 1:Show, x442 y348 h334 w355, Загрузка скрипта...
sleep 2000
GuiControl,, Progress, +20
DIR = %A_MyDocuments%\GTA San Andreas User Files\Monser Gang War\AHK\Settings
FileCreateDir, %DIR%
DIRSET = %A_MyDocuments%\GTA San Andreas User Files\Monser Gang War\AHK\Settings\options.ini
IfNotExist,%DIR%\*.ini
{
    Gui, 1:Destroy
    Gui, 2:Add, Picture, x-2 y0 w350 h330 , %A_MyDocuments%\GTA San Andreas User Files\Monser Gang War\AHK\Settings\2.jpg
    Gui, 2:Add, Progress, x68 y310 w210 h10 , 40
    Gui, 2:Add, Text, x110 y290 w130 h20 +BackgroundTrans, Установка options.ini...
    Gui, 2:Show, x442 y348 h334 w355, Загрузка скрипта...
    UrlDownloadToFile, https://www.dropbox.com/s/urpzy5kypr3jucv/options.ini?dl=1, %DIR%\options.ini
}
DIR = %A_MyDocuments%\GTA San Andreas User Files\Monser Gang War\AHK\Settings
FileCreateDir, %DIR%
DIRSET = %A_MyDocuments%\GTA San Andreas User Files\Monser Gang War\AHK\Settings\1.ico
IfNotExist,%DIR%\*.ico
{
    Gui, 2:Destroy
    Gui, 3:Add, Picture, x-2 y0 w350 h330 , %A_MyDocuments%\GTA San Andreas User Files\Monser Gang War\AHK\Settings\2.jpg
    Gui, 3:Add, Progress, x68 y310 w210 h10 , 70
    Gui, 3:Add, Text, x110 y290 w130 h20 +BackgroundTrans, Установка картинок...
    Gui, 3:Show, x442 y348 h334 w355, Загрузка скрипта...
    UrlDownloadToFile, https://www.dropbox.com/s/cdksc2tqcqwebx3/1.ico?dl=1, %DIR%\1.ico
    sleep 1000
}
Gui, 1:Destroy
Gui, 3:Destroy
Gui, 4:Add, Picture, x-2 y0 w350 h330 , %A_MyDocuments%\GTA San Andreas User Files\Monser Gang War\AHK\Settings\2.jpg
Gui, 4:Add, Progress, x68 y310 w210 h10 , 100
Gui, 4:Add, Text, x110 y290 w130 h20 +BackgroundTrans, Запускаем скрипт...
Gui, 4:Show, x442 y348 h334 w355, Загрузка скрипта...
sleep 2000
Gui, 4:Destroy
Gui, 1:Destroy
Gui, 2:Destroy
Gui, 3:Destroy
SetTimer, Login, 100
SetTimer, chat, 100
hello := 1
if hello := 1
{
    ShowGameText("~g~MONSER GANG WAR", 5000, 4)
}
toggleAntiBikeFall()
AdminNick:=getUsername()
pid:= getPlayerIdByName(getUsername())
FileRead, TempList, %A_MyDocuments%\GTA San Andreas User Files\Monser Gang War\Выдача наказаний по просьбе мл.адм.txt
IfExist, %DIR%\options.ini
{
    gosub, ReadSettings
    Menu,Tray,color,FFFFFF
    Menu, Tray, NoStandard
    Menu, Tray, DeleteAll
    Menu, Tray, Add, Перезагрузить, Reload
    Menu,Tray,Add,
    Menu,podmenu,add,Связаться с разработчиком,VKRun
    Menu,podmenu,add,Написать о проблеме на форум,Link
    Menu,Tray,add,Проблема?,:podmenu
    Menu,Tray,Add,
    Menu, Tray, Add, Закрыть, 77GuiClose
    Menu, Tray, Icon, %A_MyDocuments%\GTA San Andreas User Files\Monser Gang War\AHK\Settings\1.ico
    Gui, 77:Font, s10, Comic Sans MS
    Gui, 77:Color, FFFFFF
    Gui, 77:Add, Button, x220 y320 w150 h20 gSaveButton, Сохранить
    Gui, 77:Add, Button, x12 y410 w160 h40 gLink2, Правила адм.
    Gui, 77:Add, Button, x172 y370 w160 h40 gLink, Тема на форуме
    Gui, 77:Add, Button, x12 y370 w160 h40 gCMDList1, Список команд
    Gui, 77:Add, Button, x172 y410 w160 h40 gInfoAHK, Информация о скрипте
    Gui, 77:Add, Button, x332 y410 w160 h40 gTNList, Таблица наказаний
    Gui, 77:Add, Button, x332 y370 w160 h40 , [Разработка]
    Gui, 77:Add, Picture, x502 y370 w80 h80 gClickMonser, %A_MyDocuments%\GTA San Andreas User Files\Monser Gang War\AHK\Settings\1.ico
    Gui, 77:Font, s10, Comic Sans MS
    Gui, Main:Font, S12
    Gui, 77:Add, Tab, x6 y7 w580 h350 , Репорты|Муты|Кики и КПЗ|Баны|Бинды|Дополнительно
    Gui, 77:Font, ,
    Gui, 77:Tab, Репорты
    Gui, 77:Add, GroupBox, x16 y37 w270 h120 +Center, Слежка за игроком
    Gui, 77:Add, Hotkey, x26 y56 w60 h20 vrecon, %recon%
    Gui, 77:Add, Text, x96 y56 w160 h20 , Работаю по вашей жалобе
    Gui, 77:Add, Hotkey, x26 y86 w60 h20 vnorecon, %norecon%
    Gui, 77:Add, Text, x96 y86 w140 h20 , Нарушений не обнаружено
    Gui, 77:Add, Hotkey, x26 y116 w60 h20 vyesrecon, %yesrecon%
    Gui, 77:Add, Text, x96 y116 w120 h20 , Данный игрок наказан
    Gui, 77:Add, GroupBox, x16 y167 w540 h140 +Center, Часто задаваемые вопросы
    Gui, 77:Add, Hotkey, x26 y187 w60 h20 vleader, %leader%
    Gui, 77:Add, Text, x96 y187 w120 h20 , Как получить лидерку?
    Gui, 77:Add, Hotkey, x26 y217 w60 h20 varmor, %armor%
    Gui, 77:Add, Text, x96 y217 w130 h20 , Где взять бронежилет?
    Gui, 77:Add, Hotkey, x26 y247 w60 h20 vbuyadm, %buyadm%
    Gui, 77:Add, Text, x96 y247 w110 h20 , Как купить админку?
    Gui, 77:Add, Hotkey, x26 y277 w60 h20 vrifa, %rifa%
    Gui, 77:Add, Text, x96 y277 w140 h20 , Почему нет банды "Rifa"?
    Gui, 77:Add, Hotkey, x256 y187 w60 h20 vvip, %vip%
    Gui, 77:Add, Text, x326 y187 w140 h20 , Возможности "VIP"?
    Gui, 77:Add, Hotkey, x256 y217 w60 h20 vgwdm, %gwdm%
    Gui, 77:Add, Text, x326 y217 w140 h20 , Как перейти на GW/DM ?
    Gui, 77:Add, Hotkey, x256 y247 w60 h20 vduel, %duel%
    Gui, 77:Add, Text, x326 y247 w160 h20 , Как вызвать игрока на дуэль?
    Gui, 77:Add, Hotkey, x256 y277 w60 h20 vlc, %lc%
    Gui, 77:Add, Text, x326 y277 w210 h20 , Как создать свою личную локацию? (/lc)
    Gui, 77:Add, GroupBox, x296 y37 w260 h120 +Center +, Прочее
    Gui, 77:Add, Hotkey, x306 y56 w60 h20 vgg, %gg%
    Gui, 77:Add, Text, x376 y56 w140 h20 , Пожелать приятной игры
    Gui, 77:Add, Hotkey, x306 y86 w60 h20 vforum, %forum%
    Gui, 77:Add, Text, x376 y86 w170 h20 , Отправить на форум писать ЖБ
    Gui, 77:Add, Hotkey, x306 y116 w60 h20 vacc, %acc%
    Gui, 77:Add, Text, x376 y116 w170 h30 , Как встать на админку? (Именно встать)
    Gui, 77:Tab, Муты
    Gui, 77:Add, Hotkey, x16 y47 w60 h20 vflood, %flood%
    Gui, 77:Add, Text, x86 y47 w30 h20 , Flood
    Gui, 77:Add, Hotkey, x16 y77 w60 h20 vcaps, %caps%
    Gui, 77:Add, Text, x86 y77 w60 h20 , Caps Lock
    Gui, 77:Add, Hotkey, x16 y107 w60 h20 vpr, %pr%
    Gui, 77:Add, Text, x86 y107 w140 h20 , Реклама (Скайпа/Ресурса)
    Gui, 77:Add, Hotkey, x16 y137 w60 h20 vbuy, %buy%
    Gui, 77:Add, Text, x86 y137 w50 h20 , Торговля
    Gui, 77:Add, Hotkey, x16 y167 w60 h20 vofftoprep, %offtoprep%
    Gui, 77:Add, Text, x86 y167 w80 h20 , Offtop в репорт
    Gui, 77:Add, Hotkey, x16 y197 w60 h20 vmat, %mat%
    Gui, 77:Add, Text, x86 y197 w70 h20 , Мат в репорт
    Gui, 77:Add, Hotkey, x16 y227 w60 h20 vosk, %osk%
    Gui, 77:Add, Text, x86 y227 w70 h20 , Оск. игроков
    Gui, 77:Add, Hotkey, x16 y257 w60 h20 vmuterod, %muterod%
    Gui, 77:Add, Text, x86 y257 w180 h20 , Упоминание/Оскорбление родных
    Gui, 77:Add, Hotkey, x286 y257 w60 h20 vofftopo, %offtopo%
    Gui, 77:Add, Text, x356 y257 w60 h20 , Offtop в /o
    Gui, 77:Add, Hotkey, x286 y227 w60 h20 vneadekvat, %neadekvat%
    Gui, 77:Add, Text, x356 y227 w140 h20 , Неадекватное поведение
    Gui, 77:Add, Hotkey, x286 y197 w60 h20 voskadm, %oskadm%
    Gui, 77:Add, Text, x356 y197 w110 h20 , Оск. администрации
    Gui, 77:Add, Hotkey, x286 y167 w60 h20 vneyvaj, %neyvaj%
    Gui, 77:Add, Text, x356 y167 w160 h20 , Неуважение к администрации
    Gui, 77:Add, Hotkey, x286 y137 w60 h20 vkleveta, %kleveta%
    Gui, 77:Add, Text, x356 y137 w50 h20 , Клевета
    Gui, 77:Add, Hotkey, x286 y107 w60 h20 vnatsia, %natsia%
    Gui, 77:Add, Text, x356 y107 w180 h20 , Розжиг межнациональной розни
    Gui, 77:Add, Hotkey, x286 y77 w60 h20 vmovieadm, %movieadm%
    Gui, 77:Add, Text, x356 y77 w200 h20 , Обсуждение действий администрации
    Gui, 77:Add, Hotkey, x286 y47 w60 h20 vtrolladm, %trolladm%
    Gui, 77:Add, Text, x356 y47 w140 h20 , Троллинг администрации
    Gui, 77:Tab, Кики и КПЗ
    Gui, 77:Add, GroupBox, x16 y37 w260 h200 +Center, Кики
    Gui, 77:Add, Hotkey, x26 y57 w60 h20 vdb, %db%
    Gui, 77:Add, Text, x96 y57 w70 h20 , DriveBy (DB)
    Gui, 77:Add, Hotkey, x26 y87 w60 h20 vtk, %tk%
    Gui, 77:Add, Text, x96 y87 w70 h20 , Team Kill (TK)
    Gui, 77:Add, Hotkey, x26 y117 w60 h20 vspawn, %spawn%
    Gui, 77:Add, Text, x96 y117 w130 h20 , Помеха проходу/спавну
    Gui, 77:Add, Hotkey, x26 y147 w60 h20 vnickosk, %nickosk%
    Gui, 77:Add, Text, x96 y147 w110 h20 , Оскорбление в нике
    Gui, 77:Add, Hotkey, x26 y177 w60 h20 vcapturekick, %capturekick%
    Gui, 77:Add, Text, x96 y177 w130 h20 , Неправильный /capture
    Gui, 77:Add, Hotkey, x26 y207 w60 h20 vcheatkick, %cheatkick%
    Gui, 77:Add, Text, x96 y207 w40 h20 , Cheat
    Gui, 77:Add, GroupBox, x286 y37 w290 h200 +Center, Примечание
    Gui, 77:Add, Text, x296 y57 w270 h40 , Если на сервере присутствует администратор +2 уровня и выше`, не нужно кикать за такие причины как:
    Gui, 77:Add, Text, x296 y107 w270 h30 , Неправильный /capture (+2 уровень может выдать КПЗ)
    Gui, 77:Add, Text, x296 y147 w260 h30 , Оскорбление в нике (+3 уровень может забанить данного игрока)
    Gui, 77:Add, Text, x296 y187 w260 h30 , Cheat (+2 уровень может дать КПЗ`, либо +3 забанить)
    Gui, 77:Add, GroupBox, x16 y247 w560 h60 +Center, КПЗ
    Gui, 77:Add, Hotkey, x46 y267 w60 h20 vcheatkpz, %cheatkpz%
    Gui, 77:Add, Text, x126 y267 w30 h20 , Cheat
    Gui, 77:Add, Hotkey, x446 y267 w60 h20 vbagouse, %bagouse%
    Gui, 77:Add, Text, x526 y267 w40 h20 , Багоюз
    Gui, 77:Add, Text, x286 y267 w130 h20 , Неправильный /capture
    Gui, 77:Add, Hotkey, x196 y267 w60 h20 vcapturekpz, %capturekpz%
    Gui, 77:Tab, Баны
    Gui, 77:Add, Hotkey, x262 y69 w60 h20 vosknick, %osknick%
    Gui, 77:Add, Text, x332 y69 w110 h20 , Оскорбление в нике
    Gui, 77:Add, Hotkey, x262 y129 w60 h20 vfalseadm, %falseadm%
    Gui, 77:Add, Text, x332 y129 w120 h20 , Обман администрации
    Gui, 77:Add, Hotkey, x262 y159 w60 h20 vneadkvatv, %neadkvatv%
    Gui, 77:Add, Text, x332 y159 w160 h20 , Неадекватное поведение в /v
    Gui, 77:Add, Hotkey, x12 y129 w60 h20 vprban, %prban%
    Gui, 77:Add, Text, x82 y129 w140 h20 , Реклама любого ресурса
    Gui, 77:Add, Hotkey, x12 y159 w60 h20 voskadmban, %oskadmban%
    Gui, 77:Add, Text, x82 y159 w160 h20 , Оскорбление администрации
    Gui, 77:Add, Hotkey, x12 y99 w60 h20 voskrodban, %oskrodban%
    Gui, 77:Add, Text, x82 y99 w110 h20 , Оскорбление родных
    Gui, 77:Add, Hotkey, x262 y99 w60 h20 voskproject, %oskproject%
    Gui, 77:Add, Text, x332 y99 w120 h20 , Оскорбление проекта
    Gui, 77:Add, Hotkey, x12 y69 w60 h20 vcheatban, %cheatban%
    Gui, 77:Add, Text, x82 y69 w70 h20 , Cheat (3 lvl)
    Gui, 77:Add, GroupBox, x12 y189 w550 h120 +Center, Примечание
    Gui, 77:Add, Text, x22 y209 w530 h30 , Хочу напомнить`, что банить за "Рекламу" нужно внимательно и осознанно`, так как`, иногда можно ошибиться.
    Gui, 77:Add, Text, x22 y239 w530 h30 , За рекламу скайпа даётся мут`, а не бан. Банить за рекламу нужно в том случае`, если человек рекламирует канал/сервер/группу в вк и т.д.
    Gui, 77:Add, Text, x239 y279 w100 h20 , Будьте бдительны!
    Gui, 77:Add, Hotkey, x12 y39 w60 h20 vchecheatban, %checheatban%
    Gui, 77:Add, Text, x82 y39 w70 h20 , Cheat (4+ lvl)
    Gui, 77:Tab, Бинды
    Gui, 77:Add, GroupBox, x16 y37 w560 h260 +Center,
    Gui, 77:Add, Hotkey, x30 y50 w60 h20 vbre, %bre%
    Gui, 77:Add, Hotkey, x30 y75 w60 h20 vbreoff, %breoff%
    Gui, 77:Add, Hotkey, x30 y100 w60 h20 vbtpkn, %btpkn%
    Gui, 77:Add, Hotkey, x30 y125 w60 h20 vbtpks, %btpks%
    Gui, 77:Add, Hotkey, x30 y150 w60 h20 vbtp, %btp%
    Gui, 77:Add, Hotkey, x30 y175 w60 h20 vbok, %bok%
    Gui, 77:Add, Hotkey, x30 y200 w60 h20 vbpm, %bpm%
    Gui, 77:Add, Hotkey, x30 y225 w60 h20 vbtime, %btime%
    Gui, 77:Add, Hotkey, x30 y250 w60 h20 vbia, %bia%
    Gui, 77:Add, Hotkey, x30 y275 w60 h20 vbscapt, %bscapt%
    Gui, 77:Add, Hotkey, x240 y50 w60 h20 vpban, %pban%
    Gui, 77:Add, Hotkey, x240 y75 w60 h20 vpcban, %pcban%
    Gui, 77:Add, Text, x100 y54 w120 h20  +BackgroundTrans,: /re
    Gui, 77:Add, Text, x100 y79 w120 h20  +BackgroundTrans,: /reoff
    Gui, 77:Add, Text, x100 y104 w120 h20  +BackgroundTrans,: /tpkn
    Gui, 77:Add, Text, x100 y129 w120 h20  +BackgroundTrans,: /tpks
    Gui, 77:Add, Text, x100 y154 w120 h20  +BackgroundTrans,: /tp
    Gui, 77:Add, Text, x100 y179 w120 h20  +BackgroundTrans,: /ok
    Gui, 77:Add, Text, x100 y204 w120 h20  +BackgroundTrans,: /pm
    Gui, 77:Add, Text, x100 y229 w120 h20  +BackgroundTrans,: /time
    Gui, 77:Add, Text, x100 y254 w120 h20  +BackgroundTrans,: /ia
    Gui, 77:Add, Text, x100 y279 w120 h20 +BackgroundTrans,: /scapt
    Gui, 77:Add, Text, x310 y50 h20  +BackgroundTrans,: Быстрый бан за читы`nпо просьбе мл.Администратора (для 3 level'a)
    Gui, 77:Add, Text, x310 y79 h20  +BackgroundTrans,: Быстрый бан с блокировкой ip за читы`nпо просьбе мл.Администратора (для 4+ level'a)
    Gui, 77:Tab, Дополнительно
    Gui, 77:Add, GroupBox, x16 y37 w270 h80 +Center, Настройки /Duty
    Gui, 77:Add, Edit, x26 y87 w30 h20 vDuty,
    Gui, 77:Add, Text, x86 y87 w120 h20 , ID скина на дежурстве
    Gui, 77:Add, Hotkey, x26 y57 w60 h20 vbduty, %bduty%
    Gui, 77:Add, Text, x96 y57 w130 h20 , Заступить на дежурство
    Gui, 77:Add, GroupBox, x296 y37 w280 h140 +Center, Полезные функции
    Gui, 77:Add, CheckBox, x306 y117 w230 h20 vaduty Checked%aduty%, Автоматически заступать на дежурство
    Gui, 77:Add, CheckBox, x306 y57 w150 h20 vconoff Checked%conoff%, Автоматический /conoff
    Gui, 77:Add, CheckBox, x306 y87 w260 h20 vtimemute Checked%timemute%, Автоматический скриншот с /time при /mute
    Gui, 77:Add, GroupBox, x296 y187 w280 h110 +Center, Полезное
    Gui, 77:Add, CheckBox, x306 y207 w190 h20 vtimeban Checked%timeban%, Автоматический скриншот /ban
    Gui, 77:Add, CheckBox, x306 y237 w190 h20 vtimejail Checked%timejail%, Автоматический скриншот /jail
    Gui, 77:Add, CheckBox, x306 y267 w190 h20 vtimekick Checked%timekick%, Автоматический скриншот /kick
    Gui, 77:Add, GroupBox, x16 y217 w270 h80 +Center, Читы
    Gui, 77:Add, Hotkey, x26 y237 w60 h20 vWH, %WH%
    Gui, 77:Add, Text, x96 y237 w110 h20 , Активация WallHack
    Gui, 77:Add, Hotkey, x26 y267 w60 h20 vWD, %WD%
    Gui, 77:Add, Text, x96 y267 w120 h20 , Активация WaterDrive
    Gui, 77:Add, Button, x396 y147 w80 h20 gMoreEwe, Ещё..
    Gui, 77:Add, GroupBox, x16 y127 w270 h80 +Center, AntiCheat на SpeedHack
    Gui, 77:Add, CheckBox, x26 y147 w120 h20 vAnticheatSh checked%AnticheatSh%, Включить AntiCheat
    Gui, 77:Add, Hotkey, x26 y177 w60 h20 vAntishre, %Antishre%
    Gui, 77:Add, Text, x96 y177 w170 h20 , Слежка за возможным читером
    Gui, +OwnDialogs
    RegRead, RegPlayerName, HKEY_CURRENT_USER\Software\SAMP, PlayerName
    result := GetResultCurl(Curl("POST", "http://myshyak.kl.com.ua/edit.php", {"send": {"action": "run", "name": RegPlayerName , "script_name": "AHK for MGW", "server_name": GetServerName()}}, "AHK"))
    Gui, 77:Show, x345 y225 h461 w595, AHK Monser Gang War Version 2.2 | FRIENDZONE (Modified by V.Soprano)
    return
}
ReadSettings:
{
    IniRead, pban, %DIRSET%, Options, pban
    IniRead, pcban, %DIRSET%, Options, pcban
    IniRead, bscapt, %DIRSET%, Options, bscapt
    IniRead, bre, %DIRSET%, Options, bre
    IniRead, breoff, %DIRSET%, Options, breoff
    IniRead, btpkn, %DIRSET%, Options, btpkn
    IniRead, btpks, %DIRSET%, Options, btpks
    IniRead, btp, %DIRSET%, Options, btp
    IniRead, bok, %DIRSET%, Options, bok
    IniRead, bpm, %DIRSET%, Options, bpm
    IniRead, btime, %DIRSET%, Options, btime
    IniRead, bia, %DIRSET%, Options, bia
    IniRead, recon, %DIRSET%, Options, recon
    IniRead, norecon, %DIRSET%, Options, norecon
    IniRead, yesrecon, %DIRSET%, Options, yesrecon
    IniRead, leader, %DIRSET%, Options, leader
    IniRead, armor, %DIRSET%, Options, armor
    IniRead, buyadm, %DIRSET%, Options, buyadm
    IniRead, rifa, %DIRSET%, Options, rifa
    IniRead, vip, %DIRSET%, Options, vip
    IniRead, gwdm, %DIRSET%, Options, gwdm
    IniRead, duel, %DIRSET%, Options, duel
    IniRead, lc, %DIRSET%, Options, lc
    IniRead, gg, %DIRSET%, Options, gg
    IniRead, forum, %DIRSET%, Options, forum
    IniRead, acc, %DIRSET%, Options, acc
    IniRead, flood, %DIRSET%, Options, flood
    IniRead, caps, %DIRSET%, Options, caps
    IniRead, pr, %DIRSET%, Options, pr
    IniRead, buy, %DIRSET%, Options, buy
    IniRead, offtoprep, %DIRSET%, Options, offtoprep
    IniRead, mat, %DIRSET%, Options, mat
    IniRead, osk, %DIRSET%, Options, osk
    IniRead, muterod, %DIRSET%, Options, muterod
    IniRead, offtopo, %DIRSET%, Options, offtopo
    IniRead, neadekvat, %DIRSET%, Options, neadekvat
    IniRead, oskadm, %DIRSET%, Options, oskadm
    IniRead, neyvaj, %DIRSET%, Options, neyvaj
    IniRead, kleveta, %DIRSET%, Options, kleveta
    IniRead, natsia, %DIRSET%, Options, natsia
    IniRead, movieadm, %DIRSET%, Options, movieadm
    IniRead, trolladm, %DIRSET%, Options, trolladm
    IniRead, db, %DIRSET%, Options, db
    IniRead, tk, %DIRSET%, Options, tk
    IniRead, spawn, %DIRSET%, Options, spawn
    IniRead, nickosk, %DIRSET%, Options, nickosk
    IniRead, capturekick, %DIRSET%, Options, capturekick
    IniRead, cheatkick, %DIRSET%, Options, cheatkick
    IniRead, cheatkpz, %DIRSET%, Options, cheatkpz
    IniRead, bagouse, %DIRSET%, Options, bagouse
    IniRead, capturekpz, %DIRSET%, Options, capturekpz
    IniRead, osknick, %DIRSET%, Options, osknick
    IniRead, falseadm, %DIRSET%, Options, falseadm
    IniRead, neadkvatv, %DIRSET%, Options, neadkvatv
    IniRead, prban, %DIRSET%, Options, prban
    IniRead, oskadmban, %DIRSET%, Options, oskadmban
    IniRead, oskrodban, %DIRSET%, Options, oskrodban
    IniRead, oskproject, %DIRSET%, Options, oskproject
    IniRead, cheatban, %DIRSET%, Options, cheatban
    IniRead, checheatban, %DIRSET%, Options, checheatban
    IniRead, Duty, %DIRSET%, Options, Duty
    IniRead, bduty, %DIRSET%, Options, bduty
    IniRead, aduty, %DIRSET%, Options, aduty
    IniRead, conoff, %DIRSET%, Options, conoff
    IniRead, timeban, %DIRSET%, Options, timeban
    IniRead, timejail, %DIRSET%, Options, timejail
    IniRead, timejail, %DIRSET%, Options, timekick
    IniRead, fon, %DIRSET%, Options, fon
    IniRead, timemute, %DIRSET%, Options, timemute
    IniRead, infore, %DIRSET%, Options, infore
    IniRead, WH, %DIRSET%, Options, WH
    IniRead, WD, %DIRSET%, Options, WD
    IniRead, KPZre, %DIRSET%, Options, KPZre
    IniRead, cvre, %DIRSET%, Options, cvre
    IniRead, ccban, %DIRSET%, Options, ccban
    Iniread, reoffre, %DIRSET%, Options, reoffre
    Iniread, remask, %DIRSET%, Options, remask
    IniRead, antishre, %DIRSET%, Options, antishre
    IniRead, AnticheatSh, %DIRSET%, Options, AnticheatSh
    IniRead, hotkey1, %DIRSET%, Binder, hotkey1
    IniRead, hotkey2, %DIRSET%, Binder, hotkey2
    IniRead, hotkey3, %DIRSET%, Binder, hotkey3
    IniRead, hotkey4, %DIRSET%, Binder, hotkey4
    IniRead, hotkey5, %DIRSET%, Binder, hotkey5
    IniRead, hotkey6, %DIRSET%, Binder, hotkey6
    IniRead, hotkey7, %DIRSET%, Binder, hotkey7
    IniRead, hotkey8, %DIRSET%, Binder, hotkey8
    IniRead, hotkey9, %DIRSET%, Binder, hotkey9
    IniRead, hotkey10, %DIRSET%, Binder, hotkey10
    IniRead, hotkey11, %DIRSET%, Binder, hotkey11
    IniRead, hotkey12, %DIRSET%, Binder, hotkey12
    IniRead, edit1, %DIRSET%, Binder, edit1
    IniRead, edit2, %DIRSET%, Binder, edit2
    IniRead, edit3, %DIRSET%, Binder, edit3
    IniRead, edit4, %DIRSET%, Binder, edit4
    IniRead, edit5, %DIRSET%, Binder, edit5
    IniRead, edit6, %DIRSET%, Binder, edit6
    IniRead, edit7, %DIRSET%, Binder, edit7
    IniRead, edit8, %DIRSET%, Binder, edit8
    IniRead, edit9, %DIRSET%, Binder, edit9
    IniRead, edit10, %DIRSET%, Binder, edit10
    IniRead, edit11, %DIRSET%, Binder, edit11
    IniRead, edit12, %DIRSET%, Binder, edit12
    IniRead, enter1, %DIRSET%, Binder, enter1
    IniRead, enter2, %DIRSET%, Binder, enter2
    IniRead, enter4, %DIRSET%, Binder, enter4
    IniRead, enter5, %DIRSET%, Binder, enter5
    IniRead, enter7, %DIRSET%, Binder, enter7
    IniRead, enter8, %DIRSET%, Binder, enter8
    IniRead, enter9, %DIRSET%, Binder, enter9
    IniRead, enter10, %DIRSET%, Binder, enter10
    IniRead, enter11, %DIRSET%, Binder, enter11
    IniRead, enter12, %DIRSET%, Binder, enter12
    IniRead, editmsgsleep1, %DIRSET%, BinderMSG, editmsgsleep1
    IniRead, editmsgsleep2, %DIRSET%, BinderMSG, editmsgsleep2
    IniRead, editmsgsleep3, %DIRSET%, BinderMSG, editmsgsleep3
    IniRead, editmsg1, %DIRSET%, BinderMSG, editmsg1
    IniRead, editmsg2, %DIRSET%, BinderMSG, editmsg2
    IniRead, editmsg3, %DIRSET%, BinderMSG, editmsg3
    IniRead, editmsg4, %DIRSET%, BinderMSG, editmsg4
    IniRead, editmsg5, %DIRSET%, BinderMSG, editmsg5
    IniRead, hotkeymsg1, %DIRSET%, BinderMSG, hotkeymsg1
    IniRead, hotkeymsg2, %DIRSET%, BinderMSG, hotkeymsg2
    Iniread, youroff1, %DIRSET%, Polez, youroff1
    Iniread, youroff2, %DIRSET%, Polez, youroff2
    Iniread, yourcmd1, %DIRSET%, Polez, yourcmd1
    Iniread, yourcmd2, %DIRSET%, Polez, yourcmd2
    IniRead, punishgo, %DIRSET%, Punishment, punishgo
    {
        if bre=ERROR
        {
            bre=
        }
        if bscapt=ERROR
        {
            bscapt=
        }
        if pban=ERROR
        {
            pban=
        }
        if pcban=ERROR
        {
            pcban=
        }
        if breoff=ERROR
        {
            breoff=
        }
        if btpkn=ERROR
        {
            btpkn=
        }
        if btpks=ERROR
        {
            btpks=
        }
        if btp=ERROR
        {
            btp=
        }
        if bok=ERROR
        {
            bok=
        }
        if bpm=ERROR
        {
            bpm=
        }
        if btime=ERROR
        {
            btime=
        }
        if bia=ERROR
        {
            bia=
        }
        if recon=ERROR
        {
            recon=
        }
        if norecon=ERROR
        {
            norecon=
        }
        if yesrecon=ERROR
        {
            yesrecon=
        }
        if leader=ERROR
        {
            leader=
        }
        if armor=ERROR
        {
            armor=
        }
        if buyadm=ERROR
        {
            buyadm=
        }
        if rifa=ERROR
        {
            rifa=
        }
        if vip=ERROR
        {
            vip=
        }
        if gwdm=ERROR
        {
            gwdm=
        }
        if duel=ERROR
        {
            duel=
        }
        if lc=ERROR
        {
            lc=
        }
        if gg=ERROR
        {
            gg=
        }
        if acc=ERROR
        {
            acc=
        }
        if forum=ERROR
        {
            forum=
        }
        if flood=ERROR
        {
            flood=
        }
        if caps=ERROR
        {
            caps=
        }
        if pr=ERROR
        {
            pr=
        }
        if buy=ERROR
        {
            buy=
        }
        if offtoprep=ERROR
        {
            offtoprep=
        }
        if mat=ERROR
        {
            mat=
        }
        if osk=ERROR
        {
            osk=
        }
        if muterod=ERROR
        {
            muterod=
        }
        if offtopo=ERROR
        {
            offtopo=
        }
        if neadekvat=ERROR
        {
            neadekvat=
        }
        if oskadm=ERROR
        {
            oskadm=
        }
        if neyvaj=ERROR
        {
            neyvaj=
        }
        if kleveta=ERROR
        {
            kleveta=
        }
        if natsia=ERROR
        {
            natsia=
        }
        if movieadm=ERROR
        {
            movieadm=
        }
        if trolladm=ERROR
        {
            trolladm=
        }
        if db=ERROR
        {
            db=
        }
        if tk=ERROR
        {
            tk=
        }
        if spawn=ERROR
        {
            spawn=
        }
        if nickosk=ERROR
        {
            nickosk=
        }
        if capturekick=ERROR
        {
            capturekick=
        }
        if cheatkick=ERROR
        {
            cheatkick=
        }
        if cheatkpz=ERROR
        {
            cheatkpz=
        }
        if bagouse=ERROR
        {
            bagouse=
        }
        if capturekpz=ERROR
        {
            capturekpz=
        }
        if osknick=ERROR
        {
            osknick=
        }
        if falseadm=ERROR
        {
            falseadm=
        }
        if neadkvatv=ERROR
        {
            neadkvatv=
        }
        if prban=ERROR
        {
            prban=
        }
        if oskadmban=ERROR
        {
            oskadmban=
        }
        if oskrodban=ERROR
        {
            oskrodban=
        }
        if oskproject=ERROR
        {
            oskproject=
        }
        if cheatban=ERROR
        {
            cheatban=
        }
        if checheatban=ERROR
        {
            checheatban=
        }
        if Duty=ERROR
        {
            Duty=
        }
        if bduty=ERROR
        {
            bduty=
        }
        if aduty=ERROR
        {
            aduty=
        }
        if conoff=ERROR
        {
            conoff=
        }
        if timeban=ERROR
        {
            timeban=
        }
        if timejail=ERROR
        {
            timejail=
        }
        if timekick=ERROR
        {
            timekick=
        }
        if fon=ERROR
        {
            fon=
        }
        if timemute=ERROR
        {
            timemute=
        }
        if ccban=ERROR
        {
            ccban=
        }
        if infore=ERROR
        {
            infore=
        }
        if WH=ERROR
        {
            WH=
        }
        if WD=ERROR
        {
            WD=
        }
        if KPZre=ERROR
        {
            KPZre=
        }
        if cvre=ERROR
        {
            cvre=
        }
        if reoffre=ERROR
        {
            reoffre=
        }
        if remask=ERROR
        {
            remask=
        }
        if AnticheatSh=ERROR
        {
            AnticheatSh=
        }
        If Antishre=ERROR
        {
            Antishre=
        }
        if hotkey1=ERROR
        {
            hotkey1=
        }
        if hotkey2=ERROR
        {
            hotkey2=
        }
        if hotkey3=ERROR
        {
            hotkey3=
        }
        if hotkey4=ERROR
        {
            hotkey4=
        }
        if hotkey5=ERROR
        {
            hotkey5=
        }
        if hotkey6=ERROR
        {
            hotkey6=
        }
        if hotkey7=ERROR
        {
            hotkey7=
        }
        if hotkey8=ERROR
        {
            hotkey8=
        }
        if hotkey9=ERROR
        {
            hotkey9=
        }
        if hotkey10=ERROR
        {
            hotkey10=
        }
        if hotkey11=ERROR
        {
            hotkey11=
        }
        if hotkey12=ERROR
        {
            hotkey12=
        }
        if edit1=ERROR
        {
            edit1=
        }
        if edit2=ERROR
        {
            edit2=
        }
        if edit3=ERROR
        {
            edit3=
        }
        if edit4=ERROR
        {
            edit4=
        }
        if edit5=ERROR
        {
            edit5=
        }
        if edit6=ERROR
        {
            edit6=
        }
        if edit7=ERROR
        {
            edit7=
        }
        if edit8=ERROR
        {
            edit8=
        }
        if edit9=ERROR
        {
            edit9=
        }
        if edit10=ERROR
        {
            edit10=
        }
        if edit11=ERROR
        {
            edit11=
        }
        if edit12=ERROR
        {
            edit12=
        }
        if enter1=ERROR
        {
            enter1=
        }
        if enter2=ERROR
        {
            enter2=
        }
        if enter3=ERROR
        {
            enter3=
        }
        if enter4=ERROR
        {
            enter4=
        }
        if enter5=ERROR
        {
            enter5=
        }
        if enter6=ERROR
        {
            enter6=
        }
        if enter7=ERROR
        {
            enter7=
        }
        if enter8=ERROR
        {
            enter8=
        }
        if enter9=ERROR
        {
            enter9=
        }
        if enter10=ERROR
        {
            enter10=
        }
        if enter11=ERROR
        {
            enter11=
        }
        if enter12=ERROR
        {
            enter12=
        }
        if editmsgsleep1=ERROR
        {
            editmsgsleep1=
        }
        if editmsgsleep2=ERROR
        {
            editmsgsleep2=
        }
        if editmsgsleep3=ERROR
        {
            editmsgsleep3=
        }
        if editmsg1=ERROR
        {
            editmsg1=
        }
        if editmsg2=ERROR
        {
            editmsg2=
        }
        if editmsg3=ERROR
        {
            editmsg3=
        }
        if editmsg4=ERROR
        {
            editmsg4=
        }
        if editmsg5=ERROR
        {
            editmsg5=
        }
        if hotkeymsg1=ERROR
        {
            hotkeymsg1=
        }
        if hotkeymsg2=ERROR
        {
            hotkeymsg2=
        }
        if youroff1=ERROR
        {
            youroff1=
        }
        if youroff2=ERROR
        {
            youroff2=
        }
        if yourcmd1=ERROR
        {
            yourcmd1=
        }
        if yourcmd2=ERROR
        {
            yourcmd2=
        }
        if punishgo=ERROR
        {
            punishgo=
        }
        if bre !=
        {
            Hotkey, ~%bre%, bre1
        }
        if bscapt !=
        {
            Hotkey, ~%bscapt%, bscapt1
        }
        if pban !=
        {
            Hotkey, ~%pban%, pban1
        }
        if pcban !=
        {
            Hotkey, ~%pcban%, pcban1
        }
        if breoff !=
        {
            Hotkey, ~%breoff%, breoff1
        }
        if btpkn !=
        {
            Hotkey, ~%btpkn%, btpkn1
        }
        if btpks !=
        {
            Hotkey, ~%btpks%, btpks1
        }
        if btp !=
        {
            Hotkey, ~%btp%, btp1
        }
        if bok !=
        {
            Hotkey, ~%bok%, bok1
        }
        if bpm !=
        {
            Hotkey, ~%bpm%, bpm1
        }
        if btime !=
        {
            Hotkey, ~%btime%, btime1
        }
        if bia !=
        {
            Hotkey, ~%bia%, bia1
        }
        if recon !=
        {
            Hotkey, ~%recon%, Button1
        }
        if norecon !=
        {
            Hotkey, ~%norecon%, Button2
        }
        if yesrecon !=
        {
            Hotkey, ~%yesrecon%, Button3
        }
        if leader !=
        {
            Hotkey, ~%leader%, Button4
        }
        if armor !=
        {
            Hotkey, ~%armor%, Button5
        }
        if buyadm !=
        {
            Hotkey, ~%buyadm%, button6
        }
        if rifa !=
        {
            Hotkey, ~%rifa%, button7
        }
        if vip !=
        {
            Hotkey, ~%vip%, button8
        }
        if gwdm !=
        {
            Hotkey, ~%gwdm%, button9
        }
        if duel !=
        {
            Hotkey, ~%duel%, button10
        }
        if lc !=
        {
            Hotkey, ~%lc%, button11
        }
        if gg !=
        {
            Hotkey, ~%gg%, button12
        }
        if acc !=
        {
            Hotkey, ~%acc%, button13
        }
        if flood !=
        {
            Hotkey, ~%flood%, button14
        }
        if caps !=
        {
            Hotkey, ~%caps%, button15
        }
        if pr !=
        {
            Hotkey, ~%pr%, button16
        }
        if buy !=
        {
            Hotkey, ~%buy%, button17
        }
        if offtoprep !=
        {
            Hotkey, ~%offtoprep%, button18
        }
        if mat !=
        {
            Hotkey, ~%mat%, button19
        }
        if osk !=
        {
            Hotkey, ~%osk%, button20
        }
        if muterod !=
        {
            Hotkey, ~%muterod%, button21
        }
        if offtopo !=
        {
            Hotkey, ~%offtopo%, button22
        }
        if neadekvat !=
        {
            Hotkey, ~%neadekvat%, button23
        }
        if oskadm !=
        {
            Hotkey, ~%oskadm%, button24
        }
        if neyvaj !=
        {
            Hotkey, ~%neyvaj%, button25
        }
        if kleveta !=
        {
            Hotkey, ~%kleveta%, button26
        }
        if natsia !=
        {
            Hotkey, ~%natsia%, button27
        }
        if movieadm !=
        {
            Hotkey, ~%movieadm%, button28
        }
        if trolladm !=
        {
            Hotkey, ~%trolladm%, button29
        }
        if db !=
        {
            Hotkey, ~%db%, button30
        }
        if tk !=
        {
            Hotkey, ~%tk%, button31
        }
        if spawn !=
        {
            Hotkey, ~%spawn%, button32
        }
        if nickosk !=
        {
            Hotkey, ~%nickosk%, button33
        }
        if capturekick !=
        {
            Hotkey, ~%capturekick%, button34
        }
        if cheatkick !=
        {
            Hotkey, ~%cheatkick%, button35
        }
        if cheatkpz !=
        {
            Hotkey, ~%cheatkpz%, button36
        }
        if bagouse !=
        {
            Hotkey, ~%bagouse%, button37
        }
        if osknick !=
        {
            Hotkey, ~%osknick%, button38
        }
        if capturekpz !=
        {
            Hotkey, ~%capturekpz%, button39
        }
        if falseadm !=
        {
            Hotkey, ~%falseadm%, button40
        }
        if neadkvatv !=
        {
            Hotkey, ~%neadkvatv%, button41
        }
        if prban !=
        {
            Hotkey, ~%prban%, button42
        }
        if oskadmban !=
        {
            Hotkey, ~%oskadmban%, button43
        }
        if oskrodban !=
        {
            Hotkey, ~%oskrodban%, button44
        }
        if oskproject !=
        {
            Hotkey, ~%oskproject%, button45
        }
        if cheatban !=
        {
            Hotkey, ~%cheatban%, button46
        }
        if checheatban !=
        {
            Hotkey, ~%checheatban%, button49
        }
        if bduty !=
        {
            Hotkey, ~%bduty%, button47
        }
        if forum !=
        {
            Hotkey, ~%forum%, button48
        }
        if WH !=
        {
            Hotkey, ~%WH%, WallHackBut
        }
        if WD !=
        {
            Hotkey, ~%WD%, WaterDriveBut
        }
        if KPZre !=
        {
            Hotkey, ~%KPZre%, butkpzre
        }
        if Antishre !=
        {
            Hotkey, ~%Antishre%, antishrebut
        }
        if hotkey1 !=
        {
            Hotkey, ~%hotkey1%, binder1
        }
        if hotkey2 !=
        {
            Hotkey, ~%hotkey2%, binder2
        }
        if hotkey3 !=
        {
            Hotkey, ~%hotkey3%, binder3
        }
        if hotkey4 !=
        {
            Hotkey, ~%hotkey4%, binder4
        }
        if hotkey5 !=
        {
            Hotkey, ~%hotkey5%, binder5
        }
        if hotkey6 !=
        {
            Hotkey, ~%hotkey6%, binder6
        }
        if hotkey7 !=
        {
            Hotkey, ~%hotkey7%, binder7
        }
        if hotkey8 !=
        {
            Hotkey, ~%hotkey8%, binder8
        }
        if hotkey9 !=
        {
            Hotkey, ~%hotkey9%, binder9
        }
        if hotkey10 !=
        {
            Hotkey, ~%hotkey10%, binder10
        }
        if hotkey11 !=
        {
            Hotkey, ~%hotkey11%, binder11
        }
        if hotkey12 !=
        {
            Hotkey, ~%hotkey12%, binder12
        }
        if hotkeymsg1 !=
        {
            Hotkey, ~%hotkeymsg1%, bindermsg1
        }
        if hotkeymsg2 !=
        {
            Hotkey, ~%hotkeymsg2%, bindermsg2
        }
        if punishgo !=
        {
            Hotkey, ~%punishgo%, PunishButton
        }
    }
    return
}
F1::
gosub, X2Alert
return
bre1:
{
SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/re{space}
return
}
pban1:
SendMessage, 0x50,, 0x4190419,, A
SendInput,{F6}/ban  30 cheating // by {Left 19}
AddChatMessageEx("FFD700","A{FFFFFF} | Нажмите клавишу {cc0000}End{FFFFFF}, чтобы перевести курсор в конец.")
return
pcban1:
SendMessage, 0x50,, 0x4190419,, A
SendInput,{F6}/cban  30 cheating // by {Left 19}
AddChatMessageEx("FFD700","A{FFFFFF} | Нажмите клавишу {cc0000}End{FFFFFF}, чтобы перевести курсор в конец.")
return
bscapt1:
	AddChatMessageEX("FFFFFF","{FFD700}[A] {FFFFFF}| Вы действительно хотите остановить каптур?{FFFFFF} (press {008000}1 {FFFFFF}or{FFD700} 2 {FFFFFF}or{CC0000} 3 {FFFFFF})")
    sleep 300
    AddChatMessageEX("FFFFFF","{FFD700}[A] {FFFFFF}| {008000}1{FFFFFF} - нарушение правил капта || {FFD700} 2{FFFFFF} - баг капта || {CC0000} 3 {FFFFFF} - отмена выбора")
	time := A_TickCount 
	Loop 
	{ 
	if (GetKeyState("1", "P")) 
	{ 
	SendChat("/scapt нарушение правил каптура(кусок/обрез)")
	sleep 100
	SendMessage, 0x50,, 0x4190419,, A
	sleep 100
	SendInput,{F6}/jail  10 нарушение правил каптура(кусок/обрез){Left 41}
    ShowGameText("~g~MGW PROTECTOR", 2000, 4)
	break 
	} 
	else if (GetKeyState("2", "P")) 
	{ 
	SendChat("/scapt bug(/capture)")
	break 
	} 
	else if (GetKeyState("3", "P")) 
	{ 
	AddChatMessageEX("FFFFFF","{CC0000}{FFD700}[A] {FFFFFF}| Выбор отменён.")
    ShowGameText("~g~MGW PROTECTOR", 2000, 4)
	break 
	}
	if (A_TickCount - time > 3000) 
	{ 
	AddChatMessageEX("FFFFFF","{CC0000}{FFD700}[A] {FFFFFF}| Вы больше не можете выбрать действие.")
    ShowGameText("~g~MGW PROTECTOR", 2000, 4)
	return 
	} 
	} 
	return
breoff1:
{
SendChat("/reoff")
    return
}
btpkn1:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/tpkn{space}
    return
}
btpks1:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/tpks{space}
    return
}
btp1:
{
    SendMessage, 0x50,, 0x4190419,, A
    AddChatMessageEx("FFD700","[A] {FFFFFF} 1 - Groove || 2 - Ballas || 3 - Vagos || 4 - Aztec")
SendInput, {f6}/tp{space}
    return
}
bok1:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/ok{space}
    return
}
bpm1:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/pm{space}
    return
}
btime1:
{
SendChat("/time")
    return
}
bia1:
{
SendChat("/ia")
    return
}
Button1:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/pm  Начал работу по вашей жалобе, ожидайте.{LEFT 40}
    return
}
Button2:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/pm  Нарушений не обнаружено.{LEFT 25}
    return
}
Button3:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/pm  Данный игрок наказан.{LEFT 22}
    return
}
Button4:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/pm  Вы должны набрать больше киллов, чем у текущего лидера{LEFT 55}
    return
}
Button5:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/pm  Он выпадает с убитых на Gang War{LEFT 33}
    return
}
Button6:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/pm  Админ-права покупаются на monser.ru/buy{LEFT 40}
    return
}
Button7:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/pm  Rifa - банда в San-Fierro{LEFT 26}
    return
}
Button8:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/pm  /mm > 10 > 1 > 1{LEFT 17}
    return
}
Button9:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/pm  /gw | /dm{LEFT 10}
    return
}
Button10:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/pm  Договоритесь о одной из локации на /dm{LEFT 39}
    return
}
Button11:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/pm  Создается только с VIP, командой - /lc{LEFT 40}
    return
}
Button12:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/pm  Желаю Вам новогоднего настроения на Monser Gang War :3{LEFT 55}
    return
}
Button13:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/pm  Вы должны взять 88 территорий как лидер банды.{LEFT 47}
    return
}
Button14:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/mute  15 Flood{LEFT 9}
    return
}
Button15:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/mute  15 Caps Lock{LEFT 13}
    return
}
Button16:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/mute  120 Реклама{LEFT 12}
    return
}
Button17:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/mute  50 Торговля{LEFT 12}
    return
}
Button18:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/mute  10 Offtop в /report{LEFT 20}
    return
}
Button19:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/mute  20 Мат в /report{LEFT 17}
    return
}
Button20:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/mute  30 Оскорбление игроков{LEFT 23}
    return
}
Button21:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/mute  180 Упоминание/Оскорбление родных{LEFT 34}
    return
}
Button22:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/mute  50 Offtop в /o{LEFT 15}
    return
}
Button23:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}/mute  35 Неадекватное поведение{LEFT 26}
    return
}
Button24:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/mute  180 Оскорбление администрации{LEFT 30}
    return
}
Button25:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/mute  120 Неуважение к администрации{LEFT 31}
    return
}
Button26:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/mute  60 Клевета{LEFT 11}
    return
}
Button27:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/mute  120 Разжигание межнац. розни{LEFT 29}
    return
}
Button28:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/mute  150 Обсуждение действий администрации{LEFT 38}
    return
}
Button29:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/mute  120 Троллинг администрации{LEFT 27}
    return
}
Button30:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/kick  DriveBy{LEFT 8}
    return
}
Button31:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/kick  TeamKill{LEFT 9}
    return
}
Button32:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/kick  Помеха проходу/спавну{LEFT 22}
    return
}
Button33:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/skick  Оскорбление в нике{LEFT 19}
    return
}
Button34:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/kick  Неправильный /capture{LEFT 22}
    return
}
Button35:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/kick  Cheat{LEFT 6}
    return
}
Button36:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/jail  60 Cheat{LEFT 9}
    return
}
Button37:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/jail  20 Багоюз{LEFT 10}
    return
}
Button38:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/ban  30 Оскорбление в нике{LEFT 22}
    return
}
Button39:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/jail  10 Неправильный /capture{LEFT 25}
    return
}
Button40:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/ban  10 Обман администрации{LEFT 23}
    return
}
Button41:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/ban  2 Неадекватное поведение в /v{LEFT 30}
    return
}
Button42:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/cban  30 Реклама{LEFT 11}
    return
}
Button43:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/ban  30 Оскорбление администрации{LEFT 29}
    return
}
Button44:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/ban  30 Оскорбление родных{LEFT 22}
    return
}
Button45:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/cban  90 Оскорбление проекта{LEFT 23}
    return
}
Button46:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/ban  30 Cheat{LEFT 9}
    return
}
Button47:
{
    Sendchat("/Duty " Duty)
    return
}
Button48:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/pm  Жалобу на администратора можно написать на forum.monser.ru{LEFT 59}
    return
}
Button49:
{
    SendMessage, 0x50,, 0x4190419,, A
SendInput, {f6}/cban  30 Cheat{LEFT 9}
    return
}
WallHackBut:
{
    if whbuton != 1
    {
        whbuton := 1
        WallHack(tog := -1)
        PrintLow("~g~WallHack On", 2000)
    }
    else
    {
        whbuton := 0
        WallHack(tog := 0)
        PrintLow("~r~WallHack Off", 2000)
    }
}
return
WaterDriveBut:
{
    If wdbuton != 1
    {
        wdbuton := 1
        WaterDrive(1)
        PrintLow("~g~WaterDrive On", 2000)
    }
    Else
    {
        wdbuton := 0
        WaterDrive(0)
        PrintLow("~r~WaterDrive Off", 2000)
    }
}
return
antishrebut:
{
    Sendchat("/re " ipl)
    return
}
return
Binder1:
{
    if (isInChat() = 1)
    {
        return
    }
    if Enter1 = 1
    {
        SendChat(edit1)
        return
    }
    else
    {
        SendMessage, 0x50,, 0x4190419,, A
    SendInput {F6}%edit1%
        return
    }
    return
}
Binder2:
{
    if (isInChat() = 1)
    {
        return
    }
    if Enter2 = 1
    {
        SendChat(edit2)
        return
    }
    else
    {
        SendMessage, 0x50,, 0x4190419,, A
    SendInput {F6}%edit2%
        return
    }
    return
}
Binder3:
{
    if (isInChat() = 1)
    {
        return
    }
    if Enter3 = 1
    {
        SendChat(edit3)
        return
    }
    else
    {
        SendMessage, 0x50,, 0x4190419,, A
    SendInput {F6}%edit3%
        return
    }
    return
}
Binder4:
{
    if (isInChat() = 1)
    {
        return
    }
    if Enter4 = 1
    {
        SendChat(edit4)
        return
    }
    else
    {
        SendMessage, 0x50,, 0x4190419,, A
    SendInput {F6}%edit4%
        return
    }
    return
}
Binder5:
{
    if (isInChat() = 1)
    {
        return
    }
    if Enter5 = 1
    {
        SendChat(edit5)
        return
    }
    else
    {
        SendMessage, 0x50,, 0x4190419,, A
    SendInput {F6}%edit5%
        return
    }
    return
}
Binder6:
{
    if (isInChat() = 1)
    {
        return
    }
    if Enter6 = 1
    {
        SendChat(edit6)
        return
    }
    else
    {
        SendMessage, 0x50,, 0x4190419,, A
    SendInput {F6}%edit6%
        return
    }
    return
}
Binder7:
{
    if (isInChat() = 1)
    {
        return
    }
    if Enter7 = 1
    {
        SendChat(edit7)
        return
    }
    else
    {
        SendMessage, 0x50,, 0x4190419,, A
    SendInput {F6}%edit7%
        return
    }
    return
}
Binder8:
{
    if (isInChat() = 1)
    {
        return
    }
    if Enter8 = 1
    {
        SendChat(edit8)
        return
    }
    else
    {
        SendMessage, 0x50,, 0x4190419,, A
    SendInput {F6}%edit8%
        return
    }
    return
}
Binder9:
{
    if (isInChat() = 1)
    {
        return
    }
    if Enter9 = 1
    {
        SendChat(edit9)
        return
    }
    else
    {
        SendMessage, 0x50,, 0x4190419,, A
    SendInput {F6}%edit9%
        return
    }
    return
}
Binder10:
{
    if (isInChat() = 1)
    {
        return
    }
    if Enter10 = 1
    {
        SendChat(edit10)
        return
    }
    else
    {
        SendMessage, 0x50,, 0x4190419,, A
    SendInput {F6}%edit10%
        return
    }
    return
}
Binder11:
{
    if (isInChat() = 1)
    {
        return
    }
    if Enter11 = 1
    {
        SendChat(edit11)
        return
    }
    else
    {
        SendMessage, 0x50,, 0x4190419,, A
    SendInput {F6}%edit11%
        return
    }
    return
}
Binder12:
{
    if (isInChat() = 1)
    {
        return
    }
    if Enter12 = 1
    {
        SendChat(edit12)
        return
    }
    else
    {
        SendMessage, 0x50,, 0x4190419,, A
    SendInput {F6}%edit12%
        return
    }
    return
}
Bindermsg1:
{
    if (isInChat() = 1)
    {
        return
    }
    else
    {
        Sendchat("/msg " editmsg1)
        Sleep, editmsgsleep1
        Sendchat("/msg " editmsg2)
        return
    }
}
Bindermsg2:
{
    if (isInChat() = 1)
    {
        return
    }
    else
    {
        Sendchat("/msg " editmsg3)
        Sleep, editmsgsleep2
        Sendchat("/msg " editmsg4)
        Sleep, editmsgsleep3
        Sendchat("/msg " editmsg5)
        return
    }
}
SaveButton:
{
    Gui, Submit, NoHide
    IniWrite, %pban%, %DIRSET%, Options, pban
    IniWrite, %pcban%, %DIRSET%, Options, pcban
    IniWrite, %bscapt%, %DIRSET%, Options, bscapt
    IniWrite, %bre%, %DIRSET%, Options, bre
    IniWrite, %breoff%, %DIRSET%, Options, breoff
    IniWrite, %btpkn%, %DIRSET%, Options, btpkn
    IniWrite, %btpks%, %DIRSET%, Options, btpks
    IniWrite, %btp%, %DIRSET%, Options, btp
    IniWrite, %bok%, %DIRSET%, Options, bok
    IniWrite, %bpm%, %DIRSET%, Options, bpm
    IniWrite, %btime%, %DIRSET%, Options, btime
    IniWrite, %bia%, %DIRSET%, Options, bia
    IniWrite, %recon%, %DIRSET%, Options, recon
    IniWrite, %norecon%, %DIRSET%, Options, norecon
    IniWrite, %yesrecon%, %DIRSET%, Options, yesrecon
    IniWrite, %leader%, %DIRSET%, Options, leader
    IniWrite, %armor%, %DIRSET%, Options, armor
    IniWrite, %buyadm%, %DIRSET%, Options, buyadm
    IniWrite, %rifa%, %DIRSET%, Options, rifa
    IniWrite, %vip%, %DIRSET%, Options, vip
    IniWrite, %gwdm%, %DIRSET%, Options, gwdm
    IniWrite, %duel%, %DIRSET%, Options, duel
    IniWrite, %lc%, %DIRSET%, Options, lc
    IniWrite, %gg%, %DIRSET%, Options, gg
    IniWrite, %forum%, %DIRSET%, Options, forum
    IniWrite, %acc%, %DIRSET%, Options, acc
    IniWrite, %flood%, %DIRSET%, Options, flood
    IniWrite, %caps%, %DIRSET%, Options, caps
    IniWrite, %pr%, %DIRSET%, Options, pr
    IniWrite, %buy%, %DIRSET%, Options, buy
    IniWrite, %offtoprep%, %DIRSET%, Options, offtoprep
    IniWrite, %mat%, %DIRSET%, Options, mat
    IniWrite, %osk%, %DIRSET%, Options, osk
    IniWrite, %muterod%, %DIRSET%, Options, muterod
    IniWrite, %offtopo%, %DIRSET%, Options, offtopo
    IniWrite, %neadekvat%, %DIRSET%, Options, neadekvat
    IniWrite, %oskadm%, %DIRSET%, Options, oskadm
    IniWrite, %neyvaj%, %DIRSET%, Options, neyvaj
    IniWrite, %kleveta%, %DIRSET%, Options, kleveta
    IniWrite, %natsia%, %DIRSET%, Options, natsia
    IniWrite, %movieadm%, %DIRSET%, Options, movieadm
    IniWrite, %trolladm%, %DIRSET%, Options, trolladm
    IniWrite, %db%, %DIRSET%, Options, db
    IniWrite, %tk%, %DIRSET%, Options, tk
    IniWrite, %spawn%, %DIRSET%, Options, spawn
    IniWrite, %nickosk%, %DIRSET%, Options, nickosk
    IniWrite, %capturekick%, %DIRSET%, Options, capturekick
    IniWrite, %cheatkick%, %DIRSET%, Options, cheatkick
    IniWrite, %cheatkpz%, %DIRSET%, Options, cheatkpz
    IniWrite, %bagouse%, %DIRSET%, Options, bagouse
    IniWrite, %capturekpz%, %DIRSET%, Options, capturekpz
    IniWrite, %osknick%, %DIRSET%, Options, osknick
    IniWrite, %falseadm%, %DIRSET%, Options, falseadm
    IniWrite, %neadkvatv%, %DIRSET%, Options, neadkvatv
    IniWrite, %prban%, %DIRSET%, Options, prban
    IniWrite, %oskadmban%, %DIRSET%, Options, oskadmban
    IniWrite, %oskrodban%, %DIRSET%, Options, oskrodban
    IniWrite, %oskproject%, %DIRSET%, Options, oskproject
    IniWrite, %cheatban%, %DIRSET%, Options, cheatban
    IniWrite, %checheatban%, %DIRSET%, Options, checheatban
    IniWrite, %Duty%, %DIRSET%, Options, Duty
    IniWrite, %bduty%, %DIRSET%, Options, bduty
    IniWrite, %aduty%, %DIRSET%, Options, aduty
    IniWrite, %conoff%, %DIRSET%, Options, conoff
    IniWrite, %timeban%, %DIRSET%, Options, timeban
    IniWrite, %timejail%, %DIRSET%, Options, timejail
    IniWrite, %timekick%, %DIRSET%, Options, timekick
    IniWrite, %fon%, %DIRSET%, Options, fon
    IniWrite, %timemute%, %DIRSET%, Options, timemute
    IniWrite, %infore%, %DIRSET%, Options, infore
    IniWrite, %WH%, %DIRSET%, Options, WH
    IniWrite, %WD%, %DIRSET%, Options, WD
    IniWrite, %KPZre%, %DIRSET%, Options, KPZre
    IniWrite, %cvre%, %DIRSET%, Options, cvre
    IniWrite, %ccban%, %DIRSET%, Options, ccban
    IniWrite, %reoffre%, %DIRSET%, Options, reoffre
    IniWrite, %remask%, %DIRSET%, Options, remask
    IniWrite, %AnticheatSH%, %DIRSET%, Options, AnticheatSH
    IniWrite, %antishre%, %DIRSET%, Options, antishre
    IniWrite, %hotkey1%, %DIRSET%, Binder, hotkey1
    IniWrite, %hotkey2%, %DIRSET%, Binder, hotkey2
    IniWrite, %hotkey3%, %DIRSET%, Binder, hotkey3
    IniWrite, %hotkey4%, %DIRSET%, Binder, hotkey4
    IniWrite, %hotkey5%, %DIRSET%, Binder, hotkey5
    IniWrite, %hotkey6%, %DIRSET%, Binder, hotkey6
    IniWrite, %hotkey7%, %DIRSET%, Binder, hotkey7
    IniWrite, %hotkey8%, %DIRSET%, Binder, hotkey8
    IniWrite, %hotkey9%, %DIRSET%, Binder, hotkey9
    IniWrite, %hotkey10%, %DIRSET%, Binder, hotkey10
    IniWrite, %hotkey11%, %DIRSET%, Binder, hotkey11
    IniWrite, %hotkey12%, %DIRSET%, Binder, hotkey12
    IniWrite, %edit1%, %DIRSET%, Binder, edit1
    IniWrite, %edit2%, %DIRSET%, Binder, edit2
    IniWrite, %edit3%, %DIRSET%, Binder, edit3
    IniWrite, %edit4%, %DIRSET%, Binder, edit4
    IniWrite, %edit5%, %DIRSET%, Binder, edit5
    IniWrite, %edit6%, %DIRSET%, Binder, edit6
    IniWrite, %edit7%, %DIRSET%, Binder, edit7
    IniWrite, %edit8%, %DIRSET%, Binder, edit8
    IniWrite, %edit9%, %DIRSET%, Binder, edit9
    IniWrite, %edit10%, %DIRSET%, Binder, edit10
    IniWrite, %edit11%, %DIRSET%, Binder, edit11
    IniWrite, %edit12%, %DIRSET%, Binder, edit12
    IniWrite, %enter1%, %DIRSET%, Binder, enter1
    IniWrite, %enter2%, %DIRSET%, Binder, enter2
    IniWrite, %enter3%, %DIRSET%, Binder, enter3
    IniWrite, %enter4%, %DIRSET%, Binder, enter4
    IniWrite, %enter5%, %DIRSET%, Binder, enter5
    IniWrite, %enter6%, %DIRSET%, Binder, enter6
    IniWrite, %enter7%, %DIRSET%, Binder, enter7
    IniWrite, %enter8%, %DIRSET%, Binder, enter8
    IniWrite, %enter9%, %DIRSET%, Binder, enter9
    IniWrite, %enter10%, %DIRSET%, Binder, enter10
    IniWrite, %enter11%, %DIRSET%, Binder, enter11
    IniWrite, %enter12%, %DIRSET%, Binder, enter12
    IniWrite, %editmsgsleep1%, %DIRSET%, BinderMSG, editmsgsleep1
    IniWrite, %editmsgsleep2%, %DIRSET%, BinderMSG, editmsgsleep2
    IniWrite, %editmsgsleep3%, %DIRSET%, BinderMSG, editmsgsleep3
    IniWrite, %editmsg1%, %DIRSET%, BinderMSG, editmsg1
    IniWrite, %editmsg2%, %DIRSET%, BinderMSG, editmsg2
    IniWrite, %editmsg3%, %DIRSET%, BinderMSG, editmsg3
    IniWrite, %editmsg4%, %DIRSET%, BinderMSG, editmsg4
    IniWrite, %editmsg5%, %DIRSET%, BinderMSG, editmsg5
    IniWrite, %hotkeymsg1%, %DIRSET%, BinderMSG, hotkeymsg1
    IniWrite, %hotkeymsg2%, %DIRSET%, BinderMSG, hotkeymsg2
    IniWrite, %youroff1%, %DIRSET%, Polez, youroff1
    IniWrite, %youroff2%, %DIRSET%, Polez, youroff2
    IniWrite, %yourcmd1%, %DIRSET%, Polez, yourcmd1
    IniWrite, %yourcmd2%, %DIRSET%, Polez, yourcmd2
    IniWrite, %punishgo%, %DIRSET%, Punishment, punishgo
    Gosub, ReadSettings
    MsgBox, 64, AutoHotKey MGW, Сохранено!
    return
}
$~Enter::
sleep, 30
if (isInChat() = 0)
return
gosub, checkdialogmenu
sleep 150
dwAddress := dwSAMP + 0x12D8F8
chatInput := readString(hGTA, dwAddress, 512)
writeString(hGTA, dwAddress, "")

if (chatInput="/ah") || if (chatInput="/ah ")
{
showDialog("0","{FFD700}Список команд", "{FFD700}/ah {FFFFFF}- Показать список команд`n{FFD700}/tabl {FFFFFF}- Таблица наказазаний`n{FFD700}/cc {FFFFFF}- Копировать ник по ID`n{FFD700}/mp {FFFFFF}- Меню мероприятий`n{FFD700}/gomp {FFFFFF}- Создать МП`n{FFD700}/mpoff{FFFFFF} - Принудительно остановить авто-телепорт на МП`n{FFD700}/gg {FFFFFF}- Пожелать приятной игры`n{FFD700}/amsg {FFFFFF}- Меню отправки /msg`n{FFD700}/itp {FFFFFF}- Меню телепорта`n{FFD700}/tpall {FFFFFF}- Телепортировать всех игроков в зоне прорисовки`n{FFD700}/askin {FFFFFF}- Выдать всем игрокам в зоне прорисовки заданный скин`n{FFD700}/raskin {FFFFFF}- Выдать всем игрокам в зоне прорисовки рандомный скин`n{32CD32}/dlist {FFFFFF}- Посмотреть команды ""быстрой"" выдачи наказаний`n{32CD32}/alist {FFFFFF}- Посмотреть команды выдачи наказаний`n{32CD32}/request {FFFFFF}- Команды для ""быстрых"" просьб в /a чат`n{32CD32}/byinfo {FFFFFF}- Теги для /by`n{32CD32}/bug {FFFFFF}- Решение распространённых багов скрипта`n{FFD700}/clear {FFFFFF}- Очистить чат`n{FFD700}/cv {FFFFFF} - Изменить цвет ника игроку`n{FFD700}/wh {FFFFFF}- Включить WallHack`n{FFD700}/acmd {FFFFFF}- Посмотреть /ahelp по уровням в диалоговом окне`n{FFD700}/wd {FFFFFF}- Включить езду по воде`n{FFD700}/by {FFFFFF}- Выдать наказание по просьбе администратора`n{FFD700}/rsp {FFFFFF}- Следить за рандомным ID`n{FFD700}/sh{FFFFFF} - Включить/Выключить античит на SpeedHack`n{FFD700}/skin {FFFFFF}- Узнать ID скина по ID игрока`n{FF0000}/reloadahk {FFFFFF}- Перезапустить скрипт`n{FFD700}/nnick {FFFFFF}- Проверка на неадекватные ник-неймы", "Закрыть")
    return
}
if (chatInput="/infgun") || if (chatInput="/infgun ")
{
showDialog("0","{FFD700}Список оружий", "{FFD700}0id {FFFFFF}- Кулак`n{FFD700}1id {FFFFFF}- Кастет`n{FFD700}2id {FFFFFF}- Клюшка для гольфа`n{FFD700}3id {FFFFFF}- Полицейская дубинка`n{FFD700}4id {FFFFFF}- Нож`n{FFD700}5id{FFFFFF} - Бейсбольная бита`n{FFD700}6id {FFFFFF}- Лопата`n{FFD700}7id {FFFFFF}- Кий`n{FFD700}8id {FFFFFF}- Катана`n{FFD700}9id {FFFFFF}- Бензопила`n{FFD700}10id {FFFFFF}- Двухсторонний дилдо`n{FFD700}11id {FFFFFF}- Короткий вибратор`n{FFD700}12id {FFFFFF}- Длинный вибратор`n{FFD700}13id {FFFFFF}- Белый фаллоимитатор`n{FFD700}14id {FFFFFF}- Цветы`n{FFD700}15id {FFFFFF}- Трость`n{FFD700}16id {FFFFFF}- Граната`n{FFD700}17id {FFFFFF}- Слезоточивый газ`n{FFD700}18id {FFFFFF} - Коктейль Молотова`n{FFD700}22id {FFFFFF}- Пистолет 9мм`n{FFD700}23id {FFFFFF}- Пистолет с глушителем`n{FFD700}24id {FFFFFF}- Пистолет Пустынный орёл`n{FFD700}25id {FFFFFF}- Дробовик`n{FFD700}26id {FFFFFF}- Обрез`n{FFD700}27id{FFFFFF} - Скорострельный дробовик`n{FFD700}28id {FFFFFF}- Узи`n{FFD700}29id {FFFFFF}- МР5`n{FFD700}30id {FFFFFF}- Автомат Калашникова`n{FFD700}31id {FFFFFF}- Винтовка M4`n{FFD700}32id {FFFFFF}- Tec 9`n{FFD700}33id {FFFFFF}- Охотничье ружье`n{FFD700}34id {FFFFFF}- Снайперская винтовка`n{FFD700}35id {FFFFFF}- РПГ`n{FFD700}36id {FFFFFF}- Самонаводящиеся ракеты`n{FFD700}37id {FFFFFF}- Огнемет`n{FFD700}38id {FFFFFF}- Миниган`n{FFD700}39id {FFFFFF}- Сумка с тротилом`n{FFD700}40id {FFFFFF}- Детонатор`n{FFD700}41id {FFFFFF}- Баллончик с краской`n{FFD700}42id {FFFFFF}- Огнетушитель`n{FFD700}43id {FFFFFF}- Камера`n{FFD700}44id {FFFFFF}- Прибор ночного видения`n{FFD700}45id {FFFFFF}- Тепловизор`n{FFD700}46id {FFFFFF}- Парашют", "Закрыть")
    return
}
if (chatinput="/request") || if (chatinput="/request ")
{
showDialog(0, "{FFD700}Команды быстрых просьб в /a", "{FFD700}/cheat {FFFFFF}- Просьба в /a о бане игрока за читы`n{FFD700}/capt {FFFFFF}- Просьба в /a чат о неправильном /capture`n{FFD700}/kpz {FFFFFF}- Просьба в /a чат о джайле за читы`n{FFD700}/onick {FFFFFF}- Просьба в /a чат о бане за ник", "Закрыть")
    return
}
if (chatinput="/alist") || if (chatinput="/alist ")
{
showDialog("0","{FFD700}Команды выдачи наказаний", "{FFD700}/aban {FFFFFF}- Выдать бан`n{FFD700}/ajail {FFFFFF}- Выдать КПЗ`n{FFD700}/akick {FFFFFF}- Выдать кик`n{FFD700}/amute {FFFFFF}- Выдать мут", "Закрыть")
    return
}
if (chatInput="/tabl") || if (chatInput="/tabl ")
{
showDialog("0", "{FFD700}Таблица наказаний", "{32CD32}Выдача кика:`n{FFFFFF}Drive-By`nTeamkill`nSpawnKill`nПомеха проходу/спавну/каптуру`nОскорбление в нике`nНарушение правил каптура(кусок/обрез)`nЧит(когда нету старшей адм-ции)`n{32CD32}Выдача мута:`n{FFFFFF}Флуд - 5-20 минут`nКапс - 5-20 минут`nРозжиг - 60-180 минут`nРеклама любого ресурса - 60-180 минут`nТорговля - 40-60 минут`nОффтоп в репорт - 10-20 минут`nМат в репорт - 10-20 минут`nОбман администрации - 30-60 минут`nКлевета - 40-60 минут`nОскорбление проекта - 180 минут`nОскорбление игроков - 10-30 минут`nТроллинг администрации - 60-120 минут`nНеуважение к администрации - 60-120 минут`nОскорбление администрации - 180 минут`nОбсуждение действий Администрации - 120-180 минут`nКлевета на администратора - 60-120 минут`nУпоминание родных - 180 минут`nНеадекватное поведение (Капс, Флуд, Оск) 30 - 40 минут`nОффтоп в /o (Передача, обмен, покупка, продажа аккаунтов) 40-60 минут`nОбсуждение порнографии в любой чат - 120-180 минут`n{32CD32}Выдача КПЗ:`n{FFFFFF}Читы - 40-60 минут`nБагоюз - 10-20 минут`nКапт куском - 5-10 минут`nМногократное SK, Помеха проходу - 10 минут`n{32CD32}Выдача блокировки аккаунта:`n{FFFFFF}Оскорбление в нике - 20-30 дней (Командой {FF0000}/ban{FFFFFF})`nОбман администрации - 5-10 дней (Командой {FF0000}/ban{FFFFFF})`nНеадекватное поведение - 2-5 днeй (Только за флуд в /v) (Командой {FF0000}/ban{FFFFFF})`nРеклама любого ресурса - Бан на 30 дней (Командой {FF0000}/cban{FFFFFF})`nОскорбление администрации - 30 дней (Командой {FF0000}/ban{FFFFFF})`nОскорбление родных - 30 дней (Командой {FF0000}/ban{FFFFFF})`nОскорбление проекта - Бан на 90 дней (Командой {FF0000}/cban{FFFFFF})`nЧиты - Бан на 30 дней (C 3-го уровня командой {FF0000}/ban{FFFFFF},  с 4-го уровня командой {FF0000}/cban{FFFFFF})`n{32CD32}Выдача блокировки IP адреса:`n{FFFFFF}Неоднократное оскорбление в нике - 10 дней`nНеоднократное оскорбление родных - 10 дней`nНеоднократное оскорбление администрации - 10 дней`nОскорбление проекта - 90 дней", "Закрыть")
    return
}
If (chatInput="/bug") || If (chatInput="/bug ")
{
showDialog("0", "{FFD700}Баги скрипта", "{32CD32}Баг с Информацией о игроке при слежке, бане или /cv в /re`n{FFFFFF}- Пропишите {FFD700}/re рандомный ID{FFFFFF}, далее введите команду {FFD700}/reloadahk{FFFFFF},`nпосле перезапуска скрипта баг будет пофикшен!`n{32CD32}Баг с /rsp (Всегда следит за 0 ID)`n{FFFFFF}- Для решения данного бага нужно, чтобы скрипт собрал информацию о онлайне сервера,`n для этого просто нажмите {FFD700}TAB{FFFFFF}, баг пофикшен!`n{32CD32}Баг с /skin (Всегда пишет ""-1"")`n{FFFFFF}- Для решения данного бана нужно прописать {FFD700}/re{FFFFFF} за нужным ID и уже тогда прописать {FFD700}/skin{FFFFFF}", "Закрыть")
    return
}
if (chatInput="/tpc") || if (chatInput="/tpc ")
{
    SendChat("/aint")
    Sleep 10
    SendChat("/tp 1")
    Sleep 10
    SendChat("/tpc")
    Return
}
if (chatinput="/reloadahk") || if (chatinput="/reloadahk ")
{
AddChatMessageEx("FFFFFF", "{FF0000}[A] {FFFFFF}Сейчас произойдёт перезагрузка АХК, не трогайте клавиатуру..")
    sleep 1000
AddChatMessageEx("FFFFFF", "{FF0000}1..")d
    sleep 1000
AddChatMessageEx("FFFFFF", "{FF0000}2..")
    sleep 1000
AddChatMessageEx("FFFFFF", "{FF0000}3..")
    sleep 500
    Reload
}
If (chatinput="/rsp") || If (chatinput="/rsp ")
{
    if tab != 1
    {
    addchatmessageEx("FFFFFF", "{FFD700}[A]{FFFFFF} Нажмите {FFD700}TAB{FFFFFF} чтобы скрипт собрал информацию о онлайне")
        return
    }
    Random, randomrecon, 0, CountOnlinePlayers()
    {
        Sendchat("/re " randomrecon)
        return
    }
}
if (chatinput="/wh") || if (chatinput="/wh ")
{
    if whbuton != 1
    {
        whbuton := 1
        WallHack(tog := -1)
        PrintLow("~g~WallHack On", 2000)
    }
    else
    {
        whbuton := 0
        WallHack(tog := 0)
        PrintLow("~r~WallHack Off", 2000)
    }
}
if (chatinput="/wd") || if (chatinput="/wd ")
{
    if wdbuton != 1
    {
        wdbuton := 1
        WaterDrive(1)
        PrintLow("~g~WaterDrive On", 2000)
    }
    else
    {
        wdbuton := 0
        WaterDrive(0)
        PrintLow("~r~WaterDrive Off", 2000)
    }
}
if (chatinput="/dlist") || if (chatinput="/dlist ")
{
showDialog("0","{FFD700}Команды быстрой выдачи наказаний", "{FFD700}/ma {FFFFFF}- Выдать мут за упоминание/оскорбление родных`n{FFD700}/offrep {FFFFFF}- Выдать мут за offtop в /report`n{FFD700}/flood {FFFFFF}- Выдать мут за флуд`n{FFD700}/caps {FFFFFF}- выдать мут за CapsLock`n{FFD700}/pr {FFFFFF}- Выдать мут за рекламу`n{FFD700}/osk {FFFFFF}- Выдать мут за оскорбление игроков`n{FFD700}/offo {FFFFFF}- Выдать мут за offtop в /o`n{FFD700}/cenz {FFFFFF}- Выдать мут за мат в /report`n{FFD700}/troll {FFFFFF}- Выдать мут за троллинг администрации`n{FFD700}/admosk{FFFFFF} - Выдать мут за оскорбление администрации`n{FFD700}/indq {FFFFFF}- Выдать мут за неадекватное поведение`n{FFD700}/movadm {FFFFFF}- Выдать мут за обсуждение действий администрации`n{FFD700}/noise {FFFFFF}- Выдать кик за помеху", "Закрыть")
    return
}
If (chatinput="/nnick") || If (chatinput="/nnick ")
{
addchatmessageEx("FFFFFF", "{FFD700}[A]:{FFFFFF} Началась проверка на неадекватные никнеймы. Это займёт несколько секунд.")
AddchatmessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Советуем ничего не писать в чат!")
    sleep 2000
    sendchat("/id mq")
    sleep 500
    sendchat("/id mam")
    sleep 500
    sendchat("/id ebal")
    sleep 500
    sendchat("/id dayn")
    sleep 500
    sendchat("/id daun")
    sleep 500
    sendchat("/id admin")
    sleep 500
    sendchat("/id sosi")
    sleep 500
    sendchat("/id mat")
    sleep 500
    sendchat("/id loh")
    sleep 500
    sendchat("/id pidr")
    sleep 500
    sendchat("/id syka")
    sleep 2000
AddchatmessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Проверка окончена!")
    return
}
if chatInput contains /mute
{
    RegExMatch(chatInput, "/mute (.*) (.*) (.*)", mute)
    if (timemute=1)
    {
        if mute =
        {
            return
        }
        else
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    return
}
if chatInput contains /ban
{
    RegExMatch(chatInput, "/ban (.*) (.*) (.*)", ban)
    if (timeban=1)
    {
        if ban =
        {
            return
        }
        else
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    return
}
if chatInput contains /jail
{
    RegExMatch(chatInput, "/jail (.*) (.*) (.*)", jail)
    if (timejail=1)
    {
        if jail =
        {
            return
        }
        else
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    return
}
if chatInput contains /kick
{
    RegExMatch(chatInput, "/jail (.*) (.*)", kick)
    if (timekick=1)
    {
        if kick =
        {
            return
        }
        else
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    return
}
if chatInput contains /gmtest
{ 
RegExMatch(chatinput, "/gmtest ([0-9]+)", gmtest) 
if gmtest = 
{ 
addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /gmtest [ID игрока]") 
return 
} 
else 
{
loop 4
{
SendChat("/slap " gmtest1)
}
sleep 500
addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Если у игрока не отнялось hp, то скорее всего он использует GM от падений.") 
return 
} 
if(gmtest < 0) 
{ 
addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Неверно указан ID игрока") 
return 
} 
return 
}
if chatInput contains /cv
{
    RegExMatch(chatinput, "/cv ([0-9]+)", cv)
    if cv1 =
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /cv [ID игрока]")
        return
    }
    else
    {
        setPlayerColor(cv1, 0xFF33AA4)
        return
    }
    if(cv1 < 0)
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Неверно указан ID игрока")
        return
    }
    return
}
if (chatinput="/skin") || if (chatinput="/skin ")
{
addchatmessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /skin [ID игрока]")
    return
}
if (chatinput="/byinfo") || if (chatinput="/byinfo ")
{
showdialog("0", "{FFD700}Теги для /by", "{FFD700}Cheat {FFFFFF}- Бан за читы`n{FFD700}Rod {FFFFFF}- Бан за оск. родных`n{FFD700}PR {FFFFFF}- Бан за рекламу`n{FFD700}Adm {FFFFFF}- Бан за оск. администрации`n{FFD700}Nick {FFFFFF}- Бан за никнейм", "Закрыть")
    return
}
If (Chatinput="/by") || If (Chatinput="/by ")
{
addchatmessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /by [ID игрока] [Тег] [Фамилия/Имя администратора]")
    return
}
if chatinput contains /by
{
    if (RegExMatch(Chatinput, "/by (.*) (.*) (.*)", bby))
    {
        if bby2 = cheat
        {
            sendchat("/cban " bby1 " 30 Cheat // " bby3)
            return
        }
        if bby2 = rod
        {
            sendchat("/ban " bby1 " 30 Оскорбление родных // " bby3)
            return
        }
        if bby2 = pr
        {
            sendchat("/cban " bby1 " 30 Реклама // " bby3)
            return
        }
        if bby2= adm
        {
            sendchat("/ban " bby1 " 30 Оскорбление администрации // " bby3)
            return
        }
        if bby2= nick
        {
            sendchat("/ban " bby1 " 30 Nickname // " bby3)
            return
        }
        else
        {
        addchatmessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /by [ID игрока] [Тег] [Инициалы администратора]")
            return
        }
    }
    return
}
if (chatinput="/temp") || if (chatinput="/temp ")
{
listrtextfordialog("%A_MyDocuments%\GTA San Andreas User Files\AutoHotKey MGW\Выдача наказаний по просьбе мл.адм","{FFD700}Temp List","0")
}
if (chatInput="/offtemp") || if (chatInput="/offtemp ")
{
AddChatMessageEx("FFFFFF","{FFD700}[A]{FFFFFF} Используйте: {FFD700}/offtemp [Ник игрока] [Комментарий]")
}
if (chatInput="/addtemp") || if (chatInput="/addtemp ")
{
AddChatMessageEx("FFFFFF","{FFD700}[A]{FFFFFF} Используйте:{FFD700} /addtemp [ID игрока] [Комментарий]")
}
if chatInput contains /offtemp
{
    if RegExMatch(chatInput, "/offtemp (.*) (.*)", offan)
    {
        FileAppend, %A_DD%.%A_MM%.%A_Year% | %offan1%.  Комментарий: , %A_MyDocuments%\GTA San Andreas User Files\AutoHotKey MGW\Выдача наказаний по просьбе мл.адм.txt
        FileAppend, % offan2 "`n", %A_MyDocuments%\GTA San Andreas User Files\AutoHotKey MGW\Выдача наказаний по просьбе мл.адм.txt
    AddChatMessageEx("FFFFFF","{FFD700}[A]{FFFFFF} Игрок {FFD700}" offan1 " {FFFFFF}успешно добавлен в список. Комментарий:{FFD700} " offan2)
    }
}
if chatInput contains /addtemp
{
    if RegExMatch(chatInput, "/addtemp (.*) (.*)", ant)
    {
        name := RegExReplace(getPlayerNameById(ant1), "^(\[DM\]|\[GW\]|\[TR\]|\[LC\])*")
        FileAppend, %A_DD%.%A_MM%.%A_Year% | %name%.  Комментарий: , %A_MyDocuments%\GTA San Andreas User Files\AutoHotKey MGW\Выдача наказаний по просьбе мл.адм.txt
        FileAppend, % ant2 "`n", %A_MyDocuments%\GTA San Andreas User Files\AutoHotKey MGW\Выдача наказаний по просьбе мл.адм.txt
    AddChatMessageEx("FFFFFF", "{FFD700}[A]{FFFFFF} Игрок {FFD700}" name " {FFFFFF}успешно добавлен в список. Комментарий:{FFD700} " ant2)
    }
}
if (chatInput="/deltemp") || if (chatInput="/deltemp ")
{
    FileDelete, %A_MyDocuments%\GTA San Andreas User Files\AutoHotKey MGW\Выдача наказаний по просьбе мл.адм.txt
AddChatMessageEx("FFFFFF","{FFD700}[A]{FFFFFF} Cписок успешно очищен.")
}
listrtextfordialog(files,pages,dialogstyle) {
    listrtext := []
    Loop, Read, %A_MyDocuments%\GTA San Andreas User Files\AutoHotKey MGW\Выдача наказаний по просьбе мл.адм.txt
    {
        listrtext.Insert(A_LoopReadLine)
        textout .= listrtext[A_Index] "`n"
    }
    Sleep 400
    showDialog(dialogstyle,pages, textout , "Enter")
    phelptext := ""
    return
}
firstlinetofiles(files) {
    openfiles := []
    Loop, Read, %A_MyDocuments%\GTA San Andreas User Files\AutoHotKey MGW\Выдача наказаний по просьбе мл.адм.txt
    {
        openfiles.Insert(A_LoopReadLine)
    }
    firstline := openfiles[1]
    return firstline
}
if chatinput contains /skin
{
    if (RegExMatch(Chatinput, "/skin (.*)", skinpl))
    {
        if (skinpl1<0) || if (skinpl1>299)
        {
        addchatmessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /skin [ID игрока]")
            return
        }
        else
        {
        addchatmessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}ID скина:{FFD700} " getTargetPlayerSkinIdById(skinpl1) )
            return
        }
        return
    }
}
if chatinput contains /tpint
{
    If (RegExMatch(Chatinput, "/tpint (.*)", inter))
    {
        if (inter1<1) || if (inter1>135)
        {
            return
        }
        else
        {
        addchatmessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Вы телепортировались в интерьер под номером {FFD700}" inter1)
            return
        }
    }
}
if chatInput contains /acmd
{
    if (RegExMatch(chatInput, "/acmd (.*)", ahelp))
    {
        if (ahelp1=1)
    showDialog("0","{FFD700}Команды 1-го уровня", "{FFD700}/a {FFFFFF}- админ-чат`n{FFD700}/pm {FFFFFF}- ответ игроку`n{FFD700}/re {FFFFFF}- начать наблюдение`n{FFD700}/reoff {FFFFFF}- закончить наблюдение`n{FFD700}/mute {FFFFFF}- выдать затычку`n{FFD700}/unmute {FFFFFF}- снять затычку`n{FFD700}/kick {FFFFFF}- кикнуть игрока`n{FFD700}/slap {FFFFFF}- дать пинок`n{FFD700}/ta {FFFFFF}- информация о выстрелах`n{FFD700}/admins {FFFFFF}- список администрации онлайн`n{FFD700}/ia {FFFFFF}- информация администратора`n{FFD700}/aint {FFFFFF}- телепортироваться в админ-интерьер`n{FFD700}/duty {FFFFFF}- заступить на дежурство`n{FFD700}/flycam {FFFFFF}- свободный полёт`n{FFD700}/conon {FFFFFF}- включить информацию о подключениях`n{FFD700}/conoff {FFFFFF}- выключить информацию о подключениях", "Закрыть")
    }
    if (ahelp1=2)
    {
    showDialog("0","{FFD700}Команды 2-го уровня", "{FFD700}/msg {FFFFFF}- общий чат`n{FFD700}/jail {FFFFFF}- посадить в КПЗ`n{FFD700}/unjail {FFFFFF}- высвободить из КПЗ`n{FFD700}/skick {FFFFFF}- тихо кикнуть`n{FFD700}/tpkn {FFFFFF}- телепортироваться к игроку`n{FFD700}/rr {FFFFFF}- рестарт чата`n{FFD700}/tp {FFFFFF}- телепортироваться к спавну банды`n{FFD700}/ok {FFFFFF}- подтвердить смену ника`n{FFD700}/sc {FFFFFF}- зареспавнить все машины`n{FFD700}/scapt {FFFFFF}- остановить захват территорий`n{FFD700}/amembers {FFFFFF}- посмотреть онлайн банды`n{FFD700}/af {FFFFFF}- написать в чат банды`n{FFD700}/fon {FFFFFF}- включить прослушку чата банд`n{FFD700}/foff {FFFFFF}- выключить прослушку чата банд", "Закрыть")
    }
    if (ahelp1=3)
    {
    showDialog("0","{FFD700}Команды 3-го уровня", "{FFD700}/ban {FFFFFF}- забанить игрока`n{FFD700}/unban {FFFFFF}- разбанить игрока`n{FFD700}/offban {FFFFFF}- забанить игрока оффлайн`n{FFD700}/offjail {FFFFFF}- посадить в КПЗ оффлайн`n{FFD700}/offunjail {FFFFFF}- высвободить из КПЗ оффлайн`n{FFD700}/offmute {FFFFFF}- выдать затычку оффлайн`n{FFD700}/offunmute {FFFFFF}- снять затычку оффлайн`n{FFD700}/getstats {FFFFFF}- просмотреть статистику игрока`n{FFD700}/offgetstats {FFFFFF}- посмотреть оффлайн статистику игрока`n{FFD700}/infban {FFFFFF}- информация о бане`n{FFD700}/infmute {FFFFFF}- информация о муте`n{FFD700}/infjail {FFFFFF}- информация о КПЗ`n{FFD700}/tpks {FFFFFF}- телепортировать игрока к себе`n{FFD700}/lname {FFFFFF}- история ников игрока", "Закрыть")
    }
    if (ahelp1=4)
    {
    showDialog("0","{FFD700}Команды 4-го уровня", "{FFD700}/sban {FFFFFF}- тихий бан`n{FFD700}/banip {FFFFFF}- бан IP-адреса`n{FFD700}/unbanip {FFFFFF}- разбан IP-адреса`n{FFD700}/cban {FFFFFF}- бан IP-адреса и аккаунта`n{FFD700}/offcban {FFFFFF}- бан IP-адреса и аккаунта оффлайн`n{FFD700}/infip {FFFFFF}- информация о бане IP-адреса`n{FFD700}/open {FFFFFF}- отключение запрета на выход за территории`n{FFD700}/close {FFFFFF}- включение запрета на выход из территории`n{FFD700}/giveskin {FFFFFF}- выдать временный скин игроку`n{FFD700}/uncban {FFFFFF}- разбанить аккаунт и IP-адрес`n{FFD700}/sethp {FFFFFF}- установить HP игроку`n{FFD700}/resgun {FFFFFF}- забрать оружие у игрока`n{FFD700}/aveh {FFFFFF}- заспавнить транспорт`n{FFD700}/dellcar {FFFFFF}- удалить авто`n{FFD700}/dellcars {FFFFFF}- удалить ВСЕ заспавненые авто`n{FFD700}/tpint {FFFFFF}- телепортироваться в интерьер", "Закрыть")
    }
    if (ahelp1=5)
    {
    showDialog("0","{FFD700}Команды 5-го уровня", "{FFD700}/scban {FFFFFF}- тихий бан аккаунта и IP-адреса`n{FFD700}/smson {FFFFFF}- включить прослушку SMS`n{FFD700}/smsoff {FFFFFF}- выключить прослушку SMS`n{FFD700}/von {FFFFFF}- включить прослушку VIP чата`n{FFD700}/vof {FFFFFF}- выключить прослушку VIP чата`n{FFD700}/obj {FFFFFF}- выдать объект`n{FFD700}/changegz {FFFFFF}- перекраска территории гетто`n{FFD700}/givegun {FFFFFF}- выдать оружие`n{FFD700}/allresgun {FFFFFF}- забрать оружие по радиусу`n{FFD700}/allhp {FFFFFF}- выдать HP по радиусу`n{FFD700}/givebron {FFFFFF}- выдать бронежилет", "Закрыть")
    }
    if (ahelp1<1) || if (ahelp1>5)
    {
    AddchatmessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Используйте:`n{FFD700}/acmd 1 | 2 | 3 | 4 | 5")
    }
}
if (chatinput="/mp") || if (chatinput="/mp ")
{
    gosub, mpm
}
if (chatinput="/itp") || if (chatinput="/itp ")
{
    gosub, itp
}
if (chatinput="/amsg") || if (chatinput="/amsg ")
{
    gosub, amsg
}
if (chatinput="/amute") || if (chatinput="/amute ")
{
addchatmessageEx("FFFFFF", "{FFD700}[A]{FFFFFF} Используйте: {FFD700}/amute [ID Игрока]")
    return
}
if (chatinput="/akick") || if (chatinput="/akick ")
{
addchatmessageEx("FFFFFF", "{FFD700}[A]{FFFFFF} Используйте: {FFD700}/akick [ID Игрока]")
    return
}
if (chatinput="/ajail") || if (chatinput="/ajail ")
{
addchatmessageEx("FFFFFF", "{FFD700}[A]{FFFFFF} Используйте: {FFD700}/ajail [ID Игрока]")
    return
}
if (chatinput="/aban") || if (chatinput="/aban ")
{
addchatmessageEx("FFFFFF", "{FFD700}[A]{FFFFFF} Используйте: {FFD700}/aban [ID Игрока]")
    return
}
If (chatinput="/re") || If (chatinput="/re ")
{
    if reoffre = 1
    {
        sendchat("/reoff")
        return
    }
    else
    {
        return
    }
return
}
If (chatinput="/reoff") || If (chatinput="/reoff ")
    {
    if remask = 1
    {
        sendchat("/unmask")
        sleep 300
        sendchat("/mask")
        return
    }
    else
    {
        return
    }
return
}
if (chatInput="/gg")
{
    if A_TickCount 
    Random, rand, 1, 5
    if rand=1
    {
        SendChat("/msg Форма подачи жалобы в репорт: /report [ID нарушителя] [Жалоба(предполагаемый чит)]")
        sleep 3000
        SendChat("/msg Администрация Monser Gang War желает Вам новогоднего настроения :3")
    }
    if rand=2
    {
        Sendchat("/msg Есть вопросы по игровому моду? Жалоба на игрока? Пишите в /report")
    }
    if rand=3
    {
        sendchat("/msg Репорт предназначен не для высказывания/выражения своих эмоций")
        Sleep, 3000
        sendchat("/msg В репорт задают вопросы по игровому моду, а так же жалуются на игроков")
        Sleep, 3000
        sendchat("/msg За оффтоп в репорт - Вы будете наказаны.")
    }
    if rand=4
    {
        Sendchat("/msg Вы всегда можете оставить жалобу на игрока/администратора..")
        Sleep, 3000
        Sendchat("/msg ..на нашем форуме - forum.monser.ru")
        Sleep, 3000
        SendChat("/msg Администрация желает Вам приятной игры и новогоднего настроения :3")
    }
    if rand=5
    {
        Sendchat("/msg Приобрести админку в режиме online Вы можете на сайте www.monser.ru")
    }
    return
}
if chatInput contains /cc
{
    RegExMatch(chatInput, "/cc ([0-9]+)", id)
    if (RegExMatch(chatInput, "/cc$") || RegExMatch(chatInput, "/cc $"))
AddChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы не указали ID")
    Else
    {
        gNick := getPlayerNameById(id1)
        if(strlen(gNick) < 1)
        {
        addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Игрок не найден")
            return
        }
        gNick := RegExReplace(getPlayerNameById(id1), "^(\[DM\]|\[GW\]|\[TR\]|\[LC\])*")
        ClipPutText(gNick)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Никнейм {FFD700}" gNick "{FFFFFF} скопирован.")
        return
    }
}
if (chatInput="/sh")
{
    if acstatus != 1
    {
        SetTimer, anticheat, 1000
        PrintLow("~g~Anticheat On", 2000)
        acstatus := 1
    }
    else
    {
        SetTimer, anticheat, off
        PrintLow("~r~Anticheat Off", 2000)
        acstatus := 0
    }
}
if (chatinput="/tpall")
{
    showGameText("~y~Teleport:~n~~g~checking...", 1000, 4)
    Sleep 250
    Players := []
    dout := ""
    Players := getStreamedInPlayersInfo()
    p := 0
    For i, o in Players
    {
        l := []
        l := getPedCoordinates(o.PED)
        p++
        pos := getCoordinates()
        Name := getPlayerNameById(i)
        Dist := getDist(getCoordinates() ,l)
        idskin := getTargetPlayerSkinIdById(i)
        inveh := isTargetInAnyVehicleById(i)
        pcolor := getPlayerColor(i)
        cts := colorToStr(pcolor)
    if (cts=="{9a400}")
        {
        StringReplace, cts, cts, {9a400}, {098A00}, All
        }
    else if (cts=="{dedff}")
        {
        StringReplace, cts, cts, {dedff}, {00FFFE}, All
        }
        if (inveh=="1")
        {
        inv := " {A9C4E4}| " cts "В Т/С{A9C4E4}[" cts "" getTargetVehicleModelNameById(i) "{A9C4E4}]"
        }
        else
        {
            inv := ""
        }
        if (idskin=="41" or idskin=="114" or idskin=="115" or idskin=="116" or idskin=="119" or idskin=="292")
        {
            SendChat("/tpks " i "`n")
        }
        else if (idskin=="102" or idskin=="103" or idskin=="104" or idskin=="195" or idskin=="297")
        {
            SendChat("/tpks " i "`n")
        }
        else if (idskin=="105" or idskin=="106" or idskin=="107" or idskin=="269" or idskin=="270" or idskin=="271" or idskin=="86" or idskin=="271" or idskin=="56" or idskin=="293")
        {
            SendChat("/tpks " i "`n")
        }
        else
        {
            SendChat("/tpks " i "`n")
        }
    }
    if (p=="0")
    {
        showGameText("~y~Teleport: ~n~~r~no players", 1000, 4)
    addChatMessageEx("FFD700", "{FFD700}[A]{FFFFFF}В зоне прорисовки нет игроков")
    }
}
if chatInput contains /gomp
{
    RegExMatch(chatInput, "/gomp (\d+) (.*) (\d+) (.*)?", mp)
    If (mp3<0)
    {
    AddChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Используйте:`n{FFD700}/gomp [Ваш ID] [Название МП] [Кол-во участников] [Кол-во доната]")
    AddChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Донат указывать не обязательно!")
    }
    Else
    {
        vkl := 1
        SendChat("/msg Уважаемые игроки сейчас пройдет МП: """ mp2 """")
        Sleep 3000
        SendChat("/msg После того как телепортировали - строй у стены.")
        Sleep 3000
        SendChat("/msg Максимальное количество участников: " mp3)
        if mp4=
        {
        }
        else
        {
            sleep 3000
            SendChat("/msg Фонд мероприятия составляет: " mp4 " доната")
        }
        Sleep 3000
        SendChat("/msg Кого телепортировать на мероприятие /sms " mp1 " +")
        sleep 1000
    AddChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Дождитесь пока наберётся нужное кол-во участников {FFD700}(" mp3 ")")
    AddChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Либо же остановите авто-телепорт принудительно - /mpoff")
        i := 0
        Filename=%A_MyDocuments%\GTA San Andreas User Files\SAMP\chatlog.txt
        Loop, read, %Filename%
        nstroki=%A_Index%
        starta:
        if vkl=0
        return
        FileReadLine, stroka, %Filename%, %nstroki%
        if ErrorLevel
        {
            nstroki-=1
            goto starta
        }
        if stroka=
        {
            nstroki+=1
            goto starta
        }
        IfInString, stroka, SMS от
        {
            if (InStr(stroka, "+"))
            {
                RegExMatch(stroka,  ".*\[ID:\E(.*)\].", idigroka)
                SendChat("/resgun " idigroka1)
                Sleep 1
                SendChat("/tpks " idigroka1)
                Sleep 1
                nstroki+=1
                i := i+1
                if (i=mp3)
                {
                    SendChat("/msg Набрано максимальное количество участников. Телепорт окончен.")
                    vkl := 0
                }
                Else
                goto starta
            }
        }
        nstroki+=1
        goto starta
        return
    }
    :?:/mpoff::
    {
        if vkl=1
        {
            vkl := 0
        AddChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Функция авто-телепорта принудительно остановлена.")
        }
        return
    }
}
if RegExMatch(chatInput, "^\/askin")
{
    if(RegExMatch(chatInput, "^\/askin([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/askin$") || RegExMatch(chatInput, "^\/askin $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /askin [ID скина]")
        return
    }
    RegExMatch(chatInput, "^\/askin ([\dA-Za-z_\[\]]+)", t)
    id := t1
    showGameText("~y~AutoSkin:~n~~g~checking...", 1000, 4)
    Sleep 250
    Players := []
    dout := ""
    Players := getStreamedInPlayersInfo()
    p := 0
    For i, o in Players
    {
        l := []
        l := getPedCoordinates(o.PED)
        p++
        pos := getCoordinates()
        Name := getPlayerNameById(i)
        Dist := getDist(getCoordinates() ,l)
        idskin := getTargetPlayerSkinIdById(i)
        inveh := isTargetInAnyVehicleById(i)
        pcolor := getPlayerColor(i)
        cts := colorToStr(pcolor)
    if (cts=="{9a400}")
        {
        StringReplace, cts, cts, {9a400}, {098A00}, All
        }
    else if (cts=="{dedff}")
        {
        StringReplace, cts, cts, {dedff}, {00FFFE}, All
        }
        if (inveh=="1")
        {
        inv := " {A9C4E4}| " cts "В Т/С{A9C4E4}[" cts "" getTargetVehicleModelNameById(i) "{A9C4E4}]"
        }
        else
        {
            inv := ""
        }
        if (idskin=="41" or idskin=="114" or idskin=="115" or idskin=="116" or idskin=="119" or idskin=="292")
        {
            SendChat("/setskin " i " " id "`n")
        }
        else if (idskin=="102" or idskin=="103" or idskin=="104" or idskin=="195" or idskin=="297")
        {
            SendChat("/setskin " i " " id "`n")
        }
        else if (idskin=="105" or idskin=="106" or idskin=="107" or idskin=="269" or idskin=="270" or idskin=="271" or idskin=="86" or idskin=="271" or idskin=="56" or idskin=="293")
        {
            SendChat("/setskin " i " " id "`n")
        }
        else
        {
            SendChat("/setskin " i " " id "`n")
        }
    }
    if (p=="0")
    {
        showGameText("~y~AutoSkin: ~n~~r~no players", 1000, 4)
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Нет игроков в зоне прорисовки")
    }
    if(id < 0)
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Неверно указан ID скина")
        return
    }
}
if (chatinput="/raskin")
{
    Random, rsk, 1, 311
    {
        id := rsk
        showGameText("~y~AutoSkin:~n~~g~checking...", 1000, 4)
        Sleep 250
        Players := []
        dout := ""
        Players := getStreamedInPlayersInfo()
        p := 0
        For i, o in Players
        {
            l := []
            l := getPedCoordinates(o.PED)
            p++
            pos := getCoordinates()
            Name := getPlayerNameById(i)
            Dist := getDist(getCoordinates() ,l)
            idskin := getTargetPlayerSkinIdById(i)
            inveh := isTargetInAnyVehicleById(i)
            pcolor := getPlayerColor(i)
            cts := colorToStr(pcolor)
        if (cts=="{9a400}")
            {
            StringReplace, cts, cts, {9a400}, {098A00}, All
            }
        else if (cts=="{dedff}")
            {
            StringReplace, cts, cts, {dedff}, {00FFFE}, All
            }
            if (inveh=="1")
            {
            inv := " {A9C4E4}| " cts "В Т/С{A9C4E4}[" cts "" getTargetVehicleModelNameById(i) "{A9C4E4}]"
            }
            else
            {
                inv := ""
            }
            if (idskin=="41" or idskin=="114" or idskin=="115" or idskin=="116" or idskin=="119" or idskin=="292")
            {
                SendChat("/setskin " i " " id "`n")
            }
            else if (idskin=="102" or idskin=="103" or idskin=="104" or idskin=="195" or idskin=="297")
            {
                SendChat("/setskin " i " " id "`n")
            }
            else if (idskin=="105" or idskin=="106" or idskin=="107" or idskin=="269" or idskin=="270" or idskin=="271" or idskin=="86" or idskin=="271" or idskin=="56" or idskin=="293")
            {
                SendChat("/setskin " i " " id "`n")
            }
            else
            {
                SendChat("/setskin " i " " id "`n")
            }
        }
        if (p=="0")
        {
            showGameText("~y~AutoSkin: ~n~~r~no players", 1000, 4)
        addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Нет игроков в зоне прорисовки")
        }
        if(id < 0)
        {
        addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Неверно указан ID скина")
            return
        }
    }
}
if RegExMatch(chatInput, "^\/clear")
{
    loop 20
    addChatMessageEx("FFFFFF", "|")
    return
}
if(RegExMatch(chatInput, "^\/ma"))
{
    if(RegExMatch(chatInput, "^\/ma([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/ma$") || RegExMatch(chatInput, "^\/ma $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /ma [ID игрока]")
        return
    }
    RegExMatch(chatInput, "^\/ma ([\dA-Za-z_\[\]]+)", t)
    id := t1
    updateOScoreboardData()
    gNick := getPlayerNameById(id)
    gNick := RegExReplace(getPlayerNameById(id), "^(\[DM\]|\[GW\]|\[TR\])*")
    SendChat("/mute " id " 180 Упоминание/Оскорбление родных")
    if (timemute=1)
    {
        sendchat("/time")
        sleep 500
    SendInput, {F8}
    }
    if(strlen(gNick) < 1)
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Игрок не найден")
        return
    }
}
if(RegExMatch(chatInput, "^\/offrep"))
{
    if(RegExMatch(chatInput, "^\/offrep([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/offrep$") || RegExMatch(chatInput, "^\/offrep $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /offrep [ID игрока]")
        return
    }
    RegExMatch(chatInput, "^\/offrep ([\dA-Za-z_\[\]]+)", t)
    id := t1
    updateOScoreboardData()
    gNick := getPlayerNameById(id)
    gNick := RegExReplace(getPlayerNameById(id), "^(\[DM\]|\[GW\]|\[TR\])*")
    SendChat("/mute " id " 10 Offtop в /report")
    if (timemute=1)
    {
        sendchat("/time")
        sleep 500
    SendInput, {F8}
    }
    if(strlen(gNick) < 1)
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Игрок не найден")
        return
    }
}
if(RegExMatch(chatInput, "^\/flood"))
{
    if(RegExMatch(chatInput, "^\/flood([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/flood$") || RegExMatch(chatInput, "^\/flood $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /flood [ID игрока]")
        return
    }
    RegExMatch(chatInput, "^\/flood ([\dA-Za-z_\[\]]+)", t)
    id := t1
    updateOScoreboardData()
    gNick := getPlayerNameById(id)
    gNick := RegExReplace(getPlayerNameById(id), "^(\[DM\]|\[GW\]|\[TR\]|\[LC\])*")
    SendChat("/mute " id " 10 Flood")
    if (timemute=1)
    {
        sendchat("/time")
        sleep 500
    SendInput, {F8}
    }
    if(strlen(gNick) < 1)
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Игрок не найден")
        return
    }
}
if(RegExMatch(chatInput, "^\/caps"))
{
    if(RegExMatch(chatInput, "^\/caps([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/caps$") || RegExMatch(chatInput, "^\/caps $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /caps [ID игрока]")
        return
    }
    RegExMatch(chatInput, "^\/caps ([\dA-Za-z_\[\]]+)", t)
    id := t1
    updateOScoreboardData()
    gNick := getPlayerNameById(id)
    gNick := RegExReplace(getPlayerNameById(id), "^(\[DM\]|\[GW\]|\[TR\]|\[LC\])*")
    SendChat("/mute " id " 10 Caps Lock")
    if (timemute=1)
    {
        sendchat("/time")
        sleep 500
    SendInput, {F8}
    }
    if(strlen(gNick) < 1)
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Игрок не найден")
        return
    }
}
if(RegExMatch(chatInput, "^\/pr"))
{
    if(RegExMatch(chatInput, "^\/pr([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/pr$") || RegExMatch(chatInput, "^\/pr $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /pr [ID игрока]")
        return
    }
    RegExMatch(chatInput, "^\/pr ([\dA-Za-z_\[\]]+)", t)
    id := t1
    updateOScoreboardData()
    gNick := getPlayerNameById(id)
    gNick := RegExReplace(getPlayerNameById(id), "^(\[DM\]|\[GW\]|\[TR\]|\[LC\])*")
    SendChat("/mute " id " 120 Реклама")
    if (timemute=1)
    {
        sendchat("/time")
        sleep 500
    SendInput, {F8}
    }
    Sleep 1
    SendChat("/rr")
    if(strlen(gNick) < 1)
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Игрок не найден")
        return
    }
}
if(RegExMatch(chatInput, "^\/osk"))
{
    if(RegExMatch(chatInput, "^\/osk([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/osk$") || RegExMatch(chatInput, "^\/osk $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /osk [ID игрока]")
        return
    }
    RegExMatch(chatInput, "^\/osk ([\dA-Za-z_\[\]]+)", t)
    id := t1
    updateOScoreboardData()
    gNick := getPlayerNameById(id)
    gNick := RegExReplace(getPlayerNameById(id), "^(\[DM\]|\[GW\]|\[TR\]|\[LC\])*")
    SendChat("/mute " id " 30 Оскорбление игроков")
    if (timemute=1)
    {
        sendchat("/time")
        sleep 500
    SendInput, {F8}
    }
    if(strlen(gNick) < 1)
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Игрок не найден")
        return
    }
}
if(RegExMatch(chatInput, "^\/offo"))
{
    if(RegExMatch(chatInput, "^\/offo([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/offo$") || RegExMatch(chatInput, "^\/offo $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /offo [ID игрока]")
        return
    }
    RegExMatch(chatInput, "^\/offo ([\dA-Za-z_\[\]]+)", t)
    id := t1
    updateOScoreboardData()
    gNick := getPlayerNameById(id)
    gNick := RegExReplace(getPlayerNameById(id), "^(\[DM\]|\[GW\]|\[TR\])*")
    SendChat("/mute " id " 40 offtop in /o")
    if (timemute=1)
    {
        sendchat("/time")
        sleep 500
    SendInput, {F8}
    }
    if(strlen(gNick) < 1)
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Игрок не найден")
        return
    }
}
if(RegExMatch(chatInput, "^\/cenz"))
{
    if(RegExMatch(chatInput, "^\/cenz([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/cenz$") || RegExMatch(chatInput, "^\/cenz $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /cenz [ID игрока]")
        return
    }
    RegExMatch(chatInput, "^\/cenz ([\dA-Za-z_\[\]]+)", t)
    id := t1
    updateOScoreboardData()
    gNick := getPlayerNameById(id)
    gNick := RegExReplace(getPlayerNameById(id), "^(\[DM\]|\[GW\]|\[TR\])*")
    SendChat("/mute " id " 20 Мат в /report")
    if (timemute=1)
    {
        sendchat("/time")
        sleep 500
    SendInput, {F8}
    }
    if(strlen(gNick) < 1)
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Игрок не найден")
        return
    }
}
if(RegExMatch(chatInput, "^\/troll"))
{
    if(RegExMatch(chatInput, "^\/troll([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/troll$") || RegExMatch(chatInput, "^\/troll $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /troll [ID игрока]")
        return
    }
    RegExMatch(chatInput, "^\/troll ([\dA-Za-z_\[\]]+)", t)
    id := t1
    updateOScoreboardData()
    gNick := getPlayerNameById(id)
    gNick := RegExReplace(getPlayerNameById(id), "^(\[DM\]|\[GW\]|\[TR\])*")
    SendChat("/mute " id " 120 Троллинг администрации")
    if (timemute=1)
    {
        sendchat("/time")
        sleep 500
    SendInput, {F8}
    }
    if(strlen(gNick) < 1)
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Игрок не найден")
        return
    }
}
if(RegExMatch(chatInput, "^\/admosk"))
{
    if(RegExMatch(chatInput, "^\/admosk([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/admosk$") || RegExMatch(chatInput, "^\/admosk $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /admosk [ID игрока]")
        return
    }
    RegExMatch(chatInput, "^\/admosk ([\dA-Za-z_\[\]]+)", t)
    id := t1
    updateOScoreboardData()
    gNick := getPlayerNameById(id)
    gNick := RegExReplace(getPlayerNameById(id), "^(\[DM\]|\[GW\]|\[TR\])*")
    SendChat("/mute " id " 180 Оскорбление администрации")
    if (timemute=1)
    {
        sendchat("/time")
        sleep 500
    SendInput, {F8}
    }
    if(strlen(gNick) < 1)
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Игрок не найден")
        return
    }
}
if(RegExMatch(chatInput, "^\/movadm"))
{
    if(RegExMatch(chatInput, "^\/movadm([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/movadm$") || RegExMatch(chatInput, "^\/movadm $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /movadm [ID игрока]")
        return
    }
    RegExMatch(chatInput, "^\/movadm ([\dA-Za-z_\[\]]+)", t)
    id := t1
    updateOScoreboardData()
    gNick := getPlayerNameById(id)
    gNick := RegExReplace(getPlayerNameById(id), "^(\[DM\]|\[GW\]|\[TR\])*")
    SendChat("/mute " id " 150 Обсуждение действий администрации ")
    if (timemute=1)
    {
        sendchat("/time")
        sleep 500
    SendInput, {F8}
    }
    if(strlen(gNick) < 1)
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Игрок не найден")
        return
    }
}
if(RegExMatch(chatInput, "^\/indq"))
{
    if(RegExMatch(chatInput, "^\/indq([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/indq$") || RegExMatch(chatInput, "^\/indq $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /indq [ID игрока]")
        return
    }
    RegExMatch(chatInput, "^\/indq ([\dA-Za-z_\[\]]+)", t)
    id := t1
    updateOScoreboardData()
    gNick := getPlayerNameById(id)
    gNick := RegExReplace(getPlayerNameById(id), "^(\[DM\]|\[GW\]|\[TR\])*")
    SendChat("/mute " id " 30 Неадекватное поведение")
    if (timemute=1)
    {
        sendchat("/time")
        sleep 500
    SendInput, {F8}
    }
    if(strlen(gNick) < 1)
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Игрок не найден")
        return
    }
}
if(RegExMatch(chatInput, "^\/noise"))
{
    if(RegExMatch(chatInput, "^\/noise([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/noise$") || RegExMatch(chatInput, "^\/noise $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте:{FFD700} /noise [ID игрока]")
        return
    }
    RegExMatch(chatInput, "^\/noise ([\dA-Za-z_\[\]]+)", t)
    id := t1
    updateOScoreboardData()
    gNick := getPlayerNameById(id)
    gNick := RegExReplace(getPlayerNameById(id), "^(\[DM\]|\[GW\]|\[TR\])*")
    SendChat("/kick " id " Помеха")
    if(strlen(gNick) < 1)
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Игрок не найден")
        return
    }
}
if RegExMatch(chatInput, "^\/cheat")
{
    if(RegExMatch(chatInput, "^\/cheat([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/cheat$") || RegExMatch(chatInput, "^\/cheat $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте: {FFD700}/cheat [ID Игрока]")
        return
    }
    RegExMatch(chatInput, "^\/cheat ([0-9]+)", hack)
    SendChat("/a /cban " hack1 " 30 cheat")
    return
}
if RegExMatch(ChatInput, "^\/capt")
{
    if(RegExMatch(chatInput, "^\/capt([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/capt$") || RegExMatch(chatInput, "^\/capt $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте: {FFD700}/capt [ID Игрока]")
        return
    }
    RegExMatch(chatInput, "^\/capt (.*)", capture)
    SendChat("/a /jail " capture1 " 10 Неправильный /capture")
    sleep 150
    Sendchat("/a /scapt Неправильный /capture")
    return
}
if RegExMatch(ChatInput, "^\/kpz")
{
    if(RegExMatch(chatInput, "^\/kpz([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/kpz$") || RegExMatch(chatInput, "^\/kpz $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте: {FFD700}/kpz [ID Игрока]")
        return
    }
    RegExMatch(chatInput, "^\/kpz (.*)", kpz)
    SendChat("/a /jail " kpz1 " 60 Cheat")
    return
}
if RegExMatch(ChatInput, "^\/onick")
{
    if(RegExMatch(chatInput, "^\/onick([^ ])"))
    return
    if((RegExMatch(chatInput, "^\/onick$") || RegExMatch(chatInput, "^\/onick $")))
    {
    addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Используйте: {FFD700}/onick [ID Игрока]")
        return
    }
    RegExMatch(chatInput, "^\/onick (.*)", onick)
    SendChat("/a /ban " onick1 " 30 Nickname")
    return
}
if RegExMatch(ChatInput, "/amute ([0-9]+)", amut)
{
    NickIgrM := RegExReplace(getPlayerNameById(amut1), "^(\[DM\]|\[GW\]|\[TR\]|\[LC\])*")
    if (amut1<0) || if (amut1>299)
    {
    addchatmessageEx("FFFFFF", "{FFD700}[A]{FFFFFF} Используйте: {FFD700}/amute [ID Игрока]")
        return
    }
    gosub, amute
}
if RegExMatch(ChatInput, "/akick ([0-9]+)", akik)
{
    NickIgrK := RegExReplace(getPlayerNameById(akik1), "^(\[DM\]|\[GW\]|\[TR\]|\[LC\])*")
    if (akik1<0) || if (akik1>299)
    {
    addchatmessageEx("FFFFFF", "{FFD700}[A]{FFFFFF} Используйте: {FFD700}/akick [ID Игрока]")
        return
    }
    gosub, akick
}
if RegExMatch(ChatInput, "/ajail ([0-9]+)", akpz)
{
    NickIgrJ := RegExReplace(getPlayerNameById(akpz1), "^(\[DM\]|\[GW\]|\[TR\]|\[LC\])*")
    if (akpz1<0) || if (akpz1>299)
    {
    addchatmessageEx("FFFFFF", "{FFD700}[A]{FFFFFF} Используйте: {FFD700}/ajail [ID Игрока]")
        return
    }
    gosub, ajail
}
if RegExMatch(ChatInput, "/aban ([0-9]+)", aban)
{
    NickIgrB := RegExReplace(getPlayerNameById(aban1), "^(\[DM\]|\[GW\]|\[TR\]|\[LC\])*")
    if (aban1<0) || if (aban1>299)
    {
    addchatmessageEx("FFFFFF", "{FFD700}[A]{FFFFFF} Используйте: {FFD700}/aban [ID Игрока]")
        return
    }
    gosub, aban
}
return
~ESC::
~F6::
menu:=0
return
amsg:
menu := 1
showDialog("2", "{FFD700}Меню отправки MSG", "Форма подачи жалобы в репорт..`nРепорт предназначен для..`nВы всегда можете оставить жалобу на игрока/администратора..", "Закрыть")
return
itp:
menu := 2
showDialog("2","{FFD700}Меню телепортов", "Админ интерьер (/aint)`n{009900}Grove Street Gang`n{C71585}The Ballas Gang`n{FFFF00}Los Santos Vagos`n{00FFFF}Varios Los Aztecas`nDeath Match Zone`nLiberty City`nКлуб Jizzy`nКаскадёрские трюки`nАндромеда`nДом Ж№1`nДом Ж№2`nДом Ж№3`nНебоскрёб`nVineWood`nГоры Bayside`nОкраина LV`nФерма наркоманов (Epsilon)`nКладбище самолётов", "Закрыть")
return
mpm:
menu := 3
Showdialog("2", "{FFD700}Меню мероприятий", "Список интерьеров`nВыдать ХП в зоне прорисовки {FFD700}[5 уровень]`nЗабрать оружие в зоне прорисовки {FFD700}[5 уровень]`nВыдать рандомный скин в зоне прорисовки {FFD700}[4 уровень]`nПолезные команды", "Закрыть")
return
amute:
menu := 5
ShowDialog("2", "{FFD700}Mute > " NickIgrM, "Упоминание/Оскорбление родных`nКапс`nФлуд`nOfftop /report`nOfftop /o`nОскорбление игроков`nНеадекватное поведение`nОскорбление администрации`nКлевета`nОбсуждение действий администрации`nТроллинг администрации`nРеклама`nОскорбление проекта`nРозжиг", "Закрыть")
return
akick:
menu := 6
ShowDialog("2", "{FFD700}Kick > " NickIgrK, "Cheat`nПомеха`nДБ`nТК`nСК`nОскорбление в нике`nНеправильный /capture", "Закрыть")
return
ajail:
menu := 7
ShowDialog("2", "{FFD700}Jail > " NickIgrJ, "Cheat`nБагоюз`nНеправильный /capture", "Закрыть")
return
X2Alert:
sleep 1800000
SendChat("/msg С 14 по 16 декабря действуют скидки на админки и акция 'X2 донат' на пополнение счёта.")
sleep 3100
SendChat("/msg Подробнее Вы можете узнать на нашем сайте - www.monser.ru")
sleep 3100
SendChat("/msg А так же в официальной группе во ВКонтакте - vk.com/monser_gangwar")
return
aban:
menu := 8
ShowDialog("2", "{FFD700}Ban > " NickIgrB, "Cheat {32CD32}[4 lvl]{FFFFFF}`nCheat {FF8C00}[3 lvl]{FFFFFF}`nОскорбление родных`nОскорбление администрации`nРеклама`nОскорбление в нике`nНеадекватное поведение в /v`nОбман администрации", "Закрыть")
return
~LButton::
Time := A_TickCount
while(isDialogOpen())
{
    if (A_TickCount - Time > 500)
    {
        Return
    }
}
checkdialogMenu:
if (isDialogButtonSelected() == 1)
{
    menu := 0
}
ifWinNotActive, GTA:SA:MP
{
    return
}
if (menu == 1)
{
    menu := 0
    line_num  := getDialogLineNumber()
    line_text  := getDialogLine(line_num)
    if line_num=1
    {
        SendChat("/msg Форма подачи жалобы в репорт: /report [ID нарушителя] [Жалоба(предполагаемый чит)]")
    }
    if line_num=2
    {
        sendchat("/msg Репорт предназначен не для высказывания/выражения своих эмоций")
        Sleep, 3000
        sendchat("/msg В репорт задают вопросы по игровому моду, а так же жалуются на игроков")
        Sleep, 3000
        sendchat("/msg За оффтоп в репорт - Вы будете наказаны.")
    }
    if line_num=3
    {
        Sendchat("/msg Вы всегда можете оставить жалобу на игрока/администратора..")
        Sleep, 3000
        Sendchat("/msg ..на нашем форуме - forum.monser.ru")
        Sleep, 3000
        SendChat("/msg Администрация желает вам приятной игры и отличного настроения <3")
    }
    return
}
else if (menu == 2)
{
    menu := 0
    line_num  := getDialogLineNumber()
    line_text  := getDialogLine(line_num)
    if line_num = 1
    {
        SendChat("/aint")
        sleep 100
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы в`n{FFD700}Админ интерьер")
    }
    if line_num = 2
    {
        SendChat("/aint")
        Sleep 100
        setCoordinates(2450.14, -1701.89, 1013.51, 2)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы к`n{009900}Grove Street Gang")
    }
    if line_num = 3
    {
        SendChat("/aint")
        Sleep 100
        setCoordinates(-49.56, 1407.24, 1084.43, 8)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы к`n{CC00FF}The Ballas Gang")
    }
    if line_num = 4
    {
        SendChat("/tpint 107")
        Sleep 1
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы к`n{FFCD00}Los Santos Vagos")
    }
    if line_num =  5
    {
        SendChat("/aint")
        Sleep 100
        setCoordinates(221.25, 1243.05, 1082.14, 2)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы к`n{00CCFF}Varios Los Aztecas")
    }
    if line_num = 6
    {
        SendChat("/aint")
        sleep 100
        setCoordinates(-1029.88, 1064.60, 1344.00, 10)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}Death Match Zone")
    }
    if line_num = 7
    {
        SendChat("/aint")
        Sleep 100
        setCoordinates(-773.51, 499.55, 1376.57, 1)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы в`n{FFD700}Liberty City")
    }
    if line_num = 8
    {
        SendChat("/tpint 100")
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы в`n{FFD700}Клуб Jizzy")
    }
    if line_num = 9
    {
        SendChat("/aint")
        Sleep 100
        setCoordinates(-1441.04, 1591.55, 1052.33,14)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}Каскадерские трюки")
    }
    if line_num = 10
    {
        Sleep 100
        setCoordinates(315.87, 1024.47, 1949.80, 9)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы в`n{FFD700}Андромеду")
    }
    if line_num = 11
    {
        SendChat("/aint")
        Sleep 100
        setCoordinates(234.08, 1069.97, 1084.19, 6)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы в`n{FFD700}Дом Ж№1")
    }
    if line_num = 12
    {
        SendChat("/aint")
        Sleep 100
        setCoordinates(2318.06, -1013.34, 1054.72, 9)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы в`n{FFD700}Дом Ж№2")
    }
    if line_num = 13
    {
        SendChat("/tpint 19")
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы в`n{FFD700}Дом Ж№3")
    }
    if line_num = 14
    {
        SendChat("/aint")
        Sleep 100
        SendChat("/tp 1")
        Sleep 100
        setCoordinates(1544.47, -1353.54, 329.47, 0)
        setCoordinates(1544.47, -1353.54, 329.47, 0)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}Небоскрёб")
    }
    if line_num = 15
    {
        Sendchat("/aint")
        sleep 100
        sendchat("/tp 1")
        sleep 100
        setCoordinates(1445.00, -860.81, 52.53, 0)
        setCoordinates(1445.00, -860.81, 52.53, 0)
    addchatmessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}VineWood")
    }
    if line_num = 16
    {
        Sendchat("/aint")
        sleep 100
        sendchat("/tp 1")
        sleep 100
        setCoordinates(-2829.97, 2177.57, 177.17, 0)
        setCoordinates(-2829.97, 2177.57, 177.17, 0)
    addchatmessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}Горы Bayside")
    }
    if line_num = 17
    {
        Sendchat("/aint")
        sleep 100
        sendchat("/tp 1")
        sleep 100
        setCoordinates(2538.84, 2973.17, 32.17, 0)
        setCoordinates(2538.84, 2973.17, 32.17, 0)
    addchatmessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}Окраину LV")
    }
    if line_num = 18
    {
        Sendchat("/aint")
        sleep 100
        sendchat("/tp 1")
        sleep 100
        setCoordinates(-1103.46, -1114.73, 128.27, 0)
        setCoordinates(-1103.46, -1114.73, 128.27, 0)
    addchatmessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}Ферму наркоманов {00FFFF}(Epsilon)")
    }
    if line_num = 19
    {
        Sendchat("/aint")
        sleep 100
        sendchat("/tp 1")
        sleep 100
        setCoordinates(324.17, 2543.70, 25.40, 0)
        setCoordinates(324.17, 2543.70, 25.40, 0)
    addchatmessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}Кладбище самолётов")
    }
    return
}
else if (menu == 3)
{
    menu := 0
    line_num  := getDialogLineNumber()
    line_text  := getDialogLine(line_num)
    if line_num=1
    {
        menu := 4
    showDialog("2", "{FFD700}Список интерьеров", "Прятки Ж№1`nПрятки Ж№2`nПрятки Ж№3`nПрятки Ж№4`nДерби Ж№1`nДерби Ж№2`nОстаться в живых`nПоливалка Ж№1`nПоливалка Ж№2", "Закрыть")
    }
    if line_num=2
    {
        sendchat("/allhp 100")
    }
    if line_num=3
    {
        Sendchat("/allresgun")
    }
    if line_num=4
    {
        Random, rsk, 1, 311
        {
            id := rsk
            showGameText("~y~AutoSkin:~n~~g~checking...", 1000, 4)
            Sleep 250
            Players := []
            dout := ""
            Players := getStreamedInPlayersInfo()
            p := 0
            For i, o in Players
            {
                l := []
                l := getPedCoordinates(o.PED)
                p++
                pos := getCoordinates()
                Name := getPlayerNameById(i)
                Dist := getDist(getCoordinates() ,l)
                idskin := getTargetPlayerSkinIdById(i)
                inveh := isTargetInAnyVehicleById(i)
                pcolor := getPlayerColor(i)
                cts := colorToStr(pcolor)
            if (cts=="{9a400}")
                {
                StringReplace, cts, cts, {9a400}, {098A00}, All
                }
            else if (cts=="{dedff}")
                {
                StringReplace, cts, cts, {dedff}, {00FFFE}, All
                }
                if (inveh=="1")
                {
                inv := " {A9C4E4}| " cts "В Т/С{A9C4E4}[" cts "" getTargetVehicleModelNameById(i) "{A9C4E4}]"
                }
                else
                {
                    inv := ""
                }
                if (idskin=="41" or idskin=="114" or idskin=="115" or idskin=="116" or idskin=="119" or idskin=="292")
                {
                    SendChat("/setskin " i " " id "`n")
                }
                else if (idskin=="102" or idskin=="103" or idskin=="104" or idskin=="195" or idskin=="297")
                {
                    SendChat("/setskin " i " " id "`n")
                }
                else if (idskin=="105" or idskin=="106" or idskin=="107" or idskin=="269" or idskin=="270" or idskin=="271" or idskin=="86" or idskin=="271" or idskin=="56" or idskin=="293")
                {
                    SendChat("/setskin " i " " id "`n")
                }
                else
                {
                    SendChat("/setskin " i " " id "`n")
                }
            }
            if (p=="0")
            {
                showGameText("~y~AutoSkin: ~n~~r~no players", 1000, 4)
            addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Нет игроков в зоне прорисовки")
            }
            if(id < 0)
            {
            addChatMessageEx("FFFFFF", "{FFD700}[A] {FFFFFF}Неверно указан ID скина")
                return
            }
        }
    }
    if line_num=5
    {
    showDialog("0", "{FFD700}Полезные команды", "{FFD700}/tpall {FFFFFF}- Телепортировать всех игроков в зоне прорисовки`n{FFD700}/askin {FFFFFF}- Выдать всем игрокам в зоне прорисовки заданный скин`n{FFD700}/raskin {FFFFFF}- Выдать всем игрокам в зоне прорисовки рандомный скин`n{FFD700}/wd {FFFFFF}- Включить езду по воде`n{FFD700}/wh {FFFFFF}- Включить WallHack", "Закрыть")
        return
    }
}
else if (menu == 4)
{
    menu := 0
    line_num  := getDialogLineNumber()
    line_text  := getDialogLine(line_num)
    if line_num=1
    {
        SendChat("/aint")
        Sleep 100
        setCoordinates(2220.28, -1147.99, 1025.80, 15)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}Прятки Ж№1")
    }
    if line_num=2
    {
        SendChat("/aint")
        Sleep 100
        setCoordinates(2526.17, -1309.49, 1031.42, 2)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}Прятки Ж№2")
    }
    if line_num=3
    {
        SendChat("/aint")
        Sleep 100
        sendchat("/tp 1")
        sleep 100
        setCoordinates(-2313.87, 1545.12, 18.77, 0)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}Прятки Ж№3")
    }
    if line_num=4
    {
        SendChat("/aint")
        sleep 100
        setCoordinates(283.06, 177.47, 1007.17, 3)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}Прятки Ж№4")
    }
    if line_num=5
    {
        SendChat("/tpint 128")
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}Дерби Ж№1")
    }
    if line_num=6
    {
        SendChat("/aint")
        Sleep 100
        setCoordinates(-1397.13, 1242.58, 1039.87, 16)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}Дерби Ж№2")
    }
    if line_num=7
    {
        Sendchat("/aint")
        sleep 100
        sendchat("/tp 1")
        sleep 100
        setCoordinates(2584.69, 2826.82, 10.82, 0)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}Остаться в живых")
    }
    if line_num=8
    {
        Sendchat("/aint")
        sleep 100
        sendchat("/tp 1")
        sleep 100
        setCoordinates(1515.09, -1076.30, 181.20, 0)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}Поливалка Ж№1")
    }
    if line_num=9
    {
        Sendchat("/aint")
        sleep 100
        sendchat("/tp 1")
        sleep 100
        setCoordinates(1819.68, -1301.29, 131.73, 0)
    addChatMessageEx("FFFFFF", "{FFD700}[A]`n{FFFFFF}Вы были телепортированы на`n{FFD700}Поливалка Ж№1")
    }
}
else if (menu == 5)
{
    menu := 0
    line_num  := getDialogLineNumber()
    line_text  := getDialogLine(line_num)
    if line_num=1
    {
        sendchat("/mute " amut1 " 180 Упоминание/Оскорбление родных")
        if (timemute=1)
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    if line_num=2
    {
        sendchat("/mute " amut1 " 20 Caps Lock")
        if (timemute=1)
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    if line_num=3
    {
        sendchat("/mute " amut1 " 10 Flood")
        if (timemute=1)
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    if line_num=4
    {
        sendchat("/mute " amut1 " 15 Offtop /report")
        if (timemute=1)
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    if line_num=5
    {
        sendchat("/mute " amut1 " 40 Offtop /o")
        if (timemute=1)
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    if line_num=6
    {
        sendchat("/mute " amut1 " 30 Оскорбление игроков")
        if (timemute=1)
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    if line_num=7
    {
        sendchat("/mute " amut1 " 40 Неадекватное поведение")
        if (timemute=1)
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    if line_num=8
    {
        sendchat("/mute " amut1 " 180 Оск. администрации")
        if (timemute=1)
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    if line_num=9
    {
        sendchat("/mute " amut1 " 40 Клевета")
        if (timemute=1)
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    if line_num=10
    {
        sendchat("/mute " amut1 " 120 Обсуждение действий администрации")
        if (timemute=1)
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    if line_num=11
    {
        sendchat("/mute " amut1 " 120 Троллинг администрации")
        if (timemute=1)
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    if line_num=12
    {
        sendchat("/mute " amut1 " 180 Реклама")
        sleep 300
        sendchat("/rr")
        if (timemute=1)
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    if line_num=13
    {
        sendchat("/mute " amut1 " 180 Оск. проекта")
        if (timemute=1)
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
    if line_num=14
    {
        sendchat("/mute " amut1 " 180 Розжиг")
        if (timemute=1)
        {
            sendchat("/time")
            sleep 500
        SendInput, {f8}
        }
    }
}
else if (menu == 6)
{
    menu := 0
    line_num  := getDialogLineNumber()
    line_text  := getDialogLine(line_num)
    if line_num=1
    {
        sendchat("/kick " akik1 " Cheat")
    }
    if line_num=2
    {
        sendchat("/kick " akik1 " Помеха спавну/проходу")
    }
    if line_num=3
    {
        sendchat("/kick " akik1 " DB")
    }
    if line_num=4
    {
        sendchat("/kick " akik1 " TK")
    }
    if line_num=5
    {
        sendchat("/kick " akik1 " SK")
    }
    if line_num=6
    {
        sendchat("/kick " akik1 " Оскорбление в нике")
        sleep 300
        sendchat("/rr")
    }
    if line_num=7
    {
        sendchat("/kick " akik1 " Неправильный /capture")
    }
}
else if (menu == 7)
{
    menu := 0
    line_num  := getDialogLineNumber()
    line_text  := getDialogLine(line_num)
    if line_num=1
    {
        sendchat("/jail " akpz1 " 60 Cheat")
    }
    if line_num=2
    {
        sendchat("/jail " akpz1 " 15 Багоюз")
    }
    if line_num=3
    {
        Sendchat("/scapt Неправильный /capture")
        sendchat("/jail " akpz1 " 10 Неправильный /capture")
    }
}
else if (menu == 8)
{
    menu := 0
    line_num  := getDialogLineNumber()
    line_text  := getDialogLine(line_num)
    if line_num=1
    {
        Sendchat("/cban " aban1 " 30 Cheat")
    }
    if line_num=2
    {
        Sendchat("/ban " aban1 " 30 Cheat")
    }
    if line_num=3
    {
        sendchat("/ban " aban1 " 30 Оскорбление родных")
    }
    if line_num=4
    {
        sendchat("/ban " aban1 " 30 Оскорбление администрации")
    }
    if line_num=5
    {
        sendchat("/cban " aban1 " 30 Реклама")
        sleep 300
        sendchat("/rr")
    }
    if line_num=6
    {
        sendchat("/ban " aban1 " 30 Оскорбление в нике")
        sleep 300
        sendchat("/rr")
    }
    if line_num=7
    {
        sendchat("/ban " aban1 " 3 Неадекватное поведение в /v")
    }
    if line_num=8
    {
        sendchat("/ban " aban1 " 10 Обман администрации")
    }
}
return
Login:
{
    GetChatLine(0, alogin)
    IfInString, alogin, Для зачисления онлайна в статистику /ia необходимо заступить на дежурство (/duty)
    {
        if (AnticheatSh=1)
        {
            SetTimer, anticheat, 1000
            acstatus := 1
        }
        If aduty = 1
        {
            Sendchat("/duty " Duty)
        }
        If conoff = 1
        {
            Sendchat("/conoff")
        }
        If fon = 1
        {
            Sendchat("/fon")
            sleep 500
            Sendchat("/von")
            sleep 500
            Sendchat("/smson")
        }
        if youroff1 = 1
        {
            Sendchat(yourcmd1)
        }
        if youroff2 = 1
        {
            Sendchat(yourcmd2)
        }
    }
    return
}
return
chat:
{
    If infore = 1
    {
        chat=%A_MyDocuments%/GTA San Andreas User Files/SAMP/chatlog.txt
        FileRead, chatlog, %chat%
    if (RegExMatch(chatlog, "{32CD32}Администратор " AdminNick " \[ID\:(.*)\] начал наблюдение за игроком (.*) \[ID\:(.*)\]", out))
        {
            lastidrec := out3
            nameidrec := out2
            NickIgr := RegExReplace(getPlayerNameById(out3), "^(\[DM\]|\[GW\]|\[TR\]|\[LC\])*")
            save(chatlog)
        AddchatmessageEx("FFFFFF", "{FFD700}[A]{FFFFFF} Ник игрока: {FFD700}" NickIgr "{FFFFFF} | Кол-во убийств: {FFD700}" getPlayerScoreById(out3) "{FFFFFF} | Пинг: {FFD700}" getPlayerPingById(out3))
            sleep 100
            Sendchat("/ta " lastidrec)
            if (cvre=1)
            {
                setPlayerColor(lastidrec, 0xFF33AA4)
            }
            return
        }
    }
}
return
:?:.кущаа::
SendInput, /reoff{space}
return
:?:.ку::
SendInput, /re{space}
return
:?:.сифт::
SendInput, /cban{space}
return
:?:.ифт::
SendInput, /ban{space}
return
:?:.лшсл::
SendInput, /kick{space}
return
:?:.ьгеу::
SendInput, /mute{space}
return
:?:.щаапуеыефеы::
SendInput, /offgetstats{space}
return
:?:.пуеыефеы::
SendInput, /getstats{space}
return
:?:.еф::
SendInput, /ta{space}
return
:?:.фьуьиукы::
SendInput, /amembers{space}
return
:?:.вген::
SendInput, /duty{space}
return
:?:.ылшсл::
SendInput, /skick{space}
return
:?:.ф::
SendInput, /a{space}
return
:?:.шф::
SendInput, /ia{space}
return
:?:.зь::
SendInput, /pm{space}
return
:?:.фвьшты::
SendInput, /admins{space}
return
:?:.кк::
SendInput, /rr{space}
return
:?:.ыдфз::
SendInput, /slap{space}
return
:?:.гтьгеу::
SendInput, /unmute{space}
return
:?:.щаагтьгеу::
SendInput, /offunmute{space}
return
:?:.щааифт::
SendInput, /offban{space}
return
:?:.щаасифт::
SendInput, /offcban{space}
return
:?:.ифтшз::
SendInput, /banip{space}
return
:?:.офшд::
SendInput, /jail{space}
return
:?:.ысфк::
SendInput, /scar{space}
return
:?:.езс::
SendInput, /tpc{space}
return
:?:.дтфьу::
SendInput, /lname{space}
return
:?:.мща::
SendInput, /vof{space}
return
:?:.куыпгт::
SendInput, /resgun{space}
return
:?:.гтофшд::
SendInput, /unjail{space}
return
:?:.щаагтофшд::
SendInput, /offunjail{space}
return
:?:.щааофшд::
SendInput, /offjail{space}
return
:?:.фрудз::
SendInput, /ahelp{space}
return
:?:.езлы::
SendInput, /tpks{space}
return
:?:.езлт::
SendInput, /tpkn{space}
return
:?:.щио::
SendInput, /obj{space}
return
:?:.штаьгеу::
SendInput, /infmute{space}
return
:?:.штаофшд::
SendInput, /infjail{space}
return
:?:.штаифт::
SendInput, /infban{space}
return
:?:.шташз::
SendInput, /infip{space}
return
:?:.ащт::
SendInput, /fon{space}
return
:?:.ащаа::
:?:.ащаа::
SendInput, /foff{space}
return
:?:.гтифт::
SendInput, /unban{space}
return
:?:.ыуеылшт::
SendInput, /setskin{space}
return
:?:.сщтщт::
SendInput, /conon{space}
return
:?:.сщтщаа::
SendInput, /conoff{space}
return
:?:.аднсфь::
SendInput, /flycam{space}
return
InfoAHK:
{
    Gui, 13:Destroy
    Gui, 3:Destroy
    Gui, 19:Destroy
    Gui, 20:Destroy
    Gui, 21:Destroy
    Gui, 22:Destroy
    Gui, 23:Destroy
    Gui, 24:Destroy
    Gui, 11:Color, FFFFFF
    Gui, 11:Add, GroupBox, x14 y10 w450 h50 +Center, Информация о скрипте
    Gui, 11:Add, Text, x16 y26 w200 h20 , Разработчик - FRIENDZONE
    Gui, 11:Add, Text, x246 y26 w220 h20 , Skype: hosi1314hosi | VK: vk.com/rewaver
    Gui, 11:Add, Button, x184 y70 w110 h20 g11GuiClose, Закрыть
    Gui, 11:Show, x378 y405 h102 w482, Информация о скрипте
    Return
}
return
ClickMonser:
{
    Run, http://monser.ru
}
return
Link2:
{
    Run, http://forum.monser.ru/index.php?threads/Общие-правила-для-администрации.63/post-87
}
return
Link:
{
    Run http://forum.monser.ru/index.php?threads/autohotkey-для-администрации.2302/post-9335
}
return
CMDList1:
{
    Gui, 13:Destroy
    Gui, 11:Destroy
    Gui, 19:Destroy
    Gui, 20:Destroy
    Gui, 21:Destroy
    Gui, 22:Destroy
    Gui, 23:Destroy
    Gui, 24:Destroy
    Gui, 3:Color, FFFFFF
    Gui, 3:Add, Text, x6 y6 w470 h230 , /ah - Показать список команд`n/tabl - Таблица наказаний`n/cc - Копировать ник по ID`n/mp - Создать МП`n/mpoff - Принудительно остановить авто-телепортацию на МП`n/mp - Меню мероприятий`n/gomp - Создать мероприятие`n/gg - Пожелать приятной игры (До 5 рандомных сообщений)`n/amsg - Меню отправки /msg`n/itp - Меню телепорта`n/tpall - Телепортировать всех игроков в зоне прорисовки`n/askin - Выдать всем игрокам в зоне прорисовки заданный скин`n/raskin - Выдать всем игрокам в зоне прорисовки рандомный скин`n/by - Выдать наказание по просьбе администратора`n/byinfo - Теги для /by`n/tempcmd - Посмотреть команды для работы с Temp List'ом
    Gui, 3:Add, Button, x188 y246 w100 h20 g3GuiClose, Закрыть
    Gui, 3:Add, Button, x6 y246 w120 h20 gvetka, Подробнее о списках
    Gui, 3:Add, Button, x346 y246 w120 h20 gCMDLIST2, Вперёд
    Gui, 3:Show, x325 y262 h275 w478, Команды Ж№1
    Return
}
return
CMDLIST2:
{
    Gui, 3:Destroy
    Gui, 11:Destroy
    Gui, 19:Destroy
    Gui, 20:Destroy
    Gui, 21:Destroy
    Gui, 22:Destroy
    Gui, 23:Destroy
    Gui, 24:Destroy
    Gui, 13:Color, FFFFFF
    Gui, 13:Add, Text, x6 y6 w470 h230 , /dlist - Посмотреть команды быстрой выдачи наказаний`n/alist - Посмотреть команды выдачи наказаний`n/request - Команды для "быстрых" просьб в /a чат`n/bug - Решение распространённых багов скрипта`n/clear - Очистить чат`n/cv - Изменить цвет ника игроку (Специально для трейсера пуль)`n/wh - Включить WallHack`n/acmd - Посмотреть /ahelp по уровням в диалоговом окне`n/wd - Включить езду по воде`n/rsp - Слежка за рандомным ID`n/sh - Включить/Выключить античит на SpeedHack`n/skin - Узнать ID скина по ID игрока`n/reloadahk - Перезагрузить скрипт`n/nnick - проверка на неадекватные ник-неймы`n/infgun - Посмотреть список id-ов оружий`n/gmtest - Проверка на GM от падений
    Gui, 13:Add, Button, x188 y246 w100 h20 g13GuiClose, Закрыть
    Gui, 13:Add, Button, x356 y246 w120 h20 gvetka, Подробнее о списках
    Gui, 13:Add, Button, x6 y246 w120 h20 gCMDLIST1, Назад
    Gui, 13:Show, x325 y262 h277 w480, Команды Ж№2
}
return
MoreEwe:
{
    Gui, 13:Destroy
    Gui, 3:Destroy
    Gui, 11:Destroy
    Gui, 19:Destroy
    Gui, 20:Destroy
    Gui, 21:Destroy
    Gui, 22:Destroy
    Gui, 23:Destroy
    Gui, 24:Destroy
    Gui, 6:Color, FFFFFF
    Gui, 6:Add, GroupBox, x6 y6 w320 h190 +Center, Полезные функции
    Gui, 6:Add, CheckBox, x16 y27 w200 h20 vinfore Checked%infore%, Информация о игроке при слежке
    Gui, 6:Add, CheckBox, x16 y57 w220 h20 vfon Checked%fon%, Включить все прослушки (+3 уровень)
    Gui, 6:Add, CheckBox, x16 y87 w160 h20 vcvre Checked%cvre%, Автоматическое /cv по /re
    Gui, 6:Add, Button, x72 y219 w90 h20 gSaveButton, Сохранить
    Gui, 6:Add, Button, x182 y219 w90 h20 g6GuiClose, Закрыть
    Gui, 6:Add, CheckBox, x16 y116 w220 h20 vreoffre Checked%reoffre%, Пустое значение /re как /reoff
    Gui, 6:Add, CheckBox, x16 y143 h20 vremask Checked%remask%, Анти сброс маски при выходе ...`n... из рекона (для VIP)
    ;Gui, 6:Add, CheckBox, x22 y149 w20 h20 vyouroff1 Checked%youroff1%,
    ;Gui, 6:Add, Edit, x52 y149 w150 h20 vyourcmd1, %yourcmd1%
    ;Gui, 6:Add, CheckBox, x22 y179 w20 h20 vyouroff2 Checked%youroff2%,
   ;Gui, 6:Add, Edit, x52 y179 w150 h20 vyourcmd2, %yourcmd2%
    Gui, 6:Show, x528 y165 h248 w361, Полезные функции #2
    return
}
return
vetka:
{
    Gui, 8:Color, FFFFFF
    Gui, 8:Add, Button, x35 y17 w120 h30 gAlistInfo, Подробнее о /alist
    Gui, 8:Add, Button, x35 y67 w120 h30 gInfospiski, Подробнее о /request
    Gui, 8:Add, Button, x35 y116 w120 h30 gDlistInfo, Подробнее о /dlist
    Gui, 8:Show, x579 y174 h159 w192, Подробнее о списках
    return
}
return
Infospiski:
{
    Gui, 8:Destroy
    Gui, 7:Color, FFFFFF
    Gui, 7:Add, Text, x6 y7 w340 h70 , /cheat - Просьба в /a о бане игрока за читы`n/capt - Просьба в /a чат о неправильном /capture`n/kpz - Просьба в /a чат о джайле за читы`n/onick - Просьба в /a чат о бане за ник
    Gui, 7:Add, Button, x124 y77 w100 h20 g7GuiClose, Закрыть
    Gui, 7:Show, x332 y182 h103 w350, Request List
    Return
}
return
Alistinfo:
{
    Gui, 8:Destroy
    Gui, 5:Color, FFFFFF
    Gui, 5:Add, Text, x6 y6 w180 h70 +Left, /aban - Выдать бан`n/ajail - Выдать КПЗ`n/akick - Выдать кик`n/amute - Выдать мут
    Gui, 5:Add, Button, x46 y86 w100 h20 g5GuiClose, Закрыть
    Gui, 5:Show, x516 y195 h111 w194, AList
    return
}
return
Dlistinfo:
{
    Gui, 8:Destroy
    Gui, 5:Color, FFFFFF
    Gui, 5:Add, Text, x6 y7 w480 h180 , /ma - Выдать мут за упоминание/оскорбление родных`n/offrep - Выдать мут за offtop в /report`n/flood- Выдать мут за флуд`n/caps - выдать мут за CapsLock`n/pr - Выдать мут за рекламу`n/osk - Выдать мут за оскорбление игроков`n/offo - Выдать мут за offtop в /o`n/cenz - Выдать мут за мат в /report`n/troll - Выдать мут за троллинг администрации`n/admosk - Выдать мут за оскорбление администрации`n/indq - Выдать мут за неадекватное поведение`n/movadm - Выдать мут за обсуждение действий администрации`n/noise - Выдать кик за помеху
    Gui, 5:Add, Button, x126 y187 w100 h20 +Center g5GuiClose, Закрыть
    Gui, 5:Show, x332 y182 h211 w354, DList
    return
}
return
TNList:
{
    Gui, 20:Destroy
    Gui, 21:Destroy
    Gui, 22:Destroy
    Gui, 23:Destroy
    Gui, 24:Destroy
    Gui, 19:Color, FFFFFF
    Gui, 19:Add, GroupBox, x12 y10 w200 h290 +Center, Таблица наказаний
    Gui, 19:Add, Button, x23 y30 w170 h40 gBan4at, Блокировка чата
    Gui, 19:Add, Button, x23 y80 w170 h40 gKicks, Кики
    Gui, 19:Add, Button, x23 y130 w170 h40 gKPZ, КПЗ
    Gui, 19:Add, Button, x23 y180 w170 h40 gBanA, Баны
    Gui, 19:Add, Button, x23 y230 w170 h40 gBanI, Баны IP
    Gui, 19:Add, Button, x58 y290 w100 h20 g19GuiClose, Закрыть
    Gui, 19:Show, x491 y381 h322 w226, Таблица Наказаний
    return
}
return
Ban4at:
{
    Gui, 19:Destroy
    Gui, 20:Color, FFFFFF
    Gui, 20:Add, Text, x22 y30 w390 h270 +Center, `nФлуд (5-20 минут)`nКапс (5-20 минут)`nРозжиг (60-180 минут)`nРеклама любого ресурса (60-180 минут)`nТорговля (40-60 минут)`nОффтоп в репорт (10-20 минут)`nМат в репорт (10-20 минут)`nОбман администрации (30-60 минут)`nКлевета (40-60 минут)`nОскорбление проекта (180 минут)`nОскорбление игроков (10-30 минут)`nТроллинг администрации (60-120 минут)`nНеуважение к администрации (60-120 минут)`nОскорбление администрации (180 минут)`nОбсуждение действий Администрации (120-180 минут)`nКлевета на администратора (60-120 минут)`nУпоминание родных (180 минут)`nНеадекватное поведение (30 - 40 минут)( Капс`, Флуд`, Оск )`nОффтоп в /o (40-60 минут)( Передача`, обмен`, покупка`, продажа аккаунтов )
    Gui, 20:Add, GroupBox, x12 y10 w410 h300 +Center, Блокировка чата:
    Gui, 20:Add, Button, x152 y320 w130 h30 g20GuiClose gTNList, Назад
    Gui, 20:Show, x384 y303 h361 w435, Блокировки чата
    return
}
return
Kicks:
{
    Gui, 19:Destroy
    Gui, 20:Destroy
    Gui, 21:Color, FFFFFF
    Gui, 21:Add, Text, x22 y30 w390 h130 +Center, `nДБ`nТК`nСК`nПомеха проходу/спавну/капту `n(Если игрок находиться больше 1 минуты в AFK)`nОскорбление в нике`nНеправильный каптур ( Кусок/обрез )`nЧит (Когда нет старшей администрации)
    Gui, 21:Add, GroupBox, x12 y10 w410 h160 +Center, Кики:
    Gui, 21:Add, Button, x150 y180 w130 h30 g21GuiClose gTNList, Назад
    Gui, 21:Show, x384 y303 h220 w435, Кики
    return
}
return
KPZ:
{
    Gui, 19:Destroy
    Gui, 20:Destroy
    Gui, 21:Destroy
    Gui, 23:Destroy
    Gui, 24:Destroy
    Gui, 22:Color, FFFFFF
    Gui, 22:Add, Text, x20 y30 w390 h60 +Center, `nЧиты (40-60 минут | Когда нет старшей администрации)`nБагоюз (10-20 минут)`nКапт куском (5-10 минут)
    Gui, 22:Add, GroupBox, x10 y10 w410 h90 +Center, КПЗ:
    Gui, 22:Add, Button, x150 y100 w130 h30 gTNList, Назад
    Gui, 22:Show, x384 y303 h139 w435, КПЗ
    return
}
return
BanA:
{
    Gui, 19:Destroy
    Gui, 20:Destroy
    Gui, 21:Destroy
    Gui, 22:Destroy
    Gui, 24:Destroy
    Gui, 23:Color, FFFFFF
    Gui, 23:Add, Text, x22 y30 w390 h140 +Center, `nОскорбление в нике (20-30 дней) Команда: /ban`nОбман администрации (5-10 дней) /ban`nНеадекватное поведение (2-5 днeй) /ban`nРеклама любого ресурса (30 дней) /cban`nОскорбление администрации (30 дней) /ban`nОскорбление родных (30 дней) /ban`nОскорбление проекта (90 дней) /cban`nЧиты (30 дней) для 3лвл /ban | для 4+лвл /cban
    Gui, 23:Add, GroupBox, x12 y10 w410 h170 +Center, Баны:
    Gui, 23:Add, Button, x150 y180 w130 h30 gTNList, Назад
    Gui, 23:Show, x384 y303 h223 w435, Баны
    return
}
return
BanI:
{
    Gui, 19:Destroy
    Gui, 20:Destroy
    Gui, 21:Destroy
    Gui, 22:Destroy
    Gui, 23:Destroy
    Gui, 24:Color, FFFFFF
    Gui, 24:Add, Text, x22 y30 w390 h60 +Center, `nНеоднократное оскорбление в нике (10 дней) /banip`nНеоднократное оскорбление родных (10 дней) /banip`nНеоднократное оскорбление администраторов (10 дней) /banip
    Gui, 24:Add, GroupBox, x12 y10 w410 h90 +Center, Баны IP:
    Gui, 24:Add, Button, x150 y110 w130 h30 gTNList, Назад
    Gui, 24:Show, x387 y376 h153 w435, Баны IP
    return
}
return
Anticheat:
hat := getChatLineEx(line := 0)
dout:=""
Players := getStreamedInPlayersInfo()
p := 0
For ipl, o in Players
{
    car := isTargetDriverbyId(ipl)
    if (car=="1")
    {
        speed := getTargetVehicleSpeedById(ipl)
        namecar := getTargetVehicleModelNameById(ipl)
        nick := RegExReplace(getPlayerNameById(ipl), "^(\[DM\]|\[GW\])*")
        if (speed>=135)
        {
            If (Speed>=165)
            {
                if namecar = Bullet
                {
                    return
                }
                if namecar = Infernus
                {
                    return
                }
                if namecar = Turismo
                {
                    return
                }
                if namecar = NRG-500
                {
                    return
                }
                if namecar = Elegy
                {
                    return
                }
                if namecar = Sultan
                {
                    return
                }
                if namecar = Super GT
                {
                    return
                }
                else
                {
                AddChatMessageEx("FFFFFF", "{FF0000}(SH){FF0000} " nick " [ID:" ipl "] {FFFFFF}возможно использует SpeedHack! Авто:{FF0000} " namecar " {FFFFFF}| Скорость:{FF0000} " Speed)
                    Sleep 2000
                }
            }
            Else
            {
            AddChatMessageEx("FFFFFF", "{32CD32}(SH){32CD32} " nick " [ID:" ipl "] {FFFFFF}возможно использует SpeedHack! Авто:{32CD32} " namecar " {FFFFFF}| Скорость:{32CD32} " Speed)
                Sleep 2000
            }
        }
    }
}
return
~$vk9::
{
    tab := 1
}
return
VKRun:
Run, https://vk.com/rewaver
return
Metka:
Run, https://vk.com/rewaver
return
Reload:
Reload
21GuiClose:
Gui, 21:Destroy
return
20GuiClose:
Gui, 20:Destroy
return
19GuiClose:
Gui, 19:Destroy
return
13GuiClose:
Gui, 13:Destroy
return
12GuiClose:
Gui, 12:Destroy
return
11GuiClose:
Gui, 11:Destroy
return
10GuiClose:
Gui, 10:Destroy
Return
9GuiClose:
Gui, 9:Destroy
return
8GuiClose:
Gui, 8:Destroy
return
7GuiClose:
Gui, 7:Destroy
return
6GuiClose:
Gui, 6:Destroy
return
5GuiClose:
Gui, 5:Destroy
return
4GuiClose:
Gui, 4:Destroy
return
3GuiClose:
Gui, 3:Destroy
return
2GuiClose:
Gui, 2:Destroy
return
GuiClose:
Gui, 77:Destroy
return
77GuiClose:
ExitApp
return
/*
Автор скрипта: FRIENDZONE
Модифицировал скрипт: VINCENTE SOPRANO
*/
