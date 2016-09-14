// npm install elementtree
// Converts a RGB Color look up table to R_B (removes the G channel)

// TODO - generates
/*
  <ColorTable>Palette
    <Entry c1="0" c2="1" c3="2" c4="3" />
  </ColorTable>
*/


var fs = require('fs');

var et = require('elementtree');

var XML = et.XML;
var ElementTree = et.ElementTree;
var element = et.Element;
var subElement = et.SubElement;

var data, etree;

// data = fs.readFileSync('clut.vrt').toString();
// etree = et.parse(data);



root = element('ColorTable');
root.text = 'Palette';

category = subElement(root, 'Entry');
category.set('c1', '0');
category.set('c2', '1');
category.set('c3', '2');
category.set('c4', '3');


etree = new ElementTree(root);
xml = etree.write({'xml_declaration': false});
console.log(xml);
