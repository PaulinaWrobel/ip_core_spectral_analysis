function data = open_file(filename,length)

    fid = fopen(filename);
    data = fread(fid,length,'double');
    fclose(fid);

end

%fileID = fopen('din.txt','w');
%fprintf(fileID,'%d\n',w);
%fclose(fileID);
