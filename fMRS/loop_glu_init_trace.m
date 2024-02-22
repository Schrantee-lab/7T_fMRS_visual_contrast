maindir=''

cd(maindir)

subjects=dir(fullfile(maindir,'0*'));

for i=1:length(subjects)

 % load data 
    filename=fullfile(maindir,subjects(i).name,'output_mixed/init_results.csv')
    glu_trace=extract_glu_init_trace(filename);
    movmean_indiv(i,:)=movmean(glu_trace{2:end,:},32);
    glu_trace_all(i,:) = glu_trace{2:end, :};
    
end 

mean_glu=mean(glu_trace_all',2); 
output=movmean(mean_glu,32);
csvwrite('movav_trace.csv',output)

