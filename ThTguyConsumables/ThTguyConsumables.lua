

--[[to do:
Add runes (negative tarots temporary gain, long term downsides)

Add Jokers (balance top 10% chips + mult, transfer 5% of mult to chips, chip multiplier, set mult to 100, reduce mult by 10% and award 1$ per 10 mult)
]]


--[[
Runes and meanings:
	Laguz (Water) : +1 discard for round
	Dagaz (Dawn) : disable boss blind, no boss reward
	OTHALA (Inheritance) : gain intrest cap * 5, lower intrest cap by 20%
    Inguz (Seed) : set money to 0, gain intrest per 5 dollars lost


	Blank : Spawn a rune, 50% chance to not get destroyed when used, +5% chance for cursed cards
]]

--talisman moment
to_big = to_big or function(num)
    return num
end

local IntrestAmt = 0


TGTMConsumables = {}

TGTMConsumables.config = SMODS.current_mod.config

SMODS.current_mod.config_tab = function()
    return {
        n = G.UIT.ROOT,
        config = {emboss = 0.05, minh = 6, r = 0.1, minw = 10, align = "cm", padding = 0.2, colour = G.C.PURPLE},
        nodes = {
            {
                n=G.UIT.R,
                config= {align = "tm"}, 
                nodes= {
                    {
                        n=G.UIT.O, 
                        config={object = DynaText({string = "Beware traveller...", colours = {G.C.WHITE}, shadow = true, scale = 0.4})}
                    },
                },
            },
            {
                n=G.UIT.R,
                config= {align = "tm"}, 
                nodes= {
                    {
                        n=G.UIT.O,
                        config={object = DynaText({string = "Lest you want to be cursed ...", colours = {G.C.WHITE}, shadow = true, scale = 0.4})}
                    }
                }
            },
                    
            {
                n=G.UIT.R,
                config= {align = "cm"}, 
                nodes={
                    create_toggle({
                        label = "Disable Rune Downsides..?", 
                        ref_table = TGTMConsumables.config, 
                        ref_value = "CursedRunes",
                    }),
                }
            },
            
        
        }
    }
end



--Globals
local startRef = Game.start_run
function Game:start_run(args)
    startRef(self, args)

    --reduce hand size by x after round
    G.GAME.TGTMchangeHandSize = 0
    --Get intrest amount
    IntrestAmt = G.GAME.interest_cap
    --Chance for a card to get cursed
    G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance or 0
    --Buff Face Card for a round
    G.GAME.TGTMFaceBuff = G.GAME.TGTMFaceBuff or false

    G.GAME.TGTMBPbuff = G.GAME.TGTMBPbuff or false    

end

SMODS.Shader({
    key = "cursed",
    path = "cursed.fs"
})
SMODS.Shader({
    key = "pure",
    path = "pure.fs"
})
SMODS.Shader({
    key = "broken",
    path = "broken.fs"
})


SMODS.Enhancement{
    --Blank
    key = "Blank",
    atlas = "Tatatro",
    pos = {x = 5, y = 2},
    unlocked = true,
    discovered = true,
    --Has no suit or rank
    no_suit = true,
    no_rank = true,
    --goes over card
    replace_base_card = true,
    --scores 0 chips
    bonus = 0,
    bonus_chips = 0,
    loc_txt = {
        name = "Blank",
        text = {"Scores {C:attention}0{} chips", "No rank or suit"}
    }
    
    
}

SMODS.Enhancement{
    --glass
    key = "SturdyGlass",
    atlas = "Tatatro",
    pos = {x = 5, y = 2},
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal, (card and card.ability.extra.DbfChance) or 5}, key = (card and card.config.center.key) or "m_TGTM_SturdyGlass"}
    end,
    config = {
        extra = {DbfChance = 5},
        x_mult = 2
    },
    calculate = function(self, card, context, effect)
        if context.cardarea == G.play and context.main_scoring then
            if pseudorandom(pseudoseed("SturdyGlassDebf")) < G.GAME.probabilities.normal/card.ability.extra.DbfChance then
                local x_multtt = 1
            else
                local x_multtt = 2
            end

            return {
                xmult = x_multtt
            }
        end
    end

}

SMODS.Enhancement{
    --glass
    key = "SturdierGlass",
    atlas = "Tatatro",
    pos = {x = 5, y = 2},
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal, (card and card.ability.extra.DbfChance) or 5}, key = (card and card.config.center.key) or "m_TGTM_SturdierGlass"}
    end,
    config = {
        extra = {DbfChance = 5},
        x_mult = 2
    },
    calculate = function(self, card, context, effect)
        if context.cardarea == G.play and not context.repetition then
            if pseudorandom(pseudoseed("SturdierGlassDebf")) < G.GAME.probabilities.normal/card.ability.extra.DbfChance then
                local x_multt = 1.5
            else
                local x_multt = 2
            end
            return {
                xmult = x_multt
            }
        end
    end

}


