return {
    {
        id = 1,
        name = "Healing Potion",
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
    },
    {
        id = 4,
        name = "Healing Potion",
        description = "Restores 50 health points.",
        effect = function(target)
            target:heal(50)
        end,
        chapter = 1,
        quantity = 1,
        zoneId = "zone2",
        x = 250,
        y = 450,
        sprite = "assets/sprites/potion.png"  -- Ruta al sprite
    },
    {
        id = 5,
        name = "Sanity Elixir",
        description = "Restores 30 sanity points.",
        effect = function(target)
            target:restoreSanity(30)
        end,
        chapter = 1,
        quantity = 1,
        zoneId = "zone3",
        x = 350,
        y = 150,
        sprite = "assets/sprites/sanity_elixir.png"  -- Ruta al sprite
    },
    {
        id = 6,
        name = "Healing Potion",
        description = "Restores 50 health points.",
        effect = function(target)
            target:heal(50)
        end,
        chapter = 1,
        quantity = 1,
        zoneId = "zone6",
        x = 400,
        y = 150,
        sprite = "assets/sprites/potion.png"  -- Ruta al sprite
    },
    {
        id = 6,
        name = "Healing Potion",
        description = "Restores 50 health points.",
        effect = function(target)
            target:heal(50)
        end,
        chapter = 1,
        quantity = 1,
        zoneId = "zone9",
        x = 400,
        y = 320,
        sprite = "assets/sprites/potion.png"  -- Ruta al sprite
    },
}