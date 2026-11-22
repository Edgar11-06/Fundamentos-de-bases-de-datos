#!/usr/bin/env python3
"""Validador reproducible de la Tarea 5.2 (biblioteca).
Usa únicamente biblioteca estándar; NO requiere SQL Server ni red.
IMPORTANTE: las tablas creadas en SQLite son una simulación de prueba,
NO sustituyen las restricciones ni tipos T-SQL de normalized_schema.sql.
"""
from pathlib import Path
import re,csv,sqlite3,json,sys
root=Path(__file__).resolve().parent.parent
raw=(root/'insumos'/'ejemplos_datos_normalizados.sql').read_text(encoding='utf-8')
expected=json.loads((root/'validacion'/'resultados_simulador.json').read_text(encoding='utf-8'))
conn=sqlite3.connect(':memory:')
pattern=re.compile(r'INSERT\s+INTO\s+dbo\.(\w+)\s*\((.*?)\)\s*VALUES\s*(.*?);',re.I|re.S)
counts={}
for m in pattern.finditer(raw):
    name,columns,raw_rows=m.groups()
    cols=[s.strip() for s in columns.split(',')]
    conn.execute('CREATE TABLE '+name+' ('+', '.join('"'+c+'" TEXT' for c in cols)+')')
    values=[]
    for b in re.findall(r'\(([^()]*)\)',raw_rows):
        cells=next(csv.reader([b],delimiter=',',quotechar="'",skipinitialspace=True))
        row=[None if x.strip().upper()=='NULL' else x.strip() for x in cells]
        if len(row)!=len(cols):raise ValueError(name)
        values.append(row)
    conn.executemany('INSERT INTO '+name+' VALUES ('+','.join(['?']*len(cols))+')',values)
    counts[name]=len(values)
assert counts==expected['tables'],('Table fixture counts have changed',counts)
checks=0
for query in expected['consultas']:
    for stage in query['stages']:
        cur=conn.execute(stage['sql'])
        observed=[list(row) for row in cur.fetchall()]
        if observed != stage['rows']:
            print('FAIL',query['id'],stage['label'],'expected:',stage['rows'],'observed:',observed)
            sys.exit(1)
        checks+=1
    print(f"OK {query['id']}: {query['title']} ({query['stages'][-1]['n']} filas finales)")
print(f"VALIDACIÓN CORRECTA: {len(expected['consultas'])} consultas, {checks} relaciones intermedias, {len(counts)} tablas.")
