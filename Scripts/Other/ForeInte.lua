QFForeInte = {};
local key,Path=nil,nil;
local MyName="QFWDModeifiers";
function QFForeInte.OnInte()--预先载入
	print("MOD版修改器:ModifierMain init");
	--local GMod=CS.GameWatch.Instance;
	--if GMod~=nil and GMod ~= CS.XiaWorld.g_emGameMode.Fight then
-----------------------杂项修改-------------------
	QFForeInte.FightMap=false;
	
	local PWrdMgr=CS.XiaWorld.World;
	if PWrdMgr~=nil then
		local WrdMgr=PWrdMgr.Instance;
		if WrdMgr~=nil and WrdMgr.GameMode~=nil and WrdMgr.GameMode ~= CS.XiaWorld.g_emGameMode.Fight then
			--print("MOD版修改器:Isn't Fight Map!")
			if QFForeInte.CheckValue(1) then
				print("MOD版修改器:真仙模式");
				QFForeInte.ToZhenXian();
			end
			if QFForeInte.CheckValue(2) then
				print("MOD版修改器:堆叠上限");
				QFForeInte.ToRange9999();
			end
			if QFForeInte.CheckValue(3) then
				print("MOD版修改器:建筑血量");
				QFForeInte.ChangeBuilding99999();
			end
			if QFForeInte.CheckValue(4) then
				print("MOD版修改器:物品建筑美观");
				QFForeInte.ChangeBeauty999();
			end
			if QFForeInte.CheckValue(5) then
				print("MOD版修改器:物品聚灵范围");
				QFForeInte.ChangeAddLing9();
			end
			if QFForeInte.CheckValue(6) then
				print("MOD版修改器:物品聚灵");
				QFForeInte.ChangeLing999();
			end
		else
			QFForeInte.FightMap=true;
		end
	end
	

-----------------------载入dll-------------------
	if tonumber(key)==nil then
		print("MOD版修改器:Can not load Dll.");
	else
		--MyName=ModifierMain:GetMyName(key);
		QFForeInte.SetPath(key);
		--if MyName=="Key cann't be used!" then
		--	print("MOD版修改器:Can not load Dll.");
		--end
		QFForeInte.LoadDll();
	end
	if QFLanguage~=nil then
		QFLanguage.OnInit();
	end
end
function QFForeInte.SetValue(num,value)
	local head=78000
	World:SetFlag(head+num, value);
	return true;
end
function QFForeInte.CheckValue(num)
	local head=78000
	local num=World:GetFlag(head+num);
	if num==1 then
		return true;
	else
		return false;
	end
end
function QFForeInte.OnEnter()
	print("MOD版修改器:ModifierMain enter");
	--注册第二快捷键
	if CS.XiaWorld.InputMgr ~= nil and CS.XiaWorld.InputMgr.Instance~=nil then
		CS.XiaWorld.InputMgr.Instance:AddNewInputKeyData("ModifierMains", "MOD-辅助启动", "Mod", "PageUp", "PageDown", "", true)
	end
	local PWrdMgr=CS.XiaWorld.World;
	if PWrdMgr~=nil then
		local WrdMgr=PWrdMgr.Instance;
		if WrdMgr~=nil and WrdMgr.GameMode~=nil and WrdMgr.GameMode ~= CS.XiaWorld.g_emGameMode.Fight then
			print("MOD版修改器:Isn't Fight Map!")
			if ModifierMain:FindWindow("OthersSet")~=nil then
				ModifierMain:FindWindow("OthersSet"):GameIn();
			end
		else
			print("MOD版修改器:Is Fight Map!")
		end
	end
	
	if ModifierMain:FindWindow("EasyUse")~=nil then
		ModifierMain:FindWindow("EasyUse"):GameIn()
	end
	if World:GetFlag(6202)==1 then
		ModifierMain.SpeedOpen=false;
	else
		ModifierMain.SpeedOpen=true;
	end
	ModifierMain.InSpeedFunc=false;
	if TimeSetSpeed == nil then
		ModifierMain.SpeedHadInt = true;
	end
end
function QFForeInte.ToZhenXian()
	local MyKey=CS.XiaWorld.GlobleDataMgr.Instance:GetUserKey();
	local OldKey=World.UserID;
	if MyKey~=OldKey then
		World.UserID=CS.XiaWorld.GlobleDataMgr.Instance:GetUserKey();
	end
	World.GameMode = CS.XiaWorld.g_emGameMode.HardCore;
	
end

