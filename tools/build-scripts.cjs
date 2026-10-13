// Single source: execute only the definitions from index.html, without a browser.
const fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');
const root=path.resolve(__dirname,'..');
const html=fs.readFileSync(path.join(root,'index.html'),'utf8');
const scripts=[...html.matchAll(/<script\b[^>]*>([\s\S]*?)<\/script>/g)].map(m=>m[1]);
scripts.forEach((s,i)=>new vm.Script(s,{filename:'inline-'+i+'.js'}));
let src=scripts.at(-1);src=src.slice(0,src.indexOf('/* ---------- inicio ---------- */'))+'globalThis.platform={EX,exFiles,PRACT,MODULES,exModel,erSvg};})();';
const noop=()=>{};
const sandbox={localStorage:{getItem:()=>null},document:{addEventListener:noop},window:{addEventListener:noop},console};
vm.createContext(sandbox);vm.runInContext(src,sandbox);
let count=0;
const checking=process.argv.includes('--check')||require.main!==module;
for(const ex of sandbox.platform.EX){
 const folder=path.join(root,'scripts','ej'+ex.k+'_'+ex.slug);fs.mkdirSync(folder,{recursive:true});
 for(const file of sandbox.platform.exFiles(ex)){
  const target=path.join(folder,file.f);
  if(checking){if(fs.readFileSync(target,'utf8').replace(/\r\n/g,'\n')!==file.text.replace(/\r\n/g,'\n'))throw Error('Out of sync: '+target);}
  else fs.writeFileSync(target,file.text);
  count++;
 }
}
console.log(count+' generated files '+(checking?'match':'updated')+'. JavaScript syntax OK.');
module.exports=sandbox.platform;
