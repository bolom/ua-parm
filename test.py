import pykew.powo as powo
from pykew.powo_terms import Name, Filters

res = powo.lookup('urn:lsid:ipni.org:names:320035-2', include=['distribution'])
native_to = [d['name'] for d in res['distribution']['natives']]
print(res)
