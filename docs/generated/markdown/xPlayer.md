## class xPlayer
*server/classes/player.lua*



**triggerEvent** **(** <span style="color:#46a0f0">string</span> eventName, <span style="color:#000">any</span> ...rest **)**
> 
*Trigger event to player*

---
**setCoords** **(** <span style="color:#32a83e">custom</span> coords **)**
> 
*Update player coords on both server and client*

---
**updateCoords** **(** <span style="color:#32a83e">custom</span> coords **)**
> 
*Update player coords on server*

---
<span style="color:#000">any</span> **getCoords** **(** <span style="color:#f0ac46">boolean</span> asVector **)**
> 
*Update player coords on server*

---
**kick** **(** <span style="color:#46a0f0">string</span> reason **)**
> 
*Kick player*

---
**setMoney** **(** <span style="color:#d300eb">number</span> money **)**
> 
*Set amount for player 'money' account*

---
<span style="color:#d300eb">number</span> **getMoney** **(**  **)**
> 
*Get amount for player 'money' account*

---
**addMoney** **(** <span style="color:#d300eb">number</span> money **)**
> 
*Add amount for player 'money' account*

---
**removeMoney** **(** <span style="color:#d300eb">number</span> money **)**
> 
*Remove amount for player 'money' account*

---
<span style="color:#46a0f0">string</span> **getIdentifier** **(**  **)**
> 
*Get player identifier*

---
**setGroup** **(** <span style="color:#46a0f0">string</span> newGroup **)**
> 
*Set player group*

---
<span style="color:#46a0f0">string</span> **getGroup** **(**  **)**
> 
*Get player group*

---
**set** **(** <span style="color:#46a0f0">string</span> k, <span style="color:#000">any</span> v **)**
> 
*Set field on this xPlayer instance*

---
<span style="color:#000">any</span> **get** **(** <span style="color:#46a0f0">string</span> k **)**
> 
*Get field on this xPlayer instance*

---
<span style="color:#32a83e">custom</span> **getAccounts** **(** <span style="color:#f0ac46">boolean</span> minimal **)**
> 
*Get player accounts*

---
<span style="color:#32a83e">custom</span> **getAccount** **(** <span style="color:#46a0f0">string</span> account **)**
> 
*Get player account*

---
<span style="color:#32a83e">custom</span> **getInventory** **(** <span style="color:#f0ac46">boolean</span> minimal **)**
> 
*Get player inventory*

---
<span style="color:#32a83e">custom</span> **getJob** **(**  **)**
> 
*Get player job*

---
<span style="color:#32a83e">custom</span> **getLoadout** **(** <span style="color:#f0ac46">boolean</span> minimal **)**
> 
*Get player inventory*

---
<span style="color:#46a0f0">string</span> **getName** **(**  **)**
> 
*Get player name*

---
**setName** **(** <span style="color:#46a0f0">string</span> newName **)**
> 
*Set player name*

---
**setAccountMoney** **(** <span style="color:#46a0f0">string</span> accountName, <span style="color:#d300eb">number</span> money **)**
> 
*Set player account money*

---
**addAccountMoney** **(** <span style="color:#46a0f0">string</span> accountName, <span style="color:#d300eb">number</span> money **)**
> 
*Add player account money*

---
**addAccountMoney** **(** <span style="color:#46a0f0">string</span> accountName, <span style="color:#d300eb">number</span> money **)**
> 
*Add player account money*

---
<span style="color:#32a83e">custom</span> **getInventoryItem** **(** <span style="color:#46a0f0">string</span> name **)**
> 
*Get player inventory item*

---
**addInventoryItem** **(** <span style="color:#46a0f0">string</span> name, <span style="color:#d300eb">number</span> count **)**
> 
*Add player inventory item*

---
**removeInventoryItem** **(** <span style="color:#46a0f0">string</span> name, <span style="color:#d300eb">number</span> count **)**
> 
*Remove player inventory item*

---
**removeInventoryItem** **(** <span style="color:#46a0f0">string</span> name, <span style="color:#d300eb">number</span> count **)**
> 
*Remove player inventory item*

---
<span style="color:#d300eb">number</span> **getWeight** **(**  **)**
> 
*Get player weight*

---
<span style="color:#d300eb">number</span> **getMaxWeight** **(**  **)**
> 
*Get max player weight*

