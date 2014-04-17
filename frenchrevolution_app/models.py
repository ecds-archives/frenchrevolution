import re
import datetime

from django.utils.safestring import mark_safe

from eulexistdb.manager import Manager
from eulexistdb.models import XmlModel
from eulxml.xmlmap.core import XmlObject 
from eulxml.xmlmap.dc import DublinCore
from eulxml.xmlmap.fields import StringField, NodeField, StringListField, NodeListField, Field
from eulxml.xmlmap.teimap import Tei, TeiDiv, _TeiBase, TEI_NAMESPACE, xmlmap, TeiInterpGroup, TeiInterp


'''
declare namespace xml=\'http://www.w3.org/XML/1998/namespace\';
\n
declare namespace tei=\'http://www.tei-c.org/ns/1.0\';
\n
collection("/db/fr_django/")
'''

class Fields(XmlObject):
    id = StringField('@id')
    figure = StringField('figure')
    author = StringField('author')
    date = StringField('date')
    title = StringField('title') 

class Pamphlet(XmlObject):
    pamphlets = NodeListField('//pamphlet', Fields)
    

class Text(XmlModel, Tei):
    ROOT_NAMESPACES = {'tei' : TEI_NAMESPACE}
    objects = Manager('/tei:TEI')
    id = StringField('@xml:id')
    title = StringField('//tei:titleStmt/tei:title')
    author = StringField('//tei:titleStmt/tei:author')
    text_string = StringField('tei:text')

    site_url = 'http://beck.library.emory.edu/frenchrevolution'
    source_title = StringField('tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:title')
    source_place = StringField('tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:pubPlace')
    created_date = StringField('tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:date')
    issued_date = StringField('tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date')
    #author = StringField('tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:publisher')
    identifier_ark = StringField('tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type="ark"]')
    header_title = StringField('tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title')
    contributor = StringField('tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt')
    publisher = StringField('tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:publisher')
    pub_place = StringField('tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:pubPlace')
    address = StringField('tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:address')
    rights = StringField('tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:p')
    series = StringField('tei:teiHeader/tei:fileDesc/tei:seriesStmt/tei:title')


   
