% Experimentalskript 'Number representations' fuer Steuerung psychol.
% Experimente 2020

% Vordefinieren der Inputparameter----------------------------------------
useScreen = 0;  % 0 = genuiner Bildschirm / 1 = externer Bildschirm

nPositions_root = 7; % Anzahl der Miniquadrate horizontal bzw. vertikal
nShowSamePos = 1; % wie oft die Targets an derselben Position gezeigt werden
oddsNogoGo = 1/5; % Approx. Ratio, wie viele nogo trials pro go trial gezeigt werden (=odds für nogo)

% Target Matrix 
big_square_length = 910; % Kantenlänge des Gesamtquadrats in Pixel
puffer_zone = 15; % Mindestabstand der Symbole zum Rand eines Miniquadrats in Pixel
distractor = '#'; %Distraktor Symbol

% Vordefinieren von Text und Hintergrund
bkgrCol = [ 255 255 255 ]; % Hintergrundfarbe

txtCol = [0 0 0]; %Textfarbe Allgemein
txtCol_prime = [0 0 0]; %Textfarbe Prime
txtCol_square = [0 0 0]; % Textfarbe Target/Distraktor

txtSize_intro = 50; %Textgröße Intro
txtSize_description = 40; %Textgröße Introbeschreibung
txtSize_prime = 60; %Textgröße Primestimulus & Fixationskreuz
txtSize_square = 42; % Textgröße Target/Distraktor

introText = 'Herzlich willkommen zu unserem Experiment!'; 
instructions = 'Im folgenden Experiment wollen wir Ihre Reaktionsgeschwindigkeit bei einer visuellen Suchaufgabe messen. \n \n Hierzu wird Ihnen zuerst ein Fixationskreuz präsentiert, gefolgt von dem Zahlenwort "Eins" oder "Neun". \n Nachdem ein weiteres Fixationskreuz präsentiert wird, erscheinen mehrere Rauten-Symbole (#) gleichzeitig über dem \n Bildschirm verteilt. Unter den Rauten-Symbolen kann sich in einigen Durchgängen zusätzlich \n das zuvor gezeigte Zahlenwort in numerischer Form (1 vs. 9) befinden. \n \n Ihre Aufgabe ist es, so schnell wie möglich mit der Leertaste zu reagieren, falls sich das Zahlenwort unter den Rauten befindet. \n Falls dies nicht der Fall ist, ist keine Reaktion erforderlich. \n \n Solange ein Fixationskreuz dargeboten ist bitten wir Sie, Ihren Blick auf die Mitte des Bildschirms gerichtet zu lassen. \n \n \n Drücken Sie bitte eine beliebige Taste um mit dem Experiment zu beginnen.';

% Tastenreaktion, Darbietungsdauer, SOA etc.
respKey = KbName('Space'); % Reaktion auf Go-trials mit Leertaste
soa = 0.5:0.001:0.8;  % Soa innerhalb des Trials: Vektor von 500-800 ms in 1ms Schritten    
primeDur = 1; % Darbeitungszeit für den Prime in Sekunden
respTime =  3; % Maximale Response Time bevor es zum nächsten Trial weiter geht in Sekunden


%% Berechnen der Grundvariablen aus Inputparametern----------------------------------------

nPrimes = 2; % Anzahl Primes; 1 und 9
nPos = nPositions_root^2; %Gesamtanzahl der Miniquadrate d.h. Positionen

%Trialanzahl
nGoTrialsPerPrime = (nPos)*nShowSamePos;
nGoTrials = nGoTrialsPerPrime*nPrimes; % Anzahl trials, in denen ein target gezeigt wird

nNogoTrialsPerPrime = round((nGoTrials*oddsNogoGo)/nPrimes);
nNogoTrials = nNogoTrialsPerPrime*nPrimes; % Anzahl trials, in denen kein target gezeigt wird

nTrials = nGoTrials + nNogoTrials;% Anzahl trials insg.

%% Erstellung Trial-Matrix und Randomisierung 

    % Bestimmung der Targets per Prime:
goTrialTargMat1 = ones(1, nGoTrialsPerPrime);
goTrialTargMat9 = 9*ones(1, nGoTrialsPerPrime);

    % Bestimmung der Targetpositionen per Prime:
goTrialPosMat1 = repmat(1:nPos, 1, nShowSamePos);
goTrialPosMat9 = repmat(1:nPos, 1, nShowSamePos);

    % Randomisierung der Targetpositionen per Prime:
goTrialPosMat1_rand = goTrialPosMat1(randperm(nGoTrialsPerPrime));
goTrialPosMat9_rand = goTrialPosMat9(randperm(nGoTrialsPerPrime));

    % Erstellen nogo-trials:
