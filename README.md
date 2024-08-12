### ` ❔ `  `AMXX NVault DataBase`
- NVault The method of saving data is
- You can easily write your data in this script

### ` ❓ `  `Data Base Settings`
** **
#### **`Should he save the data for the bots?`**
- **DataBaseBots** = 0 | `Default: 0`
- **1** | ___`Allows bots to save data`___
- **0** | ___`Does not allow bots to save data`___
** **
#### **`Type of data saving`**
- **DataBaseType** = 3 | `Default: 3`
- **1** | ___`Saves to the username`___
- **2** | ___`Saves to the ip`___
- **3** | ___`Saves to the valve_id`___
** **
#### **`Database file name`**
- **DataBaseName** = "main_cdata" | `Default: "main_cdata"`
- The name of this database is in the `"amxmodx/data/vault"` section
- creates a file with the following name `"main_cdata.vault"`
** **
### ` ❓ `  `How is the data extracted?`
-		// here is the area that we will use to print data to global variables.
-		// example for numbers: client_data[id] = str_to_num(BData[i]);
-		// example for strings: format(client_data[id], charsmax(client_data), "%s", BData[i]);
-		// to use this area, remove the break; function.

**Code:**
```pawn
#include <amxmodx>
#include <nvault>

new DataBase;
const DataBaseBots = 0;
const DataBaseType = 3; // 1=Name | 2=IP | 3=VALVE_ID
new const DataBaseName = "main_cdata";

public plugin_init() {
	register_plugin("[CH] Advanced Database", "v2.00", "--chcode");
	DataBase = nvault_open(DataBaseName);
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
```

![Picsart_24-08-12_15-48-00-500](https://github.com/user-attachments/assets/00bbd518-d0e9-4524-990c-cb04c9dd340d)
