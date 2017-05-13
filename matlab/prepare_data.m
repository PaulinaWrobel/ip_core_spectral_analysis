data_double = open_file(FILENAME,N);
data_double(data_double==-32768)=0;
N = length(data_double);
data_fixed = complex(fi(data_double,NT));

fileID = fopen('../../data/data_in.txt','w');
fprintf(fileID,'%d\n',data_double);
fclose(fileID);