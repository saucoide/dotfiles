{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    pavucontrol # sound settings gui
    # easyeffects # Optional
  ];
  services.pulseaudio.enable = false; # conflicts with pipewire?
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    wireplumber.enable = true;
  };
}
