% Experimentalskript 'Number representations' fuer Steuerung psychol.
% Experimente 2020
% Experimentalskript 'Number representations' fuer Steuerung psychol.
% Experimente 2020

% Vordefinieren der Grundparameter
useScreen = 0;  % 0 = genuiner Bildschirm / 1 = externer Bildschirm
bkgrCol = [ 128 128 128 ];

nGoTrials = 98; % Anzahl trials, in denen ein target gezeigt wird
ratioGoNogo = 5/6; % Ratio, wie viele go vs nogo trials gezeigt werden
nTrials = round(nGoTrials/ratioGoNogo);
nPrimes = 2; % 1 und 9
nShowSamePos = 2; % wie oft die targets an derselben Positon gezeigt werden

% Vordefinieren der Textparameter
txtCol = [255 255 255];
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
soa = linspace(0.5, 0.8, 0.001);  % Soa innerhalb des Trials: Vektor von 500-800 ms in 1ms Schritten    
primeDur = 1;        % 1000 ms Darbeitungszeit für das Primes
respTime =  3;  % Maximale Response Time bevor es zum nächsten Trial weiter geht


% ResultMatrix vorbereiten + VP NR
NResVar = 14 % Anzahl Resultatvariablen
resMatrix = zeros(nTrials, NResVar);
iVp = input('Versuchspersonennummer: ');
% eventuell auch:  iBlock = input('Blocknummer: ');


% Positions-Matrix

%%  Randomisierung der Bedingungen
nNogoTrials = nTrials-nGoTrials;

    % getrennte Matrizen zur Bestimmung der go und nogo trials:
goTrialPosMat = ones(2, nGoTrials);
nogoTrialPosMat = zeros(2, nNogoTrials);

    % Bestimmung der Targets (1. Zeile der Matrix):
goTrialPosMat(1,:) = [ones(1, nGoTrials/nPrimes), 9*ones(1, nGoTrials/nPrimes)];
% nogoTrialPosMat(1,:) = [ones(1, nNogoTrials/nPrimes), 9*ones(1, nNogoTrials/nPrimes)];

    % Bestimmung der Targetpositionen (2. Zeile der Matrix; 0 für nogo-trial):
goTrialPosMat(2,:) = repmat([1:(nGoTrials/nShowSamePos)], 1, 2);
    
    % gemeinsame Matrix für alle trials (go + nogo und zugehörige primes):
allTrialMat = [goTrialPosMat, nogoTrialPosMat]; % 1. Zeile target, 2. Zeile target position

    % Randomisierung der conditions:
randAllTrialMat = allTrialMat(:, randperm(nTrials));

%% 
% PsychToolbox initiieren & Instruktionen  --------------------------------------------------------------------------------------------------------
Screen('Preference', 'SkipSyncTests', 1);
  %Screen('Preference','ConserveVRAM',64);
[window, windowSize]=Screen('OpenWindow', useScreen, bkgrCol);
flip_int = Screen('GetFlipInterval', window); % optimieren des timings
HideCursor; 

%%% Textausgabe Intro & Instruktionen
Screen('TextSize', window, introSize ); % Introtext
Screen('TextFont', window, 'Arial');
DrawFormattedText(window, introText, 'center', 'center', txtCol);

Screen('TextSize', window, txtSize ); % Instruktionen
Screen('TextFont', window, 'Arial');
DrawFormattedText(window, instructions, 'center', 'center', txtCol);  % Anpassen, unter dem intro text
Screen('Flip', window);
KbStrokeWait;


% Experiment--------------------------------------------------------------
visonset = GetSecs;  % Zeitmarker für Beginn des trials

for i = 1:nTrials
%% Fixationskreuz 1
  DrawFormattedText(window, '+', 'center', 'center', [0 0 0]);  
  Screen('Flip', window);

%%  Prime-Ausgabe 
  Screen('TextSize', window, introSize);
  Screen('TextFont', window, 'Arial');
  DrawFormattedText(window, primeCondVec(i), 'center', 'center', stimCol); 
  
  randSoa1 = randsample(soa,1) % select random element from SOA Vector (500-800ms)
  primeVisonset = Screen('Flip',window, visonset + randSoa1 - flip_int/2 );          % überprüfen       

%%  Fixationskreuz 2
  DrawFormattedText(window, '+', 'center', 'center', [0 0 0]);  
  primeVisoffset = Screen('Flip', window, primeVisonset + primeDur - flip_int/2);      % Überprüfen

%% Targetausgabe
  DrawFormattedText(window, tarCondVec(i), position(i) , stimCol); % Passt das so mit der Konstruktion der Matrix + Randomisierung überein?
  randSoa2 = randsample(soa,1)
  targetVisonset = Screen('Flip',window, primeVisoffset + randSoa2 - flip_int/2);                % überprüfen       
  
%% Warten auf Reaktion der VP
  ButtonPress=0; Button = 0; rt = 0; resCorrect = 0; GoTrial = 0;
 
  while ( ButtonPress == 0 ) & (GetSecs - targetVisonset) < respTime  %solange kein Button gedrückt und Zeit nicht abgelaufen
        [keyIsDown, rsecs, keyCode] = KbCheck;  % Zustand der Tastatur abfragen
        ButtonPress =  keyIsDown;
        WaitSecs(.001); % um system zu entlasten
   
  end
  
  % todo: code auf randomisierten Vektor anpassen (go-nogo statt if-loop)
  if ( ButtonPress == 1 & primeCondVec(i) == targetCondVec(i) ) | ( ButtonPress == 0 & primeCondVec(i) ~= targetCondVec(i) ) % ABGLEICHEN
    Button = find(keyCode);
    rt = rsecs - targetVisonset; % Reaktionszeit
    resCorrect = 1;  % 1 = richtige Antwort, 0 = falsche Antwort
    GoTrial = 1;  % 1 = Go-Trial, 0 = No-Go Trial
  else 
    Button = find(keyCode);
    rt = respTime - targetVisonset; 
    % resCorrect = 0; % ist schon default
    % GoTrial = 0;
  end  
 
 %% Befüllen der Spalten der Ergebnismatrix
 resMatrix(i,1:NResVar) = [iVp i randSoa1 randSoa2 targetCondVec(i) GoTrial resCorrect visonset visoffset ButtonPress Button rt randSoa1 randSoa2]; % Resultatvariablen Ergänzen
   
end % Ende der Trialschleife ------------------------------------------------------------------------

% Speichern der Resultat Matrix 
filename = ['vp' num2str(iVp, '%0.2d') '.mat']; % '%0.2d': mit führender null
save(filename,'resMatrix');

% Feedback an die VP
correctRate = 100*length( find(resMatrix(:,*Index*)==1) )/nTrials;  % Index der respCorrect Spalte ergänzen
meanRT = 1000*mean(resMatrix( find(resMatrix(:,*Index*)==1),8));    % Index der respCorrect Spalte ergänzen

feedbackText = ['Rate korrekter Antworten: ' num2str(correctRate) ' %\nMittlere Reaktionszeit: ' num2str(round(meanRT)) ' ms'];

% alles schließen
Screen('CloseAll')
