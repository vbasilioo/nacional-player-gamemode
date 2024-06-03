#include "../SDK/plugin.h"
#include "iostream"
#include "fstream"
#include "windows.h"

typedef void 
    (*logprintf_t)(char* format, ...)
;

logprintf_t 
    logprintf
;

void 
    **ppPluginData
;

extern void 
    *pAMXFunctions
;

PLUGIN_EXPORT bool PLUGIN_CALL Load(void **ppData)
{
   pAMXFunctions = ppData[PLUGIN_DATA_AMX_EXPORTS];
   logprintf = (logprintf_t)ppData[PLUGIN_DATA_LOGPRINTF];
   return 1;
}

PLUGIN_EXPORT void PLUGIN_CALL Unload()
{
}

static cell AMX_NATIVE_CALL PAWN_GetKeys(AMX *amx, cell *params)
{
    if(GetAsyncKeyState(params[1]) != 0) return 1;
    return 0;
}

AMX_NATIVE_INFO projectNatives[] =
{
        { "IsKeyDown", PAWN_GetKeys }
};


PLUGIN_EXPORT unsigned int PLUGIN_CALL Supports()
{
   return SUPPORTS_VERSION | SUPPORTS_AMX_NATIVES;
}

PLUGIN_EXPORT int PLUGIN_CALL AmxLoad(AMX *amx)
{
   return amx_Register(amx, projectNatives, -1);
}

PLUGIN_EXPORT int PLUGIN_CALL AmxUnload(AMX *amx)
{
   return AMX_ERR_NONE;
}
