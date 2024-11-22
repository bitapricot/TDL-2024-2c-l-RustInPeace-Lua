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
        zone = 1,
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
        zone = 1,
        x = 300,
        y = 450,
        sprite = "assets/sprites/sanity_elixir.png"  -- Ruta al sprite
    }
}