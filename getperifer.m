function [lungkiriasli,lungkananasli,periferkiri,centralkiri,periferkanan,centralkanan]=getperifer(BW,I,Iasli,label)

CH = bwconvhull(BW);
D1=bwdist(~CH,'euclidean');
d2=D1>0&D1<(0.3*max(max(D1)));
d3=D1>=0.4*max(max(D1));
bwperifer=BW&d2;
bwcentral=BW&d3;
idxkiri=find(label==2);
lungkiri=zeros(size(I,1),size(I,2));
lungkiri(idxkiri)=1;
lungkiri=logical(lungkiri);
lungkiriasli=zeros(size(I,1),size(I,2));
lungkiriasli(idxkiri)=Iasli(idxkiri);
idxkanan=find(label==1);
lungkanan=zeros(size(I,1),size(I,2));
lungkanan(idxkanan)=1;
lungkanan=logical(lungkanan);
lungkananasli=zeros(size(I,1),size(I,2));
lungkananasli(idxkanan)=Iasli(idxkanan);
bwperiferkiri=bwperifer&lungkiri;
bwcentralkiri=bwcentral&lungkiri;
bwperiferkanan=bwperifer&lungkanan;
bwcentralkanan=bwcentral&lungkanan;
BW = imbinarize(I);
%%%%%%%%
imshow(I)
[B,L] = bwboundaries(bwperiferkiri,'noholes');
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end
[B,L] = bwboundaries(bwperiferkanan,'noholes');
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'y', 'LineWidth', 2)
end
%%%%%%%%
idx1=find(bwperiferkiri>0);
periferkiri=zeros(size(I,1),size(I,2));
periferkiri(idx1)=Iasli(idx1);
idx2=find(bwcentralkiri>0);
centralkiri=zeros(size(I,1),size(I,2));
centralkiri(idx2)=Iasli(idx2);
idx3=find(bwperiferkanan>0);
periferkanan=zeros(size(I,1),size(I,2));
periferkanan(idx3)=Iasli(idx3);
idx4=find(bwcentralkanan>0);
centralkanan=zeros(size(I,1),size(I,2));
centralkanan(idx4)=Iasli(idx4);