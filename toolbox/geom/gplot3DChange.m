function [Xout,Yout]=gplot3DChange(graphA,lc, varargin)
%GPLOT Plot graph, as in "graph theory".
%   GPLOT(A,xyz) plots the graph specified by A and xyz. A graph, G, is
%   a set of nodes numbered from 1 to n, and a set of connections, or
%   edges, between them.  
%
%   In order to plot G, two matrices are needed. The adjacency matrix,
%   A, has a(i,j) nonzero if and only if node i is connected to node
%   j.  The coordinates array, xyz, is an n-by-2 or n-by-3 matrix with the
%   position for node i in the i-th row, xyz(i,:,:) = [x(i) y(i) z(i)].
%   
%   GPLOT(A,xyz,LineSpec) uses line type and color specified in the
%   string LineSpec. See PLOT for possibilities.
%
%   [X,Y] = GPLOT(A,xyz) returns the NaN-punctuated vectors
%   X and Y without actually generating a plot. These vectors
%   can be used to generate the plot at a later time if desired.
%   
%   See also SPY, TREEPLOT.

%   John Gilbert, 1991.
%   Modified 1-21-91, LS; 2-28-92, 6-16-92 CBM.
%   Copyright 1984-2002 The MathWorks, Inc. 
%   $Revision: 5.12 $  $Date: 2002/04/15 04:13:43 $
%   Revised by G. De Marco, 2006
%   Revised by M. Catherall, 2006
A = graphA.conn;
[i,j] = find(A);
xyz = [graphA.coor(:,1) graphA.coor(:,2) graphA.coor(:,3)];
Radi = graphA.radi;

minR = min( Radi); maxR = max(Radi);

% [ignore, p] = sort(max(i,j));
% i = i(p);
% j = j(p);

% Create a long, NaN-separated list of line segments,
% rather than individual segments.

if size(xyz,2)<3, xyz(:,3) = 0; end
X = [ xyz(i,1) xyz(j,1) repmat(NaN,size(i))]';
Y = [ xyz(i,2) xyz(j,2) repmat(NaN,size(i))]';
Z = [ xyz(i,3) xyz(j,3) repmat(NaN,size(i))]';
% indX = X~=0; indY = Y~=0;   indZ = Z~=0;
Rxyz = [Radi(i), Radi(j), repmat(NaN,size(i))]';

Rxyz = Rxyz(:);
X = X(:);
Y = Y(:);
Z = Z(:);
% Create the line properties string
% figure; 
% hold on
map = colormap(jet(128));
% map = colormap(parula(128));
if nargout==0,
    if nargin<3
        for Indi = 1:length(X)-1
            if ~isnan(Rxyz(Indi)) 
                indx = map2index(Rxyz(Indi), minR, maxR );
                plot3([X(Indi), X(Indi+1)], [Y(Indi), Y(Indi+1)], [Z(Indi), Z(Indi+1)], 'color', map(indx, :), 'LineWidth',1);
%                 if Rxyz(Indi)>0  plot3([X(Indi), X(Indi+1)], [Y(Indi), Y(Indi+1)], [Z(Indi), Z(Indi+1)], 'g-', 'LineWidth',2); end
%                 if Rxyz(Indi)<=0  plot3([X(Indi), X(Indi+1)], [Y(Indi), Y(Indi+1)], [Z(Indi), Z(Indi+1)], 'b-', 'LineWidth',2); end
            end
        end
        view(3), axis equal; hold off, box on;
    else
        h=plot3(X, Y, Z, lc);
        view(3), axis equal;  box on;
    end
else
    Xout = X;
    Yout = Y;
end

% if nargout==0,
%     if nargin<3
%         h=plot3(X, Y, Z);
%     else
%         h=plot3(X, Y, Z, lc);
%     end
%     view(2), box on
% else
%     Xout = X;
%     Yout = Y;
% end

if nargin>2
    for k=1:nargin-3
        s=varargin{k};
    try
        if isnumeric(varargin{k+1})

      set(h,s,varargin{k+1});
        else
      set(h,s);
        end
    catch
    end
    
    end
end
end

function index = map2index(radius, minR, maxR )
%     flag1 = -1;  flag2 = 1;
    flag1 = -0.8;  flag2 = 0.8;
    if radius < flag1
%         index = floor((radius-minR)/(flag1-minR)*59 +1 );
        index = 10;
    elseif radius >=flag1 && radius < flag2
%         index = floor( (radius - flag1)/2 *9 + 60 );
        index = 64;
    elseif radius >= flag2
%         index = floor( (radius - flag2)/(maxR - flag2) * 58 + 70);
        index = 110;
    end
end
        