SMODS.Edition{
    --0.75X mult
    key = "Cursed",
    shader = "cursed",
    loc_txt = {
        name = "Cursed!",
        label = "Cursed!",
        text = {"{X:mult,C:white} X0.75{} mult"}
    },
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context, effect)
        if context.cardarea == G.play and not context.repetition then
            return {xmult = 0.75}
        end
    end
}

SMODS.Edition{
    --0.5X mult
    key = "Broken",
    shader = "broken",
    loc_txt = {
        name = "Broken",
        label = "Broken",
        text = {"{X:mult,C:white} X0.5{} mult"}
    },
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context, effect)
        if context.cardarea == G.play and not context.repetition then
            return {xmult = 0.5}
        end
    end,
    
    disable_base_shader = true
}

SMODS.Edition{
    --Purified
    key = "Purified",
    shader = "pure",
    loc_txt = {
        name = "Purified",
        label = "Purified",
        text = {"This joker is unable to be retriggered", "This joker's abilities cannot be copied"}
    },
    unlocked = true,
    discovered = true,
    config = {
        
    },
    on_apply = function(card)
        card.blueprint_compat = false
    end,
    on_remove = function(card)
        card.blueprint_compat = true
    end
}

SMODS.Atlas{
    key = "Tatatro",
	px = 71,
	py = 95,
	path = "Tarots.png"
}

SMODS.Atlas{
    key = "runes",
	px = 71,
	py = 95,
	path = "Runes.png"
}

SMODS.ConsumableType{

    key = "Runes",
    --Rune colors
    primary_colour = HEX("480049"),
    secondary_colour = HEX("890062"),
    collection_rows = { 5, 5 }, -- 3 pages for all runes, 10 per page
    shop_rate = 2, -- same as spectrals in shop for ghost
    loc_txt = {
        name = "Runes",
        collection = "Runes"
    },
    --class_prefix = "r",
    can_stack = true,
    can_divide = true

}



--[[
base for cards


SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative", true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return {vars = { !!VARS!! }, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
    config = {extra = { !!VARS!! }},
	atlas = "runes",
    set = "Runes",
    name = "runes-NAME",
    key = "name",
    pos = {x = 0, y = 0},
    cost = 4,
    order = 1,
    can_use = function(self, card)
        !!CONDITION FOR USING!!
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            
            --!!UPSIDE!!
            if not TGTMConsumables.config.CursedRunes then
                --!!DOWNSIDE!!
            else
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (G.RuneCurse / 100)
            end

        return true end }))
    end,
}



]]

G.RuneCurse = 2

--blank
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        
        --print(card)
        --print(card.area)
        --print(card.area.config)
        --print(card.area.config.collection)
        card:set_edition("e_negative", true)
    end,
	unlocked = true,
	discovered = true,
    config = { extra = {Curse = 5, Chance = 2} },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Curse, G.GAME.probabilities.normal, card.ability.extra.Chance, (card.ability.extra.Curse * 2)}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
    end,
	atlas = "runes",
    set = "Runes",
    name = "runes-blank",
    key = "blank",
    pos = {x = 0, y = 0},

    cost = 4,
    order = 1,
    keep_on_use = function(self, card)

        local akep = TGTMConsumables.config.CursedRunes or (pseudorandom(pseudoseed("CurseStay")) < G.GAME.probabilities.normal/card.ability.extra.Chance)

        if akep then
            card_eval_status_text(card,"extra",nil,nil,nil,{message = "Kept!", colour = G.C.PURPLE})
        end
        return akep
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            
            
            G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (card.ability.extra.Curse / 100)
            if TGTMConsumables.config.CursedRunes then
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (card.ability.extra.Curse / 100)
            end

            local card = create_card("Runes", G.consumeables, nil, nil, nil, nil, nil, "TGTM_runes")
            --print(card.ability.name)
            card:add_to_deck()
            G.consumeables:emplace(card)
            



        return true end }))
    end,
}

--Laguz
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative",true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)

        local AmtDisc = card.ability.extra.discards
        if TGTMConsumables.config.CursedRunes then AmtDisc = AmtDisc * 2 end
        print(card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or ""))
        --print(Runes.class_prefix)
		return {vars = {AmtDisc, G.RuneCurse}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
	atlas = "runes",
    set = "Runes",
    name = "runes-laguz",
    key = "laguz",
    pos = {x = 1, y = 0},
    config = {extra = {discards = 1}},
    cost = 4,
    order = 21,
    can_use = function(self, card)
        return G.STATE == G.STATES.SELECTING_HAND
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            --Add 1 discard
            local amt = card.ability.extra.discards
            
            if TGTMConsumables.config.CursedRunes then
                amt = amt * 2
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (G.RuneCurse / 100)
            end
            ease_discard(amt)
            
            --G.GAME.TGTMchangeHandSize = G.GAME.TGTMchangeHandSize - 1

        return true end }))
    end,
}

