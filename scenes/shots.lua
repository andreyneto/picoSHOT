player = {}
--  = {
--     adjust_speed = 1,  -- Velocidade do ajuste da mira
--     oscillation_speed = 1,  -- Velocidade de oscilação da mira
--     precision = 50,  -- Precisão inicial
--     precision_recovery_rate = 5,  -- Taxa de recuperação de precisão
--     precision_decay_rate = 0.75, -- Taxa de perca de precisão
--     oscillation_deceleration = 0.975,  -- Fator de desaceleração da oscilação
--     randomness_factor = 1,
-- }


shots = {
    init = function()
        global.game_state = "shots"
        shots.state = "next_shot"
        shots.horizontal = 0
        shots.vertical = 0
        shots.precision = player.precision  -- Usando a precisão do jogador
        shots.shot_timer = 5 * 60
        shots.h_oscillation = 0
        shots.v_oscillation = 0
        shots.h_speed = player.oscillation_speed  -- Usando a velocidade de oscilação do jogador
        shots.v_speed = player.oscillation_speed  -- Usando a velocidade de oscilação do jogador
        shots.precision_x = 64
        shots.precision_y = 64
        shots.shot_x = 0
        shots.shot_y = 0
        shots.shots = {}
        shots.max_shots = 5
        shots.current_shot = 1
        shots.next_shot_timer = 5 * 60
        shots.radius_limit = 36
        shots.shake_intensity = 0
        shots.shake_duration = 0
    end,

    positioning = {
        update = function()
            if shots.shot_timer > 0 then
                shots.shot_timer = shots.shot_timer - 1
            else
                add(shots.shots, {x = -100, y = -100, point = 0, success = false})
                shots.state = "next_shot"
                shots.next_shot_timer = 5 * 60
            end

            if btn(0) then
                shots.h_speed = shots.h_speed - 0.05 * player.adjust_speed  -- Ajuste com base na velocidade do ajuste
                if shots.h_speed == 0 then shots.h_speed = -0.05 end
            elseif btn(1) then
                shots.h_speed = shots.h_speed + 0.05 * player.adjust_speed  -- Ajuste com base na velocidade do ajuste
                if shots.h_speed == 0 then shots.h_speed = 0.05 end
            end

            if btn(2) then
                shots.v_speed = shots.v_speed - 0.05 * player.adjust_speed  -- Ajuste com base na velocidade do ajuste
                if shots.v_speed == 0 then shots.v_speed = -0.05 end
            elseif btn(3) then
                shots.v_speed = shots.v_speed + 0.05 * player.adjust_speed  -- Ajuste com base na velocidade do ajuste
                if shots.v_speed == 0 then shots.v_speed = 0.05 end
            end

            shots.h_oscillation = shots.h_oscillation + shots.h_speed
            shots.v_oscillation = shots.v_oscillation + shots.v_speed

            local distance_from_center = sqrt(shots.h_oscillation^2 + shots.v_oscillation^2)
            if distance_from_center > shots.radius_limit + 14 then
                local angle = atan2(shots.v_oscillation, shots.h_oscillation)
                shots.h_oscillation = sin(angle) * (shots.radius_limit + 14)
                shots.v_oscillation = cos(angle) * (shots.radius_limit + 14)
                shots.h_speed = 0
                shots.v_speed = 0
            end

            shots.h_speed = shots.h_speed * player.oscillation_deceleration  -- Usando o fator de desaceleração
            shots.v_speed = shots.v_speed * player.oscillation_deceleration  -- Usando o fator de desaceleração

            if shots.precision > 0 then
                shots.precision = shots.precision - player.precision_decay_rate
            end

            if btnp(5) then
                shots.precision = min(shots.precision + player.precision_recovery_rate, 100)  -- Usando a taxa de recuperação de precisão do jogador
            end

            if btnp(4) then
                local center_x = 64
                local center_y = 64

                local current_x = center_x + shots.h_oscillation
                local current_y = center_y + shots.v_oscillation

                local distance_from_center = sqrt((current_x - center_x)^2 + (current_y - center_y)^2)

                local precision = shots.precision
                local success = true

                if distance_from_center > 36 then
                    shots.horizontal = flr(shots.h_oscillation)
                    shots.vertical = flr(shots.v_oscillation)
                    shots.shake_intensity = 3
                elseif precision > 80 then
                    shots.horizontal = flr(shots.h_oscillation)
                    shots.vertical = flr(shots.v_oscillation)
                    shots.shake_intensity = 1
                else 
                    local max_deviation = shots.radius_limit * (1 - precision / 100) * player.randomness_factor
                    shots.horizontal = flr(shots.h_oscillation + rnd(max_deviation) - max_deviation / 2)
                    shots.vertical = flr(shots.v_oscillation + rnd(max_deviation) - max_deviation / 2)
                    shots.shake_intensity = 2
                end

                shots.shot_x = shots.horizontal
                shots.shot_y = shots.vertical

                local registered_distance = sqrt(shots.shot_x^2 + shots.shot_y^2)
                local point = 0
                if registered_distance <= 3 then
                    point = 10
                elseif registered_distance <=6 then
                    point = 9
                elseif registered_distance <=16 then
                    point = 8
                elseif registered_distance <=26 then
                    point = 7
                elseif registered_distance <=36 then
                    point = 6
                else
                    success = false
                end

                add(shots.shots, {x = shots.shot_x, y = shots.shot_y, success = success, point = point})

                shots.state = "next_shot"
                shots.next_shot_timer = 5 * 60

                shots.shake_duration = 10
            end

            local t = 0.5 + (shots.precision / 100) * 0.5

            shots.precision_x = lerp(shots.precision_x, 64 + shots.h_oscillation, t)
            shots.precision_y = lerp(shots.precision_y, 64 + shots.v_oscillation, t)
        end,

        draw = function()
            shots.draw_timer(shots.shot_timer, 8, 8, 10, 4)

            local indicator_x = 64 + shots.h_oscillation
            local indicator_y = 64 + shots.v_oscillation
            line(indicator_x - 5, indicator_y, indicator_x + 5, indicator_y, 8)
            line(indicator_x, indicator_y - 5, indicator_x, indicator_y + 5, 8)
            circ(indicator_x, indicator_y, 2, 8)

            local precision_circle_radius = 25 - (shots.precision / 100) * (25 - 2)
            circ(shots.precision_x, shots.precision_y, precision_circle_radius, 7)
        end
    },

    next_shot = {
        text = "",
        state = "hidden", -- Estados: "hidden", "sliding_in", "visible", "sliding_out"
        x_position = 127, -- Começa fora da tela à direita
        color = 12,
        update = function()
            local last_shot = shots.shots[#shots.shots]
            if last_shot != nil then
                if last_shot.x == -100 then
                    shots.next_shot.text = "TEMPO ESGOTADO"
                    shots.next_shot.color = 8
                elseif last_shot.point == 0 then
                    shots.next_shot.text = "VOCE ERROU"
                    shots.next_shot.color = 8
                else
                    shots.next_shot.text = last_shot.point .. " PONTOS"
                    shots.next_shot.color = 11
                end
            else 
                shots.next_shot.text = "PREPARE-SE"
                    shots.next_shot.color = 12
            end
            if shots.next_shot_timer > 0 then
                if shots.next_shot_timer == 5 * 60 then
                    shots.next_shot.state = "sliding_in"
                    shots.next_shot.x_position = 127
                end
                shots.next_shot_timer = shots.next_shot_timer - 1
            else
                if shots.current_shot < shots.max_shots then
                    shots.current_shot = shots.current_shot + 1
                    shots.state = "positioning"
                    shots.shot_timer = 5 * 60
                    shots.precision = player.precision  -- Reinicia a precisão do jogador
                else
                    fade(true, function ()
                        global.game_state = "results"
                    end)
                end
            end
        end,

        draw = function()
            if shots.next_shot.state == "sliding_in" then
                shots.next_shot.x_position = shots.next_shot.x_position - 2
                if shots.next_shot.x_position <= 127 - #shots.next_shot.text * 4 then
                    shots.next_shot.x_position = 127 - #shots.next_shot.text * 4
                    shots.next_shot.state = "visible"
                end
            elseif shots.next_shot.state == "visible" then
                if shots.next_shot_timer <= 60 then
                    shots.next_shot.state = "sliding_out"
                end
            elseif shots.next_shot.state == "sliding_out" then
                shots.next_shot.x_position = shots.next_shot.x_position + 2
                if shots.next_shot.x_position >= 127 then
                    shots.next_shot.state = "hidden"
                end
            end
    
            if shots.next_shot.state ~= "hidden" then
                rectfill(shots.next_shot.x_position - 10, 8, 119, 16, shots.next_shot.color)
                print(shots.next_shot.text, shots.next_shot.x_position - 8, 10, 7)
                rectfill(120,0,128,128,9)
            end

            local last_shot = shots.shots[#shots.shots]
            if(last_shot != nil) then
                local x_pos = 64 + last_shot.x
                local y_pos = 64 + last_shot.y
                line(x_pos - 5, y_pos - 5, x_pos + 5, y_pos + 5, 8)
                line(x_pos - 5, y_pos + 5, x_pos + 5, y_pos - 5, 8)

                local precision_circle_radius = 25 - (shots.precision / 100) * (25 - 2)
                circ(shots.precision_x, shots.precision_y, precision_circle_radius, 7)
            end

            shots.draw_timer(shots.next_shot_timer, 8, 8, 10, 4)
        end
    },

    apply_shake = function()
        local shake_x = 0
        local shake_y = 0
        if shots.shake_duration > 0 then
            shake_x = rnd(shots.shake_intensity) - shots.shake_intensity / 2
            shake_y = rnd(shots.shake_intensity) - shots.shake_intensity / 2
            shots.shake_duration = shots.shake_duration - 1
        end
        camera(shake_x, shake_y)
    end,

    draw_shots = function ()        
        local positions = {
            {x = 10, y = 109},
            {x = 10, y = 117},
            {x = 18, y = 109},
            {x = 18, y = 117},
            {x = 26, y = 117}
        }

        for i, pos in ipairs(positions) do
            local color = 5
            if shots.shots[i] then
                color = shots.shots[i].success and 11 or 8
            end
            circfill(pos.x, pos.y, 2, color)
        end
    end,
    draw_timer = function(timer, x, y, width, height)
        rect(x, y, x + width, y + height, 6)
        rectfill(x, y, x + (timer / (5 * 60)) * width, y + height, 8)
        local remaining_time = ceil(timer / 60)
        print(remaining_time .. "S", x, y + height + 2, 7)
    end,
    draw_background = function ()
        rectfill(0,0,127,127,9)
        circ(64, 64, shots.radius_limit, 1)
        circfill(64, 64, 26, 1)
        circfill(64, 64, 16, 14)
        circfill(64, 64, 6, 12)
        circ(64, 64, 3, 1)
        line(40,40,44,44,1)
        line(44,84,40,88,1)
        line(84,44,88,40,1)
        line(84,84,88,88,1)
        line(47,47,51,51,9)
        line(51,77,47,81,9)
        line(77,51,81,47,9)
        line(77,77,81,81,9)
        line(53,53,59,59,1)
        line(59,69,53,75,1)
        line(69,59,75,53,1)
        line(69,69,75,75,1)
        line(64,30,64,36,1)
        line(64,49,64,56,1)
        line(64,72,64,79,1)
        line(64,92,64,98,1)
        line(30,64,36,64,1)
        line(49,64,56,64,1)
        line(72,64,79,64,1)
        line(92,64,98,64,1)
        pal(9,129,1)
        pal(14,140,1)
        for y = 0, 127 do
            local dx = sqrt(50^2 - (y - 64)^2) or 0
            line(0, y, 64 - dx, y, 9)
            line(64 + dx, y, 127, y, 9)
        end
    end,
    update = function () 
        if shots.state == "positioning" then
            shots.positioning.update()
        elseif shots.state == "next_shot" then
            shots.next_shot.update()
        end
    end,
    draw = function ()
        cls()
        shots.apply_shake()
        shots.draw_background()
        if shots.state == "positioning" then
            shots.positioning.draw()
        elseif shots.state == "next_shot" then
            shots.next_shot.draw()
        end
        shots.draw_shots()
        spr(player.sm, 103,103,3,3)
    end
}