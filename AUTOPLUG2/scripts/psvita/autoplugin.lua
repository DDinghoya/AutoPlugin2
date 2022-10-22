--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/scripts/psvita/autoplugin.lua", APP_REPO, APP_PROJECT, APP_FOLDER), tmpdir.."autoplugin.lua")
if res.headers and res.headers.status_code == 200 and files.exists(tmpdir.."autoplugin.lua") then
	files.move(tmpdir.."autoplugin.lua","scripts/psvita/")
	dofile("scripts/psvita/autoplugin.lua")--Official
else
	files.delete(tmpdir.."autoplugin.lua")
end

screenshots = "ux0:data/AUTOPLUGIN2/screenshots/"
files.mkdir(screenshots)

function plugins_installation(obj)

	if obj.path:find(string.lower("udcd_uvc"),1,true) and hw.model() == "PlayStation TV" then os.message(LANGUAGE["INSTALLP_WARNING_UDCD"])
	elseif obj.path == "custom_warning.suprx" and ( version == "3.67" or version == "3.68" or version == "3.73") then os.message(LANGUAGE["INSTALLP_CWARNING_360_365"])
	elseif obj.path == "reVita.skprx" and ( version == "3.67" or version == "3.68" or version == "3.73") then os.message(LANGUAGE["INSTALLP_CWARNING_360_365"])
	elseif obj.path == "pspemu-colour-crunch.skprx" and hw.model() != "Vita Slim" then os.message(LANGUAGE["INSTALLP_LCDCOLOURSPACECHANGE"])
	elseif obj.path == "PSVshellPlus_Kernel.skprx" and ( version != "3.60" and version != "3.65") then os.message(LANGUAGE["INSTALLP_CWARNING_360_365"])
	else

		--Aqui checaremos posibles conflictos de plugins
		if obj.path == "sharpscale.skprx" and not tai.check("!AKRK00005") then
			tai.putBeforeSection("ALL","*!AKRK00005","")

		elseif obj.path == "vsh.suprx" and not tai.check("!PSPEMUCFW") then
			tai.putBeforeSection("ALL","*!PSPEMUCFW","")

		elseif obj.path == "hide-autoplugin.suprx" then
			if not tai.check("!1MENUVITA") and game.exists("1MENUVITA") then
				tai.putBeforeSection("ALL","*!1MENUVITA","")
			end
			if not tai.check("!1VITASHELL") and game.exists("VITASHELL") then
				tai.putBeforeSection("ALL","*!VITASHELL","")
			end
		--Ds4Touch
		elseif obj.path == "ds4touch.skprx" then
			tai.del("ALL",  "ds4touch.suprx")

		-- Sysident
		elseif obj.path == "sysident.suprx" then
			tai.put("KERNEL", path_tai.."sysident.skprx")
			files.copy(path_plugins.."sysident.skprx", path_tai)
			change = true

		-- QuickMenuPlus
		elseif obj.path == "quickmenuplus.suprx" then
			tai.del("main", "quick_power.suprx")
			tai.del("main", "quick_volume.suprx")
			tai.del("KERNEL", "rapidmenu.skprx")

		-- QuickMenuReborn
		elseif obj.path == "QuickMenuReborn.suprx" then
			files.delete("ux0:QuickMenuReborn/")

		--Checking plugin Batt (only 1 of them)
		elseif obj.path == "shellbat.suprx" then
			tai.del("main", "shellsecbat.suprx")
		elseif obj.path == "shellsecbat.suprx" then
			tai.del("main", "shellbat.suprx")

		elseif obj.path == "EmergencyMount.skprx" then
			if not files.exists("ur0:tai/EmergencyMount.bmp") then
				http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s", APP_REPO, APP_PROJECT, APP_FOLDER, "EmergencyMount.bmp"), "ur0:tai/EmergencyMount.bmp")
			end
			
		elseif obj.path == "HonRipper.suprx" then
			files.mkdir("ux0:HonRipper")

		-- Repatch
		elseif obj.path:find(string.lower("repatch"),1,true) then
			tai.del("KERNEL", "repatch.skprx")
			tai.del("KERNEL", "repatch_4.skprx")
			tai.del("KERNEL", "repatch_ex.skprx")
		-- Nonpdrm
		elseif obj.path:find(string.lower("nonpdrm"),1,true) then
			tai.del("KERNEL", "nonpdrm.skprx")
			tai.del("KERNEL", "nonpdrm_un.skprx")
		--Refood or syscall
		elseif obj.path == "reF00D.skprx" then
			tai.del("KERNEL", "0syscall6.skprx")
		elseif obj.path == "0syscall6.skprx" then
			tai.del("KERNEL", "reF00D.skprx")

		--Vitacheat
		elseif obj.path:find(string.lower("vitacheat"),1,true) then
			tai.del("KERNEL", "vitacheat360.skprx")
			tai.del("KERNEL", "vitacheat.skprx")

		--udcd
		elseif obj.path:find(string.lower("udcd_uvc"),1,true) then
			--os.message("delete udcds")
			tai.del("KERNEL", "udcd_uvc.skprx")
			tai.del("KERNEL", "udcd_uvc_oled_off.skprx")
			tai.del("KERNEL", "udcd_uvc_lcd_off.skprx")
		end

		--Aqui vamos a hacer que los vpks se descarguen y se instalen
		if obj.vpk then
			__file = files.nopath(obj.vpk)
			os.message(__file.." "..LANGUAGE["INSTALLP_QUESTION_VPK"],0)
			local path2vpk = "ux0:data/AUTOPLUGIN2/vpks/"..__file
			local res = http.download(obj.vpk, path2vpk)
			if res.headers and res.headers.status_code == 200 and files.exists(path2vpk) then
				game.install("ux0:data/AUTOPLUGIN2/vpks/"..__file,false)
			else
				os.message(LANGUAGE["INSTALLP_NO_VPK"])
			end
		end

		if obj.path == "vitastick.skprx" then
			__file = "vitastick.vpk"
			game.install("resources/plugins/vitastick.vpk",false)
		elseif obj.path == "ModalVol.suprx" then
			__file = "VolumeControl.vpk"
			game.install("resources/plugins/VolumeControl.vpk",false)
		elseif obj.path == "monaural.skprx" then
			__file = "MonauralConfig.vpk"
			game.install("resources/plugins/MonauralConfig.vpk",false)
		elseif obj.path == "pspemu-colour-crunch.skprx" then
			__file = "lcd-colour-crunch.vpk"
			game.install("resources/plugins/lcd-colour-crunch.vpk",false)
		elseif obj.path == "vitabright.skprx" then
			files.delete("tmp")
			if back2 then back2:blit(0,0) end
				message_wait()
			os.delay(250)
			
			local onNetGetFileOld = onNetGetFile
			onNetGetFile = nil
			http.download("https://github.com/devnoname120/vitabright-lut-editor","tmp")
			onNetGetFile = onNetGetFileOld
			if files.exists("tmp") then
				local objh = html.parsefile("tmp")
				if objh then

					local links = objh:findall(html.TAG_A)
					if links then
						--os.message("Links "..#links)
						for i=1,#links do
							if links[i].href then
								if links[i].href:find("releases/tag/",1,true) then
									--os.message(links[i].href)
									__file = "Vitabrightluteditor "..files.nopath(links[i].href)
									http.download("https://github.com/devnoname120/vitabright-lut-editor/releases/download/"..files.nopath(links[i].href).."/vitabright-lut-editor-1.1.vpk","ux0:data/AUTOPLUGIN2/vpks/vitabrightluteditor.vpk")
									if files.exists("ux0:data/AUTOPLUGIN2/vitabrightluteditor.vpk") then
										game.install("ux0:data/AUTOPLUGIN2/vpks/vitabrightluteditor.vpk",false)
										break
									end
								end
							end
						end
					else
						os.message(LANGUAGE["LANG_ONLINE_FAIL_CONEXION"])
					end
				else
					os.message(LANGUAGE["UPDATE_WIFI_IS_ON"])
				end
			else
				os.message(LANGUAGE["UPDATE_WIFI_IS_ON"])
			end

		elseif obj.path == "VitaGrafix.suprx" then
			files.delete("tmp")
			if back2 then back2:blit(0,0) end
				message_wait()
			os.delay(250)

			files.copy(path_plugins.."vitagrafix/patch/", "ux0:data/VitaGrafix/")
			local onNetGetFileOld = onNetGetFile
			onNetGetFile = nil
			http.download("https://github.com/Kirezar/VitaGrafixConfigurator","tmp")
			onNetGetFile = onNetGetFileOld
			if files.exists("tmp") then
				local objh = html.parsefile("tmp")
				if objh then

					local links = objh:findall(html.TAG_A)
					if links then
						--os.message("Links "..#links)
						for i=1,#links do
							if links[i].href then
								if links[i].href:find("releases/tag/",1,true) then
									--os.message(links[i].href)
									--onNetGetFile = onNetGetFileOld
									__file = "VitaGrafixConfigurator".." "..files.nopath(links[i].href)
									http.download("https://github.com/Kirezar/VitaGrafixConfigurator/releases/download/"..files.nopath(links[i].href).."/VitaGrafixConfigurator.vpk","ux0:data/AUTOPLUGIN2/vpks/VitaGrafixConfigurator.vpk")
									http.download("https://raw.githubusercontent.com/Electry/VitaGrafixPatchlist/master/patchlist.txt", "ux0:data/VitaGrafix/patchlist.txt")
									if files.exists("ux0:data/AUTOPLUGIN2/vpks/VitaGrafixConfigurator.vpk") then
										game.install("ux0:data/AUTOPLUGIN2/vpks/VitaGrafixConfigurator.vpk",false)
										break
									end
								end
							end
						end
					else
						os.message(LANGUAGE["LANG_ONLINE_FAIL_CONEXION"])
					end
				else
					os.message(LANGUAGE["UPDATE_WIFI_IS_ON"])
				end
			else
				os.message(LANGUAGE["UPDATE_WIFI_IS_ON"])
			end

		end

		--Clean
		files.delete("tmp")
		files.delete("ux0:data/AUTOPLUGIN2/vpks/")
		__file = ""

		--Delete plugins Specials
		if obj.tai_del1 and obj.section_del1 then
			--os.message("section1: "..obj.section_del1.."\n".."plugin1: "..obj.tai_del1)
			tai.del(obj.section_del1, obj.tai_del1)
			if obj.section_del1:upper() == "MAIN" or obj.section_del1:upper() == "KERNEL" then change = true end
		end
		if obj.tai_del2 and obj.section_del2 then
			--os.message("section2: "..obj.section_del2.."\n".."plugin2: "..obj.tai_del2)
			tai.del(obj.section_del2, obj.tai_del2)
			if obj.section_del2:upper() == "MAIN" or obj.section_del2:upper() == "KERNEL" then change = true end
		end

		--path_plugins = "resources/plugins/"
        --path_tai = "ur0:tai/"

		--Copy Especial Config for the plugin
		if obj.config and not obj.configpath then files.copy(path_plugins..obj.config, path_tai) end
		if obj.config and obj.configpath then
			if files.ext(obj.config):upper() == "ZIP" then
				files.extract(path_plugins..obj.config,obj.configpath)
			else
				files.copy(path_plugins..obj.config, obj.configpath)
			end
		end

		--Insert plugin to Config
		local pathline_in_config = path_tai..obj.path

		if obj.path == "adrenaline_kernel.skprx" then pathline_in_config = "ux0:app/PSPEMUCFW/sce_module/adrenaline_kernel.skprx" end

		--Aqui colocamos el plugin seleccionado al config tai
		local plugin_name = obj.name
		local plugin_path = obj.path

		if obj.path:find("udcd_uvc_",1,true) then
			if hw.model() == "Vita Fat" then
				--os.message("Fat")
				tai.put(obj.section,  path_tai.."udcd_uvc_oled_off.skprx")
				plugin_name = "udcd_uvc_oled"
				plugin_path = "udcd_uvc_oled_off.skprx"
			else
				--os.message("Slim")
				tai.put(obj.section,  path_tai.."udcd_uvc_lcd_off.skprx")
				plugin_name = "udcd_uvc_lcd"
				plugin_path = "udcd_uvc_lcd_off.skprx"
			end
		else
			tai.put(obj.section,  pathline_in_config)
		end

		--Copy plugin to tai folder
		files.copy(path_plugins..plugin_path, path_tai)

		--Copy Extra Plugin (section2 & Path2)
		if obj.path2 then files.copy(path_plugins..obj.path2, path_tai) end
		if obj.section2 then tai.put(obj.section2, path_tai..obj.path2)	end

		--Extra
		if obj.path == "vsh.suprx" then files.delete("ur0:/data:/vsh/")
		elseif obj.path == "custom_boot_splash.skprx" and not files.exists("ur0:tai/boot_splash.bin") then--Custom Boot Splash
			local henkaku = image.load("imgs/boot_splash.png")
			if henkaku then img2splashbin(henkaku,false) end

		elseif obj.path == "vitacheat.skprx" then		--Vitacheat 3.65

			files.extract("resources/plugins/vitacheat.zip","ux0:")
			files.delete("ux0:vitacheat/font/font.dat")--delete old font
			files.extract("ux0:data/AUTOPLUGIN2/font365.zip","ux0:vitacheat/font/")--reinstall font
			files.copy("resources/plugins/vitacheat365/vitacheat.suprx","ux0:vitacheat/")

		elseif obj.path == "vitacheat360.skprx" then	--Vitacheat 3.60

			files.delete("ux0:vitacheat/font/font.dat")
			files.extract("resources/plugins/vitacheat.zip","ux0:")
			files.copy("resources/plugins/vitacheat360/vitacheat.suprx","ux0:vitacheat/")

		elseif obj.path == "AutoBoot.suprx" and not files.exists("ux0:data/AutoBoot/boot.cfg") then--AutoBoot
			files.extract("resources/plugins/AutoBoot.zip","ux0:")
		elseif obj.path == "ps4linkcontrols.suprx" and not files.exists("ux0:ps4linkcontrols.txt") then--ps4linkcontrols
			files.extract("resources/plugins/ps4linkcontrols.zip","ux0:")
			-- reVita.skprx
		elseif obj.path == "reVita.skprx" then
			if os.message(LANGUAGE["INSTALLP_DESC_REVITA_GYRO"].."\n",1) == 1 then
				files.copy(path_plugins.."reVitaMotion.suprx", path_tai)
				tai.put("main",  path_tai.."reVitaMotion.suprx")
				change = true
			end
		elseif string.find(obj.name, "QuickLauncher", 1, true) then
			if not files.exists("ux0:data/quicklauncher.txt") then
				files.copy(path_plugins.."quicklauncher.txt", "ux0:data/")
			end
			--fruitpeel.suprx
		elseif obj.path == "fruitpeel.suprx" then
			if not files.exists("ur0:/data/fruitpeel.png") then
				files.copy("imgs/fruitpeel.png","ur0:/data/")
			end
		end

		if obj.section2 and obj.section2:upper() == "KERNEL" then change = true	end
		if obj.section:upper() == "MAIN" or obj.section:upper() == "KERNEL" then change = true else	ReloadConfig = true	end

		if back2 then back2:blit(0,0) end
			message_wait(plugin_name.."\n\n"..LANGUAGE["STRING_INSTALLED"])
		os.delay(1500)

	end

end

function autoplugin()

	local tb_cop = {}
	update_translations(plugins, tb_cop)

	for k = #tb_cop,1,-1 do
		if tb_cop[k].path == "adrenaline_kernel.skprx" and not files.exists("ux0:app/PSPEMUCFW") then
			table.remove(tb_cop,k)
		end
		if tb_cop[k].REMOVE then
			table.remove(tb_cop,k)
		end
	end

	local limit = 9
	local scr = newScroll(tb_cop,limit)
	local xscr1 = 10
	scr.ini,scr.lim,scr.sel = 1,limit,1

	while true do
		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end
		if back2 then back2:blit(0,0) end

		screen.print(10,15,LANGUAGE["LIST_PLUGINS"].." "..#tb_cop,1,color.white)

		--Partition
		draw.fillrect(860,0,100,47, color.green:a(90))
		screen.print(930, 14, "ur0:", 1, color.white, color.blue, __ARIGHT)

		--List of Plugins
		local y = 62
		for i=scr.ini,scr.lim do

			if i == scr.sel then draw.offsetgradrect(3,y-9,944,33,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

			idx = tai.find(tb_cop[i].section,tb_cop[i].path)
			if idx != nil then
				if files.exists(tai.gameid[ tb_cop[i].section ].prx[idx].path) then
					if dotg then dotg:blit(924,y-1) else draw.fillrect(924,y-2,21,21,color.green:a(205)) end
				else
					if doty then doty:blit(924,y-1) else draw.fillrect(924,y-2,21,21,color.yellow:a(205)) end
				end
			end

			if tb_cop[i].path2 == "kuio.skprx" or tb_cop[i].path2 == "ioplus.skprx" then
				screen.print(40,y, tb_cop[i].name, 1.2,color.white,color.blue:a(175),__ALEFT)--125
				screen.print(895,y, " ("..tb_cop[i].path2.." )", 1.0,color.yellow,color.blue,__ARIGHT)
			else
				screen.print(40,y, tb_cop[i].name, 1.2,color.white,color.blue:a(175),__ALEFT)
			end

			y+=36
		end

		---- Draw Scroll Bar
		local ybar,hbar = 60, (limit*36)
		draw.fillrect(950,ybar-2,8,hbar,color.shine)
		--if scr.maxim >= limit then
			local pos_height = math.max(hbar/scr.maxim, limit)
			--Bar Scroll
			draw.fillrect(950, ybar-2 + ((hbar-pos_height)/(scr.maxim-1))*(scr.sel-1), 8, pos_height, color.new(0,255,0))
		--end

		if tb_cop[scr.sel].desc then
			if screen.textwidth(tb_cop[scr.sel].desc) > 925 then
				xscr1 = screen.print(xscr1, 405, tb_cop[scr.sel].desc,1,color.green, 0x0,__SLEFT,935)
			else
				screen.print(480, 405, tb_cop[scr.sel].desc,1,color.green, 0x0,__ACENTER)
			end
		end

		if tb_cop[scr.sel].section then
		screen.print(950, 435, tb_cop[scr.sel].section,1,color.yellow, 0x0,__ARIGHT)
		end
		if tb_cop[scr.sel].path then
		screen.print(950, 457, tb_cop[scr.sel].path,1,color.yellow, 0x0,__ARIGHT)
		end
		if tb_cop[scr.sel].section2 then
			screen.print(950, 482, tb_cop[scr.sel].section2,1,color.yellow, 0x0,__ARIGHT)
		end
		if tb_cop[scr.sel].path2 then
			screen.print(950, 502, tb_cop[scr.sel].path2,1,color.yellow, 0x0,__ARIGHT)
		end

		if buttonskey then buttonskey:blitsprite(10,448,__TRIANGLE) end
		screen.print(45,450,LANGUAGE["PLUGINS_README_ONLINE"],1,color.white,color.black, __ALEFT)

		if buttonskey then buttonskey:blitsprite(10,472,scancel) end
		screen.print(45,475,LANGUAGE["STRING_BACK"],1,color.white,color.black, __ALEFT)

		if buttonskey3 then buttonskey3:blitsprite(5,515,1) end
		screen.print(45,520,LANGUAGE["STRING_CLOSE"],1,color.white,color.blue, __ALEFT)

		screen.flip()

		--------------------------	Controls	--------------------------

		if buttons.cancel then
			os.delay(100)
			return
		end

		--Exit
		if buttons.start then
			exit_bye_bye()
		end

		vol_mp3()

		if scr.maxim > 0 then
			if buttons.l then
			end

			if buttons.left or buttons.right then xscr1 = 10 end

			if buttons.up or buttons.analogly < -60 then
				if scr:up() then xscr1 = 10	end
			end
			if buttons.down or buttons.analogly > 60 then
				if scr:down() then xscr1 = 10 end
			end

			--Install selected plugins
			if buttons.accept then
				buttons.homepopup(0)

				if back2 then back2:blit(0,0) end
					message_wait()
				os.delay(1000)

				local vbuff = screen.buffertoimage()

				local onNetGetFileOld = onNetGetFile
				onNetGetFile = nil

				local SCREENSHOT,img = nil,nil
				if tb_cop[scr.sel].id then
					SCREENSHOT = string.format("https://raw.githubusercontent.com/%s/%s/master/screenshots/%s", APP_REPO, APP_PROJECT, tb_cop[scr.sel].id)
					img = image.load(screenshots..tb_cop[scr.sel].id)
					if not img then
						local res = http.download(SCREENSHOT, screenshots..tb_cop[scr.sel].id)
						if res.headers and res.headers.status_code == 200 and files.exists(screenshots..tb_cop[scr.sel].id) then
							img = image.load(screenshots..tb_cop[scr.sel].id)
						else files.delete(screenshots..tb_cop[scr.sel].id)
						end
					end
					if img then img:setfilter(__IMG_FILTER_LINEAR, __IMG_FILTER_LINEAR) end
				end

				if tb_cop[scr.sel].link and not tb_cop[scr.sel].status then
					tb_cop[scr.sel].readme = http.get(tb_cop[scr.sel].link)
					if not tb_cop[scr.sel].readme then
						local res = http.download(tb_cop[scr.sel].link,"ux0:data/AUTOPLUGIN2/tmp.txt")
						if res.headers and res.headers.status_code == 200 and files.exists("ux0:data/AUTOPLUGIN2/tmp.txt") then
							tb_cop[scr.sel].readme = files.read("ux0:data/AUTOPLUGIN2/tmp.txt")
						end
						files.delete("ux0:data/AUTOPLUGIN2/tmp.txt")
					end
					if not tb_cop[scr.sel].readme then tb_cop[scr.sel].status = false else tb_cop[scr.sel].status = true end
				end

				os.dialog(tb_cop[scr.sel].readme or LANGUAGE["PLUGINS_NO_README_ONLINE"], tb_cop[scr.sel].name.."\n")

				if img then
					if vbuff then vbuff:blit(0,0) elseif back2 then back2:blit(0,0) end
					img:scale(85)
					img:center()
					img:blit(480,272)
					screen.flip()
					buttons.waitforkey()
					os.delay(150)
				end

				img,vbuff = nil,nil
				onNetGetFile = onNetGetFileOld
				os.delay(75)

				if tb_cop[scr.sel].path:lower() == "vitacheat.skprx" then--360
					if not files.exists("ux0:data/AUTOPLUGIN2/font365.zip") then
						__file = "Vitacheat (Font)"
						local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/font365.zip", APP_REPO, APP_PROJECT, APP_FOLDER), "ux0:data/AUTOPLUGIN2/font365.zip")
						if res.headers and res.headers.status_code == 200 and files.exists("ux0:data/AUTOPLUGIN2/font365.zip") then
							plugins_installation(tb_cop[scr.sel])
						else
							files.delete("ux0:data/AUTOPLUGIN2/font365.zip")
							os.message(LANGUAGE["LANG_ONLINE_FAILDB"].."\n\n"..LANGUAGE["UPDATE_WIFI_IS_ON"])
						end
					else
						plugins_installation(tb_cop[scr.sel])
					end
				else plugins_installation(tb_cop[scr.sel]) end

				buttons.homepopup(1)
			end

			--Readme online
			if buttons.triangle then

				local vbuff = screen.buffertoimage()

				local onNetGetFileOld = onNetGetFile
				onNetGetFile = nil

				local SCREENSHOT,img = nil,nil
				if tb_cop[scr.sel].id then
					SCREENSHOT = string.format("https://raw.githubusercontent.com/%s/%s/master/screenshots/%s", APP_REPO, APP_PROJECT, tb_cop[scr.sel].id)
					img = image.load(screenshots..tb_cop[scr.sel].id)
					if not img then
						local res = http.download(SCREENSHOT, screenshots..tb_cop[scr.sel].id)
						if res.headers and res.headers.status_code == 200 and files.exists(screenshots..tb_cop[scr.sel].id) then
							img = image.load(screenshots..tb_cop[scr.sel].id)
						else files.delete(screenshots..tb_cop[scr.sel].id)
						end
					end
					if img then img:setfilter(__IMG_FILTER_LINEAR, __IMG_FILTER_LINEAR) end
				end

				if tb_cop[scr.sel].link and not tb_cop[scr.sel].status then
					tb_cop[scr.sel].readme = http.get(tb_cop[scr.sel].link)
					if not tb_cop[scr.sel].readme then
						local res = http.download(tb_cop[scr.sel].link,"ux0:data/AUTOPLUGIN2/tmp.txt")
						if res.headers and res.headers.status_code == 200 and files.exists("ux0:data/AUTOPLUGIN2/tmp.txt") then
							tb_cop[scr.sel].readme = files.read("ux0:data/AUTOPLUGIN2/tmp.txt")
						end
						files.delete("ux0:data/AUTOPLUGIN2/tmp.txt")
					end
					if not tb_cop[scr.sel].readme then tb_cop[scr.sel].status = false else tb_cop[scr.sel].status = true end
				end

				os.dialog(tb_cop[scr.sel].readme or LANGUAGE["PLUGINS_NO_README_ONLINE"], tb_cop[scr.sel].name.."\n")

				if img then
					if vbuff then vbuff:blit(0,0) elseif back2 then back2:blit(0,0) end
					img:scale(85)
					img:center()
					img:blit(480,272)
					screen.flip()
					buttons.waitforkey()
					os.delay(150)
				end

				img,vbuff = nil,nil
				onNetGetFile = onNetGetFileOld
				os.delay(75)

			end

		end
	end

end
