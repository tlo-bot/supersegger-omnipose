function rl_ = watershedpaw( im )

rl = watershed( im );

ss = size( im );

[XX,YY] = meshgrid( -1:1,-1:1 );
xx = -1:1;
yy = -1:1;

rl_ = rl;
for r = 1:ss(1)
    for c = 1:ss(2)
    
        if ~rl(r,c)
            
            xx_ = xx+c;
            yy_ = yy+r;
            
            ll = logical((xx_<1)+(xx_>ss(2))+(yy_<1)+(yy_>ss(1)));
      
            xx_(ll) = c;
            yy_(ll) = r;
            
            im_ = im(yy_,xx_);
            
            [~,ind] = sort( im_(:) ); 
            
            
            rl__ = rl(yy_,xx_);
            rl__ = rl__(:);
            
            ind2 = find( rl__(ind)>0, 1, 'first' );
            
            [r0,c0] = ind2sub( [3,3], ind(ind2) );
            
            
%             imshow( im, [] );
%             hold on;
%             plot( c,r, 'r.' );
%             plot( xx_(c0),yy_(r0), 'g.' );

            
            rl_(r,c) = rl(yy_(r0),xx_(c0));
        end
    end
end


end