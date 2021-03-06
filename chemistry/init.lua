chemistry={}
chemistry.reaction=0
chemistry.reactions={}

function chemistry:register_reaction(reaction)
  chemistry.reaction=chemistry.reaction+1
  chemistry.reactions[chemistry.reaction]=reaction
end

local ident={H=1,He=2,Li=3,Be=4,B=5,C=6,N=7,O=8,F=9,Ne=10,Na=11,Mg=12,Al=13,Si=14,P=15,S=16,Cl=17,Ar=18,K=19,Ca=20,Sc=21,Ti=22,V=23,Cr=24,Mn=25,Fe=26,Co=27,Ni=28,Cu=29,Zn=30,Ga=31,Ge=32,As=33,Se=34,Br=35,Kr=36,Rb=37,Sr=38,Y=39,Zr=40,Nb=41,Mo=42,Tc=43,Ru=44,Rh=45,Pd=46,Ag=47,Cd=48,In=49,Sn=50,Sb=51,Te=52,I=53,Xe=54,Cs=55,Ba=56,La=57,Ce=58,Pr=59,Nd=60,Pm=61,Sm=62,Eu=63,Gd=64,Tb=65,Dy=66,Ho=67,Er=68,Tm=69,Yb=70,Lu=71,Hf=72,Ta=73,W=74,Re=75,Os=76,Ir=77,Pt=78,Au=79,Hg=80,Tl=81,Pb=82,Bi=83,Po=84,At=85,Rn=86,Fr=87,Ra=88,Ac=89,Th=90,Pa=91,U=92,Np=93,Pu=94,Am=95,Cm=96,Bk=97,Cf=98,Es=99,Fm=100,Md=101,No=102,Lr=103,Rf=104,Db=105,Sg=106,Bh=107,Hs=108,Mt=109,Ds=110,Rg=111,Cn=112,Uut=113,Fl=114,Uup=115,Lv=116,Uus=117,Uuo=118,}

function chemistry:fetch_element_id(str)
	print(ident[string.sub(str,11,-1)])
	return ident[string.sub(str,11,-1)]
end

dofile(minetest.get_modpath("chemistry").."/crafts.lua")


local groups={{"H",1},{"He",2},{"Li",3},{"Be",4},{"B",5},{"C",6},{"N",7},{"O",8},{"F",9},{"Ne",10},{"Na",11},{"Mg",12},{"Al",13},{"Si",14},{"P",15},{"S",16},{"Cl",17},{"Ar",18},{"K",19},{"Ca",20},{"Sc",21},{"Ti",22},{"V",23},{"Cr",24},{"Mn",25},{"Fe",26},{"Co",27},{"Ni",28},{"Cu",29},{"Zn",30},{"Ga",31},{"Ge",32},{"As",33},{"Se",34},{"Br",35},{"Kr",36},{"Rb",37},{"Sr",38},{"Y",39},{"Zr",40},{"Nb",41},{"Mo",42},{"Tc",43},{"Ru",44},{"Rh",45},{"Pd",46},{"Ag",47},{"Cd",48},{"In",49},{"Sn",50},{"Sb",51},{"Te",52},{"I",53},{"Xe",54},{"Cs",55},{"Ba",56},{"La",57},{"Ce",58},{"Pr",59},{"Nd",60},{"Pm",61},{"Sm",62},{"Eu",63},{"Gd",64},{"Tb",65},{"Dy",66},{"Ho",67},{"Er",68},{"Tm",69},{"Yb",70},{"Lu",71},{"Hf",72},{"Ta",73},{"W",74},{"Re",75},{"Os",76},{"Ir",77},{"Pt",78},{"Au",79},{"Hg",80},{"Tl",81},{"Pb",82},{"Bi",83},{"Po",84},{"At",85},{"Rn",86},{"Fr",87},{"Ra",88},{"Ac",89},{"Th",90},{"Pa",91},{"U",92},{"Np",93},{"Pu",94},{"Am",95},{"Cm",96},{"Bk",97},{"Cf",98},{"Es",99},{"Fm",100},{"Md",101},{"No",102},{"Lr",103},{"Rf",104},{"Db",105},{"Sg",106},{"Bh",107},{"Hs",108},{"Mt",109},{"Ds",110},{"Rg",111},{"Cn",112},{"Uut",113},{"Fl",114},{"Uup",115},{"Lv",116},{"Uus",117},{"Uuo",118},}
 
for _, element in ipairs(groups) do
  minetest.register_node("chemistry:"..element[1], {
    description = element[1],
    tiles = {element[1]..".png"},
    inventory_image = element[1]..".png",
    groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,flammable=3,chemistry=1},
  })
  minetest.register_ore({
	  ore_type = "scatter",
	  ore = "chemistry:"..element[1],
	  wherein = "default:stone",
	  clust_scarcity = 30 * 30 * 30,
	  clust_num_ores = 3,
	  clust_size = 3, 
	  y_min = -31000,
	  y_max = 0,
  })
end

minetest.register_node("chemistry:extractor", {
  description = "Chemical Extractor",
  tiles = {"extractor_sign.png", "chemistry_base.png", "chemistry_base.png", "chemistry_base.png", "extractor.png", "reactor.png"},
  inventory_image = "extractor.png",
  groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,flammable=3,chemistry=1},
  on_punch = function(pos)
    local node_name = minetest.env:get_node({x=pos.x-1, y=pos.y, z=pos.z}).name
    for reaction in ipairs(chemistry.reactions) do
      local name = chemistry.reactions[reaction][1]
      if name == node_name then
			minetest.env:remove_node({x=pos.x-1, y=pos.y, z=pos.z})
			for i,str in ipairs(chemistry.reactions[reaction][2]) do
				  chemistry:fetch_element_id(str)
				  minetest.add_node({x=pos.x+i, y=pos.y, z=pos.z},{name=str})
			end
        return
      end
    end
  end
})

minetest.register_node("chemistry:reactor", {
  description = "Chemical Reactor",
  tiles = {"reactor_sign.png", "chemistry_base.png", "chemistry_base.png", "chemistry_base.png", "reactor.png", "extractor.png"},
  inventory_image = "reactor.png",
  groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,flammable=3,chemistry=1},
  on_punch = function(pos)
	  local curr = 0
	  local tab = {}
	  -- Collect the atoms
	  while true do
		  -- Get current node
		  local name = minetest.get_node({x=pos.x+curr+1,y=pos.y,z=pos.z}).name
		  if chemistry:fetch_element_id(name) == nil then
			  break
		  else
			  curr = curr+1
			  tab[curr] = chemistry:fetch_element_id(name)
		  end
	  end
	  print("Fetch Complete")
	  -- Check whether is thing is a good recipe
	  for i = 1, chemistry.reaction, 1 do
		  -- Count.
		  local cnt = 0
		  local can = true
		  for _ in ipairs(chemistry.reactions[i][2]) do cnt = cnt+1 end
		  if cnt == curr then
			  for j = 1, cnt do
				  if tab[j] ~= chemistry:fetch_element_id(chemistry.reactions[i][2][j]) then
					  can = false
					  break
				  end
			  end
			  if can then
				  minetest.add_node({x=pos.x-1,y=pos.y,z=pos.z},{name=chemistry.reactions[i][1]})
				  for j = 1,curr do 
					  minetest.remove_node({x=pos.x+j,y=pos.y,z=pos.z})
				  end
				  break
			  end
		  end
	  end
  end
})