--Dagaz
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative",true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {G.RuneCurse}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
    end,
	atlas = "runes",
    set = "Runes",
    name = "runes-daguz",
    key = "dagaz",
    pos = {x = 2, y = 0},
    config = {},
    cost = 4,
    order = 24,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND and G.GAME.blind:get_type() == 'Boss')
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            card_eval_status_text(card,"extra",nil,nil,nil,{message = "Blind Disabled", colour = G.C.RED})
            --disable blind
            G.GAME.blind:disable()
            if TGTMConsumables.config.CursedRunes then
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (G.RuneCurse / 100)
            else
                --No reward money
                G.GAME.blind.dollars = 0
                G.GAME.current_round.dollars_to_be_earned = ''
            end
            
            
        return true end }))
    end,
}

--Othala
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative",true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return { vars = {G.GAME and G.GAME.interest_cap or '???', card.ability.extra.MultDollars, card.ability.extra.percentChange, G.RuneCurse}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
	atlas = "runes",
    set = "Runes",
    name = "runes-othala",
    key = "othala",
    pos = {x = 3, y = 0},
    config = {extra = {MultDollars = 5, percentChange = 20}},
    cost = 4,
    order = 23,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            --Give money
            ease_dollars(G.GAME.interest_cap)
            
            
            

            if TGTMConsumables.config.CursedRunes then
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (G.RuneCurse / 100)
            else
                print(G.GAME.interest_cap)
                --reduce by 20% if more than 1 intrest cap
                if G.GAME.interest_cap > 5 then
                    G.GAME.interest_cap = math.floor((G.GAME.interest_cap/5) * (1 - (card.ability.extra.percentChange / 100))) * 5
                end

                print(G.GAME.interest_cap)
            end


        return true end }))
    end,
}

--Inguz
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative",true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return {vars = {G.GAME and math.floor(G.GAME.interest_cap/5) or '???', card.ability.extra.DollarsInt, card.ability.extra.IntPer, (G.RuneCurse * 2.5)},key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
	atlas = "runes",
    set = "Runes",
    name = "runes-inguz",
    key = "inguz",
    pos = {x = 4, y = 0},
    config = {extra = {DollarsInt = 5, IntPer = 1}},
    cost = 4,
    order = 22,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            G.GAME.interest_cap = G.GAME.interest_cap + math.floor(G.GAME.interest_cap/5)
            if TGTMConsumables.config.CursedRunes then
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + ((G.RuneCurse * 2) / 100)
            else
                ease_dollars(-G.GAME.dollars)
            end
        return true end }))
    end,
}
--Mannaz
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative",true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.FaceMult, card.ability.extra.BaseChip, card.ability.extra.FaceChip,G.RuneCurse},key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
	atlas = "runes",
    set = "Runes",
    name = "runes-Mannaz",
    key = "mannaz",
    pos = {x = 1, y = 1},
    config = {extra = {FaceMult = 1.5, BaseChip = -20, FaceChip = -10}},
    cost = 4,
    order = 21,
    keep_on_use = function(self, card) 
        return true 
    end,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND) and (G.GAME.TGTMFaceBuff == false)
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            G.GAME.TGTMFaceBuff = true
            --add_joker("j_TGTM_MannazJoker")
            juice_card_until(card, function()
                return G.GAME.TGTMFaceBuff
            end)
        return true end }))
    end,
    calculate = function(self, card, context, effect)
        if G.GAME.TGTMFaceBuff then
            if context.individual and context.cardarea == G.play then
                if (context.other_card:get_id() == 11 or context.other_card:get_id() == 12 or context.other_card:get_id() == 13) then
                    card:juice_up()
                    local Amt
                    if not TGTMConsumables.config.CursedRunes then
                        Amt = card.ability.extra.FaceChip
                    end
                    return {
                        x_mult = card.ability.extra.FaceMult,
                        chips = Amt,
                        card = card,
                        chip_message = {"".. Amt}
                    }
                end
            end
            if context.joker_main then                
                local chehe = card.ability.extra.BaseChip
                if TGTMConsumables.config.CursedRunes then
                    chehe = 0
                end
                if hand_chips <= to_big(-(card.ability.extra.BaseChip)) then
                    chehe = -(hand_chips - 1)
                end
                return {
    
                    message = {""..tostring(chehe)},
                    chip_mod = chehe,
                    colour = G.C.CHIPS
                    
                }
            end
            if context.end_of_round then
                G.GAME.TGTMFaceBuff = false
                card:start_dissolve({HEX("57ecab")}, nil, 1.6)
            end
        end
    end
}

