# Desktop Weather Station

A Plasma widget that displays the weather from weather stations registered with Weather Underground.

## Installing

Go to the [Releases](https://github.com/hal7df/kde-desktop-weather/releases) page.

### Graphical method

Download the latest .plasmoid package. Then, on the desktop, right-click and select 'Add Widgets'. In the upper-right corner of the menu that pops up, there is a 'Get new widgets' option. Click that, and select "Install Widget From Local File...", find the .plasmoid package you downloaded, and install it.

### Commandline method 

#### Account-only

Download the latest .plasmoid package. Open up the folder in a terminal, and type `plasmapkg -i desktop-weather-station-*.plasmoid`.

#### System-wide

Download the tar.gz file and navigate into that folder. Then run the following steps:

  * `cmake .`
  * `make && make install`

