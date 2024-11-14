--- STEAMODDED HEADER
--- MOD_NAME: TGTM's Consumables
--- MOD_ID: ThTguyConsumables
--- MOD_AUTHOR: [Thatguytheman]
--- MOD_DESCRIPTION: runes and stuff (and a few random jokers)

--[[to do:
Add runes (negative tarots temporary gain, long term downsides)

Add Jokers (balance top 10% chips + mult, transfer 5% of mult to chips, chip multiplier, set mult to 100, reduce mult by 10% and award 1$ per 10 mult)

thank you to cryptid mod because i copied a bunch of stuff from it to learn

]]


--[[
Runes and meanings:
	Laguz (Water) : +1 discard for round
	Dagaz (Dawn) : disable boss blind, no boss reward
	OTHALA (Inheritance) : gain intrest cap * 5, lower intrest cap by 20%


	Blank : Spawn last used rune, +1% chance for cursed tarots
]]
local IntrestAmt = 0

--Globals
local startRef = Game.start_run
function Game:start_run(args)
    startRef(self, args)
    G.GAME.TGTMchangeHandSize = 0
    IntrestAmt = G.GAME.interest_cap
    G.GAME.TGTMLastRune = nil
end



SMODS.Atlas{
    key = "runes",
	px = 71,
	py = 95,
	path = "Runes.png"
}

SMODS.ConsumableType{

    key = "Runes",
    primary_colour = HEX("480049"),
    secondary_colour = HEX("890062"),
    collection_rows = { 5, 2 }, -- 3 pages for all runes
    shop_rate = 2,
    loc_txt = {
        name = "Runes",
        collection = "Runes"
    },
    can_stack = true,
    can_divide = true

}

--[[
base for cards


SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative")
    end,
	unlocked = true,
	discovered = true,
    loc_txt = {
        name = "NAME",
        text = {"DESC"}
    },
	atlas = "runes",
    set = "Runes",
    name = "runes-NAME",
    key = "name",
    pos = {x = 0, y = 0},
    config = {},
    cost = 4,
    order = 1,
    can_use = function(self, card)
        CONDITION FOR USING
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            ON USE
        return true end }))
    end,
}


]]


--Laguz
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative")
    end,
	unlocked = true,
	discovered = true,
    loc_txt = {
        name = "Laguz",
        text = {"Gain {C:attention}1{} discard for this round"}
    },
	atlas = "runes",
    set = "Runes",
    name = "runes-laguz",
    key = "laguz",
    pos = {x = 1, y = 0},
    config = {},
    cost = 4,
    order = 21,
    can_use = function(self, card)
        return G.STATE == G.STATES.SELECTING_HAND
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            ease_discard(1)
            
            --G.GAME.TGTMchangeHandSize = G.GAME.TGTMchangeHandSize - 1

        return true end }))
    end,
}

--Dagaz
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative")
    end,
	unlocked = true,
	discovered = true,
    loc_txt = {
        name = "Dagaz",
        text = {"{C:red}Disable{} boss blind", "{C:attention}No reward money from blind{} "}
    },
	atlas = "runes",
    set = "Runes",
    name = "runes-daguz",
    key = "daguz",
    pos = {x = 2, y = 0},
    config = {},
    cost = 4,
    order = 24,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND and G.GAME.blind:get_type() == 'Boss')
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            G.GAME.blind:disable()
            G.GAME.blind.dollars = 0
            G.GAME.current_round.dollars_to_be_earned = ''
        return true end }))
    end,
}

--Othala
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative")
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return { vars = {G.GAME and G.GAME.interest_cap or '???'}}
	end,
    loc_txt = {
        name = "Othala",
        text = {"Earn {C:attention}interest cap * 5{} Dollars {C:inactive}($#1#){}", "{C:red}-20%{} of Interest cap"}
    },
	atlas = "runes",
    set = "Runes",
    name = "runes-othala",
    key = "othala",
    pos = {x = 3, y = 0},
    config = {},
    cost = 4,
    order = 23,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            ease_dollars(G.GAME.interest_cap)
            
            
            print(G.GAME.interest_cap)
            if G.GAME.interest_cap > 5 then
                G.GAME.interest_cap = math.floor((G.GAME.interest_cap/5) * 0.8) * 5
            end

            print(G.GAME.interest_cap)



        return true end }))
    end,
}

--Taking control of round end to change stuff
local endroundref = end_round
function end_round()
  endroundref()
  G.hand:change_size(G.GAME.TGTMchangeHandSize)
  G.GAME.TGTMchangeHandSize = 0
end
--
