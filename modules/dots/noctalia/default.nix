{ pkgs, ... }:
{
  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus-Dark";
  };

  home.file."wallpapers/wallhaven-839g92.png".source = ./wallpapers/wallhaven-839g92.png;
  home.file."wallpapers/wallhaven-e8xlgw.png".source = ./wallpapers/wallhaven-e8xlgw.png;

  programs.noctalia-shell = {
    enable = true;
    settings = {
        settingsVersion = 0;
        bar = {
          barType = "simple";
          position = "top";
          monitors = [ ];
          density = "default";
          showOutline = false;
          showCapsule = true;
          capsuleColorKey = "none";
          widgetSpacing = 6;
          contentPadding = 2;
          fontScale = 1;
          enableExclusionZoneInset = true;
          useSeparateOpacity = false;
          floating = false;
          marginVertical = 4;
          marginHorizontal = 4;
          frameThickness = 8;
          frameRadius = 12;
          outerCorners = true;
          hideOnOverview = false;
          displayMode = "always_visible";
          autoHideDelay = 500;
          autoShowDelay = 150;
          showOnWorkspaceSwitch = true;
          widgets = {
            left = [
              { id = "Launcher"; }
              { id = "Clock"; }
              { id = "SystemMonitor"; }
              { id = "ActiveWindow"; }
              { id = "MediaMini"; }
            ];
            center = [
              { id = "Workspace"; }
            ];
            right = [
              { id = "Tray"; }
              { id = "NotificationHistory"; }
              { id = "Battery"; }
              { id = "Volume"; }
              { id = "Brightness"; }
              { id = "ControlCenter"; }
            ];
          };
          mouseWheelAction = "none";
          reverseScroll = false;
          mouseWheelWrap = true;
          middleClickAction = "none";
          middleClickFollowMouse = false;
          middleClickCommand = "";
          rightClickAction = "controlCenter";
          rightClickFollowMouse = true;
          rightClickCommand = "";
          screenOverrides = [ ];
        };
        general = {
          avatarImage = "";
          dimmerOpacity = 0.2;
          showScreenCorners = false;
          forceBlackScreenCorners = false;
          scaleRatio = 1;
          radiusRatio = 1;
          iRadiusRatio = 1;
          boxRadiusRatio = 1;
          screenRadiusRatio = 1;
          animationSpeed = 1;
          animationDisabled = false;
          compactLockScreen = false;
          lockScreenAnimations = false;
          lockOnSuspend = true;
          showSessionButtonsOnLockScreen = true;
          showHibernateOnLockScreen = false;
          enableLockScreenMediaControls = false;
          enableShadows = true;
          enableBlurBehind = true;
          shadowDirection = "bottom_right";
          shadowOffsetX = 2;
          shadowOffsetY = 3;
          language = "";
          allowPanelsOnScreenWithoutBar = true;
          showChangelogOnStartup = true;
          telemetryEnabled = false;
          enableLockScreenCountdown = true;
          lockScreenCountdownDuration = 10000;
          autoStartAuth = false;
          allowPasswordWithFprintd = false;
          clockStyle = "custom";
          clockFormat = "hh\nmm";
          passwordChars = false;
          lockScreenMonitors = [ ];
          lockScreenBlur = 0;
          lockScreenTint = 0;
          reverseScroll = false;
        };
        ui = {
          fontDefaultScale = 1;
          fontFixedScale = 1;
          tooltipsEnabled = true;
          scrollbarAlwaysVisible = true;
          boxBorderEnabled = false;
          translucentWidgets = false;
          panelsAttachedToBar = true;
          settingsPanelMode = "attached";
          settingsPanelSideBarCardStyle = false;
        };
        location = {
          name = "Madrid";
          weatherEnabled = true;
          weatherShowEffects = true;
          useFahrenheit = false;
          use12hourFormat = false;
          showWeekNumberInCalendar = false;
          showCalendarEvents = true;
          showCalendarWeather = true;
          analogClockInCalendar = false;
          firstDayOfWeek = -1;
          hideWeatherTimezone = false;
          hideWeatherCityName = false;
        };
        calendar = {
          cards = [
            { enabled = true;  id = "calendar-header-card"; }
            { enabled = true;  id = "calendar-month-card"; }
            { enabled = true;  id = "weather-card"; }
          ];
        };
        wallpaper = {
          enabled = true;
          overviewEnabled = false;
          directory = "/home/g4ng/wallpapers";
          viewMode = "single";
          setWallpaperOnAllMonitors = true;
          fillMode = "crop";
          useSolidColor = false;
          solidColor = "#1a1a2e";
          automationEnabled = false;
          wallpaperChangeMode = "random";
          randomIntervalSec = 300;
          transitionDuration = 1500;
          transitionType = [ "fade" "disc" "stripes" "wipe" "pixelate" "honeycomb" ];
          transitionEdgeSmoothness = 0.05;
          panelPosition = "follow_bar";
          overviewBlur = 0.4;
          overviewTint = 0.6;
          useWallhaven = false;
          sortOrder = "name";
          favorites = [ ];
        };
        appLauncher = {
          enableClipboardHistory = false;
          enableClipPreview = true;
          clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
          clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
          position = "center";
          pinnedApps = [ ];
          sortByMostUsed = true;
          terminalCommand = "ghostty -e";
          viewMode = "grid";
          showCategories = true;
          iconMode = "system";
          enableSettingsSearch = true;
          enableWindowsSearch = true;
          enableSessionSearch = true;
          density = "default";
        };
        controlCenter = {
          position = "close_to_bar_button";
          diskPath = "/";
          shortcuts = {
            left = [
              { id = "Network"; }
              { id = "Bluetooth"; }
              { id = "WallpaperSelector"; }
              { id = "NoctaliaPerformance"; }
            ];
            right = [
              { id = "Notifications"; }
              { id = "PowerProfile"; }
              { id = "KeepAwake"; }
              { id = "NightLight"; }
            ];
          };
          cards = [
            { enabled = true;  id = "profile-card"; }
            { enabled = true;  id = "shortcuts-card"; }
            { enabled = true;  id = "audio-card"; }
            { enabled = false; id = "brightness-card"; }
            { enabled = true;  id = "weather-card"; }
            { enabled = true;  id = "media-sysmon-card"; }
          ];
        };
        systemMonitor = {
          enableDgpuMonitoring = false;
          externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
        };
        noctaliaPerformance = {
          disableWallpaper = true;
          disableDesktopWidgets = true;
        };
        dock = {
          enabled = true;
          position = "bottom";
          displayMode = "auto_hide";
          dockType = "floating";
          floatingRatio = 1;
          size = 1;
          onlySameOutput = true;
          monitors = [ ];
          pinnedApps = [ ];
          colorizeIcons = false;
          showLauncherIcon = false;
          launcherPosition = "end";
          launcherUseDistroLogo = false;
          launcherIcon = "";
          launcherIconColor = "none";
          pinnedStatic = false;
          inactiveIndicators = false;
          groupApps = false;
          groupContextMenuMode = "extended";
          groupClickAction = "cycle";
          groupIndicatorStyle = "dots";
          deadOpacity = 0.6;
          animationSpeed = 1;
          sitOnFrame = false;
          showDockIndicator = false;
          indicatorThickness = 3;
          indicatorColor = "primary";
          indicatorOpacity = 0.6;
        };
        network = {
          wifiEnabled = true;
          airplaneModeEnabled = false;
          bluetoothRssiPollingEnabled = false;
          bluetoothRssiPollIntervalMs = 60000;
          networkPanelView = "wifi";
          wifiDetailsViewMode = "grid";
          bluetoothDetailsViewMode = "grid";
          bluetoothHideUnnamedDevices = false;
          disableDiscoverability = false;
          bluetoothAutoConnect = true;
        };
        sessionMenu = {
          enableCountdown = true;
          countdownDuration = 10000;
          position = "center";
          showHeader = true;
          showKeybinds = true;
          largeButtonsStyle = true;
          largeButtonsLayout = "single-row";
          powerOptions = [
            { action = "lock";         enabled = true; keybind = "1"; }
            { action = "suspend";      enabled = true; keybind = "2"; }
            { action = "hibernate";    enabled = true; keybind = "3"; }
            { action = "reboot";       enabled = true; keybind = "4"; }
            { action = "logout";       enabled = true; keybind = "5"; }
            { action = "shutdown";     enabled = true; keybind = "6"; }
            { action = "rebootToUefi"; enabled = true; keybind = "7"; }
          ];
        };
        notifications = {
          enabled = true;
          location = "top_right";
          overlayLayer = true;
          lowUrgencyDuration = 3;
          normalUrgencyDuration = 8;
          criticalUrgencyDuration = 15;
          clearDismissed = true;
          saveToHistory = { low = true; normal = true; critical = true; };
          sounds.enabled = false;
          enableMediaToast = false;
          enableKeyboardLayoutToast = true;
          enableBatteryToast = true;
        };
        osd = {
          enabled = true;
          location = "top_right";
          autoHideMs = 2000;
          overlayLayer = true;
          enabledTypes = [ 0 1 2 ];
          monitors = [ ];
        };
        audio = {
          volumeOverdrive = false;
          visualizerType = "linear";
        };
        brightness = {
          enableDdcSupport = false;
          backlightDeviceMappings = [ ];
        };
        colorSchemes = {
          useWallpaperColors = false;
          predefinedScheme = "Noctalia (default)";
          darkMode = true;
          schedulingMode = "off";
          generationMethod = "tonal-spot";
        };
        nightLight = {
          enabled = false;
          autoSchedule = true;
          nightTemp = "4000";
          dayTemp = "6500";
        };
        plugins = {
          autoUpdate = false;
          notifyUpdates = true;
        };
      };
    };
}
