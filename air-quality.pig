-- Hacemos la carga del fichero separando por ';' y creamos el schema.
measure = load 'calidad_del_aire_cyl_1997_2013.csv' using PigStorage(';') as (date:chararray, co:float, no:float, no2:float, o3:float, pm10:float, sh2:float, pm25:float, pst:float, so2:float, province:chararray, station:chararray);

--dump measure;
--describe measure;
--explain measure;

-- Filtramos los resultados, la primera línea no nos vale.
filter_measure = filter measure by date != 'DIA';

-- Agrupamos los datos por provincia.
measure_by_province = group filter_measure by province;

-- Recorremos los registros por provincia y calculamos la media de co.
num_measures_by_province = foreach measure_by_province generate group, AVG(filter_measure.co) as measure;

dump num_measures_by_province;

-- Ordenamos de menor a mayor índice de co.
ordered_measures = order num_measures_by_province by measure;

-- Mostramos los resultados ordenados.
dump ordered_measures;

-- Almacenamos la salida en un fichero
store ordered_measures INTO 'measures_by_province.out';



