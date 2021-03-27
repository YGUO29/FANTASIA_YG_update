function h = Panelette(S, WP, GlobalName)
% Panelette: Create Panelette based on parameters provided in WP and S
% usage:   h = Panelette(S, WP, GlobalName) 
%
% where,
%   S is a structure contains Color and Scale settings for UI effects
%       defaults are:
%       .PaneletteWidth = 	100;
%       .PaneletteHeight =  150;
%       .PaneletteTitle =   18;
%       .SP =               10;
%       .S =                2; 
%       .Color.BG =    	[   0.8     0.8     0.8];
%  		.Color.HL =    	[   1       1       1];  
%       .Color.FG =    	[   0       0       0];
%       .Color.TextBG =	[   0.94    0.94    0.94];
%       .Color.Select = [   0.94    0.94    0.94];
%   WP is a structure contains instruction fields for creating panelettes
%       .handleseed =   the panelette handle seed stored in the GlobalName
%       .type =         'LED',' ToggleSwitch', 'RockerSwitch', 'Potentiometer', 
%                       'MonmentarySwitch', 'Edit'
%       .name =         panelette title name
%       .row =          panelette's row # inside the handlseed array
%       .column =       panelette's column # inside the handlseed array
%       .text =         display text
%       .tip =          floating tip
%       .inputOptions = uicontrol name (choices & togglebuttons)
%       .inputDefault = default button # for 'ToggleSwitch', 'RockerSwitch'
%                       (1 2 3) from the top
%       .inputValue =   initial value for 'Potentiometer', 'Edit'
%       .inputRange = 	value range for 'Potentiometer'
%       .inputSlideStep=sliding setp for 'Potentiometer'
%       .inputFormat =  like '%5.0f' for 'Edit'
%       .inputEnable =    'Enable' is 'on' & 'off' 
%                       for 'Edit', 'MomentarySwitch', 'ToggleSwitch', 'RockerSwitch'
%   GlobalName is a global variable that used for passing handles

%% Prepare Gloabal Variable for Returning Handles 
% eval(strcat(WP.handleseed,'{',num2str(WP.row),',',num2str(WP.column),'}.hXXX{',num2str(num),'}=hhh;'));
% The global varible contains WP.handleseed that needs to be modified w/o
% returning by the function
eval(['global ', GlobalName]);

%% Prepare Scale, Scale should be in the S.olor field,
%   if not, use default values as follows

if ~isfield(S, 'PaneletteWidth');   S.PaneletteWidth =  100;    end;
if ~isfield(S, 'PaneletteHeight');  S.PaneletteHeight = 150;    end;
if ~isfield(S, 'PaneletteTitle');   S.PaneletteTitle =  18;     end;
if ~isfield(S, 'SP');               S.SP =              10;     end;
if ~isfield(S, 'S');                S.S =               2;      end;

%% Prepare Color, Color should be in the S.Color field,
%   if not, use default values as follows
try
    eval(['S.Color = ',GlobalName,'.UI.C;']);
catch
 	S.Color.BG =        [   0.8     0.8     0.8];
 	S.Color.HL =        [   1       1       1];  
 	S.Color.FG =        [   0       0       0];
 	S.Color.TextBG =    [   0.94    0.94    0.94];
	S.Color.SelectB =  	[   0.94    0.94    0.94];
	S.Color.SelectT =   [   0.18    0.57   	0.77];
end;
 	S.Color.Textdiff =  S.Color.TextBG - S.Color.BG;
	S.Color.BTdiff =    S.Color.BG - S.Color.TextBG;

%% LED scale
S.LEDwidth = round((S.PaneletteWidth - 3*S.SP)/2);          % square LED 
S.LEDTitleHeight = round((S.PaneletteHeight...
                        - 3*S.SP - 2* S.LEDwidth - 18)/2);  % left space for title
S.LEDheight = S.LEDwidth + S.LEDTitleHeight;                % title + square LED
S.LEDButtonColor = {[1 1 0],[0 1 0],[0.8 0.2 0],[1 0 0]};   % yellow, green, orange red
S.TextFont = 7;                                             % small text font

%% Toggle Switch scale
S.ButtonGroupHeight = 90;                                  	% Button Group Height
S.ButtonTitleHeight = S.PaneletteHeight...
    - S.ButtonGroupHeight - S.PaneletteTitle - 2*S.SP;      % Button Title Height
S.ToggleGroupWidth = round((S.PaneletteWidth-2*S.SP-S.S)/2);% Toggle Group Width
                                                          
