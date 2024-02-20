


function [data_out, index_sample_out,end_file] = read_gr_complex_binary(fileName, index_sample_in, num_samples_block)

number_bytes_per_complex_sample=8;
offset=number_bytes_per_complex_sample*index_sample_in;

%open data file
[fid, message] = fopen(fileName, 'rb');

if ~feof(fid)
    end_file=0;
    %go to defined data block
    fseek(fid, offset , 'bof');
    
    %read defined data block
    [data, count] = fread(fid, [2, num_samples_block], 'float');
    data_out= data(1,:) + data(2,:).*1i; %Inphase and Quadrature
    
    index_sample_out=ftell(fid)/number_bytes_per_complex_sample;

else
    disp('END OF FILE!!');
    end_file=1;
    data_out=zeros(1,num_samples_block);
    index_sample_out=NaN;
    
end;

fclose(fid);