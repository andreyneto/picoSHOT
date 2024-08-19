classification = {
    init = function()
        global.game_state = "classification"
        total_scores = {}
        for _, round in ipairs(results.results) do
            for _, result in ipairs(round) do
                if not total_scores[result.player] then
                    total_scores[result.player] = {points = 0, flag = result.flag}
                end
                total_scores[result.player].points = total_scores[result.player].points + result.points
            end
        end

        sorted_scores = {}
        for player, data in pairs(total_scores) do
            add(sorted_scores, {player = player, points = data.points, flag = data.flag})
        end

        sort_scores(sorted_scores)

        classification.last_player = sorted_scores[#sorted_scores].player

        -- Inicializa o contador de frames e jogadores exibidos
        classification.frame_counter = 0
        classification.players_to_show = 0
        classification.last_player_frame_counter = 0
        classification.last_player_shown = false
        classification.line_width = 0
        classification.line_animation_done = false
    end,
    update = function()
        -- Incrementa o contador de frames
        classification.frame_counter = classification.frame_counter + 1

        -- A cada 30 frames, aumenta o número de jogadores a serem exibidos
        if classification.frame_counter % 30 == 0 then
            classification.players_to_show = min(classification.players_to_show + 1, #sorted_scores)
        end

        -- Se o último jogador foi exibido, começa a contar os frames para riscar
        if classification.players_to_show == #sorted_scores then
            classification.last_player_frame_counter = classification.last_player_frame_counter + 1
            if classification.last_player_frame_counter >= 30 then
                classification.last_player_shown = true
            end
        end

        -- Incrementa a largura da linha para a animação
        if classification.last_player_shown and classification.line_width < 123 then
            classification.line_width = classification.line_width + (120 / 30)
        end

        -- Verifica se a animação da linha está completa
        if classification.line_width >= 123 then
            classification.line_animation_done = true
        end
        if classification.line_animation_done then
            if btnp(4) then
                fade(true, function ()
                    printh(classification.last_player, '@clip')
                    remove_player_from_players()
                    remove_player_from_results()
                    if(classification.last_player == player.name) then
                        game_over.init()
                    else
                        title_screen.init()
                    end
                end)
            end
        end
    end,
    draw = function()
        cls()
        rectfill(0,0,127,127,11)
        title("ranking")
        pal(11,129,1)
        if(classification.players_to_show == 1 ) then
            pal()
            pal(11,129,1)
            palt(4, true)
            palt(0, false)
            pal(14,140,1)
        end
        local y = 32
        for i = 1, classification.players_to_show do
            local score = sorted_scores[i]
            local c1 = (i%2==(#results.players%2==0 and 1 or 0)) and 1 or 11
            local c2 = 7
            if score.player == player.name then
                -- c1 = 6
                c2 = 7
            end
            if i <= 3 then
                c1 = i%2 == 0 and 6 or 13
            end
            rectfill(0, y-3, 127, y+6, c1)

            if i <= 3 then
                spr(255, 4, y-2)
                spr(191+(i*16), 12, y-2)
            else
                print(i, 12, y, c2)
            end

            spr(score.flag, 24, y-2)
            print(score.player, 36, y, c2)
            print(score.points, 120-(#tostr(score.points)*4), y, c2)

            -- Desenha a linha para riscar o último jogador com animação
            if score.player == classification.last_player and classification.last_player_shown then
                line(4, y+2, classification.line_width, y+2, i>3 and 8 or 14)
            end

            y = y + 10
        end

        -- Chama actions(true) apenas após a animação da linha estar completa
        if classification.line_animation_done then
            actions(true)
        end
    end
}
function remove_player_from_results()
    -- Itera sobre cada rodada em results.results
    for _, round in ipairs(results.results) do
        local new_round = {}
        for _, result in ipairs(round) do
            if result.player ~= classification.last_player then
                add(new_round, result)
            end
        end
        -- Substitui a rodada antiga pela nova sem o último jogador
        for i = 1, #round do
            round[i] = new_round[i]
        end
        for i = #new_round + 1, #round do
            round[i] = nil
        end
    end
end

function remove_player_from_players()
    local new_players = {}
    for _, player in ipairs(results.players) do
        if player.name ~= classification.last_player then
            add(new_players, player)
        end
    end
    -- Substitui a lista antiga pela nova sem o último jogador
    for i = 1, #results.players do
        results.players[i] = new_players[i]
    end
    for i = #new_players + 1, #results.players do
        results.players[i] = nil
    end
end

function sort_scores(scores)
    for i = 1, #scores - 1 do
        local max_index = i
        for j = i + 1, #scores do
            if scores[j].points > scores[max_index].points then
                max_index = j
            end
        end
        scores[i], scores[max_index] = scores[max_index], scores[i]
    end
end