import hashlib

#def get_cz_user_hash(a_list):
#  return ['"%s"' % an_element for an_element in a_list]
#
def get_cz_user_hash (a_list):
  string = "%s%s%s" % (a_list[0], a_list[1], a_list[2])
  return hashlib.sha1(string).hexdigest()

class FilterModule(object):
  def filters(self):
    return {'get_cz_user_hash': get_cz_user_hash}
