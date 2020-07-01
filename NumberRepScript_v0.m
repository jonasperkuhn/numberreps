% Experimentalskript 'Number representations' fuer Steuerung psychol.
% Experimente 2020

% Vordefinieren der Grundparameter
useScreen = 0;  % 0 = genuiner Bildschirm / 1 = externer Bildschirm
bkgrCol = [ 128 128 128 ];

% Vordefinieren der Textparameter
txtCol = [255 255 255];
introSize = 64;
txtSize = 30;
yInt = windowSize(4)/2 - 600;   %ggf. Anpassen
yIns = windowSize(4)/2 - 100;
introText = 'Herzlich willkommen zu unserem Experiment!'; 
instructions = 'Im folgenden Experiment.. Reaktion mit Leertaste... Drücken Sie bitte eine beliebige Taste um mit dem Experiment zu starten' % Instruktion Ergänzen

% Vordefinieren der Stimuli 
einsTxt = 'Eins';
neunTxt = 'Neun';
einsNr = '1';
neunNr = '9';
distractor = '#';
stimCol = [0 0 0];
stimSize = 30;            % Anpassen
primeFixSize = 50;

% Tastenreaktion, Darbietungsdauer, SOA etc.
respKey = KbName('Space'); % Reaktion auf Go-trials mit Leertaste
soa = [0.5:0.001:0.8];  % Soa innerhalb des Trials: Vektor von 500-800 ms in 1ms Schritten    
primeDur = 1;        % 1000 ms Darbeitungszeit für das Primes
respTime =  3;  % 3s Maximale Response Time bevor es zum nächsten Trial weiter geht


% ResultMatrix vorbereiten + VP NR
NResVar = 14; % Anzahl Resultatvariablen
resMatrix = zeros(nTrials, NResVar);
iVp = input('Versuchspersonennummer: ');
% eventuell auch:  iBlock = input('Blocknummer: ');


% Positions-Matrix


%% *% Randomisierung der Bedingungen*
nGoTrials = nTrials*ratioGoNogo;
nNogoTrials = round(nTrials*(1-ratioGoNogo));

    %Matrizen zur Bestimmung der go und nogo trials:
goCondMat = ones(2, nTrials*5/6);
nogoCondMat = -ones(2, nTrials*1/6);

goCondMat(2,:) = [ones(1, nGoTrials/nPrimes), 9*ones(1, nGoTrials/nPrimes)];
nogoCondMat(2,:) = [ones(1, nNogoTrials/nPrimes), 9*ones(1, nNogoTrials/nPrimes)];

    % gemeinsame Matrix für alle trials (go + nogo und zugehörige primes):
allCondVec = [goCondMat, nogoCondMat];
    % Randomisierung der conditions:
randAllCondVec = allCondVec(:, randperm(nTrials));



primeCondVec = % finaler Prime Condition Vector
tarCondVec = % finaler Target Condition Vector

