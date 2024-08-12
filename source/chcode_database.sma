#include <amxmodx>
#include <nvault>

new DataBase;
const DataBaseBots = 0;
const DataBaseType = 3; // 1=Name | 2=IP | 3=VALVE_ID

public plugin_init() {
	register_plugin("[CH] Advanced Database", "v2.00", "--chcode");
	DataBase = nvault_open("class_cdata");
}

public client_disconnected(id) {
	if(is_user_bot(id) && !DataBaseBots) {
		return;
	}
	
	DataSave(id);
}

public client_connect(id) {
	if(is_user_bot(id) && !DataBaseBots) {
		return;
	}
	
	DataLoad(id);
}

public DataSave(id) {
	new szAuth[33];
	
	switch(DataBaseType) {
		case 1: get_user_name(id , szAuth , charsmax(szAuth));
		case 2: get_user_ip(id , szAuth , charsmax(szAuth));
		case 3: get_user_authid(id , szAuth , charsmax(szAuth));
	}
	
	new szKey[64]; formatex(szKey , 63 , "%s" , szAuth);
	new szData[256]; formatex(szData , 255 , "%s#%s#%s#", "x", "a", "b");
	
	nvault_pset(DataBase , szKey , szData);
}

public DataLoad(id) {
	new szAuth[33];
	
	switch(DataBaseType) {
		case 1: get_user_name(id , szAuth , charsmax(szAuth));
		case 2: get_user_ip(id , szAuth , charsmax(szAuth));
		case 3: get_user_authid(id , szAuth , charsmax(szAuth));
	}
	
	new szKey[40]; formatex(szKey , 63 , "%s" , szAuth);
	new szData[256]; formatex(szData , 255, "%s#%s#%s#", "x", "a", "b");
	
	nvault_get(DataBase, szKey, szData, 255);
	replace_all(szData , 255, "#", " ");
	
	new Data[33];
	new BData[33][33];
	new LData; LData = DataString(szData, strlen(szData));
	
	for(new i = 0; i < LData; i++) {
		ParseString(szData, charsmax(Data), Data);
		format(BData[i], 32, "%s", Data);
	}
	
	for(new i = 0; i < LData; i++) {
		// here is the area that we will use to print data to global variables.
		// example for numbers: client_data[id] = str_to_num(BData[i]);
		// example for strings: format(client_data[id], charsmax(client_data), "%s", BData[i]);
		// to use this area, remove the break; function.
		break;
	}
}

public ParseString(text[], len, part[]) {
	parse(text, part, len);
	replace_string(text, len, part, "");
}

public DataString(text[], len) {
	new solid_data[128]; formatex(solid_data, 127, "%s", text);
	new result;
	result = replace_all(solid_data, len, " ", "/");
	return result;
}