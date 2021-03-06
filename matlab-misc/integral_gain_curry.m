function [integral_derivative] = integral_gain_curry(root_dir)
    %handle the proportional gains
    files = {'Trianglerefkd_03.mat','Trianglerefki1.mat',...
                'Trianglerefki2.mat','Trianglerefki3.mat',...
                'Trianglerefki4.mat','Trianglerefki5.mat',...
                'Trianglerefki6.mat'};
    struct_names = {'ki_0','ki_1','ki_2','ki_3','ki_4','ki_5','ki_6'};      
    integral_derivative = struct; %container for all proportional gains
    disp('Processing...')
    for i = 1:length(files)
        file = files{i}; %extract the name
        file = strjoin({root_dir, file},'');
        disp(strjoin({'    ',file}))
        temp = struct;
        names = who('-file',file); %get the variable names from the file
        load(file,'-mat') %get the acutal variables
        for j=1:length(names)
            var_name = names(j); % get the name
            match = regexp(var_name,'Time','match'); %get cell array with rexex match
            if strcmp(match{1,1},'Time')
                time_var_name = var_name; %figure out the time variable name
            else
                match = regexp(var_name,'Value','match');
                if strcmp(match{1,1},'Value')
                    val_var_name = var_name; %figure out the value variable name
                end
            end
        end
        time = eval(char(time_var_name)); %store the time arrays
        signals = eval(char(val_var_name)); % store the signals
        %take out the individual signals
        sys_out = signals(:,1); %actual system response
        reference = signals(:,2); %reference signal
        search_period = 260; % go a little longer than one period
        %we search the very end because this is where the data is good when
        %saved
        [minimum, index] = min(reference(end-search_period+1:end));
        end_index = index+length(reference)-search_period; %adjust to slice parent vector
        [second_min,sec_index] = min(reference(end_index-search_period+1:end_index-10));
        start_index = sec_index+end_index-search_period;
        %update the temp struct
        temp = setfield(temp,'input',reference(start_index:end_index));
        temp = setfield(temp,'sys_out',sys_out(start_index:end_index));
        temp = setfield(temp,'time',time(start_index:end_index,1));
        integral_derivative = setfield(integral_derivative,struct_names{i},temp);
    end
    disp('Saving...')
    out_file = 'Integral_Derivative.mat';
    save(out_file,'integral_derivative','-mat')
    disp(strjoin({'Saved to: ',out_file}))
    return
end
