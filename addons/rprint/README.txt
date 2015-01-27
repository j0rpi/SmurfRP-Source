- Installation

Extract to garrysmod/addons.

- Configuration

All configuration options are located in lua/rprint/sh_config.lua.

 - To enable removing printers on player disconnect, simply set rPrint.RemovePrintersOnDisconnect = true.

 - How to add new printers to DarkRP

     rPrint.RegisterPrinterType( printer_name, params, entity_name )
     And then add the entity to DarkRP like you normally would.

     Note: `entity_name` is optional, if you do not provide one, an entity name will be generated
     from the `printer_name` in the form "rprint_(`printer_name`)printer" without the ().

     Note: `params` is a table of printer operating perameters, basically these correspond to the table
     of rPrint default parameters (rPrint.DefaultPrinterParams). If you put something into `params`, it will
     override the default value for that field for that specific printer.

 - Explanations on the printer operating parameters

  - PrintRate
 
    This is the rate at which the printer prints money per second. So in one minute, it will print 60 times
    this value.

  - HeatRate

    This is how much the printer heats up for every dollar it prints. This does *not* correspond to money printed
    per unit time. The smaller you make this number (the bigger you make `x` in "1 / x"), the slower the printer
    will heat up.

  - CoolRate

    This is how much the printer cools down *per unit time*. This does not depend on how much money it prints.
    Even when the printer is off the CoolRate applies, so think of this as how fast it gives off heat normally
    (without the added cooler). The bigger the number, the faster it cools down.

  - CoolerCoolRate

    This works just like the CoolRate, except it only applies when the cooler is on. This should be kinda big
    (3/2 or 1.5 by default).

  - CoolerBreakInterval

    If CoolerBreak is enabled, this interval defines the minimum and maximum time that the printer will randomly
    pick to break the cooler. The smaller number comes first in the table, and this is in seconds.

  - PowerConsumptionRate

    This is how fast the printer uses power in percent per second. When this reaches zero, the printer will shut off.
    The smaller you make this number, the more slowly the printer uses power.

  - PowerConsumptionRateCooler

    This is how fast the printer uses power with the cooler *in addition* to PowerConsumptionRate. So when the cooler is
    on, both power consumption rates are applied. This works just like the PowerConsumptionRate.

  - AlertOwenrOnDestroyed and AlertOwnerOnOverheated

    Alerts the owner when the printer overheats or is destroyed. Prints a message to their chat.

  - ExplodeOnOverheat

    Whether to explode when the printer overheats. If set to false, the printer will simply shut off (power goes to 0)
    and start cooling off.

  - CanBeDestroyed

    Whether or not to allow CP and other teams from blowing up printers.

  - DestroyPayout

    How much a player gets paid for destroying the printer.

  - DestroyPayoutTeams

    Teams that will receive monetary compensation for destroying printers.
