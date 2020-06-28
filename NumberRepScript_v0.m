% Experimentalskript 'Number representations' fuer Steuerung psychol.
% Experimente 2020

% Vordefinieren der Grundparameter
useScreen = 0;  % 0 = genuiner Bildschirm / 1 = externer Bildschirm
bkgrCol = [ 128 128 128 ];

% Vordefinieren der Textparameter
txtCol = [255 200 200];
textSize = 30;
introText = 'Herzlich willkommen zu unserem Experiment!'; % Instruktion Ergänzen
respTime = 3  % sollen wir die maximale RespTime auch bei 3s belassen?


% Vordefinieren der Stimuli
einsTxt = 'Eins'
neunTxt = 'Neun'
einsNr = '1'
neunNr = '9'
distractor = '#'
stimCol = [0 0 0]
stimSize = 12; % Anpassen

%ResultMatrix vorbereiten + VP NR
resMatrix = zeros(nTrials, 5);
iVp = input('Versuchspersonennummer: ');
% eventuell auch:  iBlock = input('Blocknummer: ');


% Positions-Matrix


% Randomisierung der Bedingungen


% Instruktionen  --------------------------------------------------------------------------------------------------------

Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','ConserveVRAM',64);
[window, windowSize]=Screen('OpenWindow', useScreen, bkgrCol );

%%% Textausgabe
Screen('TextSize', window, txtSize );
DrawFormattedText(window, introText, 'center', 'center', txtCol);
Screen('Flip', window);

KbStrokeWait;

% Experiment--------------------------------------------------------------
%% Zeige Fixationskreuz
DrawFormattedText(window, '+', 'center', 'center', [0 0 0]);  % Ergänze: Fixationskreuz muss wieder verschwinden
Screen('Flip', window);

% Vorbereitung der Prime-Ausgabe 
DrawFormattedText(window, textQuad, {%position%} , stimCol);
