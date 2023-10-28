function [V2] = getRespiratoryOrgansSlice(I,cr,ci)
%{

% Fungsi untuk mendapatkan volume respiratory organs (lung dan airway volume)
% tanpa memisahkan bagian kanan dan kiri lung .

% V = Volume image dengan radiodensity data dalam Hounsfield (HU) units.
% cr = radius vessels untuk morphological closing.
% ci = jumlah iterasi morphological closing.

%}
%% parameter default
if (nargin < 2)
    cr=3;
end
if (nargin < 3)
    ci=2;
end

V=double(I);
[nx, ny] = size(V);
AL=~imbinarize(V,-300);  %% respiratory organ threshold
SE=strel('sphere',3);
EAL=imerode(AL,SE);

%%%% get external air
VL=bwlabeln(EAL);
R=regionprops(VL,'BoundingBox','PixelIdxList');
EA=logical(zeros(nx,ny));
for i=1:length(R)
    x0=R(i).BoundingBox(1);
    y0=R(i).BoundingBox(2);
    x1=x0+R(i).BoundingBox(3);
    y1=y0+R(i).BoundingBox(4);
    if (x0 < 1 || x1 > nx-1 || y0 < 1 || y1 > ny-1)
        mat=R(i).PixelIdxList;
        EA(mat)=1;
    end
end
%%%%%

DEA=EA;
for i=1:4
    DEA=imdilate(DEA,SE);
    DEA=DEA & AL;
end
IAL=AL-DEA;
IAL=bwareaopen(IAL,10);
se = strel('disk',2);
IAL=imdilate(IAL,se);

%%% get Max Object in Area ;
VIAL=bwlabeln(IAL,8);
R=regionprops(VIAL,'all');
RO=logical(zeros(nx,ny));
for i=1:length(R)
    if R(i).Area>2000 & R(i).Eccentricity<0.92 %%& R(i).Solidity<0.85
        idx=R(i).PixelIdxList;
        RO(idx)=1;
    end
end

%%%morphological closing 
V2=RO;
for i=1:ci
    V2=imdilate(V2,SE);
end
for i=1:ci
    V2=imerode(V2,SE);
end
V2=imerode(V2,SE); %%ditambah satu untuk mengurangi boundary yg terambil
