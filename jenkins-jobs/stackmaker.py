import keystoneclient.v2_0.client as ksclient
from heatclient.v1.stacks import StackManager
from heatclient.client import Client as hclient
from novaclient.client import Client as nclient
import json

def get_token_tid(ksh, tname, user, passwd):
    keystone = ksclient.Client(auth_url=ksh, username=user, password=passwd, tenant_name=tname)

    return  keystone.auth_token, keystone.tenant_id

def get_heat_client(hhost, tok, tid):
    heat_url = "{}/{}".format(hhost, tid)
    heat = hclient('1', endpoint=heat_url, token=tok)
    return heat

def create_stack(heat, stack_str_id):
    # first get template
    json_content  = open('devstack4.json', 'r').read().rstrip()
    template_str = json.loads(json_content )['template']

    # get stack manager and create stack
    heat_stack_mgr = StackManager(heat.http_client)
    result = heat_stack_mgr.create(stack_name=stack_str_id, template=template_str)
    return result['stack']['id']

def wait_for_active(timeout, stack_id, heat):
    hsm = StackManager(heat.http_client)
    status = hsm.get(stack_id)
    elapsed = 0
    while(status != 'CREATE_COMPLETE' and elapsed < timeout):
        time.sleep(30)
        elapsed += 30
        status = hsm.get(stack_id)
    
    if status != 'CREATE_COMPLETE':
         return None

    return status

if __name__ == '__main__':
    ksh = "http://10.135.126.20:5000/v2.0"
    tname = "demo"
    user = "admin"
    passwd = "cloud"
    heath = "http://10.135.126.20:8004/v1"

    tok,tid = get_token_tid(ksh, tname, user, passwd)
    heat = get_heat_client(heath,tok,tid)
    hsm = StackManager(heat.http_client)
    
    stack_human_id = "stack257"
    stack_id = create_stack(heat, stack_human_id) # stack_str,  
    wait_for_active(300, stack_id, heat)
