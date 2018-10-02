% Need to make this a multi-state function
% Currently only supports 2-state machine interactions?
%
% INPUTS:
%
% m1 - machine type 1 (Ta in the composition equation)
% m2 - machine type 2 (Tb in the composition equation)
% lookup - transition decoding table
% types - list of all current machine types in the population
% mode - 0 (maximise interactions), 1 (strict - if any states are
% unreachable Tc is invalid)
%
% OUTPUTS:
%
% Tc - the new machine type

function [Tc,index] = composeMachinesRevised(m1,m2,lookup,types,mode)

index = 0;

if isempty(m1{:}) || isempty(m2{:})
    keyboard
end

% Functional composition of m1,m2
% m1 is Tb, m2 is Ta (m2's output transformed by m1)
[Tc,index] = performCompositionRevised(m1,m2,lookup,types);

if ~isempty(Tc)
    [connected,str_bins] = checkStronglyConnected(Tc);

    if connected == 0
        % Machine isn't strongly connected but there may be sub-structures that
        % are (str_bins gives us this information)
        Tc = pruneTc(m1,m2,Tc,str_bins);
        index = findList(Tc,types);
    end

    if ~isempty(Tc) && index == 0
    
    %if mode == 0
    % Remove unreachable states
    %[reachable,unreachable] = findUnreachableStates(Tc);
    %for r=1:length(unreachable)
    %    [R] = find(Tc(:,1)==unreachable(r));
    %    if ~isempty(R)
    %        Tc(R,:)=[];
    %    end
    %    [S] = find(Tc(:,3)==unreachable(r));
    %    if ~isempty(S)
    %        Tc(S,:)=[];
    %    end
    %end
    %end
    
    %if ~isempty(Tc)
        Tc = reLabel(Tc);
        index = findList(Tc,types);
    
        if index == 0
            % Minimise the machine
            [index,Tc] = minList(Tc,types);
        end
    end
end
end