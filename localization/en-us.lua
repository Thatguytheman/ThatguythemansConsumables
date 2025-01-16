

--[[
            c_TGTM_name = {
                name = "",
                text = {""}
            },
            c_TGTM_nameC = {
                name = "",
                text = {"", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards"}
            },
]]

return {
    descriptions = {
        Runes = {
            c_TGTM_blank = {
                name = "Blank",
                text = {"Spawn a {C:purple}rune{}", "{C:red}#2# in #3# chance to not get destroyed when used{}", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_blankC = {
                name = "Blank?",
                text = {"Spawn a {C:purple}rune{}", "{C:red}DOES NOT GET DESTROYED WHEN USED{}", "{C:attention}+#4#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_laguz = {
                name = "Laguz",
                text = {"Gain {C:red}#1#{} discard"}
            },
            c_TGTM_laguzC = {
                name = "Laguz?",
                text = {"Gain {C:red}#1#{} discards", "{C:attention}+#2#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_dagaz = {
                name = "Dagaz",
                text = {"{C:red}Disable{} boss blind", "{C:attention}No reward money from blind{} "}
            },
            c_TGTM_dagazC = {
                name = "Dagaz?",
                text = {"{C:red}Disable{} boss blind", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_othala = {
                name = "Othala",
                text = {"Earn {C:attention}interest cap * #2#{} Dollars {C:inactive}($#1#){}", "{C:red}-#3#%{} of Interest cap"}
            },
            c_TGTM_othalaC = {
                name = "Othala?",
                text = {"Earn {C:attention}interest cap * #2#{} Dollars {C:inactive}($#1#){}", "{C:attention}+#4#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_inguz = {
                name = "Inguz",
                text = {"{C:red}Set money to 0", "{C:attention}+#3#{} Interest per {C:attention}#2#${} lost {C:inactive}(+#1#){}"}
            },
            c_TGTM_inguzC = {
                name = "Inguz?",
                text = {"{C:attention}+#3#{} Interest per {C:attention}#2#${} {C:inactive}(+#1#){}", "{C:attention}+#4#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_mannaz = {
                name = "Mannaz",
                text = {"Scored face cards give {X:mult,C:white}#1#x{} mult and {C:attention}#3#{} chips", "{C:attention}#2#{} chips","Only for this round"}
            },
            c_TGTM_mannazC = {
                name = "Mannaz?",
                text = {"Scored face cards give {X:mult,C:white}#1#x{} mult", "Only for this round", "{C:attention}+#4#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_ehwaz = {
                name = "Ehwaz",
                text = {"{C:attention}#1# ante{}", "Break a random non-negative joker"}
            },
            c_TGTM_ehwazC = {
                name = "Ehwaz?",
                text = {"{C:attention}#1# ante{}", "{C:attention}+#2#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_berkano = {
                name = "Berkano",
                text = {"{C:attention}Duplicate{} one joker","{C:mult}Debuff{} another joker"}
            },
            c_TGTM_berkanoC = {
                name = "Berkano?",
                text = {"{C:attention}Duplicate{} one joker", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_tiwaz = {
                name = "Tiwaz",
                text = {"Increase blind payout by {C:attention}+$#1#{} dollars","Increase current blind score by #2#%"}
            },
            c_TGTM_tiwazC = {
                name = "Tiwaz?",
                text = {"Increase blind payout by {C:attention}+$#1#{} dollars", "{C:attention}+#3#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_sowilo = {
                name = "Sowilo",
                text = {"Remove all stickers from a selected joker","Purify the joker"}
            },
            c_TGTM_sowiloC = {
                name = "Sowilo?",
                text = {"Remove all stickers from a selected joker", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_algiz = {
                name = "Algiz",
                text = {"Upgrade #1# selected glass cards to Sturdy Glass cards"}
            },
            c_TGTM_algizC = {
                name = "Algiz?",
                text = {"Upgrade #1# selected glass cards to Sturdier Glass cards", "{C:attention}+#2#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_perthro = {
                name = "Perthro",
                text = {"{C:attention}Reroll{} selected {C:attention}joker{} to one of higher {C:attention}rarity{}", "All future blinds raised proportional to the rarity generated"}
            },
            c_TGTM_perthroC = {
                name = "Perthro?",
                text = {"{C:attention}Reroll selected {C:attention}joker{} to one of higher {C:attention}rarity{}", "{C:purple}Curse chance{} raised proportional to the rarity generated"}
            },
            c_TGTM_eihwaz = {
                name = "Eihwaz",
                text = {"Balance chips and mult this round", "X#1# current blind requirements"}
            },
            c_TGTM_eihwazC = {
                name = "Eihwaz?",
                text = {"Balance chips and mult this round", "{C:attention}+#2#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_jera = {
                name = "Jera",
                text = {"Double money", "{C:inactive}Max of #1# dollars{}"}
            },
            c_TGTM_jeraC = {
                name = "Jera?",
                text = {"Double money", "{C:attention}+#2#%{} chance for {C:purple}cursed{} cards", "{C:inactive}Max of #1# dollars{}"}
            },
            c_TGTM_isa = {
                name = "Isa",
                text = {"+#1# hands for this round", "#2# handsize for this round"}
            },
            c_TGTM_isaC = {
                name = "Isa?",
                text = {"+#1# hands for this round", "{C:attention}+#3#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_nauthiz = {
                name = "Nauthiz",
                text = {"Upgrades next hand played", "Downgrades the selected hand after round", "{C:inactive}(Selected hand:#2#){}"}
            },
            c_TGTM_nauthizC = {
                name = "Nauthiz?",
                text = {"Upgrades next hand played", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_hagalaz = {
                name = "Hagalaz",
                text = {"Destroys all cards in hand except for one", "-#2#% blind size per card destroyed"}
            },
            c_TGTM_hagalazC = {
                name = "Hagalaz?",
                text = {"-#3#% blind size", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_wunjo = {
                name = "Wunjo",
                text = {"Awards $#3# per #2#% overkill this round", "{C:inactive}(Max payout: #4#){}"}
            },
            c_TGTM_wunjoC = {
                name = "Wunjo?",
                text = {"Awards $#3# per #2#% overkill this round", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards", "{C:inactive}(Max payout: #4#){}"}
            },
            c_TGTM_gebo = {
                name = "Gebo",
                text = {"Give #2# selected cards a random edition and seal"}
            },
            c_TGTM_geboC = {
                name = "Gebo?",
                text = {"Give #2# selected cards a random edition and seal", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_kennaz = {
                name = "Kennaz",
                text = {"Flip all jokers and cards held in hand"}
            },
            c_TGTM_kennazC = {
                name = "Kennaz?",
                text = {"Flip all jokers and cards held in hand face up", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_raidho = {
                name = "Raidho",
                text = {"Spawn #2# tags"}
            },
            c_TGTM_raidhoC = {
                name = "Raidho?",
                text = {"Spawn #2# tags", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_ansuz = {
                name = "Ansuz",
                text = {"Reroll boss blind", "Increase blind size by #2#%"}
            },
            c_TGTM_ansuzC = {
                name = "Ansuz?",
                text = {"Reroll boss blind", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_thurisaz = {
                name = "Thurisaz",
                text = {"#2# in #3# chance to remove a selected jokers edition"}
            },
            c_TGTM_thurisazC = {
                name = "Thurisaz?",
                text = {"Remove a selected jokers edition", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_uruz = {
                name = "Uruz",
                text = {"Score #2#% of blind instantly", "+#3# ante", "{C:inactive}(#4# chips){}"}
            },
            c_TGTM_uruzC = {
                name = "Uruz?",
                text = {"Score #2#% of blind instantly", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards", "{C:inactive}(#4# chips){}"}
            },
            c_TGTM_fehu = {
                name = "Fehu",
                text = {"Clense #2#% of curse chance", "{C:inactive}(Current curse chance: #3#){}"}
            },
            c_TGTM_fehuC = {
                name = "Fehu?",
                text = {"Clense #2#% of curse chance", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards after clensing","{C:inactive}(Current curse chance: #3#){}"}
            },

        },
        Enhanced = {
            m_TGTM_SturdyGlass = {
                name = "Sturdy Glass",
                text = {"{X:mult,C:white}X2{} Mult", "#1# in #2# chance to not give {X:mult,C:white}X2{} Mult"}
            },
            m_TGTM_SturdierGlass = {
                name = "Sturdier Glass",
                text = {"{X:mult,C:white}X2{} Mult", "#1# in #2# chance to give {X:mult,C:white}X1.5{} Mult"}
            }
        }

    }
}