--Ehwaz
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative",true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
        if not TGTMConsumables.config.CursedRunes then
            info_queue[#info_queue + 1] = {
                key = 'e_TGTM_Broken', 
                set = 'Edition',
                config = {extra = 1}
            }
        end
		return {vars = {card.ability.extra.AnteChange, G.RuneCurse * 2.5},key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
	atlas = "runes",
    set = "Runes",
    name = "runes-Ehwaz",
    key = "ehwaz",
    pos = {x = 0, y = 1},
    config = {extra = {AnteChange = -1}},
    cost = 4,
    order = 20,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            if G.GAME.round_resets.ante > 0 then 
                local NonNegativeJokers = {}
                if TGTMConsumables.config.CursedRunes then
                    G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + ((G.RuneCurse * 2.5) / 100)
                else
                    for i = 1, #G.jokers.cards do
                        local very = G.jokers.cards[i]
                        print(i)
                        print(very)
                        if ((very.edition and very.edition.negative ~= true) or not (very.edition)) then
                            table.insert(NonNegativeJokers, very)
                            print(very.ability)
                        end
                    end

                    if NonNegativeJokers then
                        local BreakJoker = pseudorandom_element(NonNegativeJokers, pseudoseed("BreakEhwaz"))
                        if BreakJoker then
                            BreakJoker:set_edition("e_TGTM_Broken")
                            card_eval_status_text(BreakJoker,"extra",nil,nil,nil,{message = "Broken!", colour = G.C.CHIPS})
                        end
                    end
                end

                ease_ante(card.ability.extra.AnteChange)
                
            end
            

        return true end }))
    end,
}
--Berkano
G.JokerToRemove = {}
G.JokerToUndebuff = {}
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative",true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return {vars = {G.RuneCurse * 3},key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
	atlas = "runes",
    set = "Runes",
    name = "runes-Berkano",
    key = "berkano",
    pos = {x = 2, y = 1},
    config = {extra = {}},
    cost = 4,
    order = 19,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND) and (G.jokers.cards) and (#G.jokers.cards > 0)
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            local Jok1 = pseudorandom_element(G.jokers.cards, pseudoseed('BerkanoChooseDup'))
            local Jok2
            local anyUnDbf = false
            for ke, va in ipairs(G.jokers.cards) do
                if va.debuff == false then
                    anyUnDbf = true
                end
            end
            if anyUnDbf == true then
                repeat
                    Jok2 = pseudorandom_element(G.jokers.cards, pseudoseed('BerkanoChooseDbf'))
                until Jok2.debuff == false
            else
                Jok2 = Jok1
            end

            if #G.jokers.cards ~= 1 then
                repeat
                    Jok2 = pseudorandom_element(G.jokers.cards, pseudoseed('BerkanoChoose'))
                until (Jok1 ~= Jok2)
            end
            print(Jok1.ability.name)
            print(Jok2.ability.name)


            card_eval_status_text(Jok1,"extra",nil,nil,nil,{message = "Copied!", colour = G.C.CHIPS})
            local dupeJoker = copy_card(Jok1)
            dupeJoker:set_edition("e_negative",true)
            dupeJoker.ability.eternal = true

            table.insert(G.JokerToRemove, 1, dupeJoker)
            dupeJoker.debuff = false
            dupeJoker:add_to_deck()
            G.jokers:emplace(dupeJoker)

            tprint(G.JokerToRemove)
            if TGTMConsumables.config.CursedRunes == false then
                table.insert(G.JokerToUndebuff, 1, Jok2)
                card_eval_status_text(Jok2,"extra",nil,nil,nil,{message = "Debuffed!", colour = G.C.MULT})
                Jok2.debuff = true
            else
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + ((G.RuneCurse * 3) / 100)
            end
        return true end }))
    end,
}

--Tiwaz
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative", true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.Payout,card.ability.extra.BlindInc, G.RuneCurse}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
    config = {extra = {BlindInc = 50, Payout = 25}},
	atlas = "runes",
    set = "Runes",
    name = "runes-Tiwaz",
    key = "tiwaz",
    pos = {x = 3, y = 1},
    cost = 4,
    order = 18,
    can_use = function(self, card)
        return G.STATE == G.STATES.SELECTING_HAND
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            
            G.GAME.blind.dollars = G.GAME.blind.dollars + 25
            G.GAME.current_round.dollars_to_be_earned = '$' .. G.GAME.blind.dollars 

            if not TGTMConsumables.config.CursedRunes then
                G.GAME.blind.chips = G.GAME.blind.chips * (1 + (card.ability.extra.BlindInc / 100))
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            else
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (G.RuneCurse / 100)
            end

        return true end }))
    end,
}

--Sowilo
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative", true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
        if not TGTMConsumables.config.CursedRunes then
            info_queue[#info_queue + 1] = {
                key = 'e_TGTM_Purified', 
                set = 'Edition',
                config = {extra = 1}
            }
        end
		return {vars = {G.RuneCurse}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
    config = {extra = {}},
	atlas = "runes",
    set = "Runes",
    name = "runes-SOWILO",
    key = "sowilo",
    pos = {x = 4, y = 1},
    cost = 4,
    order = 17,
    can_use = function(self, card)
        return #G.jokers.highlighted == 1
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            local CARD = G.jokers.highlighted[1]
            CARD.ability.perishable = nil
			CARD:set_rental(nil)
            
            if SMODS.Mods.Cryptid.can_load then
                CARD.pinned = nil
                if not CARD.sob then
                    CARD:set_eternal(nil)
                end
                CARD.ability.banana = nil
            else
                CARD:set_eternal(nil)
            end

            if not TGTMConsumables.config.CursedRunes then
                CARD:set_edition("e_TGTM_Purified")
            else
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (G.RuneCurse / 100)
            end

        return true end }))
    end,
}

