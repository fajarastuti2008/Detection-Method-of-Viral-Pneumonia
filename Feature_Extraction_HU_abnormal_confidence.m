function [RGB,BW_GGO,BW_Konsol,feature]=Feature_Extraction_HU_abnormal_confidence(Igray,lungkiri,lungkanan,periferkiri,centralkiri,periferkanan,centralkanan)
%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Lung Feature Extraction HU
%%% version : 1.2 
%%% tanggal : 26 Juni 2020
%%% program ini digunakan untuk mendapatkan feature GGO dan consolidation
%%% pada area perifer dan central
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%
IR=Igray;
IG=Igray;
IB=Igray;

pixel=find(Igray~=0);
n_pixel=length(pixel);
gray_pixel=Igray(pixel);
lung=lungkiri+lungkanan;

% %% ekstraksi pembuluh pada lapang paru, 
% %% berdasarkan nilai keragaman graylevel image input
stdev=std(double(gray_pixel));  %% standart deviasi daerah lapang paru 
segimg = segment_vessel(Igray,stdev);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ektraksi Fitur GGO dengan HU threshold
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BW=lung>-700&lung<-300&(lung~=0);%%%BW=lung>-750&lung<-300&(lung~=0)
% % %% selisih citra daerah GGO dengan pembuluh pada lapang parun
BWGGO=BW-segimg;
BWGGO=imbinarize(BWGGO);
BWGGO=imfill(BWGGO,'holes');
BWGGO=bwareaopen(BWGGO,100);
IR(find(BWGGO>0))=255;
IG(find(BWGGO>0))=255;
IB(find(BWGGO>0))=0;
BW_GGO=BWGGO;
% figure,imshow(BWGGO);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ektraksi Fitur GGO lung kiri
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Luaslungkiri=length(find(lungkiri~=0));
bw_lungkiri=lungkiri~=0;
BWGGOlungkiri=bw_lungkiri&BWGGO;
LuasGGO=length(find(BWGGOlungkiri>0));
if LuasGGO>0
    GGOlungkiri=1;
else
    GGOlungkiri=0;
end
prosenGGOlungkiri=LuasGGO/Luaslungkiri;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ektraksi Fitur GGO lung kanan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Luaslungkanan=length(find(lungkanan~=0));
bw_lungkanan=lungkanan~=0;
BWGGOlungkanan=bw_lungkanan&BWGGO;
LuasGGO=length(find(BWGGOlungkanan>0));
if LuasGGO>0
    GGOlungkanan=1;
else
    GGOlungkanan=0;
end
prosenGGOlungkanan=LuasGGO/Luaslungkanan;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ektraksi Fitur GGO perifer kiri
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Luasperiferkiri=length(find(periferkiri~=0));
bw_periferkiri=periferkiri~=0;
BWGGOperikiri=bw_periferkiri&BWGGO;
LuasGGO=length(find(BWGGOperikiri>0));
if LuasGGO>0
    GGOperikiri=1;
else
    GGOperikiri=0;
end
prosenGGOperikiri=LuasGGO/Luasperiferkiri;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ektraksi Fitur GGO perifer kanan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Luasperiferkanan=length(find(periferkanan~=0));
bw_periferkanan=periferkanan~=0;
BWGGOperikanan=bw_periferkanan&BWGGO;
LuasGGO=length(find(BWGGOperikanan>0));
if LuasGGO>0
    GGOperikanan=1;
else
    GGOperikanan=0;
end
prosenGGOperikanan=LuasGGO/Luasperiferkanan;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ektraksi Fitur GGO di central kiri
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Luascentralkiri=length(find(centralkiri~=0));
bw_centralkiri=centralkiri~=0;
BWGGOcentralkiri=bw_centralkiri&BWGGO;
LuasGGO=length(find(BWGGOcentralkiri>0));
if LuasGGO>0
    GGOcentralkiri=1;
else
    GGOcentralkiri=0;
end
prosenGGOcentralkiri=LuasGGO/Luascentralkiri;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ektraksi Fitur GGO di central kanan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Luascentralkanan=length(find(centralkanan~=0));
bw_centralkanan=centralkanan~=0;
BWGGOcentralkanan=bw_centralkanan&BWGGO;
LuasGGO=length(find(BWGGOcentralkanan>0));
if LuasGGO>0
    GGOcentralkanan=1;
else
    GGOcentralkanan=0;
end
prosenGGOcentralkanan=LuasGGO/Luascentralkanan;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ektraksi Fitur Konsolidasi 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BW=lung>=-300&lung<50&(lung~=0);%%BW=lung>-300&lung<50&(lung~=0);
%%tambahan / revisi
% BWGGO=BW-segimg;
% BWGGO=imbinarize(BWGGO);
BWGGO=BW;  %%versi image 38?
%%%-------------------
BWGGO=imfill(BWGGO,'holes');
BWGGO=bwareaopen(BWGGO,50);
IR(find(BWGGO>0))=255;
IG(find(BWGGO>0))=0;
IB(find(BWGGO>0))=0;
BW_Konsol=BWGGO;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ektraksi Fitur Konsolidasi di perifer kiri
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BWGGOperikiri=bw_periferkiri&BWGGO;
LuasGGO=length(find(BWGGOperikiri>0));
prosenkonsolperikiri=LuasGGO/Luasperiferkiri;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ektraksi Fitur Konsolidasi di perifer kanan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BWGGOperikanan=bw_periferkanan&BWGGO;
LuasGGO=length(find(BWGGOperikanan>0));
prosenkonsolperikanan=LuasGGO/Luasperiferkanan;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ektraksi Fitur Konsolidasi di central kiri
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BWGGOcentralkiri=bw_centralkiri&BWGGO;
IR(find(BWGGOcentralkiri>0))=Igray(find(BWGGOcentralkiri>0));
IG(find(BWGGOcentralkiri>0))=Igray(find(BWGGOcentralkiri>0));
IB(find(BWGGOcentralkiri>0))=Igray(find(BWGGOcentralkiri>0));
BW_Konsol(find(BWGGOcentralkiri>0))=0;
BWGGOcentralkiri=BWGGOcentralkiri-segimg;
BWGGOcentralkiri=imbinarize(BWGGOcentralkiri);
BWGGOcentralkiri=bwareaopen(BWGGOcentralkiri,50);

