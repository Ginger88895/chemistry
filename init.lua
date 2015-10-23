chemistry={}
chemistry.reaction=0
chemistry.reactions={}

function chemistry:register_reaction(reaction)
  chemistry.reaction=chemistry.reaction+1
  chemistry.reactions[chemistry.reaction]=reaction
end

dofile(minetest.get_modpath("chemistry").."/crafts.lua")

local groups = {
	{"H",1}
	{"He",2}
	{"Li",3}
	{"Be",4}
	{"B",5}
	{"C",6}
	{"N",7}
	{"O",8}
	{"F",9}
	{"Ne",10}
	{"Na",11}
	{"Mg",12}
	{"Al",13}
	{"Si",14}
	{"P",15}
	{"S",16}
	{"Cl",17}
	{"Ar",18}
	{"K",19}
	{"Ca",20}
	{"Sc",21}
	{"Ti",22}
	{"V",23}
	{"Cr",24}
	{"Mn",25}
	{"Fe",26}
	{"Co",27}
	{"Ni",28}
	{"Cu",29}
	{"Zn",30}
	{"Ga",31}
	{"Ge",32}
	{"As",33}
	{"Se",34}
	{"Br",35}
	{"Kr",36}
	{"Rb",37}
	{"Sr",38}
	{"Y",39}
	{"Zr",40}
	{"Nb",41}
	{"Mo",42}
	{"Tc",43}
	{"Ru",44}
	{"Rh",45}
	{"Pd",46}
	{"Ag",47}
	{"Cd",48}
	{"In",49}
	{"Sn",50}
	{"Sb",51}
	{"Te",52}
	{"I",53}
	{"Xe",54}
	{"Cs",55}
	{"Ba",56}
	{"La",57}
	{"Ce",58}
	{"Pr",59}
	{"Nd",60}
	{"Pm",61}
	{"Sm",62}
	{"Eu",63}
	{"Gd",64}
	{"Tb",65}
	{"Dy",66}
	{"Ho",67}
	{"Er",68}
	{"Tm",69}
	{"Yb",70}
	{"Lu",71}
	{"Hf",72}
	{"Ta",73}
	{"W",74}
	{"Re",75}
	{"Os",76}
	{"Ir",77}
	{"Pt",78}
	{"Au",79}
	{"Hg",80}
	{"Tl",81}
	{"Pb",82}
	{"Bi",83}
	{"Po",84}
	{"At",85}
	{"Rn",86}
	{"Fr",87}
	{"Ra",88}
	{"Ac",89}
	{"Th",90}
	{"Pa",91}
	{"U",92}
	{"Np",93}
	{"Pu",94}
	{"Am",95}
	{"Cm",96}
	{"Bk",97}
	{"Cf",98}
	{"Es",99}
	{"Fm",100}
	{"Md",101}
	{"No",102}
	{"Lr",103}
	{"Rf",104}
	{"Db",105}
	{"Sg",106}
	{"Bh",107}
	{"Hs",108}
	{"Mt",109}
	{"Ds",110}
	{"Rg",111}
	{"Cn",112}
	{"Uut",113}
	{"Fl",114}
	{"Uup",115}
	{"Lv",116}
	{"Uus",117}
	{"Uuo",118}
}
 
for ii, element in ipairs(groups) do
  minetest.register_node("chemistry:"..element[1], {
    description = element[1],
    tiles = {element[1]..".png"},
    inventory_image = element[1]..".png",
    groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,flammable=3,chemistry=1},
  })
end

minetest.register_node("chemistry:extractor", {
  description = "Chemical extractor",
  tiles = {"extractor_sign.png", "chemistry_base.png", "chemistry_base.png", "chemistry_base.png", "extractor.png", "reactor.png"},
  inventory_image = "extractor.png",
  groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,flammable=3,chemistry=1},
  on_punch = function(pos)
    minetest.env:set_node(pos,{name="chemistry:reactor"})
    
    local node_name = minetest.env:get_node({x=pos.x-1, y=pos.y, z=pos.z}).name
    for reaction in ipairs(chemistry.reactions) do
      name = chemistry.reactions[reaction][1]
      if name == node_name then
        
        minetest.env:remove_node({x=pos.x-1, y=pos.y, z=pos.z})
        for xx in ipairs(chemistry.reactions[reaction]) do
          if xx > 1 then
            for yy in ipairs(chemistry.reactions[reaction][xx]) do
              
              minetest.env:add_node({x=pos.x+xx-1, y=pos.y+yy-1, z=pos.z},{name=chemistry.reactions[reaction][xx][yy]})
            end
          end
        end
        
        return
      end
    end
  end
})

minetest.register_node("chemistry:reactor", {
  description = "Chemical reactor",
  tiles = {"reactor_sign.png", "chemistry_base.png", "chemistry_base.png", "chemistry_base.png", "reactor.png", "extractor.png"},
  inventory_image = "reactor.png",
  groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,flammable=3,chemistry=1},
  on_punch = function(pos)
    minetest.env:set_node(pos,{name="chemistry:extractor"})
    local numb = 0
    local atom = 1
    local candidates = deepcopy(chemistry.reactions)
    local candidate = 0
    local match = ""
    local node_name = minetest.env:get_node({x=pos.x+atom, y=pos.y+numb, z=pos.z}).name
    
    while true do
      if node_name == "air" then
        return
      end
      
      node_name = minetest.env:get_node({x=pos.x+atom, y=pos.y+numb, z=pos.z}).name
      
      if node_name == "air" then
        atom = atom + 1
        numb = 0
        node_name = minetest.env:get_node({x=pos.x+atom, y=pos.y+numb, z=pos.z}).name
      end
      
      if candidate == 1 then
        local count = 0
        local max = 0
        for xx in ipairs(candidates[1]) do
          if xx > 1 then
            for yy in ipairs(candidates[1][xx]) do
              max = max + 1
              node_name = minetest.env:get_node({x=pos.x+xx-1, y=pos.y+yy-1, z=pos.z}).name
              if node_name == candidates[1][xx][yy] then
                count = count + 1
              end
            end
          end
        end
        
        if count == max then
          minetest.env:add_node({x=pos.x-1, y=pos.y, z=pos.z}, {name=candidates[1][1]})
          for xx in ipairs(candidates[1]) do
            if xx > 1 then
              for yy in ipairs(candidates[1][xx]) do
                minetest.env:remove_node({x=pos.x+xx-1, y=pos.y+yy-1, z=pos.z})
              end
            end
          end
        end
        return
      end
      
      candidate = 0 
      for reaction in ipairs(candidates) do
          local a = tostring(candidates[reaction][atom+1][numb+1])
          
          if a == node_name then
            candidate = candidate+1
            candidates[candidate] = candidates[reaction]
          end
          
          if candidate < reaction then
            if candidate ~= 0 then
              candidates[reaction] = nil
            end
          end
          
      end
      
      if candidate == 0 then
        return
      end
      
      numb = numb + 1
      
    end
  end,
})

function deepcopy(t)
if type(t) ~= 'table' then return t end
local mt = getmetatable(t)
local res = {}
for k,v in pairs(t) do
if type(v) == 'table' then
v = deepcopy(v)
end
res[k] = v
end
setmetatable(res,mt)
return res
end

