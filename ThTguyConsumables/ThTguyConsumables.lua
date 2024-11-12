--- STEAMODDED HEADER
--- MOD_NAME: Thatguytheman's consumables and stuff
--- MOD_ID: ThTguyConsumable
--- MOD_AUTHOR: [Thatguytheman]
--- MOD_DESCRIPTION: runes and stuff (and a few random jokers)

--[[to do:
Add runes (negative tarots that are weaker and more temporary)
Add reverser card (can appear in any pack, and reverses all consumables and makes them eternal (you HAVE to use them))
Add reverse planet cards (removes a level from poker hand)
Add reverse runes (more permanent and stronger runes)
Add reverse tarots (weaker and eternal)
Add reverse spectrals (weaker and eternal)

Add Jokers (balance top 10% chips + mult, transfer 5% of mult to chips, chip multiplier, set mult to 100, reduce mult by 10% and award 1$ per 10 mult)

thank you to cryptid mod because i copied a bunch of stuff from it to learn

]]


--[[
    Runes and meanings:
    Laguz (water) : +1 discard for round

]]

SMODS.Atlas{
    
}

SMODS.ConsumableType{

    key = "Runes",
    primary_colour = HEX("480049"),
    secondary_colour = HEX("890062"),
    collection_rows = { 2, 6 }, -- 2 pages for all runes
    shop_rate = 0.2,
    loc_txt = {
        name = "Runes",
        collection = "Runes"
    },
    can_stack = true,
    can_divide = true,

}

SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition(e_negative, false, false)
    end,
    loc_txt = {
        name = "Laguz",
        text = {"Gain {C:attention}+1{} discard"}
    },
    set = "Runes",
    name = "runes-laguz",
    key = "laguz",
    pos = {x = 0, y = 0},
    config = {},
    cost = 4,
    order = 1,
    can_use = function(self, card)
        return G.STATE == G.STATES.SELECTING_HAND
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            ease_discard(1)
        return true end }))
    end,
}


    
