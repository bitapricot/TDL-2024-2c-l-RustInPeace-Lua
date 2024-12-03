return {
    {
        id = 1,
        name = "Potion of Healing",
        description = "Restores 50 health points.",
        effect = function(target)
            target:heal(50)
        end,
        chapter = 1,
        quantity = 1,
        zoneId = "zone4",
        x = 200,
        y = 250,
        sprite = "assets/sprites/potion.png"  -- Ruta al sprite
    },
    {
        id = 2,
        name = "Sanity Elixir",
        description = "Restores 30 sanity points.",
        effect = function(target)
            target:restoreSanity(30)
        end,
        chapter = 1,
        quantity = 1,
        zoneId = "zone4",
        x = 300,
        y = 450,
        sprite = "assets/sprites/sanity_elixir.png"  -- Ruta al sprite
    },
    {
        id = 3,
        name = "Offering",
        description = "Ofrecer al cadáver",
        -- effect = function(target)
        --     target:restoreSanity(30)
        -- end,
        effect = nil,
        chapter = 1,
        quantity = 1,
        zoneId = "zone5",
        x = 500,
        y = 500,
        sprite = "assets/sprites/offering.png"
    }
}