nogoTrialMat = zeros(2, nNogoTrials);
goTrialMat  = ones(2, nGoTrials);
nogoTrialMat(1,:) = [ones(1, nNogoTrialsPerPrime), 9*ones(1, nNogoTrialsPerPrime)];

% Erstellen der Gesamtmatrix:

    % Zusammenführen der Targets für go-trials(1. Zeile der Matrix):
goTrialMat(1,:) = [goTrialTargMat1, goTrialTargMat9];

    % Zusammenführen der Targetpositionen für go-trials(2. Zeile der Matrix):
goTrialMat(2,:) = [goTrialPosMat1_rand, goTrialPosMat9_rand];

    % gemeinsame Matrix für alle trials (go + nogo und zugehörige primes):
allTrialMat = [goTrialMat, nogoTrialMat]; % 1. Zeile target, 2. Zeile target position (0 für nogo-trial)

    % Randomisierung der conditions (go vs nogo):
randAllTrialMat = allTrialMat(:, randperm(nTrials)); % erste Spalte = target(1 vs 9), Spalte = Position des Targets (1-49)

%% ResultMatrix vorbereiten + VP NR
NResVar = 13; % Anzahl Resultatvariablen
resMatrix = zeros(nTrials, NResVar);

iVp = input('Versuchspersonennummer: ');

%% PsychToolbox initiieren & Instruktionen  --------------------------------------------------------------------------------------------------------
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','ConserveVRAM',64);
[window, windowSize]=Screen('OpenWindow', useScreen, bkgrCol);
flip_int = Screen('GetFlipInterval', window); % optimieren des timings
HideCursor; % Mauszeiger verstecken


%%% Textausgabe Intro & Instruktionen
yInt = windowSize(4)/2 - (windowSize(4)/4); %Position Introtext
yIns = windowSize(4)/2 - (windowSize(4)/6); %Position Instruktionen

Screen('TextSize', window, txtSize_intro ); % Intro Ueberschrift
Screen('TextFont', window, 'Arial');
DrawFormattedText(window, introText, 'center', yInt, txtCol);

Screen('TextSize', window, txtSize_description ); % Instruktionen
DrawFormattedText(window, instructions, 'center', yIns, txtCol);
Screen('Flip', window);

KbStrokeWait;