--whatever this one is
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative", true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
        local keyeeee = ""
        if not TGTMConsumables.config.CursedRunes then
            keyeeee = G.P_CENTERS.m_TGTM_SturdyGlass
        else
            keyeeee = G.P_CENTERS.m_TGTM_SturdierGlass
        end
        print(keyeeee)
        info_queue[#info_queue + 1] = keyeeee
        

		return {vars = {card.ability.extra.CardAmt, G.RuneCurse * 2}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
    config = {extra = {CardAmt = 2}},
	atlas = "runes",
    set = "Runes",
    name = "runes-ALGIZ",
    key = "algiz",
    pos = {x = 0, y = 2},
    cost = 4,
    order = 16,
    can_use = function(self, card)
        local flag = false
        for i, card in pairs(G.hand.highlighted) do
            print(card.ability.name)
            if not (card.ability.name == 'Glass Card') then
                flag = true
            end
        end
        return (#G.hand.highlighted <= card.ability.extra.CardAmt) and (flag == false)
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            local keyeeee = ""
            if not TGTMConsumables.config.CursedRunes then
            keyeeeee = G.P_CENTERS.m_TGTM_SturdyGlass
            else
            keyeeeee = G.P_CENTERS.m_TGTM_SturdierGlass
            G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + ((G.RuneCurse * 2)/100)
            end
            for i, card in pairs(G.hand.highlighted) do
                card:set_ability(keyeeeee)
            end
        return true end }))
    end,
}

--pertro!!!!!!!!!!!!!!! PRETORO
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative", true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.BlindIncrease * 100,G.RuneCurse * 3}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
    config = {extra = {BlindIncrease = 0.0}},
	atlas = "runes",
    set = "Runes",
    name = "runes-PERTHRO",
    key = "perthro",
    pos = {x = 1, y = 2},
    cost = 4,
    order = 15,
    can_use = function(self, card)
        return #G.jokers.highlighted == 1
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            local CARD = G.jokers.highlighted[1]
            
            local rarity = G.jokers.highlighted[1].config.center.rarity
		    local legendary = nil

            

            if rarity == 1 then
                rarity = 0.9
                card.ability.extra.BlindIncrease = 1.1
            elseif rarity == 2 then
                rarity = 0.99
                card.ability.extra.BlindIncrease = 1.5
            elseif rarity == 3 then
                rarity = nil
                legendary = true
                card.ability.extra.BlindIncrease = 2.0
            elseif rarity == 4 and SMODS.Mods.Cryptid.can_load then
                rarity = 1
                card.ability.extra.BlindIncrease = 4.0
            elseif rarity == "cry_epic" then
                rarity = "cry_exotic"
                card.ability.extra.BlindIncrease = 8.0
            elseif rarity == 4 and not SMODS.Mods.Cryptid.can_load then
                rarity = nil
                legendary = true
                card.ability.extra.BlindIncrease = 1.0
            elseif rarity == "cry_exotic" then
                rarity = 0
                card.ability.extra.BlindIncrease = 0.1
            end
                

            G.jokers.highlighted[1]:start_dissolve()
            local cardC = create_card("Joker", G.jokers, legendary, rarity, nil, nil, nil, "TGTM_Pert")
			cardC:add_to_deck()
			G.jokers:emplace(cardC)
			cardC:juice_up(0.3, 0.5)

            if not TGTMConsumables.config.CursedRunes then
                G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling + card.ability.extra.BlindIncrease

            else
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (G.RuneCurse * card.ability.extra.BlindIncrease * 1.25 / 100)
            end

        return true end }))
    end,
}


UnPlasmaRnd = false
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative", true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.BlindIncRnd, G.RuneCurse * 3}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
    config = {extra = {BlindIncRnd = 3.0}},
	atlas = "runes",
    set = "Runes",
    name = "runes-EIHWAZ",
    key = "eihwaz",
    pos = {x = 2, y = 2},
    cost = 4,
    order = 1,
    can_use = function(self, card)
        return G.STATE == G.STATES.SELECTING_HAND and UnPlasmaRnd == false
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            
            --!!UPSIDE!!
            UnPlasmaRnd = true

            if not TGTMConsumables.config.CursedRunes then
                G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.BlindIncRnd
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

            else
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (G.RuneCurse * 3 / 100)
            end

        return true end }))
    end,
}

SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative", true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.MaxGain + ((TGTMConsumables.config.CursedRunes and MaxGain) or 0)}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
    config = {extra = {MaxGain = 40}},
	atlas = "runes",
    set = "Runes",
    name = "runes-JERA",
    key = "jera",
    pos = {x = 3, y = 2},
    cost = 4,
    order = 1,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            monomon = card.ability.extra.MaxGain
            if TGTMConsumables.config.CursedRunes then
                monomon = monomon * 2
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (G.RuneCurse / 100)
            end
            
            ease_dollars(math.max(0,math.min(G.GAME.dollars, monomon)), true)

            

        return true end }))
    end,
}

SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative",true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.hands, card.ability.extra.handsizes, G.RuneCurse}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
	atlas = "runes",
    set = "Runes",
    name = "runes-ISA",
    key = "isa",
    pos = {x = 4, y = 2},
    config = {extra = {hands = 1, handsizes = -1}},
    cost = 4,
    order = 21,
    can_use = function(self, card)
        return G.STATE == G.STATES.SELECTING_HAND
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()

            local amt = card.ability.extra.hands
            
            if TGTMConsumables.config.CursedRunes then

                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (G.RuneCurse / 100)
            else
                G.hand:change_size(card.ability.extra.handsizes)
                G.GAME.TGTMchangeHandSize = G.GAME.TGTMchangeHandSize - card.ability.extra.handsizes
            end
            ease_hands_played(amt)
            
            
            
        return true end }))
    end,
}




SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative",true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return {vars = {G.RuneCurse}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
	atlas = "runes",
    set = "Runes",
    name = "runes-NAUTHIZ",
    key = "nauthiz",
    pos = {x = 0, y = 3},
    config = {extra = {DegradeHand = nil,UpgradedHanded = false, UpgradeNextHandPlayed = false}},
    cost = 4,
    order = 21,
    keep_on_use = function(self, card) 
        return true 
    end,
    can_use = function(self, card)
        return G.STATE == G.STATES.SELECTING_HAND and not card.ability.extra.UpgradeNextHandPlayed
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()

            
            card.ability.extra.UpgradeNextHandPlayed = true

            
            
            juice_card_until(card, function()
                return card.ability.extra.UpgradeNextHandPlayed
            end)
            
        return true end }))
    end,
    calculate = function(self, card, context)

        if card.ability.extra.UpgradeNextHandPlayed then
            if context.before then
                card.ability.extra.UpgradeNextHandPlayed = false
                card.ability.extra.UpgradedHanded = true 
                card.ability.extra.DegradeHand = context.scoring_name
                print(card.ability.extra.DegradeHand)
                return {
                    card = card,
                    level_up = true,
                    message = "Need!"

                }
            end
        end
        if card.ability.extra.UpgradedHanded then
            if context.end_of_round then
                if TGTMConsumables.config.CursedRunes then

                    G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (G.RuneCurse / 100)
                
                else
                level_up_hand(card, card.ability.extra.DegradeHand, nil, -1)
                end
                card.ability.extra.DegradeHand = nil
                card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                card.ability.extra.UpgradedHanded = nil
            end
        end
    end

}

SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative",true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return {vars = {G.RuneCurse}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
	atlas = "runes",
    set = "Runes",
    name = "runes-HAGALAZ",
    key = "hagalaz",
    pos = {x = 1, y = 3},
    config = {extra = {PcentDecBlndyes = 2}},
    cost = 4,
    order = 21,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND) and ((#G.hand.cards > 0) or (TGTMConsumables.config.CursedRunes))
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()

            
            local cardsDestroyed = 0

            if TGTMConsumables.config.CursedRunes then
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (G.RuneCurse / 100)
                cardsDestroyed = 3
            else

                local keepIndex = pseudorandom_element(G.hand.cards, pseudoseed('HagalazChooseSafe'))
                for k, v in pairs(G.hand.cards) do
                    if v ~= keepIndex then
                        v:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        cardsDestroyed = cardsDestroyed + 1
                    end
                end

            end         
            
            G.GAME.blind.chips = G.GAME.blind.chips * (1 - ((card.ability.extra.PcentDecBlndyes * cardsDestroyed) / 100))
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

                        
        return true end }))
    end,
}

SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative",true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return {vars = {G.RuneCurse * 2}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
	atlas = "runes",
    set = "Runes",
    name = "runes-WUNJO",
    key = "wunjo",
    pos = {x = 2, y = 3},
    config = {extra = {PcentOverkill = 20, reward = 5, active = false}},
    cost = 4,
    order = 21,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND) and not card.ability.extra.active
    end,
    keep_on_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()


            card.ability.extra.active = true
            juice_card_until(card, function()
                return card.ability.extra.active
            end)
                        
        return true end }))
    end,
    calculate = function(self, card, context)
        if card.ability.extra.active then
            if context.end_of_round then
                print(G.GAME.chips)

                local pcent = (G.GAME.chips - G.GAME.blind.chips) / G.GAME.blind.chips
                print(pcent)

                local PcentOverkill = card.ability.extra.PcentOverkill

                if TGTMConsumables.config.CursedRunes then
                    PcentOverkill = PcentOverkill / 2
                    G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (G.RuneCurse * 2 / 100)
                end

                local pcent2 = math.floor((pcent / (PcentOverkill/100)) * card.ability.extra.reward)

                ease_dollars(math.min(pcent2, (TGTMConsumables.config.CursedRunes and 50) or 100))

                card:start_dissolve({HEX("57ecab")}, nil, 1.6)
            end
        end
    end
}

SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative", true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return {vars = {G.RuneCurse}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
    config = {extra = {CardAmt = 1}},
	atlas = "runes",
    set = "Runes",
    name = "runes-GEBO",
    key = "gebo",
    pos = {x = 3, y = 3},
    cost = 4,
    order = 16,
    can_use = function(self, card)
        
        return (#G.hand.highlighted <= (TGTMConsumables.config.CursedRunes and card.ability.extra.CardAmt * 2) or card.ability.extra.CardAmt) and (#G.hand.highlighted ~= 0)
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            if not TGTMConsumables.config.CursedRunes then
                
            else
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + ((G.RuneCurse)/100)
            end
            for i, card in pairs(G.hand.highlighted) do
                card:set_seal(SMODS.poll_seal({guaranteed = true}))
                card:set_edition(poll_edition(nil,nil,true,true,nil))
            end
        return true end }))
    end,
}

SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative", true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return {vars = {G.RuneCurse}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
    config = {extra = {}},
	atlas = "runes",
    set = "Runes",
    name = "runes-KENNAZ",
    key = "kennaz",
    pos = {x = 4, y = 3},
    cost = 4,
    order = 16,
    can_use = function(self, card)
        
        return G.STATE == G.STATES.SELECTING_HAND
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            
            local FlipAll = not TGTMConsumables.config.CursedRunes
            if TGTMConsumables.config.CursedRunes then
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + ((G.RuneCurse * 1.5)/100)
            end
            
            for k, v in pairs(G.jokers.cards) do
                if v.facing == 'back' then
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        v:flip()
                    return true end }))
                elseif not TGTMConsumables.config.CursedRunes then
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        v:flip()
                    return true end }))
                end
                delay(0.1)
            end
            for k, v in pairs(G.hand.cards) do
                if v.facing == 'back' then
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        v:flip()
                    return true end }))
                elseif not TGTMConsumables.config.CursedRunes then

                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        v:flip()
                    return true end }))
                    
                end
                delay(0.1)
            end

        return true end }))
    end,
}













--Taking control of round end to change stuff
local endroundref = end_round
function end_round()
  endroundref()
  G.hand:change_size(-G.GAME.TGTMchangeHandSize)
  G.GAME.TGTMchangeHandSize = 0
  for k, v in pairs(G.jokers.cards) do
    for i, vv in ipairs(G.JokerToRemove) do
        print(i, vv.ability.name, v.ability.name)
		if vv == v then 
            v.ability.eternal = false
            v:juice_up(0.8, 0.8)
            v:start_dissolve({HEX("57ecab")}, nil, 1.6)
            
        end
	end
    for i, vv in ipairs(G.JokerToUndebuff) do
		if vv == v then 
            v.debuff = false
            
        end
	end
  end
  G.JokerToRemove = {}
  UnPlasmaRnd = false
end
--
local ATDref = Card.add_to_deck
function Card:add_to_deck(args)
    ATDref(self, args)
    --print(self.ability.set)
    --print(pseudorandom(pseudoseed("Curse")))
    --print(G.GAME.TGTMCurseChance)
    if (G.GAME.TGTMCurseChance > 0) and (self.ability.set == 'Joker') and (pseudorandom(pseudoseed("Curse")) < G.GAME.TGTMCurseChance) then
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            
            --chance for jokers to be cursed
            self:set_edition("e_TGTM_Cursed")
            card_eval_status_text(self,"extra",nil,nil,nil,{message = "Cursed!", colour = G.C.PURPLE})

        return true end }))
    end
end