LuasGGO=length(find(BWGGOcentralkiri>0));
prosenkonsolcentralkiri=LuasGGO/Luascentralkiri;
IR(find(BWGGOcentralkiri>0))=255;
IG(find(BWGGOcentralkiri>0))=0;
IB(find(BWGGOcentralkiri>0))=0;
BW_Konsol=BW_Konsol|BWGGOcentralkiri;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ektraksi Fitur Konsolidasi di central kanan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BWGGOcentralkanan=bw_centralkanan&BWGGO;
IR(find(BWGGOcentralkanan>0))=Igray(find(BWGGOcentralkanan>0));
IG(find(BWGGOcentralkanan>0))=Igray(find(BWGGOcentralkanan>0));
IB(find(BWGGOcentralkanan>0))=Igray(find(BWGGOcentralkanan>0));
BW_Konsol(find(BWGGOcentralkanan>0))=0;

BWGGOcentralkanan=BWGGOcentralkanan-segimg;
BWGGOcentralkanan=imbinarize(BWGGOcentralkanan);
BWGGOcentralkanan=bwareaopen(BWGGOcentralkanan,50);
LuasGGO=length(find(BWGGOcentralkanan>0));
prosenkonsolcentralkanan=LuasGGO/Luascentralkanan;
IR(find(BWGGOcentralkanan>0))=255;
IG(find(BWGGOcentralkanan>0))=0;
IB(find(BWGGOcentralkanan>0))=0;
BW_Konsol=BW_Konsol|BWGGOcentralkanan;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ektraksi Fitur Konsolidasi lung kiri
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BWkonsollungkiri=BWGGOperikiri|BWGGOcentralkiri;
LuasGGO=length(find(BWkonsollungkiri>0));
prosenkonsollungkiri=LuasGGO/Luaslungkiri;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ektraksi Fitur konsolidasi lung kanan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BWkonsollungkanan=BWGGOperikanan|BWGGOcentralkanan;
LuasGGO=length(find(BWkonsollungkanan>0));
prosenkonsollungkanan=LuasGGO/Luaslungkanan;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Tambahan 25 Juli 2020
%%% Ektraksi Fitur Interlobular septal thickening 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BWThickening=BW&segimg;
% BWThickening=imfill(BWThickening,'holes');
% BWThickening=bwareaopen(BWThickening,50);
% IR(find(BWThickening>0))=0;
% IG(find(BWThickening>0))=255;
% IB(find(BWThickening>0))=0;
% 
RGB=cat(3,IR,IG,IB);
feature=[prosenGGOperikanan,prosenGGOcentralkanan,prosenGGOperikiri, prosenGGOcentralkiri,...
    prosenkonsolperikanan,prosenkonsolcentralkanan,prosenkonsolperikiri,prosenkonsolcentralkiri];



%%%%%%%%%%%%%%%%%%%
%%penentuan level abnormalitas
%%%%%%%%%%%%%%%%%%%
scoreluas=zeros(1,4);
scoretampakan=[1,1,2,2];
luasan=[prosenGGOlungkiri,prosenGGOlungkanan,prosenkonsollungkiri,prosenkonsollungkanan];
i0=find(luasan==0);
i1=find((luasan>0)&(luasan<0.25));
i2=find((luasan>=0.25)&(luasan<0.5));
i3=find((luasan>=0.5)&(luasan<0.75));
i4=find(luasan>=0.75);
scoreluas(i0)=0;
scoreluas(i1)=1;
scoreluas(i2)=2;
scoreluas(i3)=3;
scoreluas(i4)=4;
abnormallevel=sum(scoretampakan.*scoreluas);

%%%%%%%%%%%%%%%%%%%
%%penentuan level confidence
%%%%%%%%%%%%%%%%%%%
scoreluas=zeros(1,8);
scoretampakan=[1,1,1,1,4,4,4,4];
scorelokasi=[3,3,1,1,3,3,1,1];
luasan=[prosenGGOperikiri,prosenGGOperikanan,prosenGGOcentralkiri,prosenGGOcentralkanan,...
    prosenkonsolperikiri,prosenkonsolperikanan,prosenkonsolcentralkiri,prosenkonsolcentralkanan];
i0=find(luasan==0);
i1=find((luasan>0)&(luasan<0.25));
i2=find((luasan>=0.25)&(luasan<0.5));
i3=find((luasan>=0.5)&(luasan<0.75));
i4=find(luasan>=0.75);
scoreluas(i0)=0;
scoreluas(i1)=1;
scoreluas(i2)=2;
scoreluas(i3)=3;
scoreluas(i4)=4;
confidencelevel=sum(scoretampakan.*scorelokasi.*scoreluas)/160;
feature=[feature,abnormallevel,confidencelevel];