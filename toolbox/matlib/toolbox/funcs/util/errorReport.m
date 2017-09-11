function isNonSucesseful = errorReport(mFileName,category)
%errorReport categorize the error report into several classifications
GNATboxName = 'GNAT';
errorMsgID = [GNATboxName ':' mFileName ':' category];
% errorMsgID = [ mFileName ':' category];

if strcmp(category,'NotEnoughInput')
    errorDetailedMsg='Not enough number inputs';
elseif  strcmp(category,'TooManyInputs')
    errorDetailedMsg= 'Too many inputs';
elseif strcmp(category,'IncorrectInputType')
    errorDetailedMsg= 'Incorrect input data type';
elseif strcmp(category,'IncorrectNumberInput')
    errorDetailedMsg= 'Incorrect number of inputs';
elseif strcmp(category,'FileNotFound')
    errorDetailedMsg= 'file is not found in the path';
elseif strcmp(category,'NonStringInput')
    errorDetailedMsg='not a string input';
elseif strcmp(category,'IncorrectStucture')
    errorDetailedMsg='Incorrect Glycan Structure';
elseif strcmp(category,'FileWritingError')
    errorDetailedMsg='Incorrect File Output';
elseif strcmp(category,'InvalidSBMLTranslation')
    errorDetailedMsg='Not valid SBML Translation';   
elseif strcmp(category,'DatabaseConnectFailed');
    errorDetailedMsg='Not valid database connection';   
else    
    errorDetailedMsg=category;    
end
isNonSucesseful=true;
error(errorMsgID,errorDetailedMsg);
