{
  inputs,
  pkgs,
  ...
}:
{

  xdg.configFile."Thunar/uca.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <actions>
    <action>
        <icon>utilities-terminal</icon>
        <name>Open Terminal Here</name>
        <submenu></submenu>
        <unique-id>1769351646762757-1</unique-id>
        <command>wezterm start --always-new-process --cwd %f</command>
        <description>Example for a custom action</description>
        <range></range>
        <patterns>*</patterns>
        <startup-notify/>
        <directories/>
    </action>
    <action>
        <icon>downloader-arrow</icon>
        <name>download-subtitles</name>
        <submenu></submenu>
        <unique-id>1780181962152915-1</unique-id>
        <command>open-subtitles-download --gui=gnome %F</command>
        <description></description>
        <range>*</range>
        <patterns>*</patterns>
        <video-files/>
    </action>
    </actions>
  '';

}
