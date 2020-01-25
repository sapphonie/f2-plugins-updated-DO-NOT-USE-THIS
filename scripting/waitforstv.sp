/*
Release notes:

---- 1.0.0 (01/11/2013) ----
- Waits for STV when changing level
- Only waits the necessary amount of time
- 'stopchangelevel' supported


---- 1.0.1 (15/05/2014) ----
- Improved support for CTF maps


---- 1.0.2 (26/05/2014) ----
- Improved support for CTF maps further


---- 1.1.0 (27/09/2015) ---
- Automatically sets tv_delaymapchange_protect to 0... If you want to use tv_delaymapchange_protect, then remove this plugin.
- Support for new ready-up behaviour

---- 1.1.1 (21/01/2020) ---
- Rewrote entire plugin (forked from rglqol)
- No longer forcibly changes level
- now prints in chat on game end and when STV is done broadcasting
- warns user before changing level with active stv broadcast
- unloads plugins that force map changes if not unloaded

---- 1.1.2 (21/01/2020) ---
- fixed updatefile

---- 1.1.3 (21/01/2020) ---
- now autounloads if it detects rglqol running

*/

#pragma semicolon 1

#include <sourcemod>
#include <tf2_stocks>
#include <morecolors>
// #include <tf2_stocks>
// #include <f2stocks>
// #include <match>
#undef REQUIRE_PLUGIN
#include <updater>


#define PLUGIN_VERSION "1.1.3"
#define UPDATE_URL     "https://raw.githubusercontent.com/stephanieLGBT/f2-plugins-updated/master/waitforstv-updatefile.txt"


new isStvDone = -1;
new Handle:g_hSafeToChangeLevel = INVALID_HANDLE;
new bool:warnedStv;
new bool:IsSafe;


public Plugin:myinfo =
{
    name            = "Wait For STV",
    author          = "F2, fixed by stephanie",
    description     = "Waits for STV when changing map",
    version         = PLUGIN_VERSION,
    url             = "http://sourcemod.krus.dk/"
};

public OnPluginStart()
{
    // hooks round start events
    HookEvent("teamplay_round_active", EventRoundActive);

    // hooks game over events
    // shoutouts to lange, borrowed this from soap_tournament.smx here: https://github.com/Lange/SOAP-TF2DM/blob/master/addons/sourcemod/scripting/soap_tournament.sp#L48

    // Win conditions met (maxrounds, timelimit)
    HookEvent("teamplay_game_over", GameOverEvent);
    // Win conditions met (windifference)
    HookEvent("tf_game_over", GameOverEvent);

    RegServerCmd("changelevel", changeLvl);

    CreateTimer(5.0, checkRGL);
}

public Action GameOverEvent(Handle event, const char[] name, bool dontBroadcast)
{
    isStvDone = 0;
    CreateTimer(95.0, SafeToChangeLevel, TIMER_DATA_HNDL_CLOSE | TIMER_FLAG_NO_MAPCHANGE);
    // this is to prevent server auto changing level
    CreateTimer(5.0, unloadMapChooserNextMapANDprinttochat, TIMER_DATA_HNDL_CLOSE | TIMER_FLAG_NO_MAPCHANGE);
}


public Action checkRGL(Handle:timer)
{
    new Handle:rgl_cast = FindConVar("rgl_cast");
    if (rgl_cast == INVALID_HANDLE)
    {
        //
    }
    else
    {
        LogMessage("[WaitForSTV] RGLQoL plugin detected! Unloading to prevent conflicts.");
        ServerCommand("sm plugins unload waitforstv");
    }
}


public Action SafeToChangeLevel(Handle timer)
{
    isStvDone = 1;
    if (!IsSafe)
    {
        CPrintToChatAll("{lightgreen}[WaitForSTV] {default}STV done broadcasting. It is now safe to changelevel.");
        // this is to prevent double printing
        IsSafe = true;
    }
}

public Action unloadMapChooserNextMapANDprinttochat(Handle timer)
{
    ServerCommand("sm plugins unload nextmap");
    ServerCommand("sm plugins unload mapchooser");
    CPrintToChatAll("{lightgreen}[WaitForSTV] {default}Game has ended. Wait 90 seconds to changelevel to avoid cutting off actively broadcasting STV. This can be overridden with a second changelevel command.");
}

public Action EventRoundActive(Handle event, const char[] name, bool dontBroadcast)
{
    // prevents stv done notif spam if teams play another round before 90 seconds have passed
    delete g_hSafeToChangeLevel;
}

public Action changeLvl(int args)
{
    if (warnedStv)
    {
        return Plugin_Continue;
    }
    else if (isStvDone != 0)
    {
        return Plugin_Continue;
    }
    else
    {
        PrintToServer("\n*** Refusing to changelevel! STV is still broadcasting. If you don't care about STV, changelevel again to force a map change. ***\n");
        warnedStv = true;
        ServerCommand("tv_delaymapchange 0");
        ServerCommand("tv_delaymapchange_protect 0");
        return Plugin_Stop;
    }
}

