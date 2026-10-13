const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const target=path.resolve(__dirname,'..','index.html');let html=fs.readFileSync(target,'utf8');
const expected=JSON.parse(fs.readFileSync(process.argv[2],'utf8'));
const match=/const EXPECTED = ([^\n]+);/.exec(html);if(!match)throw Error('Expected result source not found');
if(process.argv.includes('--check'))assert.deepEqual(JSON.parse(match[1]),expected);
else fs.writeFileSync(target,html.replace(match[0],()=> 'const EXPECTED = '+JSON.stringify(expected)+';'));
console.log('42 expected results '+(process.argv.includes('--check')?'match their recomputation.':'updated.'));
