function [feature_table] = extractFeatures(dataChTimeTr,includedFeatures, Fs)
    
    % List of channels to include (can change to only use some)
    includedChannels = 1:size(dataChTimeTr,1);
    
    % Empty feature table
    feature_table = table();

    
    for f = 1:length(includedFeatures)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Calcuate feature values for 
        % fvalues should have rows = number of trials
        % usually fvales will have coluns = number of channels (but not if
        % it is some comparison between channels)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Check the name of each feature and hop down to that part of the
        % code ("case" is like... in the case that it is this thing.. do
        % this code)
        switch includedFeatures{f}

            % Variance  
            % variance represents the average squared deviation of the
            % signal from the mean. In this case, the signal is all of the
            % timepoints for a single channel and trial.
            %(fvalues = trials x channels)
            case 'var'
                fvalues = squeeze(var(dataChTimeTr,0,2))';
             
            % Write your own options here by using case 'option name'
            % 'myawesomefeature'
                % my awesome feature code that outputs fvalues
            case 'rms'
                fvalues = squeeze(rms(dataChTimeTr, 2))';

            case 'william'
                fvalues = squeeze(willson(dataChTimeTr, 2))';

            case 'lcov'
                fvalues = squeeze(log(abs(std(dataChTimeTr, 0, 2) ./ mean(dataChTimeTr, 2))))';

            case 'wl'
                fvalues = squeeze(wf(dataChTimeTr))';
            
            case 'iqr'
                fvalues = squeeze(iqr(dataChTimeTr, 2))';

            otherwise
                % If you don't recognize the feature name in the cases
                % above
                disp(strcat('unknown feature: ', includedFeatures{f},', skipping....'))
                break % This breaks out of this round of the for loop, skipping the code below that's in the loop so you don't include this unknown feature
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Put feature values (fvalues) into a table with appropriate names
        % fvalues should have rows = number of trials
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % If there is only one feature, just name it the feature name
        if size(fvalues,2) == 1
            feature_table = [feature_table table(fvalues,...
                'VariableNames',string(strcat(includedFeatures{f})))];
        
        % If the number of features matches the number of included
        % channels, then assume each column is a channel
        elseif size(fvalues,2) == length(includedChannels)
            %Put data into a table with the feature name and channel number
            for  ch = includedChannels
                feature_table = [feature_table table(fvalues(:,ch),...
                    'VariableNames',string(strcat(includedFeatures{f} ,'Ch',num2str(ch))))]; %#ok<AGROW>
            end
        
        
        else
        % Otherwise, loop through each one and give a number name 
            for  v = 1:size(fvalues,2)
                feature_table = [feature_table table(fvalues(:,v),...
                    'VariableNames',string(strcat(includedFeatures{f}, 'val',num2str(v))))]; %#ok<AGROW>
            end
        end
    end


    

end

%% Both were taken from the EMG Feature Extraction Toolbox and changed to fit this data

function WA = willson(X, dim)
    % Parameter
    thres = 700;    % threshold
    N  = size(X, dim); 
    WA = zeros(4, size(X, 3));
    for ch = 1:4
        for l = 1: size(X, 3)
            thisWA = 0;
            for k = 1 : N - 1 
              if abs(X(ch, k, l) - X(ch, k+1, l)) > thres
                thisWA = thisWA + 1; 
              end
            end
            WA(ch, l) = thisWA;
        end
    end
end

function WL = wf(X)
    N  = size(X, 2); 
    WL = zeros(4, size(X, 3));
    for ch = 1:4
        for l = 1:size(X, 3)
            thisWL = 0;
            for k = 2:N
              thisWL = thisWL + (abs(X(ch, k, l) - X(ch, k-1, l))); 
            end
            WL(ch, l) = thisWL;
        end 
    end
end