%% Rocker Switch scale
S.RockerGroupWidth = S.PaneletteWidth - 2 * S.SP;           % Rocker Group Width

%% Potentiometer scale
S.SliderHeight = S.PaneletteHeight - S.PaneletteTitle - 2*S.SP;
S.SliderWidth = 20;
S.EditFont = 12;
S.EditHeight = 20;

%% MomentarySwitch scale
S.MomenWidth = 35;                                          % Momentary Switch Width
S.MomenSpacer = S.PaneletteWidth - 2*(S.MomenWidth + S.SP); % Spacer between Switches
S.MomenTextHeight = round((S.PaneletteHeight - S.PaneletteTitle - 2*S.SP...
                    - S.MomenSpacer - S.MomenWidth )/2);   	% Momentary Text Height

%% Edit
S.EditWidth = S.PaneletteWidth - 2*S.SP;                    % Edit Width
S.EditSpacer = 2;
S.EditBlockHeight = round((S.PaneletteHeight...
    - S.PaneletteTitle - 2*S.SP - S.EditSpacer)/2);         % Edit Block Height
S.EditTextHeight = S.EditBlockHeight - S.S - S.EditHeight;  % Edit Text Height

%% global
% set the handle
eval(strcat('h=',WP.handleseed,...
            '{',num2str(WP.row),',',num2str(WP.column),'}.hPanelette;'));
% set the type
eval(strcat(WP.handleseed,'{',num2str(WP.row),',',num2str(WP.column),...
            '}.type = WP.type;'));
set(h,'title',WP.name);

