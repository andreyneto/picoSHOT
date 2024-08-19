results = {
    results = {},
    players = {},
    current_round = {},
    reset = function ()
        results.current_round = {}
        results.results = {}
        results.players = {}
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
            points = total_points,
            flag = player.flag
        })
        
        for _, competitor in ipairs(results.players) do
            local competitor_points = 0
            for j = 1, 5 do
                -- Gerar um ponto aleatório entre 6 e 10
                local random_points = flr(rnd(5)) + 6
                competitor_points = competitor_points + random_points
            end
            add(results.current_round, {
                player = competitor.name,
                points = competitor_points,
                flag = competitor.flag
            })
        end

        -- Adiciona a rodada atual à lista de rodadas
        add(results.results, results.current_round)
    end,

    update = function()
        if btnp(4) then
            fade(true, function ()
                classification.init() 
            end)
        end
    end,

    draw = function()
        cls()
        palt(0, true)
        bg(48,32)
        -- Desenha as instruções na tela
        title("rodada #"..#results.results)
    
        -- Desenhar sprite 8x8 (substitua 'spritenum' pelo número do sprite)
        spr(player.flag, 8, 60)
    
        -- Nome do tiro
        print(player.name, 24, 62, 7)
    
        -- Itera sobre os tiros para desenhar as bolinhas e somar os pontos
        for i, shot in ipairs(shots.shots) do
            local color = shot.success and 11 or 8 -- Verde para pontos, vermelho para o restante
            circfill(56 + (i * 8), 64, 2, color)
        end
    
        -- Soma de pontos
        print(total_points, 110, 62, 7)
    
        actions(true)
    end
}