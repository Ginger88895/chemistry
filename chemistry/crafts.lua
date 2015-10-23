--default
chemistry:register_reaction({"default:water_source",
  {"chemistry:H","chemistry:O","chemistry:H"},
})

chemistry:register_reaction({"default:sand",
  {"chemistry:Si", "chemistry:O", "chemistry:O"},
})

chemistry:register_reaction({"default:stone_with_coal",
  {"chemistry:C"},
})

--moreores
chemistry:register_reaction({"default:goldblock",
  {"chemistry:Au"},
})

chemistry:register_reaction({"moreores:silver_block",
  {"chemistry:Ag"},
})

chemistry:register_reaction({"default:copperblock",
  {"chemistry:Cu"},
})

chemistry:register_reaction({"moreores:tin_block",
  {"chemistry:Sn"},
})

chemistry:register_reaction({"default:stone_with_iron",
  {"chemistry:Fe"},
})

--diamonds
chemistry:register_reaction({"default:diamondblock",
  {"chemistry:C","chemistry:C","chemistry:C","chemistry:C"},
})
