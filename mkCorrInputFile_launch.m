function [ error ] = mkCorrInputFile_launch(isOMNI,isBz,strSuffix)
%mkCorrInputFile_launch Creates correlation input files from 
% OMNIWeb or GUMICS and Cluster data
%   Read OMNIWeb/GUMICS  data and interpolates. Creates one 
%   minute resolution Cluster data. Read al intervals. 
%
%   isOMNI   : OMNIWeb or GUMICS
%   isBz     : Use B or Bz for correlation calculation
%   strSuffix: Extra string to distinguish the results
%
%   Developed by Gabor Facsko (facsko.gabor@mta.csfk.hu), 2014-2017
%   Geodetic and Geophysical Institute, RCAES, Sopron, Hungary
%----------------------------------------------------------------------
%   
    % Default directories
    root_path='/home/facskog/Projectek/Matlab/ECLAT/';     
    
    % Clear the trash
    strSubDir='OMNI-ClusterSC3-SW/';
    if ((~isOMNI) & (strcmp(strSuffix,'-msh')))
        strSubDir='GUMICS-ClusterSC3-MSH/';
    end; 
    if ((~isOMNI) & (strcmp(strSuffix,'-sw')))
        strSubDir='GUMICS-ClusterSC3-SW/';
    end; 
    if ((~isOMNI) & (strcmp(strSuffix,'-msph')))
        strSubDir='GUMICS-ClusterSC3-MSPH/';
    end; 
    if ((~isOMNI) & ((strcmp(strSuffix,'-bs'))|(strcmp(strSuffix,'-mp'))...
            |(strcmp(strSuffix,'-ns'))))
        strSubDir='GUMICS-ClusterSC3-BS/';
    end; 
    
    % Delete old files
    [status,result]=unix(['rm $(echo ',root_path,'data/',strSubDir,...
        'corr-*',strSuffix,'.dat)']);
    [status,result]=unix(['rm $(echo ',root_path,'images/',strSubDir,...
        'corr-*-gumics',strSuffix,'.eps)']);
    
    % Read SW file    
    fid=fopen ([root_path,'data/cluster_',strSuffix(2:numel(strSuffix)),...
        '.txt'], 'r');
    % Skiping header
	strLine = fgetl(fid);
    tStart=datenum(strLine(1:23),'yyyy-mm-ddTHH:MM:SS.FFF');      
    tEnd=datenum(strLine(26:48),'yyyy-mm-ddTHH:MM:SS.FFF');
    % Temporary Correlation file  
    error=mkCorrInputFile(tStart,tEnd,isOMNI,isBz,strSuffix);
    while ~feof(fid)
        strLine = fgetl(fid)
        tStart=datenum(strLine(1:23),'yyyy-mm-ddTHH:MM:SS.FFF');     
        tEnd=datenum(strLine(26:48),'yyyy-mm-ddTHH:MM:SS.FFF');
        % Temporary Correlation file
        error=mkCorrInputFile(tStart,tEnd,isOMNI,isBz,strSuffix);
	end;
end

