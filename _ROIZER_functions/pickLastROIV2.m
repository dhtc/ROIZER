function [AXE] = pickLastROIV2(ROIZ)
%%

global AXI AXIALL AXALL
AXI = 0;
AXIALL = [];
AXALL = [];


ROS = ROIZ;
ROSn = size(ROS,2);
ROSiter = ceil(ROSn/16);


clear p ax fh1
close all

% Make axes coordinates
r = linspace(.02,.98,5);
c = fliplr(linspace(.02,.98,5)); c(1)=[];
w = .22; h = .22;


% fh1=figure('Position',[20 35 950 800],'MenuBar','none',...
%     'ButtonDownFcn',@(~,~)disp('pick an axis'),'HitTest','off');
% fh1=figure('Position',[20 35 950 800],'MenuBar','none');





%%

% keyboard

%%
%{.
k=0;
for ii = 1:ROSiter

    fh1=figure('Position',[20 35 950 800],'MenuBar','none');

    AXI = 0;
    m=0;
    for a=1:4
    for b=1:4
    k=k+1;
    m=m+1;

        ax{k} = axes('Position',[r(a) c(b) w h],'ButtonDownFcn',@pickaxis,...
        'PickableParts','all','Tag',['A' num2str(k)],'Color','none',...
        'XColor','none','YColor','none',...
        'HitTest','on');



        hG{k} = hggroup('ButtonDownFcn',@pickaxis,'Parent',ax{k},'Tag',['H' num2str(k)]);

        if size(ROS,2) >= k
        p{k} = plot( ROS(:,k),'LineWidth',3,'Parent',hG{k},'HitTest','off','Tag',['P' num2str(k)]); 
        else
        p{k} = plot( ROS(:,end).*0,'LineWidth',3,'Parent',hG{k},'HitTest','off','Tag',['P' num2str(k)]); 
        end

        title(sprintf('ROI-%s',num2str(k)))

    end
    end
    uiwait

    AXIALL = [AXIALL;  AXI+(16*(ii-1))];
    AXALL  = [AXALL;   AXI];


end

%%
%}


AXALL(AXALL==0) = [];

AXE = AXALL;
end



function pickaxis(hObject, eventdata)
global AXI
% disableButtons; pause(.02);
disp('############## CLICK DETECTED ##################')


disp('Previous Set:'); disp(AXI)
fprintf('\nClicked Object: %s\n\n',hObject.Tag);


S = char(hObject.Tag);
T = str2num(S(2:end));
InAXI = AXI == T;



if S(1)=='P'
    OBJ = hObject.Parent.Parent;
elseif S(1)=='H'
    OBJ = hObject.Parent;
elseif  S(1)=='A'
    OBJ = hObject;
else
disp('error')
end    




if ~any(InAXI)
    AXI = [AXI; T];
    OBJ.Color = [.5 .5 .5];
    disp('Added!')
else
    AXI(InAXI) = [];
    OBJ.Color = 'none';
    disp('Removed!')
end







disp('Updated set:'); disp(AXI)
disp('######## ROI SET UPDATED (CLOSE WINDOW WHEN FINISHED) #############')
end


%{
function pickax(hObject, eventdata)
global AXI
% disableButtons; pause(.02);

disp('Picked')


T = str2num(hObject.Tag);

InAXI = AXI == T;



if ~any(InAXI)

    AXI = [AXI; T];

    %hObject.CData(1,1) = 1;
    hObject.Parent.Color = [.5 .5 .5];

else

    AXI(InAXI) = [];

    %hObject.CData(1,1) = 1;
    hObject.Parent.Colormap = parula;

end






%     axdat = gca;
%     disp(axdat)
%     axesdata = axdat.Children;
%     axis off;

end
%}




%{
k=0;
for ii = 1:ROSiter



    % IF THERER ARE MORE THAN 16 ROIS LEFT...
    if ii ~= ROSiter
    
    for a=1:4
    for b=1:4
    k=k+1;

        ax{k} = axes('Position',[r(a) c(b) w h],'ButtonDownFcn',@pickaxis,...
        'PickableParts','all','Tag',['A' num2str(k)],'Color','none',...
        'XColor','none','YColor','none',...
        'HitTest','on');



        hG{k} = hggroup('ButtonDownFcn',@pickaxis,'Parent',ax{k},'Tag',['H' num2str(k)]);

        p{k} = plot( ROIZ(:,k),'LineWidth',3,'Parent',hG{k},'HitTest','off','Tag',['P' num2str(k)]); 

        title(sprintf('ROI-%s',num2str(k)))


    end
    end
    uiwait

    AXIALL = [AXIALL;  AXI+(16*(ii-1))];
    AXALL  = [AXALL;   AXI];
    ROIZ(:,1:16) = [];


    % IF THERER ARE LESS THAN 16 ROIS LEFT...
    else
    ROS = ROIZ;
    ROSn = size(ROS,2);
    ROSiter = ceil(ROSn/16);


    fh1=figure('Position',[20 35 950 800],'MenuBar','none');
    m=0;
    for a=1:4
    for b=1:4
    if m<ROSn
    k=k+1;
    m=m+1;

        ax{m} = axes('Position',[r(a) c(b) w h],'ButtonDownFcn',@pickaxis,...
        'PickableParts','all','Tag',['A' num2str(k)],'Color','none',...
        'XColor','none','YColor','none',...
        'HitTest','on');



        hG{m} = hggroup('ButtonDownFcn',@pickaxis,'Parent',ax{m},'Tag',['H' num2str(k)]);

        p{m} = plot( ROIZ(:,m),'LineWidth',3,'Parent',hG{m},'HitTest','off','Tag',['P' num2str(k)]); 

        title(sprintf('ROI-%s',num2str(k)))

    end
    end
    end
    uiwait

    AXIALL = [AXIALL;  AXI+(16*(ii-1))];
    AXALL  = [AXALL;   AXI];
    %ROIZ(:,1:16) = [];


    end
end

%%
%}

