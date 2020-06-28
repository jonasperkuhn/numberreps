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
stimSize = 12;            % Anpassen

% Darbietungsdauer, SOA etc.
soa = [  ];               
soaVec = [ ] 
fixDur = [ ]                                                                                        % Anpassen
fixDurVec = [ ] 
primeDur = 1;        % 1000 ms Darbeitungszeit für das Primes
respinterval = 3;      % Maximales Antwortintervall = 3 Sekunden
visonset = GetSecs;

% ResultMatrix vorbereiten + VP NR
NResVar = 5 % Anzahl Resultatvariablen
resMatrix = zeros(nTrials, NResVar);
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
for i = 1:nTrials
%% Fixationskreuz 1
  DrawFormattedText(window, '+', 'center', 'center', [0 0 0]);  
  visonset = Screen('Flip',window, visonset + soa);               % Anpassen
  visoffset = Screen('Flip',window, visonset + fixDurVec);

%%  Prime-Ausgabe 
  DrawFormattedText(window, primeCondVec(i), 'center', 'center', stimCol); 

%%  Fixationskreuz 2


%% Targetausgabe
  DrawFormattedText(window, tarCondVec(i), position(i) , stimCol); % Passt das so mit der Konstruktion der Matrix + Randomisierung überein?

%% Warten auf Reaktion der VP
  ButtonPress=0; Button = 0; rt = 0; corrResp = 0; GoTrial = 0;
  while (GetSecs - visonset) <  respinterval & ( ButtonPress == 0 )
    [keyIsDown, respTime, keyCode] = KbCheck;  % Zustand der Tastatur abfragen
    ButtonPress =  keyIsDown;
    WaitSecs(.001);
    end
    if ButtonPress
        Button = find(keyCode);
        rt = respTime - visonset;
    end
    if ButtonPress == 1 & primeCondVec(i) == targetCondVec(i) % Richtige Antwort in Condition ????
      corrResp = 1;
      GoTrial = 1;
    end
    % Befüllen der Spalten der Ergebnismatrix
    results(i,1:NResVar) = [vp i targetCondVec(i) GoTrial(i) visonset  visoffset ButtonPress Button rt corrResp]; % Resultatvariablen Ergänzen
  end
  
end % Ende der Trialschleife

% Speichern der Resultat Matrix 


Screen('CloseAll')