function QFForeInte.ToRange9999()
	local _,MapListDef = CS.XiaWorld.ThingMgr.Instance.m_mapThingDefs:TryGetValue(2);
	local num=1;
	local localKey=nil;
	local localValue=nil;
	for localKey, localValue in pairs(MapListDef) do 
		if localValue~=nil and localValue.MaxStack~=nil then
			local bool1 = (localValue.Parent=="DrugBase" or localValue.Parent=="DanBase" or localValue.Parent=="SimpleFoodBase" or localValue.Parent=="Item_SoulCrystalBase" or localValue.Parent=="IngredientBase" or localValue.Parent=="LeftoverMaterialBase" or localValue.Parent=="MeatBase" or localValue.Parent=="MetalBlockBase");
			if bool1 then
				localValue.MaxStack=9999;
			else
				local bool2 = (localValue.Parent=="RockBlockBase" or localValue.Parent=="WoodBlockBase" or localValue.Parent=="LeatherBase" or localValue.Parent=="MetalBase" or localValue.Parent=="RockBase" or localValue.Parent=="WoodBase" or localValue.Parent=="Item_SpellPaper");
				if bool2 then
					localValue.MaxStack=9999;
				end
			end
		end
	end
end
function QFForeInte.ChangeBuilding99999()
	local _,MapListDef = CS.XiaWorld.ThingMgr.Instance.m_mapThingDefs:TryGetValue(4);
	local num=1;
	local localKey=nil;
	local localValue=nil;
	for localKey, localValue in pairs(MapListDef) do 
		if localValue~=nil and localValue.MaxHitPoints~=nil then
			localValue.MaxHitPoints=99999;
		end
	end
	local list = ThingMgr:GetThingList(CS.XiaWorld.g_emThingType.Building);
	if list == nil then
		print("MOD版修改器:地图无建筑。")
		return
	end
	for localKey, localValue in pairs(list) do
		if localValue ~= nil and localValue.MaxHp~=nil then
			localValue:AddHealth(localValue.MaxHp-localValue.Hp);
			--print(item.Name)
		end
	
	end
end
function QFForeInte.ChangeBeauty999()
	local _,MapListDef = CS.XiaWorld.ThingMgr.Instance.m_mapThingDefs:TryGetValue(2);
	local num=1;
	local localKey=nil;
	local localValue=nil;
	for localKey, localValue in pairs(MapListDef) do 
		if localValue~=nil and localValue.Beauty~=nil then
			localValue.Beauty=999;
		end
	end
	_,MapListDef = CS.XiaWorld.ThingMgr.Instance.m_mapThingDefs:TryGetValue(3);
	num=1;
	localKey=nil;
	localValue=nil;
	for localKey, localValue in pairs(MapListDef) do 
		if localValue~=nil and localValue.Beauty~=nil then
			localValue.Beauty=999;
		end
	end
	_,MapListDef = CS.XiaWorld.ThingMgr.Instance.m_mapThingDefs:TryGetValue(4);
	num=1;
	localKey=nil;
	localValue=nil;
	for localKey, localValue in pairs(MapListDef) do 
		if localValue~=nil and localValue.Beauty~=nil then
			localValue.Beauty=999;
		end
	end
end
function QFForeInte.ChangeAddLing9()
	local _,MapListDef = CS.XiaWorld.ThingMgr.Instance.m_mapThingDefs:TryGetValue(2);
	local num=1;
	local localKey=nil;
	local localValue=nil;
	for localKey, localValue in pairs(MapListDef) do 
		if localValue~=nil and localValue.Ling~=nil and localValue.Ling.AddionRadius~=nil then
			localValue.Ling.AddionRadius=9;
		end
	end
end
function QFForeInte.ChangeLing999()
	local _,MapListDef = CS.XiaWorld.ThingMgr.Instance.m_mapThingDefs:TryGetValue(2);
	local num=1;
	local localKey=nil;
	local localValue=nil;
	for localKey, localValue in pairs(MapListDef) do 
		if localValue~=nil and localValue.Ling~=nil and localValue.Ling.AddionLing~=nil then
			localValue.Ling.AddionLing=999;
		end
	end
end
function QFForeInte.SetKey(Key)
	key=Key;
end
function QFForeInte.SetPath(key)
	Path=ModifierMain:GetMyPath(key);
	if Path=="Key cann't be used!" then
		return false;
	else
		return true;
	end
end
function QFForeInte.LoadDll()
	local dllType=1;
	local Me = CS.ModsMgr.Instance:FindMod(MyName, nil, true);
	--print(Me.Path)
	local MePath,MeDll,RAsm;
	if Me==nil or Me=="" then
		if Path==nil then
			dllType=0;
		else
			MePath=Path;
		end
	else
		MePath = Me.Path;
	end
	if dllType<=0 or MePath==nil or MePath=="" then
		dllType=-1;
	else
		MeDll = MePath.."//Scripts//Lib//QFLib.dll";
	end
	if dllType<=0 or MeDll==nil or MeDll=="" then
		dllType=-2;
	else
		RAsm = CS.System.Reflection.Assembly.LoadFrom(MeDll);
	end
	if dllType<=0 or RAsm==nil or RAsm=="" then
		ModifierMain.lib = nil;
		print("MOD版修改器:载入动态库失败！","错误编号:",tostring(dllType));
	else
		ModifierMain.lib = RAsm:GetType("QFLib.QFLib");
		if ModifierMain.lib==nil then
			dllType=-3;
			print("MOD版修改器:载入动态库失败！","错误编号:",tostring(dllType));
		else
			print("MOD版修改器:载入动态库成功！");
		end
	end
end