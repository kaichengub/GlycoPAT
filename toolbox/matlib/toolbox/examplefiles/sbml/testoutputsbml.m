clc;
clear;

glycanNetExampleFileName = 'gnat_test_wtannot.xml';
glycanNetModelObj              =  glycanNetSBMLread(...
    glycanNetExampleFileName);
smblstruct                             = glycanNetModelObj.toSBMLStruct;


