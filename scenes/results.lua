results = {
    results = {},
    players = {},
    current_round = {},
    reset = function ()
        current_round = {}
        results = {}
        players = {}
    end,
    init = function()
        global.game_state = "results"
        results.total_points = 0
        results.current_round = {}
        -- Processar o jogador principal
        total_points = 0
        for i, shot in ipairs(shots.shots) do
            local points = shot.point or 0
            total_points = total_points + points
        end
        add(results.current_round, {
            player = player.name,
            points = total_points
        })
        
        -- Processar outros concorrentes
        for _, competitor in ipairs(results.players) do
            local competitor_points = 0
            for j = 1, 5 do
                -- Gerar um ponto aleatório entre 6 e 10
                local random_points = flr(rnd(5)) + 6
                competitor_points = competitor_points + random_points
            end
            add(results.current_round, {
                player = competitor.name,
                points = competitor_points
            })
        end

        -- Adiciona a rodada atual à lista de rodadas
        add(results.results, results.current_round)
    end,

    update = function()
        if btnp(4) then
            fade(true, function ()
			    title_screen.init() 
            end)
        end
    end,

    draw = function()
        cls()
        palt(0, true)
        rectfill(0,0,127,127,9)
        rectfill(0,48,127,127-48,14)
        pal(9,129,1)
        pal(14,140,1)
        -- Desenha as instruções na tela
        printc("rodada #"..#results.results, 20, 7)
    
        -- Desenhar sprite 8x8 (substitua 'spritenum' pelo número do sprite)
        spr(player.flag, 8, 60)
    
        -- Nome do tiro
        print(player.name, 24, 62, 7)
    
        -- Itera sobre os tiros para desenhar as bolinhas e somar os pontos
        for i, shot in ipairs(shots.shots) do
            local points = shot.point or 0
            -- Desenhar bolinhas
            for j = 1, 5 do
                local color = (j <= points) and 11 or 8 -- Verde para pontos, vermelho para o restante
                circfill(50 + (j * 10), 64, 2, color)
            end
        end
    
        -- Soma de pontos
        print(total_points, 110, 62, 7)
    
        print("ok🅾️", 105, 115, 7)
    end
}

