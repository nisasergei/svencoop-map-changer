// Регистрируем хук на чат
void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor("Nisa");
    g_Module.ScriptInfo.SetContactInfo("https://boosty.to/nisarium");
    
    g_Hooks.RegisterHook( Hooks::Player::ClientSay, @ClientSay );
}

// Функция, которая ловит сообщения в чате
HookReturnCode ClientSay( SayParameters@ pParams )
{
    CBasePlayer@ pPlayer = pParams.GetPlayer();
    const CCommand@ args = pParams.GetArguments();
    
    // Проверяем, что игрок существует
    if ( pPlayer is null )
        return HOOK_CONTINUE;
    
    // Если первое слово в чате — "!map" или "/map"
    if ( args.ArgC() >= 2 )
    {
        string command = args[0];
        if ( command == "!map" || command == "/map" )
        {
            string mapName = args[1];
            
            // Проверяем, существует ли такая карта на сервере
            if ( !g_EngineFuncs.IsMapValid( mapName ) )
            {
                g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "[СИСТЕМА] Карта \"" + mapName + "\" не найдена!\n" );
                return HOOK_HANDLED; // Скрываем сообщение из чата
            }
            
            // Сообщаем всем, что карта меняется
            g_PlayerFuncs.ClientPrintAll( HUD_PRINTTALK, "[СИСТЕМА] Игрок " + pPlayer.pev.netname + " меняет карту на \"" + mapName + "\"!\n" );
            
            // Меняем карту (сразу)
            g_EngineFuncs.ChangeLevel( mapName );
            
            // Возвращаем HOOK_HANDLED, чтобы сообщение "!map ..." не показывалось в чате
            return HOOK_HANDLED; 
        }
    }
    
    return HOOK_CONTINUE;
}