for i = 1:(nTrials/()
    
end

% PsychToolbox initiieren & Instruktionen  --------------------------------------------------------------------------------------------------------
Screen('Preference', 'SkipSyncTests', 1);
  %Screen('Preference','ConserveVRAM',64);
[window, windowSize]=Screen('OpenWindow', useScreen, bkgrCol);
flip_int = Screen('GetFlipInterval', window); % optimieren des timings
HideCursor; % Mauszeiger verstecken

%%% Textausgabe Intro & Instruktionen
Screen('TextSize', window, introSize ); % Introtext
Screen('TextFont', window, 'Arial');
DrawFormattedText(window, introText, 'center', yInt, txtCol);

Screen('TextSize', window, txtSize ); % Instruktionen
Screen('TextFont', window, 'Arial');
DrawFormattedText(window, instructions, 'center', yIns, txtCol);  % Anpassen, unter dem intro text
Screen('Flip', window);
KbStrokeWait;


% Experiment--------------------------------------------------------------
visonset = GetSecs;  % Zeitmatker für Begin des trials

for i = 1:nTrials
    %# Fixationskreuz 1
    Screen('TextSize', window, primeFixSize);
    DrawFormattedText(window, '+', 'center', 'center', [0 0 0]);
    Screen('Flip', window);
    
    %#  Prime-Ausgabe
    Screen('TextSize', window, introSize);
    Screen('TextFont', window, 'Arial');
    DrawFormattedText(window, primeCondVec(i), 'center', 'center', stimCol);
    
    randSoa1 = randsample(soa,1) % select random element from SOA Vector (500-800ms)
    primeVisonset = Screen('Flip',window, visonset + randSoa1 - flip_int/2 );          % überprüfen, -flip_int/2 notwendig da eh ransomisierte soa?
    
    %#  Fixationskreuz 2
    Screen('TextSize', window, primFixSize);
    DrawFormattedText(window, '+', 'center', 'center', [0 0 0]);
    primeVisoffset = Screen('Flip', window, primeVisonset + primeDur - flip_int/2);      
    
    %# Targetausgabe
    Screen('TextSize', window, stimSize);
    DrawFormattedText(window, tarCondVec(i), position(i) , stimCol); % Passt das so mit der Konstruktion der Matrix + Randomisierung überein?
    randSoa2 = randsample(soa,1)
    targetVisonset = Screen('Flip',window, primeVisoffset + randSoa2 - flip_int/2);                % überprüfen
    
    %# Warten auf Reaktion der VP
    ButtonPress=0;
    
    while ( ButtonPress == 0 ) & (GetSecs - targetVisonset) < respTime  %solange kein Button gedrückt und Zeit nicht abgelaufen
        [keyIsDown, rsecs, keyCode] = KbCheck;  % Zustand der Tastatur abfragen
        ButtonPress =  keyIsDown;
        WaitSecs(.001); % um system zu entlasten
    end
    
    if ButtonPress == 1
        usedButton = find(keyCode);
        rt = rsecs - targetVisonset; % Reaktionszeit
        if primeCondVec(i) == targetCondVec(i) & usedButton == respKey
            resCorrect = 1;  % 1 = richtige Antwort, 0 = falsche Antwort
            GoTrial = 1;  % 1 = Go-Trial, 0 = No-Go Trial
        else
            resCorrect = 0;  % 1 = richtige Antwort, 0 = falsche Antwort
            GoTrial = 1;  % 1 = Go-Trial, 0 = No-Go Trial
    elseif ButtonPress == 0 & primeCondVec(i) ~= targetCondVec(i)
            resCorrect = 0; % ist schon default
            GoTrial = 0;
    end
        
    %# Befüllen der Spalten der Ergebnismatrix
    resMatrix(i,1:NResVar) = [iVp i randSoa1 randSoa2 targetCondVec(i) GoTrial resCorrect visonset visoffset ButtonPress Button rt randSoa1 randSoa2]; % Resultatvariablen Ergänzen
        
end % Ende der Trialschleife ------------------------------------------------------------------------

%% Speichern der Resultat Matrix 
filename = ['vp' num2str(iVp, '%0.2d') '.mat']; % '%0.2d': mit führender null
save(filename,'resMatrix');

% Feedback an die VP
correctRate = 100*length( find(resMatrix(:,*Index*)==1) )/nTrials;  % Index der respCorrect Spalte ergänzen
meanRT = 1000*mean(resMatrix( find(resMatrix(:,*Index*)==1),8));    % Index der respCorrect Spalte ergänzen

feedbackText = ['Rate korrekter Antworten: ' num2str(correctRate) ' %\nMittlere Reaktionszeit: ' num2str(round(meanRT)) ' ms'];

DrawFormattedText(window, feedbackText, 'center', 'center', [0 0 0]);
Screen('Flip', window);
KbStrokeWait;

% alles schließen
Screen('CloseAll')
