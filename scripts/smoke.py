#!/usr/bin/env python3
"""Real local-only note creation and retained note identity across lifecycle."""
import os,json,pathlib,hashlib,secrets,urllib.request,urllib.error
b=os.environ['BASE_URL'].rstrip('/');phase=os.environ['SMOKE_PHASE'];assert phase in ('boot','upgrade','redeploy')
p=pathlib.Path(__file__).with_name('state-'+hashlib.sha256(b.encode()).hexdigest()[:16]+'.json');password=os.environ['ADMIN_PASSWORD']
def api(path,data,expected=(200,)):
 req=urllib.request.Request(b+'/api/'+path,data=json.dumps(data).encode(),headers={'Content-Type':'application/json'})
 try:r=urllib.request.urlopen(req,timeout=60)
 except urllib.error.HTTPError as e:r=e
 with r:status=r.code;raw=r.read()
 assert status in expected,f'{path} status {status}'
 return json.loads(raw) if raw else None
assert api('meta',{}).get('requireSetup') is False
api('signin-flow',{'username':'admin','password':'wrong-'+password},(400,401,403))
login=api('signin-flow',{'username':'admin','password':password});assert login.get('finished') is True and login.get('i'),'admin login failed';token=login['i']
if p.exists():s=json.loads(p.read_text())
else:
 assert phase=='boot','missing boot note state; refusing to recreate'
 marker='railway-persist-'+secrets.token_hex(10)
 note=api('notes/create',{'i':token,'text':marker,'visibility':'home','localOnly':True})['createdNote'];s={'id':note['id'],'text':marker}
 p.write_text(json.dumps(s));p.chmod(0o600)
note=api('notes/show',{'i':token,'noteId':s['id']});assert note['id']==s['id'] and note['text']==s['text'],'durable note missing/changed';assert note.get('localOnly') is True,'test note must not federate'
print(json.dumps({'ok':True,'phase':phase,'stored_local_only_note':True,'negative_login':True,'federation_tested':False}))
