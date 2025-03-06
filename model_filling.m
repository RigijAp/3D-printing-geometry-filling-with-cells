function out = model(alpha, k)

%----------------------------------------------------
%-----------------------parameters-------------------
%----------------------------------------------------
a = 10;

h = 3;
l = 4;
m = 6;

alpha = 3618;

k = 4;


import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('model');

%%%%%%%%%%%%%%%%%%%%%%%%%%-CHANGE!!!!!!!-%%%%%%%%%%%%%%%%%%%%%%%%%%
model.modelPath('E:\MLa\2025_03_stl-stp\'); % CHANGE

model.component.create('comp1', true);

%----------------------------------------------------
%-----------------------geometry---------------------
%----------------------------------------------------

model.component('comp1').geom.create('geom1', 3);
model.component('comp1').geom('geom1').lengthUnit('mm');

model.component('comp1').geom('geom1').selection.create('csel1', 'CumulativeSelection');
model.component('comp1').geom('geom1').selection('csel1').label('singlecell');

%-----------------reading-the-single-cell-topology---------------------------


ind = 1;
for x = 0:a:l*a
    for y = 0:a:m*a
        for z = 0:a:h*a
            model.component('comp1').geom('geom1').create("imp"+ind, 'Import');
            model.component('comp1').geom('geom1').feature("imp"+ind).set('filename', "E:\MLa\2025_03_stl-stp\inp\"+alpha+".stp");
            model.component('comp1').geom('geom1').feature("imp"+ind).set('selresult', true);
           
            model.component('comp1').geom('geom1').create("mov"+ind, 'Move');
            model.component('comp1').geom('geom1').feature("mov"+ind).set('displx', x + a/2);
            model.component('comp1').geom('geom1').feature("mov"+ind).set('disply', y + a/2);
            model.component('comp1').geom('geom1').feature("mov"+ind).set('displz', z + a/2);
            model.component('comp1').geom('geom1').feature("mov"+ind).selection('input').set("imp"+ind);

            model.component('comp1').geom('geom1').feature("mov"+ind).set('contributeto', 'csel1');
           
            ind = ind+1
        end
    end
end 

model.component('comp1').geom('geom1').create('struct', 'Union');
model.component('comp1').geom('geom1').feature('struct').selection('input').named('csel1');
model.component('comp1').geom('geom1').run('struct');

%model.component('comp1').geom('geom1').create('fill_geom', 'Import');
%model.component('comp1').geom('geom1').feature('fill_geom').set('filename', "E:\MLa\2025_02_city_test\inp\"+geom+".stp");
%model.component('comp1').geom('geom1').feature('fill_geom').set('selresult', true);
%model.component('comp1').geom('geom1').feature('fill_geom').set('contributeto', 'csel4');

model.component('comp1').geom('geom1').create('fill_geom', 'Block');
model.component('comp1').geom('geom1').feature('fill_geom').set('size', [l*a m*a h*a]);
model.component('comp1').geom('geom1').feature('fill_geom').set('base', 'corner');
model.component('comp1').geom('geom1').feature('fill_geom').set('pos', [0 0 0]);

model.component('comp1').geom('geom1').create('final_filling', 'Intersection');
model.component('comp1').geom('geom1').feature('final_filling').selection('input').set({'fill_geom' 'struct'});
model.component('comp1').geom('geom1').run('final_filling');

model.component('comp1').geom('geom1').run;

mphsave(model,"E:\MLa\2025_03_stl-stp\test_fil_"+alpha);

model.component('comp1').geom('geom1').export.setType('stlbin');
model.component('comp1').geom('geom1').export('E:\MLa\2025_03_stl-stp\out\geo.stl');

model.component('comp1').geom('geom1').export.setType('step');
model.component('comp1').geom('geom1').export('E:\MLa\2025_03_stl-stp\out\Untitled.step');

mphsave(model,"E:\MLa\2025_03_stl-stp\test_fil_"+alpha);
out = model;

