const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const root=path.resolve(__dirname,'..');process.argv.push('--check');
const {EX,exFiles,MODULES}=require('./build-scripts.cjs');
let rows=0;
for(const e of EX){
 assert.equal(e.tables.length,e.k===4?3:4);
 const tables=Object.fromEntries(e.tables.map(t=>[t.n,t]));
 for(const t of e.tables){
  const cols=t.cols.concat(t.addCol?[t.addCol]:[]);const names=cols.map(c=>c[0]);assert.equal(new Set(names).size,names.length);
  for(const r of t.rows){assert.equal(r.length,cols.length,e.k+' '+t.n+' row width');rows++;cols.forEach((c,i)=>{
   if(/\bnn\b/.test(c[2]))assert.notEqual(r[i],null,c[0]);
   const len=/^(?:VARCHAR2|CHAR)\((\d+)/.exec(c[1]);if(len&&r[i]!==null)assert.ok(String(r[i]).length<=+len[1],c[0]+' length');
   if(c[1].startsWith('NUMBER')&&r[i]!==null)assert.equal(typeof r[i],'number',c[0]);
  });}
 }
 for(const [kind,keys] of [['PK',e.pk],['UQ',e.uq]])for(const k of keys){const t=tables[k[1]],idx=k[2].map(c=>t.cols.findIndex(x=>x[0]===c));assert.ok(idx.every(i=>i>=0));const seen=new Set();for(const r of t.rows){const values=idx.map(i=>r[i]);if(kind==='PK')assert.ok(values.every(v=>v!==null));if(values.some(v=>v===null))continue;const v=JSON.stringify(values);assert.ok(!seen.has(v),k[0]);seen.add(v);}}
 for(const f of e.fk){const child=tables[f[1]],parent=tables[f[3]],ci=f[2].map(c=>child.cols.findIndex(x=>x[0]===c)),pi=f[4].map(c=>parent.cols.findIndex(x=>x[0]===c));assert.ok(ci.every(i=>i>=0)&&pi.every(i=>i>=0));for(const r of child.rows){const val=ci.map(i=>r[i]);if(val.some(v=>v===null))continue;assert.ok(parent.rows.some(p=>JSON.stringify(pi.map(i=>p[i]))===JSON.stringify(val)),f[0]);}}
 const files=exFiles(e);for(const file of files.filter(f=>f.f.endsWith('.sql'))){
  assert.ok(!/\b(?:pais_origen|color|nombre|apellido)\b/i.test(file.text.replace(/^--.*$/gm,'')),'Removed column in '+file.f);
  for(const hit of file.text.matchAll(/INSERT INTO \w+\.(\w+)\s*\(([^)]+)\)/gi)){const t=tables[hit[1].toUpperCase()];assert.ok(t,'Unknown table '+hit[1]);const allowed=t.cols.map(c=>c[0]).concat(t.addCol?[t.addCol[0]]:[]);assert.ok(hit[2].split(',').every(c=>allowed.includes(c.trim().toLowerCase())),file.f+' INSERT columns');}
  assert.ok(!/IDENTIFIED BY\s+"?(?!&|CLAVE)[A-Za-z0-9]{5}/i.test(file.text),'Password literal');
 }
 const full=files.find(f=>f.f.includes('_00_')).text;
 assert.ok(full.indexOf('CREATE TABLESPACE')<full.indexOf('CREATE USER'));
 assert.ok(full.indexOf('PRIMARY KEY')<full.indexOf('FOREIGN KEY'));
 assert.ok(full.indexOf('FOREIGN KEY')<full.indexOf('INSERT INTO'));
}
assert.equal(MODULES.length,39);
if(process.argv[2]&&process.argv[2]!=='--check')fs.writeFileSync(process.argv[2],JSON.stringify(EX));
console.log('PASS: 4 models, '+rows+' rows, PK/UQ/FK, domains, INSERT columns, academic order, password scan, 39 modules.');
