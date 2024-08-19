how_to_play = {
    t=0,
    c=1,
    init = function()
        global.game_state = "how_to_play"
        t=0
        c=1
    end,

    update = function()
        if btnp(❎) then
            sfxback()
            fade(false, function ()
                menu.init()
            end)
        end
        t+=1

        if t > 30 then
            c+=1
            if c>2 then c=1 end
            t =0
        end
    end,

    draw = function()
        cls()
        bg()
        title("cOMO JOGAR")
        -- Desenha as instruções na tela
        local d = {"⬅️➡️","⬆️⬇️"}
        printc(d[c] .. " mira ", 52, 7)
        printc("❎ precisao", 62, 7)
        printc("🅾️ atirar", 72, 7)
        actions(false, true)
    end
}

