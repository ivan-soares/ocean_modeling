
function pal = make_pal(fac01,fac02);


k=1:100;

R=sin(k*pi/100 + pi/4).^fac01; R=R(10:70);
R(find(R<0))=0; R=R(:);

B=flipud(R);

G=sin(k*pi/100 + pi/100).^fac02; G=G(10:70);
G(find(G<0))=0; G=G(:);

pal=[R(:) G(:) B(:)];
pal=flipud(pal);