%% Experiment--------------------------------------------------------------
for i = 1:3 % nTrials einfügen
    visonset = GetSecs;  % Zeitmarker für Beginn des trials
    %% Pre-Target
    % Fixationskreuz 1
    Screen('TextSize', window, txtSize_prime);
    DrawFormattedText(window, '+', 'center', 'center', [0 0 0]);
    Screen('Flip', window);

    
    % Prime-Bestimmung
    if randAllTrialMat(1,i) == 1
        primeWord = 'eins';
    elseif randAllTrialMat(1,i) == 9
        primeWord = 'neun';
    else % in nogo trials zufaelligen prime bestimmen
        primeWordArray = {'eins' 'neun'};
        primeWordIndex = randi(2);
        primeWord = primeWordArray{primeWordIndex};
    end
    
    %  Prime-Ausgabe
    Screen('TextSize', window, txtSize_prime);
    Screen('TextFont', window, 'Arial');
    DrawFormattedText(window, primeWord, 'center', 'center', txtCol_prime);
    
    randSoa1 = soa(randi([1,length(soa)])); % zufälliges Element aus SOA Vector auswaehlen(500-800ms)

    primeVisonset = Screen('Flip',window, visonset + randSoa1 - flip_int/2);
    
    %  Fixationskreuz 2
    Screen('TextSize', window, txtSize_prime);
    DrawFormattedText(window, '+', 'center', 'center', [0 0 0]);
    primeVisoffset = Screen('Flip', window, primeVisonset + primeDur - flip_int/2);      
    
    %% Targetausgabe
    Screen('TextSize', window, txtSize_square);
    Screen('TextFont', window, 'Arial');

    square_length = big_square_length / nPositions_root; % Kantenlänge eines Miniquadrats
    
    % Bestimme Bildschirmmitte
    x_center = windowSize(3) / 2;
    y_center = windowSize(4) / 2;

    % Setze Startposition auf Mitte vom ersten Miniquadrat obere linke Ecke
    x_start = x_center - (((nPositions_root/2)-0.5) * square_length);
    y_start = y_center - (((nPositions_root/2)-0.5) * square_length);

    x = x_start;
    y = y_start;
    
    % Auslesen der aktuellen Targetposition und des Targettext aus der randomisierten Matrix
    targetPosition = randAllTrialMat(2,i);
    targetText = int2str(randAllTrialMat(1,i));
    
    % Schleife, die durch alle Miniquadrate geht
    for iPosition = 1: nPos

    % An richtiger Position Target, sonst Distraktor bereithalten
      if iPosition == targetPosition
        positionText = targetText;
      else
        positionText = distractor;
      end

      % Jitter um die Position innerhalb des Miniquadrats generieren mit definiertem Abstand zum Rand
      x_jitter = x - (square_length / 2) + randi([puffer_zone, round(square_length-puffer_zone)]);
      y_jitter = y - (square_length / 2) + randi([puffer_zone, round(square_length-puffer_zone)]);
      
      % Zeichnen des Target/Distraktor
      DrawFormattedText(window, positionText, x_jitter, y_jitter, txtCol_square);

      % Positionsberechnung der Mitte des nächsten Miniquadrats. 
      % Nach jeder vollen Zeile wird die nächste Zeile gezeichnet.
      if mod(iPosition,nPositions_root) == 0
        x = x_start;
        y = y + square_length;
      else
        x = x + square_length;
      end
    end
   
    randSoa2 = soa(randi([1,length(soa)])); % Randomisierter Zeitintervall (500-800 ms)

    targetVisonset = Screen('Flip',window, primeVisoffset + randSoa2 - flip_int/2);             
    
    % Warten auf Reaktion der VP ------------------------------------
    ButtonPress=0;
    
    while ( ButtonPress == 0 ) && (GetSecs - targetVisonset) < respTime  % solange kein Button gedrückt und Zeit nicht abgelaufen
        [keyIsDown, rsecs, keyCode] = KbCheck;  % Zustand der Tastatur abfragen
        ButtonPress =  keyIsDown;
        WaitSecs(.001); % um System zu entlasten
    end
    
    if ButtonPress == 1
        visoffset = GetSecs; % zur Bestimmung der Gesamtdauer des Experiments
        usedButton = find(keyCode);
        rt = rsecs - targetVisonset; % Reaktionszeit
        if randAllTrialMat(2, i) ~= 0 && usedButton == respKey % falls Go Trial & Space gedrückt
            resCorrect = 1;  % 1 = richtige Antwort, 0 = falsche Antwort
            GoTrial = 1;  % 1 = Go-Trial, 0 = No-Go Trial
        elseif randAllTrialMat(2, i) ~= 0 && usedButton ~= respKey % falls Go Trial & NICHT Space gedrückt
            resCorrect = 0;
            GoTrial = 1;
        elseif randAllTrialMat(2, i) == 0  % falls NoGo Trial & irgendeine Taste gedrückt
            resCorrect = 0;
            GoTrial = 0;
        end
        
    elseif ButtonPress == 0 && randAllTrialMat(2, i) == 0 % falls keine taste gedrückt & NoGo Trial
        visoffset = GetSecs;
        usedButton = -99;
        rt = 0;
        resCorrect = 1;
        GoTrial = 0;
        
    else % wenn keine taste gedrückt & Go Trial
        visoffset = GetSecs;
        usedButton = -99;
        rt = 0;
        resCorrect = 0;
        GoTrial = 1;
    end
    
    
    % Befüllen der Spalten der Ergebnismatrix
    resMatrix(i,1:NResVar) = [iVp i randSoa1 randSoa2 randAllTrialMat(1, i) randAllTrialMat(2, i) GoTrial resCorrect rt visonset visoffset ButtonPress usedButton];
        
end % Ende der Trialschleife ------------------------------------------------------------------------

%% Speichern der Resultat Matrix 
filename = ['vp' num2str(iVp, '%0.2d') '.mat']; % '%0.2d': mit führender null
save(filename,'resMatrix');

dlmwrite(filename, sprintf('vp \t trial \t fixDur1 \t fixDur2 \t targetStim \t Position \t GoTrial \t resCorrect \t RT \t trialBegin \t trialEnde \t buttonPress \t buttonUsed '),'delimiter','\t')
dlmwrite(filename, resMatrix, '-append', 'precision',6,'delimiter','\t')

%% Feedback an die VP
correctRate = 100*length( find(resMatrix(:,8)==1) )/nTrials;  % Index der respCorrect Spalte ergänzen
meanRT = 1000*mean(resMatrix( find(resMatrix(:,8)==1),9));    % Index der respCorrect Spalte ergänzen

feedbackText = ['Rate korrekter Antworten: ' num2str(correctRate) ' \nMittlere Reaktionszeit: ' num2str(round(meanRT)) ' ms.\nDrücken Sie die Leertaste um das Experiment zu schließen.'];
Screen('TextSize', window, txtSize_intro ); 
Screen('TextFont', window, 'Arial');
DrawFormattedText(window, feedbackText, 'center', 'center', [0 0 0]);
Screen('Flip', window);
KbStrokeWait;

%% alles schließen
Screen('CloseAll')
