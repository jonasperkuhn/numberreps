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
soa = linspace(0.5, 0.8, 0.001);  % Soa Vektor von 500-800 ms in 1ms Schritten    
primeDur = 1;        % 1000 ms Darbeitungszeit für das Primes
respinterval = 3;      % Maximales Antwortintervall = 3 Sekunden
respTime =                                                                  % Anpassen

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
visonset = GetSecs;    % der aktuelle Zeitmarker wird visonset zugewiesen, so dass der flip-Befehl beim ersten Durchlaufen der Schleife einen Wert für visonset hat

for i = 1:nTrials
%% Fixationskreuz 1
  DrawFormattedText(window, '+', 'center', 'center', [0 0 0]);  
  Screen('Flip', window);

%%  Prime-Ausgabe 
  DrawFormattedText(window, primeCondVec(i), 'center', 'center', stimCol); 
  randSoa1 = randsample(soa,1) % select random element from SOA Vector (500-800ms)
  primeVisonset = Screen('Flip',window, visonset + randSoa1);                % überprüfen       
  primeVisoffset = Screen('Flip',window, visonset + primeDur);

%%  Fixationskreuz 2
  DrawFormattedText(window, '+', 'center', 'center', [0 0 0]);  
  Screen('Flip', window);      % Überprüfen

%% Targetausgabe
  DrawFormattedText(window, tarCondVec(i), position(i) , stimCol); % Passt das so mit der Konstruktion der Matrix + Randomisierung überein?
  randSoa2 = randsample(soa,1)
  targetVisonset = Screen('Flip',window, visonset + randSoa2);                % überprüfen       
  
%% Warten auf Reaktion der VP
  ButtonPress=0; Button = 0; rt = 0; corrResp = 0; GoTrial = 0;
 
  while (GetSecs - targetVisonset) <  respinterval & ( ButtonPress == 0 )
        [keyIsDown, respTime, keyCode] = KbCheck;  % Zustand der Tastatur abfragen
        ButtonPress =  keyIsDown;
        WaitSecs(.001);
  end
  
  if ButtonPress == 1 & primeCondVec(i) == targetCondVec(i) % Richtige Antwort in Condition ???
    Button = find(keyCode);
    rt = respTime - targetVisonset;
    corrResp = 1;
    GoTrial = 1;
  else 
    Button = find(keyCode);
    rt = respTime - targetVisonset; 
    corrResp = 0;
    GoTrial = 0;
  end  
 
 %% Befüllen der Spalten der Ergebnismatrix
 results(i,1:NResVar) = [vp i targetCondVec(i) GoTrial corrResp visonset  visoffset ButtonPress Button rt]; % Resultatvariablen Ergänzen
   
end % Ende der Trialschleife ------------------------------------------------------------------------

% Speichern der Resultat Matrix 


Screen('CloseAll')