%% Create by type
switch WP.type;
    case 'LED'
        % create LEDs
        for i = 1:2
            for j = 1:2
                num = 2*i + j -2;
                % LED subpanel
                hh = uipanel(...
                    'parent', h,...
                    'BackgroundColor',      S.LEDButtonColor{num},...
                    'units',                'pixels',...
                    'ForegroundColor',      S.Color.FG,...
                   	'HighlightColor',       S.Color.HL,...
                    'Position',             [S.LEDwidth*(j-1) + S.SP*j,...
                                            S.LEDheight*(i-1) + S.SP*i,...
                                            S.LEDwidth, S.LEDwidth]);
                % LED 
                hhh = uicontrol(...
                    'parent',               hh,...
                    'style',                'pushbutton',...
                    'enable',               'off',...
                    'Position',             [S.S, S.S, S.LEDwidth-2*S.S, S.LEDwidth-2*S.S],...
                    'TooltipString',        sprintf(WP.tip{num}),...
                    'BackgroundColor',      S.Color.BG,...
                    'ForegroundColor',      S.Color.FG);
                % LED label
                hhhh = uicontrol(...
                    'parent',               hh,...
                    'style',                'text',...
                    'FontSize',             S.TextFont,...
                    'TooltipString',        sprintf(WP.tip{num}),...
                    'HorizontalAlignment',  'center',...
                    'string',               WP.text{num},...
                    'BackgroundColor',      S.Color.TextBG - isempty(WP.text{num})*S.Color.Textdiff,...
                    'ForegroundColor',      S.Color.FG,...
                    'position',             [0,S.LEDheight- S.LEDTitleHeight+S.S,...
                                            S.LEDwidth-S.S, S.LEDTitleHeight-S.S]);
                % register LED handles to global TPLSM
                eval(strcat(WP.handleseed,'{',num2str(WP.row),',',num2str(WP.column),...
                    '}.hLED{',num2str(num),'}=hhh;'));
            end;
        end;
    case 'ToggleSwitch'
        % Create two toggle switches panels
        for i = 1:2
            % Parameter Initiation
            if isfield(WP,'buttonnum');
                buttonnum = WP.buttonnum(i);
            else
                buttonnum = 3;
            end;
        	if isfield(WP,'inputOptions');
                string = WP.inputOptions(i,:);
            else
                string = {'High','Low',''};
            end;
           	if isfield(WP,'inputDefault');
                defaultbutton = WP.inputDefault(i);
            else
                defaultbutton = 2;
            end;
            
            % Toggle Button Group
            hh = uibuttongroup(...
                    'parent',               h,...
                    'unit',                 'pixel',...
                    'BackgroundColor',      S.Color.BG,...
                    'ForegroundColor',      S.Color.FG,...
                    'HighlightColor',       S.Color.HL,...
                    'ShadowColor',          [0 0 0],...
                    'position',             [S.SP + (S.ToggleGroupWidth+S.S)*(i-1), S.SP,...
                                            S.ToggleGroupWidth, S.ButtonGroupHeight]);
            % Toggle Buttons in the Group
            for j = 1:buttonnum
                hhh(j) = uicontrol(...
                    'parent',               hh,...
                    'style',                'togglebutton',...
                    'unit',                 'normalized',...
                    'position',             [0 1-j/buttonnum 1 1/buttonnum],...                 
                    'BackgroundColor',      S.Color.TextBG,...
                    'ForegroundColor',      S.Color.FG,... 
                    'string',               string{1,j},...
                    'userdata',             2-j,...
                    'TooltipString',        sprintf(WP.tip{i})); 
                if j==defaultbutton;
                    set(hhh(j), ...
                    'BackgroundColor',      S.Color.SelectB);
                end;
                if isempty(string{j})
                    set(hhh(j),...
                    'Enable',               'off');
                end;
                if isfield(WP,'enable')
                    if WP.enable(i,j)==0
                    	set(hhh(j),...
                    'Enable',               'off');
                    end;
                end;
                
            end;
            % set default button
            if defaultbutton
                set(hh,'SelectedObject',hhh(defaultbutton));
            else
                set(hh,'SelectedObject',[]);
            end;
            % Title Labels
            hhh = uicontrol(...
                    'parent',               h,...
                    'style',                'text',...
                    'FontSize',             S.TextFont,...
                    'unit',                 'pixel',...
                    'TooltipString',        sprintf(WP.tip{i}),...
                    'BackgroundColor',      S.Color.TextBG,...
                    'ForegroundColor',      S.Color.FG,...
                    'string',               sprintf(WP.text{i}),...
                    'HorizontalAlignment',  'left',...
                   	'position',             [S.SP + (S.ToggleGroupWidth+S.S)*(i-1), S.SP+S.ButtonGroupHeight + S.S,...
                                            S.ToggleGroupWidth, S.ButtonTitleHeight]);
         	% register Toggle Switch handles to global TPLSM
            eval(strcat(WP.handleseed,'{',num2str(WP.row),',',num2str(WP.column),...
                '}.hToggle{',num2str(i),'}=hh;'));            
        end
    case 'RockerSwitch'
        for i = 1:1
            % Parameter Initiation
            if isfield(WP,'buttonnum');
                buttonnum = WP.buttonnum(i);
            else
                buttonnum = 3;
            end;
        	if isfield(WP,'inputOptions');
                string = WP.inputOptions(i,:);
            else
                string = {'High','Low',''};
            end;
           	if isfield(WP,'inputDefault');
                defaultbutton = WP.inputDefault(i);
            else
                defaultbutton = 2;
            end;
            
            % Toggle Button Group
            hh = uibuttongroup(...
                   	'parent',               h,...
                    'unit',                 'pixel',...
                    'BackgroundColor',      S.Color.BG,...
                    'ForegroundColor',      S.Color.FG,...
                    'HighlightColor',       S.Color.HL,...
                    'ShadowColor',          [0 0 0],...
                    'position',             [S.SP + (S.RockerGroupWidth+S.S)*(i-1), S.SP,...
                                            S.RockerGroupWidth, S.ButtonGroupHeight]);
            % Toggle Buttons in the Group
            for j = 1:buttonnum
                hhh(j) = uicontrol(...
                    'Parent',               hh,...
                    'Style',                'togglebutton',...
                    'Unit',                 'normalized',...
                    'Position',             [0 1-j/buttonnum 1 1/buttonnum],...                    
                    'BackgroundColor',      S.Color.TextBG,...
                    'ForegroundColor',      S.Color.FG,...   
                    'String',               string{j},...
                    'UserData',             2-j,...
                    'TooltipString',        sprintf(WP.tip{i}));
                if j==defaultbutton;
                    set(hhh(j),...
                    'BackgroundColor',      S.Color.SelectB);
                end;
                if isempty(string{j})
                    set(hhh(j),...
                    'Enable',               'off');
                end;
                if isfield(WP,'enable')
                    if WP.enable(i,j)==0
                    	set(hhh(j),...
                    'Enable',               'off');
                    end;
                end;
            end;
            % set default button
            if defaultbutton
                set(hh,...
                    'SelectedObject',       hhh(defaultbutton));
            else
                set(hh,...
                    'SelectedObject',       []);
            end;          
            % Title Labels
            hhh = uicontrol(...
                    'parent',               h,...
                    'style',                'text',...
                    'FontSize',             S.TextFont,'unit','pixel',...
                    'TooltipString',        sprintf(WP.tip{i}),...
                    'BackgroundColor',      S.Color.TextBG,...
                    'ForegroundColor',      S.Color.FG,...
                    'string',               sprintf(WP.text{i}),...
                    'HorizontalAlignment',  'left',...
                    'position',             [S.SP, S.SP + S.ButtonGroupHeight + S.S,...
                                            S.RockerGroupWidth, S.ButtonTitleHeight]);
         	% register Toggle Switch handles to global TPLSM
            eval(strcat(WP.handleseed,'{',num2str(WP.row),',',num2str(WP.column),...
                '}.hRocker{',num2str(i),'}=hh;'));            
        end   
    case 'Potentiometer'
        for i = 1:1
        if isfield(WP, 'inputValue');
            inputValue = WP.inputValue;
        else
            inputValue = 0;
        end;
        % Edit Numbers
        hh =uicontrol(...
                    'parent',               h,...
                    'style',                'edit',...
                    'FontSize',             S.EditFont,...
                    'BackgroundColor',      S.Color.TextBG,...
                    'ForegroundColor',      S.Color.SelectT,...
                    'string',               sprintf('%1.2f',inputValue),...
                    'HorizontalAlignment',  'left',...
                    'TooltipString',        sprintf(WP.tip{1}),...
                    'position',             [2*S.SP+S.SliderWidth, S.SP+S.SliderHeight-S.EditHeight,...
                                            S.PaneletteWidth - 3*S.SP - S.SliderWidth, S.EditHeight],...
                    'userdata',             WP.row*10+WP.column,...
                    'callback',             ['global TPLSM; rowcolumn = get(gcbo,''userdata'');' ...
                                             'row = floor(rowcolumn/10); column = rowcolumn - row*10;' ...
                                             'hPanelette = get(gcbo,''parent'');'...
                                             'hTemp = get(hPanelette,''Children'');'...
                                             'hSlider = hTemp(2);'...
                                             'num = str2num(get(gcbo,''string''));'...
                                             'set(hSlider,''value'',num);'...
                                             'set(gcbo,''string'',sprintf(''%1.2f'',num));']...
            );
         	%'set(gcbo,''string'',sprintf(''%1.2f'',num))']...
        % Slider
        hhh = uicontrol(...
                    'parent',               h,...
                 	'unit',                 'pixel',...
                    'style',                'slider',...
                    'sliderstep',           WP.inputSlideStep,...
                    'TooltipString',        sprintf(WP.tip{1}),...
                    'BackgroundColor',      S.Color.TextBG,...
                    'ForegroundColor',      S.Color.FG,...
                    'position',             [S.SP, S.SP, S.SliderWidth, S.SliderHeight],...
                    'Min',                  WP.inputRange(1),...
                    'Max',                  WP.inputRange(2),...
                    'value',                inputValue,...
                    'userdata',             WP.row*10+WP.column,...
                    'callback',             ['global TPLSM; rowcolumn = get(gcbo,''userdata'');' ...
                                             'row = floor(rowcolumn/10); column = rowcolumn - row*10;' ...
                                             'hPanelette = get(gcbo,''parent'');'...
                                             'hTemp = get(hPanelette,''Children'');'...
                                             'hEdit = hTemp(3);'...
                                         	 'set(hEdit,''string'',sprintf(''%1.2f'',get(gcbo,''value'')))']...
            );
        %   Text
        hhhh = uicontrol(...
                    'parent',               h,...
                    'unit',                 'pixel',...
                    'style',                'text',...
                    'TooltipString',        sprintf(WP.tip{1}),...
                    'Backgroundcolor',      S.Color.TextBG,...
                    'ForegroundColor',      S.Color.FG,...
                    'position',             [2*S.SP+S.SliderWidth, S.SP,...
                                            S.PaneletteWidth - 3*S.SP - S.SliderWidth-S.S, S.SliderHeight-20-S.SP],...
                    'string',               sprintf(WP.text{1})...
            );
        eval(strcat(WP.handleseed,'{',num2str(WP.row),',',num2str(WP.column),...
                '}.hSlider{',num2str(i),'}=hhh;')); 
        eval(strcat(WP.handleseed,'{',num2str(WP.row),',',num2str(WP.column),...
                '}.hEdit{',num2str(i),'}=hh;')); 
        end;
    case 'MomentarySwitch'
        for i = 1:1
      	% create buttons
        hh1 = uicontrol(...
                    'parent',               h,...
                    'style',                'pushbutton',...
                    'units',                'pixels',...            
                    'Backgroundcolor',      S.Color.TextBG,...
                    'ForegroundColor',      S.Color.FG,...
                    'enable',               WP.inputEnable{1},...
                    'TooltipString',        sprintf(WP.tip{1}),...
                    'Position',             [S.SP,S.SP + S.MomenSpacer + S.MomenTextHeight,...
                                            S.MomenWidth, S.MomenWidth]);
        hh2 = uicontrol(...
                    'parent',               h,...
                    'style',                'pushbutton',...
                    'units',                'pixels',...
                    'Backgroundcolor',      S.Color.TextBG,...
                    'ForegroundColor',      S.Color.FG,...
                    'enable',               WP.inputEnable{2},...
                    'TooltipString',        sprintf(WP.tip{2}),...
                    'Position',             [S.SP + S.MomenWidth + S.MomenSpacer, S.SP + S.MomenTextHeight,...
                                            S.MomenWidth, S.MomenWidth]);
        % Button label
        hhh1 = uicontrol(...
                    'parent',               h,...
                    'style',                'text',...
                    'units',                'pixels',...
                    'FontSize',             S.TextFont,...
                    'string',               sprintf(WP.text{1}),...
                    'Backgroundcolor',      S.Color.TextBG,...
                    'ForegroundColor',      S.Color.FG,...
                    'TooltipString',        sprintf(WP.tip{1}),...
                    'Position',             [S.SP + S.S, S.SP + S.MomenTextHeight + S.MomenSpacer + S.MomenWidth + S.S,...
                                            S.EditWidth - S.S, S.MomenTextHeight - S.S]);
        hhh2 = uicontrol(...
                    'parent',               h,...
                    'style',                'text',....
                    'units',                'pixels',...
                    'FontSize',             S.TextFont,...
                    'string',               sprintf(WP.text{2}),...
                    'Backgroundcolor',      S.Color.TextBG,...
                    'ForegroundColor',      S.Color.FG,...
                    'TooltipString',        sprintf(WP.tip{2}),...
                    'Position',             [S.SP + S.S, S.SP + S.S,...
                                            S.EditWidth - S.S, S.MomenTextHeight - S.S]);
        eval(strcat(WP.handleseed,'{',num2str(WP.row),',',num2str(WP.column),...
                '}.hMomentary{1}=hh1;')); 
        eval(strcat(WP.handleseed,'{',num2str(WP.row),',',num2str(WP.column),...
                '}.hMomentary{2}=hh2;')); 
        end;
    case 'Edit'
        % Create 2 Edit Box
        for i = 1:2           
            % Edit Box
            hh =uicontrol(...
                    'parent',               h,...
                  	'style',                'edit',...
                    'FontSize',             S.EditFont,...
                    'Backgroundcolor',      S.Color.TextBG,...
                    'TooltipString',        sprintf(WP.tip{i}),...
                    'string',               sprintf(WP.inputFormat{i},WP.inputValue{i}),...
                    'HorizontalAlignment',  'right',...
                    'enable',               WP.inputEnable{i},...
                    'position',             [S.SP,...
                                            S.SP+i*S.EditBlockHeight+(i-1)*S.EditSpacer-S.EditHeight,...
                                            S.EditWidth, S.EditHeight]...
                );
            switch WP.inputEnable{i}
                case 'inactive';    
                    set(hh,...
                    'ForegroundColor',      S.Color.FG);
                case 'on';
                    set(hh,...
                    'ForegroundColor',      S.Color.SelectT);
                otherwise
            end;
            % Text
            hhh = uicontrol(...
                    'parent',               h,...
                    'unit',                 'pixel',...
                    'style',                'text',...
                    'FontSize',             S.TextFont,...
                    'HorizontalAlignment',  'left',...
                    'Backgroundcolor',      S.Color.TextBG,...
                    'ForegroundColor',      S.Color.FG,...
                    'TooltipString',        sprintf(WP.tip{i}),...
                    'position',             [S.SP+S.S,...
                                            S.SP+(i-1)*(S.EditBlockHeight+S.EditSpacer),...
                                            S.EditWidth-2*S.S, S.EditTextHeight],...
                  	'string',               sprintf(WP.text{i})...
                );
            eval(strcat(WP.handleseed,'{',num2str(WP.row),',',num2str(WP.column),...
                    '}.hEdit{',num2str(i),'}=hh;')); 
        end;
    otherwise
        error('unknown panelette type');
end;
