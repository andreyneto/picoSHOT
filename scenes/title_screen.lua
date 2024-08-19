title_screen = {
    init = function ()
        global.game_state = "title_screen"
    end,
    update = function()
        sfxok()
        if btnp(4) then
            fade(true, function ()
                shots.init()
            end)
        end
    end,
    draw = function()
        cls()
        bg()
        -- Desenha as instruções na tela
        title("rodada #"..#results.results + 1)
        printc((#results.players+1).." COMPETIDORES", 52, 7)
        printc("5 TIROS", 62, 7)
        printc("5 SEGUNDOS POR TIRO", 72, 7)
        actions(true)
    end
}