---
<span style="color:#f0ac46">boolean</span> **canCarryItem** **(**  **)**
> 
*Check if player can carry count of given item*

---
<span style="color:#d300eb">number</span> **maxCarryItem** **(**  **)**
> 
*Get max count of specific item player can carry*

---
<span style="color:#f0ac46">boolean</span> **canSwapItem** **(** <span style="color:#46a0f0">string</span> firstItem, <span style="color:#d300eb">number</span> firstItemCount, <span style="color:#46a0f0">string</span> testItem, <span style="color:#d300eb">number</span> testItemCount **)**
> 
*Check if player can sawp item with other item*

---
**setMaxWeight** **(** <span style="color:#d300eb">number</span> newWeight **)**
> 
*Set max player weight*

---
**setJob** **(** <span style="color:#46a0f0">string</span> job, <span style="color:#46a0f0">string</span> grade **)**
> 
*Set player job*

---
**addWeapon** **(** <span style="color:#46a0f0">string</span> weaponName, <span style="color:#d300eb">number</span> ammo **)**
> 
*Add weapon to player*

---
**addWeaponComponent** **(** <span style="color:#46a0f0">string</span> weaponName, <span style="color:#46a0f0">string</span> weaponComponent **)**
> 
*Add weapon to player*

---
**addWeaponAmmo** **(** <span style="color:#46a0f0">string</span> weaponName, <span style="color:#d300eb">number</span> ammoCount **)**
> 
*Add ammo to player weapon*

---
**updateWeaponAmmo** **(** <span style="color:#46a0f0">string</span> weaponName, <span style="color:#d300eb">number</span> ammoCount **)**
> 
*Update player weapon ammo*

---
**setWeaponTint** **(** <span style="color:#46a0f0">string</span> weaponName, <span style="color:#d300eb">number</span> weaponTintIndex **)**
> 
*Update player weapon ammo*

---
<span style="color:#d300eb">number</span> **getWeaponTint** **(** <span style="color:#46a0f0">string</span> weaponName **)**
> 
*Get player weapon tint index*

---
**removeWeapon** **(** <span style="color:#46a0f0">string</span> weaponName **)**
> 
*Remove player weapon*

---
**removeWeaponComponent** **(** <span style="color:#46a0f0">string</span> weaponName, <span style="color:#46a0f0">string</span> weaponComponent **)**
> 
*Remove player weapon component*

---
**removeWeaponAmmo** **(** <span style="color:#46a0f0">string</span> weaponName, <span style="color:#d300eb">number</span> ammoCount **)**
> 
*Remove player weapon ammo*

---
<span style="color:#f0ac46">boolean</span> **hasWeaponComponent** **(** <span style="color:#46a0f0">string</span> weaponName, <span style="color:#46a0f0">string</span> weaponComponent **)**
> 
*Check if player weapon has component*

---
<span style="color:#f0ac46">boolean</span> **hasWeapon** **(** <span style="color:#46a0f0">string</span> weaponName **)**
> 
*Check if player has weapon*

---
<span style="color:#32a83e">custom</span> **getWeapon** **(** <span style="color:#46a0f0">string</span> weaponName **)**
> 
*Get player weapon*

---
**showNotification** **(** <span style="color:#46a0f0">string</span> msg, <span style="color:#f0ac46">boolean</span> flash, <span style="color:#f0ac46">boolean</span> saveToBrief, <span style="color:#32a83e">custom</span> hudColorIndex **)**
> 
*Show notification to player*

---
**showHelpNotification** **(** <span style="color:#46a0f0">string</span> msg, <span style="color:#f0ac46">boolean</span> thisFrame, <span style="color:#f0ac46">boolean</span> beep, <span style="color:#32a83e">custom</span> duration **)**
> 
*Show notification to player*

---
<span style="color:#32a83e">custom</span> **serialize** **(**  **)**
> 
*Serialize player data*
>Can be extended by listening for esx:player:serialize event
>
>AddEventHandler('esx:player:serialize', function(add)
>add({somefield = somevalue})
>end)

---
<span style="color:#32a83e">custom</span> **serializeDB** **(**  **)**
> 
*Serialize player data for saving in database*
>Can be extended by listening for esx:player:serialize:db event
>
>AddEventHandler('esx:player:serialize:db', function(add)
>add({somefield = somevalue})
>end)

