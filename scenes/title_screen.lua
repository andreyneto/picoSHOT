title_screen = {
    init = function ()
        global.game_state = "title_screen"
    end,
    update = function()
        sfxok()
        if btnp(4) then
			shots.init()
            shots.shots = {
                {x = -100, y = -100, point = 6, success = true},
                {x = -100, y = -100, point = 0, success = false},
                {x = -100, y = -100, point = 0, success = false},
                {x = -100, y = -100, point = 9, success = true},
                {x = -100, y = -100, point = 10, success = true}
            }
            results.init()
        end
    end,
    draw = function()
        cls()
        rectfill(0,0,127,127,9)
        rectfill(0,48,127,127-48,14)
        pal(9,129,1)
        pal(14,140,1)
        -- Desenha as instruções na tela
        printc("rodada #"..#results.results + 1, 20, 7)
        printc(#results.players.." COMPETIDORES", 52, 7)
        printc("5 TIROS", 62, 7)
        printc("5 SEGUNDOS POR TIRO", 72, 7)
        print("ok🅾️", 105, 115, 7)
    end
}