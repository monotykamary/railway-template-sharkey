#!/usr/bin/env python3
import os,requests
b=os.environ['BASE_URL'].rstrip('/');pw=os.environ['ADMIN_PASSWORD'];home=requests.get(b+'/',timeout=30);assert home.status_code==200 and ('Sharkey' in home.text or 'Misskey' in home.text)
meta=requests.post(b+'/api/meta',json={},timeout=30);assert meta.status_code==200 and meta.json().get('requireSetup') is False
login=requests.post(b+'/api/signin-flow',json={'username':'admin','password':pw},timeout=30);assert login.status_code==200 and login.json().get('finished') is True and login.json().get('i');bad=requests.post(b+'/api/signin-flow',json={'username':'admin','password':'wrong-password'},timeout=30);assert bad.status_code in (400,403)
print('Sharkey smoke checks passed')
