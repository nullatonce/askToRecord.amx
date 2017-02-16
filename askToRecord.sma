
Skip to content

    All gists
    GitHub

    New gist

    0

@nullatonce nullatonce/amx_askToRecord
Created 6 hours ago
Code
Revisions 1
amx_askToRecord
/****************************************/
/*					*/
/*	Auto Demo Recorder		*/
/*	by IzI				*/
/*		
*/
/****************************************/

#include <amxmodx>
#pragma semicolon 1

new g_Toggle, g_DMod, g_UseNI, g_RStartAfter, g_DemoName, g_DemoNamePrefix;

public plugin_init() { 
	register_plugin( "Auto Demo Recorder", "1.5", "IzI" );
	g_Toggle 		= register_cvar( "amx_demo",		"1" );
	g_DMod			= register_cvar( "amx_demo_mode",	"0" );
	g_UseNI 		= register_cvar( "amx_demo_steamid",	"0" );
	register_clcmd( "ask_for_demo","askRecord" );
	g_RStartAfter 		= register_cvar( "amx_demo_rectime",	"15" );	// If it is less than 5, it will automatically set to 5, but willn't apply the changes to the console. I recoment to use default settings.
	g_DemoName 		= register_cvar( "amx_demo_name",	"Autorecorded demo" );
	g_DemoNamePrefix	= register_cvar( "amx_demo_prefix",	"AMXX" );
	register_dictionary( "demorecorder.txt" );
}

public client_putinserver( id ) {
	if( get_pcvar_num( g_Toggle ) ) {
		new Float:delay = get_pcvar_float( g_RStartAfter );
		if( delay < 5 )
			set_pcvar_float( g_RStartAfter, ( delay = 5.0 ) );
		set_task( delay, "askRecord", id );
	}
}

public askRecord( id ) {
		new askRecordMenu = menu_create( "\rAr norite áraðinëti demo ?", "askRecordMenu_handler" );
		
		menu_additem( askRecordMenu, "\wTaip, áraðinëti", "", 0 );
		menu_additem( askRecordMenu, "\wNe, atsisakysiu", "", 0 );
		
		menu_setprop( askRecordMenu, MPROP_EXIT, MEXIT_ALL );
		
		menu_display( id, askRecordMenu, 0 );
		
}

public askRecordMenu_handler ( id, menu, item ) {
	switch ( item ) {
		case 0 :
		{
			new Float:delay = get_pcvar_float( g_RStartAfter );
			if( delay < 5 )
				set_pcvar_float( g_RStartAfter, ( delay = 5.0 ) );
			set_task( delay, "Record", id );

			client_print( id, print_chat, "Tuojau pradësite demo áraðà",);
			
			menu_destroy( menu );
			return PLUGIN_HANDLED;
		}
		case 1: 
		{
			client_print( id, print_chat, "Demo nebus daromas." );
			client_print( id, print_chat, "Norëdami pradëti daryti demo naudokitës konsolës komandomis" );
			
			menu_destroy( menu );
			return PLUGIN_CONTINUE;
		}
	}
	
	return PLUGIN_HANDLED;
}

public Record( id ) {
	if( !is_user_connected( id ) || get_pcvar_num( g_Toggle ) != 1 )
		return;

	// Getting time, client SteamID, server's name, server's ip with port.
	new szSName[128], szINamePrefix[64], szTimedata[9];
	new iUseIN = get_pcvar_num( g_UseNI );
	new iDMod = get_pcvar_num( g_DMod );
	get_pcvar_string( g_DemoNamePrefix, szINamePrefix, 63 );
	get_time ( "%H:%M:%S", szTimedata, 8 );

	switch( iDMod ) {
		case 0: get_pcvar_string( g_DemoName, szSName, 127 );
		case 1: get_user_ip( 0, szSName, 127, 0 );
		case 2: get_user_name( 0, szSName, 127 );
	}

	if( iUseIN ) {
		new szCID[32];
		get_user_authid( id, szCID, 31 );
		format( szSName, 127, "[%s]%s", szCID, szSName );
	}

	// Replacing signs.
	replace_all( szSName, 127, ":", "_" );
	replace_all( szSName, 127, ".", "_" );
	replace_all( szSName, 127, "*", "_" );
	replace_all( szSName, 127, "/", "_" );
	replace_all( szSName, 127, "|", "_" );
	replace_all( szSName, 127, "\", "_" );
	replace_all( szSName, 127, "?", "_" );
	replace_all( szSName, 127, ">", "_" );
	replace_all( szSName, 127, "<", "_" );
	replace_all( szSName, 127, " ", "_" );

	// Displaying messages.
	client_cmd( id, "stop; record ^"%s^"", szSName );
	client_print( id, print_chat, "[%s] %L ^"%s.dem^"", szINamePrefix, LANG_PLAYER, "RECORDINGIN", szSName );
	client_print( id, print_chat, "[%s] %L", szINamePrefix, LANG_PLAYER, "RECORDINGAT", szTimedata );
}
@nullatonce

Attach files by dragging & dropping,

, or pasting from the clipboard.
Styling with Markdown is supported

    Contact GitHub API Training Shop Blog About 

    © 2017 GitHub, Inc. Terms Privacy Security Status Help 

