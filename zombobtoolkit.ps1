Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Xaml
Add-Type -AssemblyName System.Windows.Forms

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$installDir = "$env:USERPROFILE\Downloads\ZombobSSToolkit"

# ==============================================================================
# TOOL DATA
# ==============================================================================
$ToolData = @(
    @{ Name="PrefetchView";          Desc="Parses prefetch, extracts file info";          Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/PrefetchView/releases/latest" },
    @{ Name="BAMReveal";             Desc="Parses BAM forensic artefact";                 Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/BAMReveal/releases/latest" },
    @{ Name="StringsParser";         Desc="Strings + YARA + signatures scanner";          Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/StringsParser/releases/latest" },
    @{ Name="Fileless";              Desc="Detects fileless via eventlog + memdump";      Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/Fileless/releases/latest" },
    @{ Name="DPS-Analyzer";          Desc="Analyzes DPS memory";                          Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/DPS-Analyzer/releases/latest" },
    @{ Name="UserAssistView";        Desc="Parses UserAssist registry artifact";          Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/UserAssistView/releases/latest" },
    @{ Name="JournalParser";         Desc="Parses NTFS USNJournal entries";               Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/JournalParser/releases/latest" },
    @{ Name="InjGen";                Desc="Detects JNI/JVMTI memory injections";         Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/InjGen/releases/latest" },
    @{ Name="USBDetector";           Desc="Detects USB device history";                   Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/USBDetector/releases/latest" },
    @{ Name="PFTrace";               Desc="Rundll32/Regsvr32 prefetch analysis";          Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/PFTrace/releases/latest" },
    @{ Name="CheckDeletedUSN";       Desc="Compares USN timestamp vs boot time";          Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/CheckDeletedUSN/releases/latest" },
    @{ Name="JARParser";             Desc="Parses JAR prefetch, DcomLaunch strings";      Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/JARParser/releases/latest" },
    @{ Name="BAM-parser";            Desc="Parses BAM entries for execution history";     Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/BAM-parser/releases/latest" },
    @{ Name="PathsParser";           Desc="Extracts and analyzes executable paths";       Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/PathsParser/releases/latest" },
    @{ Name="JournalTrace";          Desc="Traces file activity via USN journal";         Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/JournalTrace/releases/latest" },
    @{ Name="KernelLiveDumpTool";    Desc="Captures live kernel memory dump";             Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/KernelLiveDumpTool/releases/latest" },
    @{ Name="BamDeletedKeys";        Desc="Finds deleted BAM registry keys";              Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/BamDeletedKeys/releases/latest" },
    @{ Name="Espouken Tool";         Desc="All-in-one SS forensics toolkit";              Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/Tool/releases/latest" },
    @{ Name="pcasvc-executed";       Desc="Extracts PCA service execution records";       Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/pcasvc-executed/releases/latest" },
    @{ Name="process-parser";        Desc="Parses process execution artefacts";           Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/process-parser/releases/latest" },
    @{ Name="prefetch-parser";       Desc="Parses Windows prefetch files";                Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/prefetch-parser/releases/latest" },
    @{ Name="ActivitiesCache";       Desc="Parses ActivitiesCache execution history";     Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/ActivitiesCache-execution/releases/latest" },
    @{ Name="MeowDoomsdayFucker";    Desc="Detects Doomsday cheat artefacts";             Category="Tonynoh";    Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowDoomsdayFucker/releases/latest" },
    @{ Name="MeowModAnalyzer";       Desc="Analyzes mod files for suspicious content";    Category="Tonynoh";    Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/MeowTonynoh/MeowModAnalyzer/main/MeowModAnalyzer.ps1')" },
    @{ Name="MeowResolver";          Desc="Resolves obfuscated strings in binaries";      Category="Tonynoh";    Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowResolver/releases/latest" },
    @{ Name="MeowNovowareFucker";    Desc="Detects Novoware cheat artefacts";             Category="Tonynoh";    Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowNovowareFucker/releases/latest" },
    @{ Name="MeowImportsChecker";    Desc="Checks PE imports for suspicious DLLs";        Category="Tonynoh";    Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowImportsChecker/releases/latest" },
    @{ Name="MeowClientsFucker";     Desc="Detects known cheat client artefacts";         Category="Tonynoh";    Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowClientFucker/releases/latest" },
    @{ Name="PSHunter";              Desc="Hunts suspicious PowerShell activity";         Category="Praiselily"; Type="GitHub"; URL="https://github.com/praiselily/PSHunter/releases/latest" },
    @{ Name="AltDetector";           Desc="Detects alternate account artefacts";          Category="Praiselily"; Type="GitHub"; URL="https://github.com/praiselily/AltDetector/releases/latest" },
    @{ Name="WeHateFakers";          Desc="Checks hotspot / tethering logs";              Category="Praiselily"; Type="Cmd";    Command="iwr https://raw.githubusercontent.com/praiselily/WeHateFakers/refs/heads/main/HotspotLogs.ps1 | iex" },
    @{ Name="CommonDirectories";     Desc="Lists files in common suspicious dirs";        Category="Praiselily"; Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/CommonDirectories.ps1')" },
    @{ Name="HarddiskConverter";     Desc="Converts harddisk identifiers for review";     Category="Praiselily"; Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/HarddiskConverter.ps1')" },
    @{ Name="Services";              Desc="Lists and analyzes running services";          Category="Praiselily"; Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Services.ps1')" },
    @{ Name="SignedScheduledTasks";  Desc="Finds unsigned / suspicious scheduled tasks"; Category="Praiselily"; Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Signed-Scheduled-Tasks.ps1')" },
    @{ Name="RL ModAnalyzer";        Desc="Analyzes mod files for cheat indicators";     Category="RedLotus";   Type="GitHub"; URL="https://github.com/ItzIceHere/RedLotus-Mod-Analyzer/releases/latest" },
    @{ Name="RL TaskSentinel";       Desc="Monitors scheduled tasks for anomalies";      Category="RedLotus";   Type="GitHub"; URL="https://github.com/ItzIceHere/RedLotus-Task-Sentinel/releases/latest" },
    @{ Name="RL AltChecker";         Desc="Checks for alternate account indicators";     Category="RedLotus";   Type="GitHub"; URL="https://github.com/ItzIceHere/RedLotusAltChecker/releases/latest" },
    @{ Name="ComputerActivityView";  Desc="Timeline of computer activity events";        Category="Others";     Type="Web";    URL="https://www.nirsoft.net/utils/computer_activity_view.html" },
    @{ Name="AmcacheParser";         Desc="Parses AMCache with YARA + signatures";       Category="Others";     Type="Web";    URL="https://download.ericzimmermanstools.com/net9/AmcacheParser.zip" },
    @{ Name="SystemInformer";        Desc="Advanced process and kernel inspector";        Category="Others";     Type="Link";   URL="https://www.systeminformer.com/canary" },
    @{ Name="DIE-engine";            Desc="Detects file type, packer, compiler";         Category="Others";     Type="Web";    URL="https://github.com/horsicq/DIE-engine/releases" },
    @{ Name="DQRKIS-FUCKER";         Desc="Detects DQRKIS cheat artefacts";              Category="Community";  Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/cheesecatlol/DQRKIS-FUCKER/refs/heads/main/DqrkisFucker.ps1')" },
    @{ Name="MacroDetector";         Desc="Detects macro / clicker software traces";     Category="Community";  Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/NiccBlahh/MacroDetector/refs/heads/main/MacroDetector.ps1')" },
    @{ Name="Jarabel";               Desc="Locates .jar files with detailed checks";     Category="Others";     Type="GitHub"; URL="https://github.com/nay-cat/Jarabel/releases/latest" },
    @{ Name="Luyten";                Desc="Open source Java decompiler GUI (Procyon)";   Category="Others";     Type="GitHub"; URL="https://github.com/deathmarine/Luyten/releases/latest" },
    @{ Name="VMAware";               Desc="Advanced VM detection library and tool";      Category="Others";     Type="GitHub"; URL="https://github.com/kernelwernel/VMAware/releases/latest" },
    @{ Name="Velociraptor";          Desc="Endpoint DFIR and threat hunting agent";      Category="Others";     Type="GitHub"; URL="https://github.com/Velocidex/velociraptor/releases/latest" },
    @{ Name="NTFS Parser";           Desc="NTFS forensics: MFT, Bitlocker, USN";        Category="Others";     Type="GitHub"; URL="https://github.com/thewhiteninja/ntfstool/releases/latest" },
    @{ Name="Hayabusa";              Desc="Fast forensics timeline generator";           Category="Others";     Type="GitHub"; URL="https://github.com/Yamato-Security/hayabusa/releases/latest" },
    @{ Name="Recuva";                Desc="File recovery tool for deleted files";        Category="Others";     Type="Link";   URL="https://www.ccleaner.com/nl-nl/recuva/download" },
    @{ Name="Everything";            Desc="Instant filename search engine for Windows";  Category="Others";     Type="Link";   URL="https://www.voidtools.com/downloads/" },
    @{ Name="HxD";                   Desc="Fast hex editor with disk and RAM editing";   Category="Others";     Type="Link";   URL="https://mh-nexus.de/en/hxd/" },
    @{ Name="bstrings";              Desc="Searches strings with regex + YARA";          Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/bstrings.zip" },
    @{ Name="JLECmd";                Desc="Parses Jump List files (CLI)";                Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/JLECmd.zip" },
    @{ Name="JumpListExplorer";      Desc="GUI explorer for Jump List artefacts";        Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/JumpListExplorer.zip" },
    @{ Name="MFTECmd";               Desc="Parses MFT, UsnJrnl, LogFile, Boot";         Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/MFTECmd.zip" },
    @{ Name="PECmd";                 Desc="Parses Windows prefetch files (CLI)";         Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/PECmd.zip" },
    @{ Name="RecentFileCacheParser"; Desc="Parses RecentFileCache.bcf artefact";         Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/RecentFileCacheParser.zip" },
    @{ Name="RegistryExplorer";      Desc="GUI explorer for registry hives";             Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/RegistryExplorer.zip" },
    @{ Name="ShellBagsExplorer";     Desc="GUI explorer for ShellBags artefacts";        Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/ShellBagsExplorer.zip" },
    @{ Name="SrumECmd";              Desc="Parses SRUM database for usage data";         Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/SrumECmd.zip" },
    @{ Name="TimelineExplorer";      Desc="GUI viewer for CSV timeline output";          Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/TimelineExplorer.zip" },
    @{ Name="FullEventLogView";      Desc="Views all Windows event log entries";         Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/fulleventlogview.zip" },
    @{ Name="NetworkUsageView";      Desc="Shows network usage per process";             Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/networkusageview.zip" },
    @{ Name="BrowserDownloadsView";  Desc="Lists all browser download history";          Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/browserdownloadsview.zip" },
    @{ Name="AlternateStreamView";   Desc="Reveals hidden NTFS alternate streams";       Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/alternatestreamview.zip" },
    @{ Name="USBDeview";             Desc="Lists all USB devices ever connected";        Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/usbdeview.zip" },
    @{ Name="OpenSaveFilesView";     Desc="Shows files opened/saved via dialogs";        Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/opensavefilesview.zip" },
    @{ Name="ExecutedProgramsList";  Desc="Lists programs run from various sources";     Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/executedprogramslist.zip" },
    @{ Name="TaskSchedulerView";     Desc="Views all scheduled tasks and history";       Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/taskschedulerview.zip" },
    @{ Name="JumpListsView";         Desc="Views Jump List recent/frequent files";       Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/jumplistsview.zip" },
    @{ Name="WinPrefetchView";       Desc="Views Windows prefetch file details";         Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/winprefetchview.zip" },
    @{ Name="RegScanner";            Desc="Scans registry for values / patterns";        Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/regscanner.zip" },
    @{ Name="ShellBagsView";         Desc="Views ShellBags folder access history";       Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/shellbagsview.zip" },
    @{ Name="NET 9.0";               Desc="Microsoft .NET 9 SDK runtime";                Category="Dependencies"; Type="Web"; URL="https://download.visualstudio.microsoft.com/download/pr/92dba916-bc51-4e76-8b0e-d41d37ce5fa4/ab08f3e95bf7a3d3da336a7e8c8eca63/dotnet-sdk-9.0.203-win-x64.exe" },
    @{ Name="NET 10.0";              Desc="Microsoft .NET 10 runtime";                   Category="Dependencies"; Type="Web"; URL="https://download.visualstudio.microsoft.com/download/pr/b3f93f0e-9e5e-4b4c-a4c4-36db0c4b0e3e/dotnet-runtime-10.0.0-win-x64.exe" },
    @{ Name="VSRedist";              Desc="Visual C++ redistributable (x64)";            Category="Dependencies"; Type="Web"; URL="https://aka.ms/vs/17/release/vc_redist.x64.exe" }
)

# ==============================================================================
# MAIN WINDOW XAML
# ==============================================================================
[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Zombob SS toolkit"
    Width="900" Height="800"
    MinWidth="900" MinHeight="800"
    WindowStartupLocation="CenterScreen"
    ResizeMode="NoResize"
    WindowStyle="None"
    AllowsTransparency="True"
    Background="Transparent"
    FontFamily="Segoe UI">

    <Window.Resources>
        <SolidColorBrush x:Key="MainBg"     Color="#0A120A"/>
        <SolidColorBrush x:Key="SidebarBg"  Color="#0F1A0F"/>
        <SolidColorBrush x:Key="CardBg"     Color="#162216"/>
        <SolidColorBrush x:Key="Accent"     Color="#2ECC71"/>
        <SolidColorBrush x:Key="AccentDim"  Color="#27AE60"/>
        <SolidColorBrush x:Key="TextMain"   Color="#EAFFEA"/>
        <SolidColorBrush x:Key="TextMuted"  Color="#6B8E6B"/>
        <SolidColorBrush x:Key="ConsoleBg"  Color="#050A05"/>
        <SolidColorBrush x:Key="GhBg"       Color="#1E2A3A"/>
        <SolidColorBrush x:Key="Ps1Bg"      Color="#1E3A2A"/>
        <SolidColorBrush x:Key="WebBg"      Color="#2A1E3A"/>

        <Style x:Key="SideBtn" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="{StaticResource TextMain}"/>
            <Setter Property="FontSize" Value="11"/>
            <Setter Property="Height" Value="30"/>
            <Setter Property="Margin" Value="4,0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="3">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" Margin="8,0"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#1E2A1E"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="TitleBtn" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="{StaticResource TextMuted}"/>
            <Setter Property="Width" Value="40"/>
            <Setter Property="Height" Value="36"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#332ECC71"/>
                                <Setter Property="Foreground" Value="#2ECC71"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Border Background="{StaticResource MainBg}" BorderBrush="#3D5A3D" BorderThickness="1" CornerRadius="8">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="42"/>
                <RowDefinition Height="48"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>

            <!-- Title Bar -->
            <Border Grid.Row="0" Background="{StaticResource SidebarBg}" CornerRadius="8,8,0,0">
                <Grid Margin="16,0">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>
                    <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                        <TextBlock Text="[Z]" FontSize="16" FontWeight="Bold" Foreground="{StaticResource Accent}" FontFamily="Consolas"/>
                        <TextBlock Text="  Zombob SS toolkit" FontSize="14" FontWeight="SemiBold" Foreground="{StaticResource TextMain}"/>
                        <TextBlock Text="  -  by Zombob Team" FontSize="11" Foreground="{StaticResource TextMuted}" VerticalAlignment="Center" Margin="4,0,0,0"/>
                    </StackPanel>
                    <StackPanel Grid.Column="1" Orientation="Horizontal">
                        <Button x:Name="MinBtn"   Style="{StaticResource TitleBtn}" Content="_"/>
                        <Button x:Name="CloseBtn" Style="{StaticResource TitleBtn}" Content="X"/>
                    </StackPanel>
                </Grid>
            </Border>

            <!-- Search + Action Buttons Row -->
            <Grid Grid.Row="1" Background="{StaticResource SidebarBg}">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <Border Grid.Column="0" Background="#0A120A" CornerRadius="4" Margin="10,6" Padding="6,0">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <TextBlock Text="Search:" FontSize="11" Foreground="{StaticResource TextMuted}" VerticalAlignment="Center" Margin="0,0,4,0"/>
                        <TextBox x:Name="SearchBox" Grid.Column="1" Background="Transparent" BorderThickness="0"
                                 Foreground="{StaticResource TextMain}" FontSize="12" VerticalContentAlignment="Center"
                                 VerticalAlignment="Center" />
                    </Grid>
                </Border>
                <StackPanel Grid.Column="1" Orientation="Horizontal" Margin="0,6">
                    <Button x:Name="OpenFolderBtn" Style="{StaticResource SideBtn}" Content="Open"/>
                    <Button x:Name="ClearCacheBtn" Style="{StaticResource SideBtn}" Content="Clear"/>
                    <Button x:Name="OpenCmdBtn"    Style="{StaticResource SideBtn}" Content="CMD"/>
                </StackPanel>
            </Grid>

            <!-- Main content area -->
            <Grid Grid.Row="2" Margin="16,14,16,14">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="10"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="10"/>
                    <RowDefinition Height="160"/>
                </Grid.RowDefinitions>

                <!-- Status card -->
                <Border Grid.Row="0" Background="{StaticResource CardBg}" CornerRadius="6" Padding="16,10">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>
                        <StackPanel>
                            <TextBlock x:Name="StatusTitle" Text="Ready" FontSize="20" FontWeight="SemiBold" Foreground="{StaticResource TextMain}"/>
                            <TextBlock x:Name="StatusSub"   Text="Select a tool to launch or download it." FontSize="11" Foreground="{StaticResource TextMuted}"/>
                        </StackPanel>
                        <Border Grid.Column="1" Background="#1E3A1E" CornerRadius="4" Padding="10,4" VerticalAlignment="Center">
                            <TextBlock x:Name="StatusBadge" Text="IDLE" FontSize="12" FontWeight="Bold" Foreground="{StaticResource Accent}"/>
                        </Border>
                    </Grid>
                </Border>

                <!-- Container for tabs or search results (with extra padding) -->
                <Grid Grid.Row="2" x:Name="ContentHost" Background="{StaticResource CardBg}">
                    <Border Padding="8">
                        <TabControl x:Name="ToolsTab" Background="Transparent" BorderThickness="0" Padding="0">
                            <TabControl.Resources>
                                <Style TargetType="TabItem">
                                    <Setter Property="Foreground" Value="{StaticResource TextMuted}"/>
                                    <Setter Property="FontSize" Value="11"/>
                                    <Setter Property="Padding" Value="12,6"/>
                                    <Setter Property="Cursor" Value="Hand"/>
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="TabItem">
                                                <Border x:Name="TabBorder" Background="Transparent" CornerRadius="4" Margin="3,4,3,0" Padding="12,5">
                                                    <ContentPresenter ContentSource="Header" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                                </Border>
                                                <ControlTemplate.Triggers>
                                                    <Trigger Property="IsSelected" Value="True">
                                                        <Setter TargetName="TabBorder" Property="Background" Value="{StaticResource Accent}"/>
                                                        <Setter Property="Foreground" Value="#0F0B00"/>
                                                    </Trigger>
                                                    <MultiTrigger>
                                                        <MultiTrigger.Conditions>
                                                            <Condition Property="IsMouseOver" Value="True"/>
                                                            <Condition Property="IsSelected" Value="False"/>
                                                        </MultiTrigger.Conditions>
                                                        <Setter TargetName="TabBorder" Property="Background" Value="#1E2A1E"/>
                                                        <Setter Property="Foreground" Value="{StaticResource TextMain}"/>
                                                    </MultiTrigger>
                                                </ControlTemplate.Triggers>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </Style>
                            </TabControl.Resources>
                        </TabControl>
                    </Border>
                </Grid>

                <!-- Console -->
                <Border Grid.Row="4" Background="{StaticResource ConsoleBg}" CornerRadius="6" Padding="12,8">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <TextBlock Text="ACTIVITY CONSOLE" FontSize="9" FontWeight="Bold" Foreground="#3D5A3D" FontFamily="Consolas" Margin="0,0,0,4"/>
                        <TextBox x:Name="LogBox"
                            Grid.Row="1"
                            Background="Transparent"
                            Foreground="{StaticResource Accent}"
                            BorderThickness="0"
                            FontFamily="Consolas"
                            FontSize="11"
                            IsReadOnly="True"
                            VerticalScrollBarVisibility="Auto"
                            TextWrapping="Wrap"/>
                    </Grid>
                </Border>
            </Grid>
        </Grid>
    </Border>
</Window>
"@

# Load main window
$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

$MinBtn        = $window.FindName("MinBtn")
$CloseBtn      = $window.FindName("CloseBtn")
$StatusTitle   = $window.FindName("StatusTitle")
$StatusSub     = $window.FindName("StatusSub")
$StatusBadge   = $window.FindName("StatusBadge")
$LogBox        = $window.FindName("LogBox")
$ToolsTab      = $window.FindName("ToolsTab")
$OpenFolderBtn = $window.FindName("OpenFolderBtn")
$ClearCacheBtn = $window.FindName("ClearCacheBtn")
$OpenCmdBtn    = $window.FindName("OpenCmdBtn")
$SearchBox     = $window.FindName("SearchBox")
$ContentHost   = $window.FindName("ContentHost")

# ==============================================================================
# HELPER FUNCTIONS
# ==============================================================================
function Write-Log {
    param([string]$msg)
    $time = Get-Date -Format "HH:mm:ss"
    $LogBox.Dispatcher.Invoke([Action]{
        $LogBox.AppendText("[$time] $msg`r`n")
        $LogBox.ScrollToEnd()
    })
}

function Set-Status {
    param($title, $sub, $badge = "BUSY")
    $window.Dispatcher.Invoke([Action]{
        $StatusTitle.Text = $title
        $StatusSub.Text   = $sub
        $StatusBadge.Text = $badge
    })
}

function Start-AppOrScript {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [string]$WorkingDirectory
    )

    if (-not $WorkingDirectory) { $WorkingDirectory = Split-Path -Parent $Path }
    $extension = [System.IO.Path]::GetExtension($Path).ToLowerInvariant()

    $quotedPath = '"' + $Path + '"'

    switch ($extension) {
        ".cmd" { Start-Process -FilePath "cmd.exe" -ArgumentList "/k", $quotedPath -WorkingDirectory $WorkingDirectory -WindowStyle Normal -Verb RunAs }
        ".bat" { Start-Process -FilePath "cmd.exe" -ArgumentList "/k", $quotedPath -WorkingDirectory $WorkingDirectory -WindowStyle Normal -Verb RunAs }
        default { Start-Process -FilePath $Path -WorkingDirectory $WorkingDirectory -WindowStyle Normal -Verb RunAs }
    }
}

function Start-CmdToolCommand {
    param([Parameter(Mandatory=$true)][string]$Command)

    $tempScript = [System.IO.Path]::Combine($env:TEMP, "zombob_$([guid]::NewGuid().ToString('N')).ps1")
    Set-Content -LiteralPath $tempScript -Value $Command -Encoding UTF8 -Force

    $startArgs = '/c start "Zombob SS toolkit" powershell.exe -NoExit -NoProfile -ExecutionPolicy Bypass -File "' + $tempScript + '"'
    Start-Process -FilePath "cmd.exe" -ArgumentList $startArgs -WindowStyle Hidden -Verb RunAs
}

function Save-UrlToFile {
    param(
        [Parameter(Mandatory=$true)][string]$Uri,
        [Parameter(Mandatory=$true)][string]$OutFile
    )

    $tempFile = "$OutFile.download"
    if (Test-Path -LiteralPath $tempFile) { Remove-Item -LiteralPath $tempFile -Force -ErrorAction SilentlyContinue }

    try {
        Invoke-WebRequest -Uri $Uri -OutFile $tempFile -UserAgent "ZombobSSToolkit" -ErrorAction Stop
        if (Test-Path -LiteralPath $OutFile) { Remove-Item -LiteralPath $OutFile -Force -ErrorAction Stop }
        Move-Item -LiteralPath $tempFile -Destination $OutFile -Force -ErrorAction Stop
    } finally {
        if (Test-Path -LiteralPath $tempFile) { Remove-Item -LiteralPath $tempFile -Force -ErrorAction SilentlyContinue }
    }
}

function Start-DownloadedTool {
    param(
        [Parameter(Mandatory=$true)][string]$Directory,
        [string]$PreferredFile
    )

    if ($PreferredFile -and (Test-Path -LiteralPath $PreferredFile) -and ($PreferredFile -notmatch "\.zip$")) {
        Write-Log "Launching $(Split-Path -Leaf $PreferredFile)"
        Start-AppOrScript -Path $PreferredFile -WorkingDirectory (Split-Path -Parent $PreferredFile)
        return $true
    }

    $launchable = Get-ChildItem -Path $Directory -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Extension -match "^\.(exe|cmd|bat)$" } |
        Sort-Object @{ Expression = { if ($_.Extension -eq ".exe") { 0 } else { 1 } } }, FullName |
        Select-Object -First 1

    if ($launchable) {
        Write-Log "Launching $($launchable.Name)"
        Start-AppOrScript -Path $launchable.FullName -WorkingDirectory $launchable.DirectoryName
        return $true
    }

    Write-Log "No .exe, .cmd, or .bat found - opening folder."
    Start-Process -FilePath explorer.exe -ArgumentList "`"$Directory`""
    return $false
}

function Get-GitHubAssetUrl {
    param([string]$ReleaseUrl)

    # Handle /releases/latest
    if ($ReleaseUrl -match "github\.com/([^/]+)/([^/]+)/releases/latest$") {
        $user = $Matches[1]
        $repo = $Matches[2]
        $api  = "https://api.github.com/repos/$user/$repo/releases/latest"
        try {
            $rel   = Invoke-RestMethod -Uri $api -Headers @{"User-Agent"="ZombobSSToolkit"} -ErrorAction Stop
            $asset = $rel.assets | Where-Object { $_.name -match "\.(exe|zip|cmd|bat)$" } | Select-Object -First 1
            if ($asset) { return @{ url=$asset.browser_download_url; name=$asset.name } }
        } catch {
            Write-Log "GitHub lookup failed: $($_.Exception.Message)"
        }
    }
    # Handle /releases/tag/...
    elseif ($ReleaseUrl -match "github\.com/([^/]+)/([^/]+)/releases/tag/(.+)$") {
        $user = $Matches[1]
        $repo = $Matches[2]
        $tag = [Uri]::EscapeDataString(([Uri]::UnescapeDataString($Matches[3])).TrimEnd("/"))
        $api  = "https://api.github.com/repos/$user/$repo/releases/tags/$tag"
        try {
            $rel   = Invoke-RestMethod -Uri $api -Headers @{"User-Agent"="ZombobSSToolkit"} -ErrorAction Stop
            $asset = $rel.assets | Where-Object { $_.name -match "\.(exe|zip|cmd|bat)$" } | Select-Object -First 1
            if ($asset) { return @{ url=$asset.browser_download_url; name=$asset.name } }
        } catch {
            Write-Log "GitHub lookup failed: $($_.Exception.Message)"
        }
    }

    return $null
}

function Invoke-ToolDownloadAndRun {
    param($tool)
    $name = $tool.Name
    $cat  = $tool.Category

    Write-Log "Fetching asset info for $name..."

    $asset = Get-GitHubAssetUrl -ReleaseUrl $tool.URL
    if (-not $asset) {
        Write-Log "No .exe/.zip/.cmd/.bat asset found for $name - opening browser."
        Set-Status "Ready" "No asset found, opened GitHub." "IDLE"
        Start-Process $tool.URL
        return
    }

    $destDir  = "$installDir\$cat\$name"
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
    $destFile = "$destDir\$($asset.name)"

    if (Test-Path $destFile) {
        Write-Log "Cached: $($asset.name) - skipping download."
    } else {
        Write-Log "Downloading $($asset.name)..."
        try {
            Save-UrlToFile -Uri $asset.url -OutFile $destFile
            Write-Log "Download complete: $($asset.name)"
        } catch {
            $err = $_
            Write-Log "Download failed: $err"
            Set-Status "Error" "Download failed for $name." "ERR"
            Start-Process $tool.URL
            return
        }
    }

    if ($asset.name -match "\.zip$") {
        Write-Log "Extracting $($asset.name)..."
        try {
            Expand-Archive -Path $destFile -DestinationPath $destDir -Force -ErrorAction Stop
        } catch {
            Write-Log "Extract failed: $($_.Exception.Message)"
            Set-Status "Error" "Could not extract $name." "ERR"
            Start-Process -FilePath explorer.exe -ArgumentList "`"$destDir`""
            return
        }
        [void](Start-DownloadedTool -Directory $destDir)
    } else {
        [void](Start-DownloadedTool -Directory $destDir -PreferredFile $destFile)
    }

    Set-Status "Ready" "$name launched successfully." "IDLE"
}

function Invoke-WebToolDownload {
    param($tool)
    $name = $tool.Name
    $url  = $tool.URL

    if ($url -match "\.(zip|exe|cmd|bat)$") {
        $fileName = ($url -split "/")[-1]
        $destDir  = "$installDir\$($tool.Category)\$name"
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
        $destFile = "$destDir\$fileName"

        if (Test-Path $destFile) {
            Write-Log "Cached: $fileName - skipping download."
        } else {
            Write-Log "Downloading $fileName..."
            try {
                Save-UrlToFile -Uri $url -OutFile $destFile
                Write-Log "Download complete: $fileName"
            } catch {
                $err = $_
                Write-Log "Download failed: $err"
                Set-Status "Error" "Download failed." "ERR"
                Start-Process $url
                return
            }
        }

        if ($fileName -match "\.zip$") {
            try {
                Expand-Archive -Path $destFile -DestinationPath $destDir -Force -ErrorAction Stop
            } catch {
                Write-Log "Extract failed: $($_.Exception.Message)"
                Set-Status "Error" "Could not extract $name." "ERR"
                Start-Process -FilePath explorer.exe -ArgumentList "`"$destDir`""
                return
            }
            [void](Start-DownloadedTool -Directory $destDir)
        } else {
            [void](Start-DownloadedTool -Directory $destDir -PreferredFile $destFile)
        }
        Set-Status "Ready" "$name launched." "IDLE"
    } else {
        Write-Log "Opening browser for $name"
        Set-Status "Browser" "Opening $name in browser." "IDLE"
        Start-Process $url
    }
}

function Invoke-ToolAction {
    param($tool)
    $name = $tool.Name
    $type = $tool.Type

    if ($type -eq "Link") {
        Write-Log "Opening $name in browser."
        Set-Status "Browser" "Opening $name..." "IDLE"
        Start-Process $tool.URL
        return
    }

    if ($type -eq "Cmd") {
        Write-Log "Starting $name..."
        Set-Status "Running" "Launching $name..." "BUSY"
        Start-CmdToolCommand -Command $tool.Command
        Set-Status "Ready" "$name launched." "IDLE"
        return
    }

    # GitHub or Web download/run
    Set-Status "Downloading" "Fetching $name..." "BUSY"
    Write-Log "Starting download: $name"

    # Run in background runspace to keep UI responsive
    $rs = [runspacefactory]::CreateRunspace()
    $rs.ApartmentState = "STA"
    $rs.ThreadOptions  = "ReuseThread"
    $rs.Open()

    $rs.SessionStateProxy.SetVariable("tData", $tool)
    $rs.SessionStateProxy.SetVariable("installDir", $installDir)
    $rs.SessionStateProxy.SetVariable("dispatcher", $window.Dispatcher)
    $rs.SessionStateProxy.SetVariable("StatusTitle", $StatusTitle)
    $rs.SessionStateProxy.SetVariable("StatusSub",   $StatusSub)
    $rs.SessionStateProxy.SetVariable("StatusBadge", $StatusBadge)
    $rs.SessionStateProxy.SetVariable("LogBox",      $LogBox)

    $ps = [powershell]::Create()
    $ps.Runspace = $rs
    $null = $ps.AddScript({
        function Set-StatusBg {
            param($title, $sub, $badge)
            $dispatcher.Invoke([Action]{
                $StatusTitle.Text = $title
                $StatusSub.Text   = $sub
                $StatusBadge.Text = $badge
            })
        }
        function Write-LogBg {
            param($msg)
            $dispatcher.Invoke([Action]{
                $LogBox.AppendText("[$(Get-Date -f 'HH:mm:ss')] $msg`n")
                $LogBox.ScrollToEnd()
            })
        }
        function Get-GitHubAssetUrlBg {
            param([string]$ReleaseUrl)
            # Handle /releases/latest
            if ($ReleaseUrl -match "github\.com/([^/]+)/([^/]+)/releases/latest$") {
                $user = $Matches[1]
                $repo = $Matches[2]
                $api = "https://api.github.com/repos/$user/$repo/releases/latest"
                try {
                    $rel = Invoke-RestMethod -Uri $api -Headers @{"User-Agent"="ZombobSSToolkit"} -ErrorAction Stop
                    $asset = $rel.assets | Where-Object { $_.name -match "\.(exe|zip|cmd|bat)$" } | Select-Object -First 1
                    if ($asset) { return @{ url=$asset.browser_download_url; name=$asset.name } }
                } catch {
                    Write-LogBg "GitHub lookup failed: $($_.Exception.Message)"
                }
            }
            # Handle /releases/tag/...
            elseif ($ReleaseUrl -match "github\.com/([^/]+)/([^/]+)/releases/tag/(.+)$") {
                $user = $Matches[1]
                $repo = $Matches[2]
                $tag = [Uri]::EscapeDataString(([Uri]::UnescapeDataString($Matches[3])).TrimEnd("/"))
                $api = "https://api.github.com/repos/$user/$repo/releases/tags/$tag"
                try {
                    $rel = Invoke-RestMethod -Uri $api -Headers @{"User-Agent"="ZombobSSToolkit"} -ErrorAction Stop
                    $asset = $rel.assets | Where-Object { $_.name -match "\.(exe|zip|cmd|bat)$" } | Select-Object -First 1
                    if ($asset) { return @{ url=$asset.browser_download_url; name=$asset.name } }
                } catch {
                    Write-LogBg "GitHub lookup failed: $($_.Exception.Message)"
                }
            }
            return $null
        }

        try {
            $name = $tData.Name
            $type = $tData.Type
            $url  = $tData.URL
            $cat  = $tData.Category

            $destDir = "$installDir\$cat\$name"
            if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }

            if ($type -eq "GitHub") {
                $assetInfo = Get-GitHubAssetUrlBg -ReleaseUrl $url
                if (-not $assetInfo) {
                    Write-LogBg "No .exe/.zip/.cmd/.bat asset found - opening browser."
                    Start-Process $url
                    Set-StatusBg "Ready" "Opened GitHub page." "IDLE"
                    return
                }
                $dlUrl = $assetInfo.url
                $fileName = $assetInfo.name
            } else {
                $dlUrl = $url
                $fileName = ($url -split "/")[-1]
            }

            $destFile = "$destDir\$fileName"
            if (Test-Path $destFile) {
                Write-LogBg "Cached: $fileName - skipping download."
            } else {
                Write-LogBg "Downloading $fileName..."
                Invoke-WebRequest -Uri $dlUrl -OutFile $destFile -UserAgent "ZombobSSToolkit" -ErrorAction Stop
                Write-LogBg "Download complete."
            }

            if ($fileName -match "\.zip$") {
                Write-LogBg "Extracting..."
                Expand-Archive -Path $destFile -DestinationPath $destDir -Force -ErrorAction Stop
                $exe = Get-ChildItem -Path $destDir -Filter "*.exe" -Recurse | Select-Object -First 1
                if ($exe) {
                    Write-LogBg "Launching $($exe.Name)..."
                    Start-Process -FilePath $exe.FullName -Verb RunAs
                } else {
                    Write-LogBg "No executable found, opening folder."
                    Start-Process explorer.exe "$destDir"
                }
            } else {
                Write-LogBg "Launching $fileName..."
                Start-Process -FilePath $destFile -Verb RunAs
            }

            Set-StatusBg "Ready" "$name launched successfully." "IDLE"
        } catch {
            Write-LogBg "Error: $_"
            Set-StatusBg "Error" "Something went wrong with $name." "ERR"
        } finally {
            $rs.Close()
        }
    })
    $null = $ps.BeginInvoke()
}

# ==============================================================================
# GENERATE TOOL CARDS
# ==============================================================================
$Categories = @("Orbdiff","Spokwn","Tonynoh","Praiselily","RedLotus","Zimmerman","NirSoft","Dependencies","Others","Community")

foreach ($cat in $Categories) {
    $tab = New-Object System.Windows.Controls.TabItem
    $tab.Header = $cat

    $scroll = New-Object System.Windows.Controls.ScrollViewer
    $scroll.VerticalScrollBarVisibility = "Auto"
    $scroll.HorizontalScrollBarVisibility = "Disabled"

    $stack = New-Object System.Windows.Controls.StackPanel
    $stack.Margin = "8"

    $catTools = $ToolData | Where-Object { $_.Category -eq $cat }

    foreach ($tool in $catTools) {
        $t = $tool

        $btn = New-Object System.Windows.Controls.Button
        $btn.Height = 60
        $btn.Margin = "0,0,0,4"
        $btn.Cursor = "Hand"
        $btn.Foreground = [Windows.Media.BrushConverter]::new().ConvertFrom("#EAFFEA")
        $btn.Background = [Windows.Media.SolidColorBrush]::new([Windows.Media.Color]::FromRgb(0x16,0x22,0x16))
        $btn.Template = [Windows.Markup.XamlReader]::Parse(
            "<ControlTemplate xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation' TargetType='Button'>" +
            "  <Border CornerRadius='4' BorderThickness='1' Background='{TemplateBinding Background}' BorderBrush='#332ECC71'>" +
            "    <ContentPresenter HorizontalAlignment='Stretch' VerticalAlignment='Center'/>" +
            "  </Border>" +
            "</ControlTemplate>"
        )

        $grid = New-Object System.Windows.Controls.Grid
        $grid.Margin = "12,6"
        $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition)) | Out-Null
        $grid.ColumnDefinitions[0].Width = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)
        $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition)) | Out-Null
        $grid.ColumnDefinitions[1].Width = [System.Windows.GridLength]::Auto

        $leftStack = New-Object System.Windows.Controls.StackPanel
        $nameBlock = New-Object System.Windows.Controls.TextBlock
        $nameBlock.Text = $t.Name
        $nameBlock.FontSize = 14
        $nameBlock.FontWeight = "SemiBold"
        $nameBlock.Foreground = [Windows.Media.Brushes]::White
        $descBlock = New-Object System.Windows.Controls.TextBlock
        $descBlock.Text = $t.Desc
        $descBlock.FontSize = 11
        $descBlock.Opacity = 0.7
        $descBlock.TextWrapping = "Wrap"
        $descBlock.Foreground = [Windows.Media.Brushes]::White
        $leftStack.Children.Add($nameBlock) | Out-Null
        $leftStack.Children.Add($descBlock) | Out-Null

        $srcBadge = New-Object System.Windows.Controls.Border
        $srcBadge.CornerRadius = 3
        $srcBadge.Padding = "5,2"
        $srcBadge.VerticalAlignment = "Center"
        $srcBadge.Margin = "8,0,0,0"
        $srcText = New-Object System.Windows.Controls.TextBlock
        $srcText.Text = $t.Type
        $srcText.FontSize = 9
        $srcText.FontWeight = "Bold"
        $srcText.Foreground = [Windows.Media.Brushes]::White
        $srcBadge.Child = $srcText

        switch ($t.Type) {
            "GitHub" { $srcBadge.Background = [Windows.Media.BrushConverter]::new().ConvertFrom("#1E2A3A"); $srcText.Foreground = [Windows.Media.Brushes]::LightBlue }
            "Cmd"    { $srcBadge.Background = [Windows.Media.BrushConverter]::new().ConvertFrom("#1E3A2A"); $srcText.Foreground = [Windows.Media.Brushes]::LightGreen }
            "Web"    { $srcBadge.Background = [Windows.Media.BrushConverter]::new().ConvertFrom("#2A1E3A"); $srcText.Foreground = [Windows.Media.Brushes]::Plum }
            "Link"   { $srcBadge.Background = [Windows.Media.BrushConverter]::new().ConvertFrom("#3A3A3A"); $srcText.Foreground = [Windows.Media.Brushes]::LightGray }
            default  { $srcBadge.Background = [Windows.Media.Brushes]::DarkSlateGray; $srcText.Foreground = [Windows.Media.Brushes]::White }
        }

        $grid.Children.Add($leftStack) | Out-Null
        $grid.Children.Add($srcBadge) | Out-Null
        [System.Windows.Controls.Grid]::SetColumn($leftStack, 0)
        [System.Windows.Controls.Grid]::SetColumn($srcBadge, 1)

        $btn.Content = $grid

        # Hover animations
        $btnBg    = [Windows.Media.SolidColorBrush]::new([Windows.Media.Color]::FromRgb(0x16,0x22,0x16))
        $btnScale = [Windows.Media.ScaleTransform]::new(1.0, 1.0)
        $btnGlow  = [Windows.Media.Effects.DropShadowEffect]::new()
        $btnGlow.Color       = [Windows.Media.Color]::FromRgb(0x2E,0xCC,0x71)
        $btnGlow.BlurRadius  = 0
        $btnGlow.ShadowDepth = 0
        $btnGlow.Opacity     = 0
        $btn.Background = $btnBg
        $btn.Tag        = $btnScale
        $btn.Resources["glow"] = $btnGlow

        $btn.Add_MouseEnter({
            $b   = $_.Source
            $bg  = $b.Background
            $sc  = $b.Tag
            $glw = $b.Resources["glow"]
            if (-not $bg -or -not $sc) { return }
            $d    = [Windows.Duration]::new([TimeSpan]::FromMilliseconds(130))
            $ease = [Windows.Media.Animation.CubicEase]::new()
            $a  = [Windows.Media.Animation.ColorAnimation]::new([Windows.Media.Color]::FromRgb(0x2E,0xCC,0x71), $d)
            $bg.BeginAnimation([Windows.Media.SolidColorBrush]::ColorProperty, $a)
            $ax = [Windows.Media.Animation.DoubleAnimation]::new(1.02, $d); $ax.EasingFunction = $ease
            $sc.BeginAnimation([Windows.Media.ScaleTransform]::ScaleXProperty, $ax)
            $ay = [Windows.Media.Animation.DoubleAnimation]::new(1.02, $d); $ay.EasingFunction = $ease
            $sc.BeginAnimation([Windows.Media.ScaleTransform]::ScaleYProperty, $ay)
            if ($glw) {
                $ab = [Windows.Media.Animation.DoubleAnimation]::new(10.0, $d)
                $glw.BeginAnimation([Windows.Media.Effects.DropShadowEffect]::BlurRadiusProperty, $ab)
                $ao = [Windows.Media.Animation.DoubleAnimation]::new(0.7, $d)
                $glw.BeginAnimation([Windows.Media.Effects.DropShadowEffect]::OpacityProperty, $ao)
            }
            $b.Foreground = [Windows.Media.Brushes]::Black
        })

        $btn.Add_MouseLeave({
            $b   = $_.Source
            $bg  = $b.Background
            $sc  = $b.Tag
            $glw = $b.Resources["glow"]
            if (-not $bg -or -not $sc) { return }
            $d    = [Windows.Duration]::new([TimeSpan]::FromMilliseconds(180))
            $ease = [Windows.Media.Animation.CubicEase]::new()
            $a  = [Windows.Media.Animation.ColorAnimation]::new([Windows.Media.Color]::FromRgb(0x16,0x22,0x16), $d)
            $bg.BeginAnimation([Windows.Media.SolidColorBrush]::ColorProperty, $a)
            $ax = [Windows.Media.Animation.DoubleAnimation]::new(1.0, $d); $ax.EasingFunction = $ease
            $sc.BeginAnimation([Windows.Media.ScaleTransform]::ScaleXProperty, $ax)
            $ay = [Windows.Media.Animation.DoubleAnimation]::new(1.0, $d); $ay.EasingFunction = $ease
            $sc.BeginAnimation([Windows.Media.ScaleTransform]::ScaleYProperty, $ay)
            if ($glw) {
                $ab = [Windows.Media.Animation.DoubleAnimation]::new(0.0, $d)
                $glw.BeginAnimation([Windows.Media.Effects.DropShadowEffect]::BlurRadiusProperty, $ab)
                $ao = [Windows.Media.Animation.DoubleAnimation]::new(0.0, $d)
                $glw.BeginAnimation([Windows.Media.Effects.DropShadowEffect]::OpacityProperty, $ao)
            }
            $b.Foreground = [Windows.Media.BrushConverter]::new().ConvertFrom("#EAFFEA")
        })

        $btn.Add_PreviewMouseDown({
            $b  = $_.Source
            $sc = $b.Tag
            if (-not $sc) { return }
            $d  = [Windows.Duration]::new([TimeSpan]::FromMilliseconds(80))
            $ax = [Windows.Media.Animation.DoubleAnimation]::new(0.98, $d)
            $sc.BeginAnimation([Windows.Media.ScaleTransform]::ScaleXProperty, $ax)
            $ay = [Windows.Media.Animation.DoubleAnimation]::new(0.98, $d)
            $sc.BeginAnimation([Windows.Media.ScaleTransform]::ScaleYProperty, $ay)
        })

        $btn.Add_PreviewMouseUp({
            $b  = $_.Source
            $sc = $b.Tag
            if (-not $sc) { return }
            $d  = [Windows.Duration]::new([TimeSpan]::FromMilliseconds(100))
            $ax = [Windows.Media.Animation.DoubleAnimation]::new(1.02, $d)
            $sc.BeginAnimation([Windows.Media.ScaleTransform]::ScaleXProperty, $ax)
            $ay = [Windows.Media.Animation.DoubleAnimation]::new(1.02, $d)
            $sc.BeginAnimation([Windows.Media.ScaleTransform]::ScaleYProperty, $ay)
        })

        $btn.Add_Click({
            $clickedBtn = $_.Source
            $tName      = ($clickedBtn.Content.Children[0].Children[0]).Text
            $tData      = $ToolData | Where-Object { $_.Name -eq $tName } | Select-Object -First 1
            if ($tData) { Invoke-ToolAction -tool $tData }
        })

        $stack.Children.Add($btn) | Out-Null
    }

    $scroll.Content = $stack
    $tab.Content = $scroll
    $ToolsTab.Items.Add($tab) | Out-Null
}

# ==============================================================================
# SEARCH FUNCTIONALITY (FIXED)
# ==============================================================================
$searchResultsList = New-Object System.Windows.Controls.ListBox
$searchResultsList.Background = [Windows.Media.Brushes]::Transparent
$searchResultsList.BorderThickness = [System.Windows.Thickness]::new(0)
$searchResultsList.HorizontalContentAlignment = "Stretch"
$searchResultsList.ItemContainerStyle = [Windows.Style]::new([Windows.Controls.ListBoxItem])
$searchResultsList.ItemContainerStyle.Setters.Add(
    [Windows.Setter]::new([Windows.Controls.Control]::BackgroundProperty, [Windows.Media.Brushes]::Transparent)
)
$searchResultsList.ItemContainerStyle.Setters.Add(
    [Windows.Setter]::new([Windows.Controls.Control]::HorizontalContentAlignmentProperty, [Windows.HorizontalAlignment]::Stretch)
)
$searchResultsList.ItemContainerStyle.Setters.Add(
    [Windows.Setter]::new([Windows.Controls.Control]::PaddingProperty, [System.Windows.Thickness]::new(0))
)
$searchResultsList.ItemContainerStyle.Setters.Add(
    [Windows.Setter]::new([Windows.Controls.Control]::MarginProperty, [System.Windows.Thickness]::new(0))
)

$ContentHost.Children.Add($searchResultsList) | Out-Null
$searchResultsList.Visibility = "Collapsed"

$SearchBox.Add_TextChanged({
    $query = $SearchBox.Text.Trim()
    if ($query.Length -eq 0) {
        $ToolsTab.Visibility = "Visible"
        $searchResultsList.Visibility = "Collapsed"
        return
    }

    $ToolsTab.Visibility = "Collapsed"
    $searchResultsList.Visibility = "Visible"

    $matches = $ToolData | Where-Object {
        $_.Name -like "*$query*" -or $_.Desc -like "*$query*" -or $_.Category -like "*$query*"
    }

    $searchResultsList.Items.Clear()
    foreach ($tool in $matches) {
        $grid = New-Object System.Windows.Controls.Grid
        $grid.Margin = "8,4"
        $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition)) | Out-Null
        $grid.ColumnDefinitions[0].Width = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)
        $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition)) | Out-Null
        $grid.ColumnDefinitions[1].Width = [System.Windows.GridLength]::Auto

        $nameBlock = New-Object System.Windows.Controls.TextBlock
        $nameBlock.Text = $tool.Name
        $nameBlock.FontSize = 14
        $nameBlock.FontWeight = "SemiBold"
        $nameBlock.Foreground = [Windows.Media.Brushes]::White

        $descBlock = New-Object System.Windows.Controls.TextBlock
        $descBlock.Text = $tool.Desc
        $descBlock.FontSize = 11
        $descBlock.Opacity = 0.7
        $descBlock.Foreground = [Windows.Media.Brushes]::White

        $leftStack = New-Object System.Windows.Controls.StackPanel
        $leftStack.Children.Add($nameBlock) | Out-Null
        $leftStack.Children.Add($descBlock) | Out-Null

        $badge = New-Object System.Windows.Controls.Border
        $badge.CornerRadius = 3
        $badge.Padding = "5,2"
        $badge.VerticalAlignment = "Center"
        $badgeText = New-Object System.Windows.Controls.TextBlock
        $badgeText.Text = $tool.Type
        $badgeText.FontSize = 9
        $badgeText.FontWeight = "Bold"
        $badgeText.Foreground = [Windows.Media.Brushes]::White
        $badge.Child = $badgeText
        switch ($tool.Type) {
            "GitHub" { $badge.Background = [Windows.Media.BrushConverter]::new().ConvertFrom("#1E2A3A"); $badgeText.Foreground = [Windows.Media.Brushes]::LightBlue }
            "Cmd"    { $badge.Background = [Windows.Media.BrushConverter]::new().ConvertFrom("#1E3A2A"); $badgeText.Foreground = [Windows.Media.Brushes]::LightGreen }
            "Web"    { $badge.Background = [Windows.Media.BrushConverter]::new().ConvertFrom("#2A1E3A"); $badgeText.Foreground = [Windows.Media.Brushes]::Plum }
            "Link"   { $badge.Background = [Windows.Media.BrushConverter]::new().ConvertFrom("#3A3A3A"); $badgeText.Foreground = [Windows.Media.Brushes]::LightGray }
            default  { $badge.Background = [Windows.Media.Brushes]::DarkSlateGray; $badgeText.Foreground = [Windows.Media.Brushes]::White }
        }

        $grid.Children.Add($leftStack) | Out-Null
        $grid.Children.Add($badge) | Out-Null
        [System.Windows.Controls.Grid]::SetColumn($leftStack, 0)
        [System.Windows.Controls.Grid]::SetColumn($badge, 1)

        # Create a button to make the whole item clickable
        $button = New-Object System.Windows.Controls.Button
        $button.Content = $grid
        $button.Tag = $tool
        $button.Background = [Windows.Media.Brushes]::Transparent
        $button.BorderThickness = [System.Windows.Thickness]::new(0)
        $button.HorizontalContentAlignment = "Stretch"
        $button.VerticalContentAlignment = "Center"
        $button.Cursor = "Hand"
        $button.Focusable = $false

        # Custom template to avoid default button hover visuals
        $button.Template = [Windows.Markup.XamlReader]::Parse(
            "<ControlTemplate xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation' TargetType='Button'>" +
            "  <Border Background='{TemplateBinding Background}' BorderThickness='0'>" +
            "    <ContentPresenter HorizontalAlignment='Stretch' VerticalAlignment='Center'/>" +
            "  </Border>" +
            "</ControlTemplate>"
        )

        $button.Add_Click({
            $clickedBtn = $_.Source
            $selectedTool = $clickedBtn.Tag
            if ($selectedTool) { Invoke-ToolAction -tool $selectedTool }
        })

        $searchResultsList.Items.Add($button) | Out-Null
    }
})

# ==============================================================================
# EVENT WIRING
# ==============================================================================
$window.Add_MouseLeftButtonDown({ try { $window.DragMove() } catch {} })
$CloseBtn.Add_Click({ $window.Close() })
$MinBtn.Add_Click({ $window.WindowState = "Minimized" })

$OpenFolderBtn.Add_Click({
    if (-not (Test-Path $installDir)) { New-Item -ItemType Directory -Path $installDir -Force | Out-Null }
    Start-Process explorer.exe $installDir
    Write-Log "Opened install folder."
})

$ClearCacheBtn.Add_Click({
    if (Test-Path $installDir) {
        $items = Get-ChildItem -Path $installDir -Force -ErrorAction SilentlyContinue
        $count = @($items).Count
        $items | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        Write-Log "Cleared $count item(s) from install folder."
        Set-Status "Clean" "Removed downloaded files and folders." "IDLE"
    } else {
        Write-Log "Nothing to clear - install folder does not exist yet."
    }
})

$OpenCmdBtn.Add_Click({
    Start-Process -FilePath "cmd.exe"
    Write-Log "Opened CMD."
})

Write-Log "Files saved to: $installDir"
Set-Status "Ready" "Select a tool to launch or download it." "IDLE"

$window.ShowDialog() | Out-Null
