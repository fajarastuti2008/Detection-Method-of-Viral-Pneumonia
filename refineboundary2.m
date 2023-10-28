function [BW,bw_lung]=refineboundary2(BW)
%%%% perbaikan boundary daerah lung
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% menghitung tinggi dan lebar area lapang paru
[m,n]=size(BW);
bw_lung=zeros(m,n);

[x,y]=find(BW>0);
tinggi_lung = max(x)-min(x);
lebar_lung = max(y)-min(y);
%% menentukan posisi kolom tengah lapang paru
koordinat_tengah = min(y)+round(lebar_lung/2);
%% menentukan posisi baris batas atas lapang paru
koordinat_baris_atas=min(x)+round(tinggi_lung/6);
%% menentukan posisi baris bawah lapang paru
koordinat_baris_bawah=max(x)-round(tinggi_lung/3);
%% mengekstraksi region dalam citra kandidat lapang paru
st=regionprops(BW,'all');
% if length(st)>1 
    %%pisahkan 
    for i=1:length(st)%%hilangkan trachea
        if st(i).Area<500 && st(i).Solidity>0.9
            BW(st(i).PixelIdxList)=0;
        end
    end
    st=regionprops(BW,'all');
    if length(st)>1
        for i=1:length(st)
            BW(st(i).PixelIdxList)=0;
            idx_left=st(i).PixelIdxList;
            left_lung=zeros(m,n);
            left_lung(idx_left) = 1;
            left_lung=imbinarize(left_lung);
            %left_lung=imdilate(left_lung,SE);
            if st(i).Area>5000
                bw=refineEachLung(left_lung,koordinat_tengah,koordinat_baris_atas,koordinat_baris_bawah);
            else
                bw=left_lung;
            end
            idx=find(bw>0);
            bw_lung(idx)=i;
            BW=BW|bw;
        end
    else
        if (~isempty(st))&& st.Area>10000
            SE = strel('diamond',3);
            BW2=BW;
            N=1;
            while(1)
                BW2=imerode(BW2,SE);
                BW2=bwareaopen(BW2,50);
                sttemp=regionprops(BW2);
                N=N+1;
                if length(sttemp)>1
                    break;
                end
            end
                    
            BW2=bwareaopen(BW2,10);
            st2=regionprops(BW2,'all');
            if (~isempty(st2))
                BW(st2(1).PixelIdxList)=0;
                for j=1:length(st2)
                    idx_left=st2(j).PixelIdxList;
                    left_lung=zeros(m,n);
                    left_lung(idx_left) = 1;
                    left_lung=imbinarize(left_lung);
                    for k=1:N-1
                        left_lung=imdilate(left_lung,SE);
                    end
                    bw=refineEachLung(left_lung,koordinat_tengah,koordinat_baris_atas,koordinat_baris_bawah);
                    idx=find(bw>0);
                    bw_lung(idx)=j;
                    BW=BW|bw;
                end
            end
        end
     end
 
