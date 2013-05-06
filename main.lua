-------------------------------------------------------
--
-- In this example, the HP bar will be shortened
-- and will transition smoothly into another color
-- Lots of bugs can arise if the transitioning values
-- are not properly pre-planned.
--
-------------------------------------------------------

-- Create buttons for adding and subtracting HP

plus = display.newImage( "plus.png" )
plus.x = display.contentWidth * 0.3
plus.y = display.contentHeight * 0.8
-- add listener at the bottom of this code (listeners can only be declared after the listener function is defined)

minus = display.newImage( "minus.png" )
minus.x = display.contentWidth * 0.7
minus.y = display.contentHeight * 0.8

-- Add HP bar

hp = display.newImage( "green.png" )

scaleFactor = 3
hp:scale( scaleFactor, scaleFactor )

hp.x = display.contentWidth/2
hp.y = display.contentHeight/2

fullHP = hp.width -- original width of the full bar, in this case 48 px
fullHPx = hp.x

widthChange = 2
xChange = widthChange * scaleFactor/2

hpValue = display.newText( hp.width.. "/".. fullHP , 0, 0, "Verdana", 30 )
hpValue.x = display.contentWidth/2
hpValue.y = display.contentHeight/2 - 20

-- flags to indicate HP color
red = false
yellow = false
green = true
restart = false

-- Functions for adding and subtracting HP
function addHP( event )
	if event.phase == "began" then
		
		-- addHP is a bit different from subHP
		-- if we surpass fullHP, we don't want to exceed the maximum, so we instantly adjust
		
		hp.width = hp.width + widthChange
		hp.x = hp.x + xChange
		hpValue.text = hp.width.. "/".. fullHP
		
		if hp.width + widthChange >= fullHP then
			diff = fullHP - hp.width
			hp.width = fullHP -- we set width of HP bar to be full HP
			hp.x = hp.x + diff * scaleFactor/2 -- but we need to manually adjust hp's x value based on the difference that was adjusted
			hpValue.text = fullHP.. "/".. fullHP
			
		elseif hp.width > fullHP * 0.4 then
			-- change back to green if it was yellow
			if yellow == true then
				greenHP()
				yellow = false
				red = false
			end
		
		elseif hp.width > fullHP * 0.2 then
			-- change to yellow if it was red
			if red == true then
				yellowHP()
				red = false
				green = false
			end
		
		end			
			
		return true
	else
		return false
	end
end

function subHP( event )
	if event.phase == "began" then
	
		if( hp.width - widthChange <= 0 ) then
			currentHP = fullHP
			currentHPx = fullHPx
			restart = true 
			greenHP()
			hpValue.text = fullHP.. "/".. fullHP
		
		else	
			hp.width = hp.width - widthChange
			hp.x = hp.x - xChange
			hpValue.text = hp.width.. "/".. fullHP
			print (" HP is "..hp.width)
			-- below 30% HP, HP bar turns yellow
			-- below 10% HP, HP bar turns red
			-- we must give the red condition priority, or else yellow will trigger by default
			
			if hp.width < fullHP * 0.2 then
				redHP()
			elseif hp.width < fullHP * 0.4 then
				yellowHP()
			end
		
		end
		
		return true
	else
		return false
	end
end

function greenHP()

	-- we need to take the HP bar's attributes before we remove it
	-- to sub back into the newly replaced HP bar
	
	if restart == false then
		currentHP = hp.width
		currentHPx = hp.x
	end
	
	-- remove the red/yellow bar
	hp:removeSelf() 
	
	-- load the new bar
	hp = display.newImage( "green.png" )
	
	-- scale and place
	hp:scale( scaleFactor, scaleFactor )
	hp.x = display.contentWidth/2
	hp.y = display.contentHeight/2	
	
	-- restore attributes
	hp.width = currentHP
	hp.x = currentHPx
	
	green = true
	
	restart = false
	
end

function redHP()

	-- we need to take the HP bar's attributes before we remove it
	-- to sub back into the newly replaced HP bar
	currentHP = hp.width
	currentHPx = hp.x
	
	-- remove the yellow bar
	hp:removeSelf() 
	
	-- load the new bar
	hp = display.newImage( "red.png" )
	
	-- scale and place
	hp:scale( scaleFactor, scaleFactor )
	hp.x = display.contentWidth/2
	hp.y = display.contentHeight/2	
	
	-- restore attributes
	hp.width = currentHP
	hp.x = currentHPx
	
	red = true
	
end

function yellowHP()

	-- we need to take the HP bar's attributes before we remove it
	-- to sub back into the newly replaced HP bar
	currentHP = hp.width
	currentHPx = hp.x
	
	-- remove the green bar
	hp:removeSelf() 
	
	-- load the new bar
	hp = display.newImage( "yellow.png" )
	
	-- scale and place
	hp:scale( scaleFactor, scaleFactor )
	hp.x = display.contentWidth/2
	hp.y = display.contentHeight/2
	
	-- restore attributes
	hp.width = currentHP
	hp.x = currentHPx
	
	yellow = true
	
end

-- add listeners
minus:addEventListener( "touch", subHP )
plus:addEventListener( "touch", addHP )