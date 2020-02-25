#include <sourcemod>
#include <sdktools>

#pragma semicolon 1

#pragma newdecls required

#define MAX_WEAPONS 56

public Plugin myinfo = {
	name = "Give Weapon & Item",
	author = "Kiske, Kento",
	description = "Give a weapon or item to a player from a command",
	version = "1.1",
	url = "http://www.sourcemod.net/"
};

char g_weapons[MAX_WEAPONS][] = {
	"item_cutters",
	"item_defuser",
	"item_heavyassaultsuit",
	"item_item_assaultsuit",
	"item_kevlar",
	"item_nvgs",
	"weapon_ak47",
	"weapon_aug",
	"weapon_awp",
	"weapon_axe",
	"weapon_bizon",
	"weapon_breachcharge",
	"weapon_cz75a",
	"weapon_deagle",
	"weapon_decoy",
	"weapon_elite",
	"weapon_famas",
	"weapon_fists",
	"weapon_fiveseven",
	"weapon_flashbang",
	"weapon_g3sg1",
	"weapon_galilar",
	"weapon_glock",
	"weapon_hammer",
	"weapon_healthshot",
	"weapon_hegrenade",
	"weapon_hkp2000",
	"weapon_inferno",
	"weapon_knife",
	"weapon_knifegg",
	"weapon_m249",
	"weapon_m4a1_silencer",
	"weapon_m4a1",
	"weapon_mac10",
	"weapon_mag7",
	"weapon_mp5sd",
	"weapon_mp7",
	"weapon_mp9",
	"weapon_negev",
	"weapon_nova",
	"weapon_p250",
	"weapon_p90",
	"weapon_revolver",
	"weapon_sawedoff",
	"weapon_scar20",
	"weapon_sg556",
	"weapon_shield",
	"weapon_smokegrenade",
	"weapon_spanner",
	"weapon_ssg08",
	"weapon_tagrenade",
	"weapon_taser",
	"weapon_tec9",
	"weapon_ump45",
	"weapon_usp_silencer",
	"weapon_xm1014"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_weapon", smWeapon, ADMFLAG_BAN, "- <target> <weaponname>");
	RegAdminCmd("sm_weaponlist", smWeaponList, ADMFLAG_BAN, "- list of the weapon names");
}

public Action smWeapon(int client, int args)
{
	if(args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_weapon <name | #userid> <weaponname>");
		return Plugin_Handled;
	}
	
	char sArg[256];
	char sTempArg[32];
	char sWeaponName[32], sWeaponToGive[32];
	int iL;
	int iNL;
	
	GetCmdArgString(sArg, sizeof(sArg));
	iL = BreakString(sArg, sTempArg, sizeof(sTempArg));
	
	if((iNL = BreakString(sArg[iL], sWeaponName, sizeof(sWeaponName))) != -1)
		iL += iNL;
	
	int iValid = 0;
	
	for(int i = 0; i < MAX_WEAPONS; ++i)
	{
		if(StrContains(g_weapons[i], sWeaponName) != -1)
		{
			PrintToChat(client, "%s, %s", sWeaponName, g_weapons[i]);
			iValid = 1;
			strcopy(sWeaponToGive, sizeof(sWeaponToGive), g_weapons[i]);
			break;
		}
	}
	if(!iValid)
	{
		ReplyToCommand(client, "[SM] The weaponname (%s) isn't valid", sWeaponName);
		return Plugin_Handled;
	}
	
	char sTargetName[MAX_TARGET_LENGTH];
	int sTargetList[MAXPLAYERS], iTargetCount;
	bool bTN_IsML;
	
	if((iTargetCount = ProcessTargetString(sTempArg, client, sTargetList, MAXPLAYERS, COMMAND_FILTER_ALIVE, sTargetName, sizeof(sTargetName), bTN_IsML)) <= 0)
	{
		ReplyToTargetError(client, iTargetCount);
		return Plugin_Handled;
	}
	
	for (int i = 0; i < iTargetCount; i++)
		GivePlayerItem(sTargetList[i], sWeaponToGive);
	
	return Plugin_Handled;
}

public Action smWeaponList(int client, int args)
{
	for(int i = 0; i < MAX_WEAPONS; ++i)
		ReplyToCommand(client, "%s", g_weapons[i]);
	
	ReplyToCommand(client, "");
	ReplyToCommand(client, "* No need to put weapon_ in the <weaponname>");
	
	return Plugin_Handled;
}
