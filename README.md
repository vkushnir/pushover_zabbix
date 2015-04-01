# Pushover for Zabbix
Send notification from Zabbix to Pushover.
Just put some tags in message body.

%PUSHOVER%TOKEN%      Application API Token [azGDORePK8gMaC0QOYAMyEEuzJnyUi]
%PUSHOVER%USER%       User Identifier       [uQiRzpo4DXghDmr9QzzfQu27cmVRsG]
%PUSHOVER%DEVICE%     User Device Name      [iphone,nexus5]
%PUSHOVER%TITLE%      Message Title
%PUSHOVER%PRIORITY%   Message Priority      [-2/-1/0/1/2]
%PUSHOVER%SOUND%      Notification Sound    [pushover/bike/bugle/cashregister/classical/cosmic/falling/gamelan/incoming/intermission/magic/mechanical/pianobar/siren/spacealarm/tugboat/alien/climb/persistent/echo/updown/none]
%PUSHOVER%RETRY%      Number of trys (required for Emergency Priority (2))
%PUSHOVER%EXPIRE%     Seconds for wait (required for Emergency Priority (2))
%PUSHOVER%URL%        Supplementary URL
%PUSHOVER%URL_TITLE%  Supplementary URL Title
%PUSHOVER%TIMESTAMP%  Message Time in Unix Timestamp
%PUSHOVER%CALLBACK%   Not implemented yet
%PUSHOVER%HTML%       Enable HTML formatting [1]
    <b>word</b> - display word in bold
    <i>word</i> - display word in italics
    <u>word</u> - display word underlined
    <font color="blue">word</font> - display word in blue text (most colors and hex codes permitted)
    <a href="http://example.com/">word</a> - display word as a tappable link to http://example.com/ 
