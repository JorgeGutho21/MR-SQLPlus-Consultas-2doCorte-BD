"""Exercise SELECTs and constraints with SQLite; does not execute or certify Oracle."""
import json,sqlite3,re,sys
from pathlib import Path
models=json.loads(Path(sys.argv[1]).read_text(encoding='utf8'));expected={};report=[]
def translate(sql):
    sql=re.sub(r'\{S\}\.', '',sql)
    sql=re.sub(r"\bDATE\s+('[^']+')",r'\1',sql)
    sql=sql.replace('SYSDATE',"'2026-10-13'")
    sql=re.sub(r"TO_CHAR\(([^,]+),\s*'YYYY-MM-DD'\)",r'\1',sql,flags=re.I)
    return sql
for e in models:
    db=sqlite3.connect(':memory:');db.execute('PRAGMA foreign_keys=ON')
    for t in e['tables']:
        cols=t['cols']+([t['addCol']] if 'addCol'in t else [])
        definitions=[]
        for c in cols:
            typ='REAL' if c[1].startswith('NUMBER') else 'TEXT'
            default=''
            if 'def:' in c[2]:
                value=c[2].split('def:',1)[1].replace(' nn','')
                default=' DEFAULT '+("'2026-10-13'"if value=='SYSDATE'else value)
            definitions.append(c[0]+' '+typ+(' NOT NULL' if 'nn'in c[2] else '')+default)
        for k in e['pk']:
            if k[1]==t['n']:definitions.append('PRIMARY KEY ('+','.join(k[2])+')')
        for k in e['uq']:
            if k[1]==t['n']:definitions.append('UNIQUE ('+','.join(k[2])+')')
        for k in e['fk']:
            if k[1]==t['n']:definitions.append('FOREIGN KEY ('+','.join(k[2])+') REFERENCES '+k[3]+' ('+','.join(k[4])+')')
        for k in e['ck']:
            if k[1]==t['n']:definitions.append('CHECK ('+k[2]+')')
        db.execute('CREATE TABLE '+t['n']+' ('+','.join(definitions)+')')
    for name in e['loadOrder']:
        t=next(t for t in e['tables']if t['n']==name)
        db.executemany('INSERT INTO '+name+' VALUES ('+','.join('?'for _ in t['rows'][0])+')',t['rows'])
    def render_query(statement):
        cur=db.execute(statement);rows=cur.fetchall();names=[c[0].upper()for c in cur.description]
        def fmt(v):return '' if v is None else str(int(v))if isinstance(v,float)and v.is_integer()else str(v)
        values=[[fmt(v)for v in r]for r in rows];widths=[max(len(n),*(len(r[i])for r in values))if values else len(n)for i,n in enumerate(names)]
        lines=['  '.join(n.ljust(w)for n,w in zip(names,widths)),'  '.join('-'*w for w in widths)]
        lines+=['  '.join(v.ljust(w)for v,w in zip(r,widths)).rstrip()for r in values]
        lines+=['',str(len(rows))+(' row selected.'if len(rows)==1 else ' rows selected.') if rows else 'no rows selected.']
        return '\n'.join(lines),len(rows)
    for q in e['queries']:
        statements=[s for s in translate(q['sql']).split(';')if s.strip()]
        results=[render_query(statement)for statement in statements]
        expected['e'+str(e['k'])+':q-'+q['id']]='\n\n'.join(text for text,_ in results)
        report.append({'query':q['id'],'rows':[count for _,count in results]})
    # Invalid INSERTs must fail because of intended integrity rules, not missing columns.
    failures=0
    for sql in e['tests']['sql'].split(';'):
        if not sql.strip().upper().startswith('INSERT'):continue
        try:db.execute(translate(sql))
        except sqlite3.IntegrityError:failures+=1
        else:raise AssertionError('Invalid row accepted: '+sql)
    assert failures==(4 if e['k']in[2,4] else 3),(e['k'],failures)
    if e['k']==3:
        db.execute('SAVEPOINT demo_defaults')
        db.execute('INSERT INTO pedido (id_pedido,id_cliente) VALUES (5999,6)')
        assert db.execute('SELECT fecha_pedido,estado FROM pedido WHERE id_pedido=5999').fetchone()==('2026-10-13','PENDIENTE')
        db.execute('ROLLBACK TO demo_defaults')
        assert db.execute('SELECT COUNT(*) FROM pedido WHERE id_pedido=5999').fetchone()[0]==0
Path(sys.argv[2]).write_text(json.dumps(expected,ensure_ascii=False),encoding='utf8')
print(json.dumps({'engine':'SQLite (Oracle SELECT syntax adapted)','queries':report,'invalid_inserts_rejected':14},ensure_ascii=False))
