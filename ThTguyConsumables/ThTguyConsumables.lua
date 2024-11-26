--- STEAMODDED HEADER
--- MOD_NAME: TGTM's Consumables
--- MOD_ID: TGTMConsumables
--- MOD_AUTHOR: [Thatguytheman]
--- MOD_DESCRIPTION: runes and stuff (and a few random jokers)
--- PREFIX: TGTM

--[[to do:
Add runes (negative tarots temporary gain, long term downsides)

Add cursed tarots (only gotten from blank rune)
Add Jokers (balance top 10% chips + mult, transfer 5% of mult to chips, chip multiplier, set mult to 100, reduce mult by 10% and award 1$ per 10 mult)

thank you to cryptid mod because i copied a bunch of stuff from it to learn

]]


--[[
Runes and meanings:
	Laguz (Water) : +1 discard for round
	Dagaz (Dawn) : disable boss blind, no boss reward
	OTHALA (Inheritance) : gain intrest cap * 5, lower intrest cap by 20%
    Inguz (Seed) : set money to 0, gain intrest per 5 dollars lost


	Blank : Spawn a rune, 50% chance to not get destroyed when used, +5% chance for cursed cards
]]
local IntrestAmt = 0

--lets dissect this
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


SMODS.Edition{
    --0.75X mult
    key = "Cursed",
    shader = false,
    loc_txt = {
        name = "Cursed!",
        label = "Cursed!",
        text = {"{X:mult,C:white} X0.75{} mult"}
    },
    unlocked = true,
    discovered = true,
    config = {
        x_mult = 0.75
    }
}

SMODS.Edition{
    --0.5X mult
    key = "Broken",
    shader = false,
    loc_txt = {
        name = "Broken",
        label = "Broken",
        text = {"{X:mult,C:black} X0.5{} mult"}
    },
    unlocked = true,
    discovered = true,
    config = {
        x_mult = 0.5
    }
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
    collection_rows = { 5, 2 }, -- 3 pages for all runes, 10 per page
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
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (RuneCurse / 100)
            end

        return true end }))
    end,
}



]]

RuneCurse = 2

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
		return {vars = {AmtDisc, RuneCurse}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
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
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (RuneCurse / 100)
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
        return {vars = {RuneCurse}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
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
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (RuneCurse / 100)
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
		return { vars = {G.GAME and G.GAME.interest_cap or '???', card.ability.extra.MultDollars, card.ability.extra.percentChange, RuneCurse}, key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
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
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + (RuneCurse / 100)
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
		return {vars = {G.GAME and math.floor(G.GAME.interest_cap/5) or '???', card.ability.extra.DollarsInt, card.ability.extra.IntPer, (RuneCurse * 2.5)},key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
	atlas = "runes",
    set = "Runes",
    name = "runes-inguz",
    key = "inguz",
    pos = {x = 4, y = 0},
    config = {extra = {DollarsInt = 5, IntPer = 1}},
    cost = 4,
    order = 1,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            G.GAME.interest_cap = G.GAME.interest_cap + math.floor(G.GAME.interest_cap/5)
            if TGTMConsumables.config.CursedRunes then
                G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + ((RuneCurse * 2) / 100)
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
		return {vars = {card.ability.extra.FaceMult, card.ability.extra.BaseChip, card.ability.extra.FaceChip,RuneCurse},key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
	atlas = "runes",
    set = "Runes",
    name = "runes-Mannaz",
    key = "mannaz",
    pos = {x = 1, y = 1},
    config = {extra = {FaceMult = 1.5, BaseChip = -20, FaceChip = -10}},
    cost = 4,
    order = 1,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND) and (G.GAME.TGTMFaceBuff == false)
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            G.GAME.TGTMFaceBuff = true
            add_joker("j_TGTM_MannazJoker")
        return true end }))
    end,
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
		return {vars = {card.ability.extra.AnteChange, RuneCurse * 2.5},key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
	atlas = "runes",
    set = "Runes",
    name = "runes-Ehwaz",
    key = "ehwaz",
    pos = {x = 0, y = 1},
    config = {extra = {AnteChange = -1}},
    cost = 4,
    order = 1,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            if G.GAME.round_resets.ante > 0 then 
                local NonNegativeJokers = {}
                if TGTMConsumables.config.CursedRunes then
                    G.GAME.TGTMCurseChance = G.GAME.TGTMCurseChance + ((RuneCurse * 2.5) / 100)
                else
                    for k, v in pairs(G.jokers.cards) do
                        if v.ability.set == 'Joker' and ((v.edition and v.edition.negative)) then
                            table.insert(NonNegativeJokers, v)
                            print(v.ability)
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
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative",true)
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return {vars = {},key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
	atlas = "runes",
    set = "Runes",
    name = "runes-Brekano",
    key = "berkano",
    pos = {x = 1, y = 1},
    config = {extra = {FaceMult = 1.5, BaseChip = -20, FaceChip = -10}},
    cost = 4,
    order = 1,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND) and (G.GAME.TGTMFaceBuff == false)
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()

        return true end }))
    end,
}












--mannaz joker
SMODS.Joker{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative",true)
        card.ability.eternal = true
    end,
    unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
        print(card.config.center.key)
		return {vars = {card.ability.extra.FaceMult, card.ability.extra.BaseChip, card.ability.extra.FaceChip},key = card.config.center.key .. (TGTMConsumables.config.CursedRunes and "C" or "")}
	end,
    config = {extra = {FaceMult = 1.5, BaseChip = -20, FaceChip = -10}},
    atlas = "runes",
    name = "runes-MannazJoker",
    key = "mannazJoker",
    pos = {x = 1, y = 1},
    rarity = 3,
    blueprint_compat = true,
    calculate = function(self, card, context)
        


        if context.individual then
            if context.cardarea == G.play then
                if (context.other_card:get_id() == 11 or context.other_card:get_id() == 12 or context.other_card:get_id() == 13) then

                    card:juice_up()
                    local Amt
                    if not TGTMConsumables.config.CursedRunes then
                        Amt = card.ability.extra.FaceChip
                    end

                    return {
                        x_mult = card.ability.extra.FaceMult,
                        chips = Amt,
                        card = card
                    }
                end
            end
        end
        if context.joker_main then
            print(hand_chips)
            

            

                
            local chehe = card.ability.extra.BaseChip
            if TGTMConsumables.config.CursedRunes then
                chehe = 0
            end
            if hand_chips <= -(card.ability.extra.BaseChip) then
                chehe = -(hand_chips - 1)
            end



            return {

                message = {""..chehe},
                chip_mod = chehe,
                colour = G.C.CHIPS
            }
        end

    end
}







--Taking control of round end to change stuff
local endroundref = end_round
function end_round()
  endroundref()
  G.hand:change_size(G.GAME.TGTMchangeHandSize)
  G.GAME.TGTMchangeHandSize = 0
  if G.GAME.TGTMFaceBuff then
    for k, v in pairs(G.jokers.cards) do
        if v.ability.name == "runes-MannazJoker" then
            v.ability.eternal = false
            v:juice_up(0.8, 0.8)
            v:start_dissolve({HEX("57ecab")}, nil, 1.6)
        end
    end
  end
  G.GAME.TGTMFaceBuff = false

end
--
local ATDref = Card.add_to_deck
function Card:add_to_deck(args)
    ATDref(self, args)
    print(self.ability.set)
    print(pseudorandom(pseudoseed("Curse")))
    print(G.GAME.TGTMCurseChance)
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