local UseRef = Card.use_consumeable
function Card:use_consumeable(args)
    stop_use()
    if not copier then set_consumeable_usage(self) end
    if self.debuff then return nil end
    local used_tarot = copier or self

    if (G.GAME.TGTMCurseChance > 0) and (self.ability.set == 'Tarot') and (pseudorandom(pseudoseed("Curse")) < G.GAME.TGTMCurseChance) then

        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            card_eval_status_text(self,"extra",nil,nil,nil,{message = "Cursed!", colour = G.C.PURPLE})
        return true end }))

        if #G.hand.highlighted == 0 and G.STATE == G.STATES.PLAY_TAROT and #G.hand.cards ~= 0 then
            print(G.STATE)
            print(G.STATES.SELECTING_HAND)
            print(G.hand.config.card_limit)
            print("G.hand and #G.hand.highlighted == 0 and G.STATES == G.STATES.SELECTING_HAND")
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                

                
                local front = pseudorandom_element(G.P_CARDS, pseudoseed('CurseLockedFront'))
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local cardLoc = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_TGTM_Blank, {playing_card = G.playing_card})
                cardLoc:start_materialize({G.C.SECONDARY_SET.Enhanced})
                table.insert(G.playing_cards, cardLoc)
                card_eval_status_text(cardLoc,"extra",nil,nil,nil,{message = "Blank!", colour = G.C.PURPLE})
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                    --print(cardLoc)
                    G.hand:emplace(cardLoc, nil, false)
                return true end }))
            return true end }))

        elseif #G.hand.cards ~= 0 then
            print(G.STATE)
            print(G.STATES.SELECTING_HAND)
            print("G.hand and G.STATES == G.STATES.SELECTING_HAND")
            for i = 1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                    local CardRef = G.hand.highlighted[i]
                    card_eval_status_text(CardRef,"extra",nil,nil,nil,{message = "Blank!", colour = G.C.PURPLE})
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                    G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    G.hand.highlighted[i]:set_ability(G.P_CENTERS["m_TGTM_Blank"])
                    return true end }))
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                    G.hand.highlighted[i]:flip()
                    return true end }))
                return true end }))
            end
        else 
            local front = pseudorandom_element(G.P_CARDS, pseudoseed('CurseLockedFront'))
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local cardLoc = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_TGTM_Blank, {playing_card = G.playing_card})
            cardLoc:start_materialize({G.C.SECONDARY_SET.Enhanced})
            table.insert(G.playing_cards, cardLoc)
            card_eval_status_text(cardLoc,"extra",nil,nil,nil,{message = "Blank!", colour = G.C.PURPLE})
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                --print(cardLoc)
                G.deck:emplace(cardLoc, nil, false)
            return true end }))
        end


        
    elseif (G.GAME.TGTMCurseChance > 0) and (self.ability.set == 'Planet') and (pseudorandom(pseudoseed("Curse")) < G.GAME.TGTMCurseChance) then
        

        
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                card_eval_status_text(self,"extra",nil,nil,nil,{message = "Cursed!", colour = G.C.PURPLE})
            return true end }))
            local handname = self.ability.consumeable.hand_type
            print("HANDNAME:", handname)
            if G.GAME.hands[handname].level > 1 then
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(self.ability.consumeable.hand_type, 'poker_hands'),chips = G.GAME.hands[self.ability.consumeable.hand_type].chips, mult = G.GAME.hands[self.ability.consumeable.hand_type].mult, level=G.GAME.hands[self.ability.consumeable.hand_type].level})
                self.triggered = true
                level_up_hand(self.children.animatedSprite, handname, nil, -1)
                update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
            end 
        return true end }))
        
    elseif (G.GAME.TGTMCurseChance > 0) and (self.ability.set == 'Spectral') and self.ability.name ~= "The Soul" and (pseudorandom(pseudoseed("Curse")) < G.GAME.TGTMCurseChance) then
        local maxClear = 2
        local cleared = 0


        for k, v in pairs(G.playing_cards) do

            if v.edition or v.config.center ~= G.P_CENTERS.c_base or v.seal then
                print(v.edition)
                print(v.config.center ~= G.P_CENTERS.c_base)
                print(v.seal)

                if cleared < maxClear then

                    if v.area.config.type == 'deck' then
                        if #G.hand.cards ~= 0 then
                            draw_card(G.deck,G.hand, 1, 'up', true, v, nil, true)
                        else
                            draw_card(G.deck,G.play, 1, 'up', true, v, nil, true)
                        end


                    end 
                    
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()

                        --G.play:emplace(v)

                    return true end }))
                    
                    card_eval_status_text(v,"extra",nil,nil,nil,{message = "Destroyed!", colour = G.C.BLUE})

                    

                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.5,func = function()
                        delay(0.5)
                        table.remove(G.playing_cards, k)
                        if v.ability.name == 'Glass Card' then 
                            v:shatter()
                        else
                            v:start_dissolve(nil)
                        end

                    return true end }))

                    
                end
                cleared = cleared + 1

            end
        end

        if cleared < maxClear then
            for la = 1, maxClear do
                local front = pseudorandom_element(G.P_CARDS, pseudoseed('CurseLockedFront'))
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local cardLoc = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_TGTM_Blank, {playing_card = G.playing_card})
                cardLoc:start_materialize({G.C.SECONDARY_SET.Enhanced})
                table.insert(G.playing_cards, cardLoc)
                card_eval_status_text(cardLoc,"extra",nil,nil,nil,{message = "Blank!", colour = G.C.PURPLE})
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                    --print(cardLoc)
                    G.deck:emplace(cardLoc, nil, false)
                return true end }))
            end
        end

        for ke, va in pairs(G.hand.cards) do
            for i, j in pairs(va.ability) do
                print(ke,i,mj)
            end
        end

    else    
    UseRef(self,args) 
    end

end
--mmmmm