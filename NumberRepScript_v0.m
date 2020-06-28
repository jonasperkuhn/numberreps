% Experimentalskript 'Number representations' fuer Steuerung psychol.
% Experimente 2020

% Vordefinieren der Grundparameter
useScreen = 0;  % 0 = genuiner Bildschirm / 1 = externer Bildschirm
bkgrCol = [ 128 128 128 ];

% Vordefinieren der Textparameter
txtCol = [255 200 200];
introSize = 64;
txtSize = 30;
introText = 'Herzlich willkommen zu unserem Experiment!'; 
instructions = 'Im folgenden Experiment ..... Drücken Sie bitte eine beliebige Taste um mit dem Experiment zu starten' % Instruktion Ergänzen

% Vordefinieren der Stimuli 
einsTxt = 'Eins'
neunTxt = 'Neun'
einsNr = '1'
neunNr = '9'
distractor = '#'
stimCol = [0 0 0]
stimSize = 12; % Anpassen

% Darbietungsdauer, SOA etc.
soa = 3;               % Stimulus Onset Asynchronie  Anpassen
primeDur = 1;        % 1000 ms Darbeitungszeit für das Primes
fixDur = 
respinterval = 3;      % Antwortintervall in Sekunden
visonset = GetSecs;

% Vordefinieren der Reaktionszeit, ButtonPress & zu drückende Taste 
respTime = 3  % sollen wir die maximale RespTime auch bei 3s belassen?
ButtonPress = 0
spacekeyID = KbName('space') % VP sollen bei Go-Trials die Space Taste drücken

% ResultMatrix vorbereiten + VP NR
resMatrix = zeros(nTrials, 5);
iVp = input('Versuchspersonennummer: ');
% eventuell auch:  iBlock = input('Blocknummer: ');


% Positions-Matrix


% Randomisierung der Bedingungen
primeCondVec = % Prime Condition
tarCondVec = % Target Condition


% Instruktionen  --------------------------------------------------------------------------------------------------------
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','ConserveVRAM',64);
[window, windowSize]=Screen('OpenWindow', useScreen, bkgrCol);
HideCursor; 

%%% Textausgabe Intro & Instruktionen
Screen('TextSize', window, introSize ); % Introtext
Screen('TextFont', window, 'Arial');
DrawFormattedText(window, introText, 'center', 'center', txtCol);

Screen('TextSize', window, txtSize ); % Instruktionen
Screen('TextFont', window, 'Arial');
DrawFormattedText(window, instructions, 'center', 'center', txtCol);
Screen('Flip', window);
KbStrokeWait;


% Experiment--------------------------------------------------------------
%% Fixationskreuz 1
DrawFormattedText(window, '+', 'center', 'center', [0 0 0]);  
Screen('Flip', window);

%%  Prime-Ausgabe 
DrawFormattedText(window, primeCondVec(i), 'center', 'center', stimCol); 

%%  Fixationskreuz 2

% Targetausgabe
DrawFormattedText(window, tarCondVec(i), position(i) , stimCol); % Passt das so mit der Konstruktion der Matrix + Randomisierung überein?




Screen('CloseAll')
