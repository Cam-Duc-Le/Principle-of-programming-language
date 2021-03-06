/* ID: 1952713 */
grammar D96;

@lexer::header {
from lexererr import *
}

options {
	language = Python3;
}

// Back up note : handle the illegal escape and format the string again
//--------------------- Parser-------------------------//
program: class_declaration+  EOF;

// program: class_main_program  EOF;

// class_main_program :CLASS 'Program' LP main_decl? RP;

// main_decl : ('main' LB  RB block_statement) ;

class_declaration : CLASS ID ( COLON ID )? LP member*  RP;

member : attribute_declaration | method_declaration | constructor | destructor ;

// Attribute declare
// Var $num2 , $num1, $num3 : Int = 1,2,3;
// Var a : Int
attribute_declaration : attribute_type attribute_decl_list SEMI_COLON;

attribute_decl_list : testing | testing2 ;

testing : att_name ( COLON compound_type (ASSIGN expression)) | (att_name COMMA testing (COMMA expression));

testing2 :  att_name (COMMA att_name )* COLON compound_type ; // Int a,b,c : = Int;

// testing1: att_name ;

primitive_type : INT_TYPE | FLOAT_TYPE | BOOLEAN_TYPE | STRING_TYPE;

array_type: (ARRAY LS compound_type  COMMA (INTLIT_ARR)  RS) ; //var a: Array[Int, 5];


// var a : Array[Int,7] = Array(0,1,2,3,4) -> operand

// Method declare

method_declaration : (att_name LB parameter_decl_list? RB block_statement);


att_name : (ID|DOLLAR_ID);

constructor : CONSTRUCTOR LB parameter_decl_list? RB block_statement; 

destructor : DESTRUCTOR LB RB block_statement;

parameter_decl_list : (parameter_decl (SEMI_COLON parameter_decl)*); // a,b : Int ; c.d : Float 

parameter_decl : ids_list COLON compound_type ;  // a,b : Int -> 

ids_list : ID ( COMMA ID)*;




block_statement : LP statement* RP; // statement + attribute declare maybe.  

statement : var_declare_statement 
| assign_statement 
| if_statement 
| for_statement 
| return_statement 
| break_statement 
| continue_statement 
| block_statement
| call_stmt; 


// var_declare_statement : ATTRIBUTE_TYPE ID (COMMA ID )* COLON (primitive_type | array_type)  ASSIGN  expression (COMMA expression)* SEMI_COLON ;

var_declare_statement : attribute_type var_decl_list SEMI_COLON ;

var_decl_list : (var_decl_stm_only | var_decl_stm_assign) ;

var_decl_stm_only : ID (COMMA ID )* COLON compound_type; 

var_decl_stm_assign : ID (COLON compound_type (ASSIGN expression)) | (ID COMMA var_decl_stm_assign (COMMA expression));



// assign_statement : expression ASSIGN expression SEMI_COLON; // a = b +1;

assign_statement : lhs ASSIGN expression SEMI_COLON;

lhs : expression7 (ASSIGN expression7)*;

call_stmt : (expression8 DOT ID LB expressions_list? RB SEMI_COLON) 
| expression8 DOUBLE_COLON DOLLAR_ID LB expressions_list RB SEMI_COLON;


// a[3] , a = b = 4 


if_statement : IF LB  expression RB block_statement (ELSEIF LB  expression RB block_statement)* (ELSE block_statement)? ;
//------ For statement handle-------//
for_statement : FOREACH LB ID IN expression DOUBLEDOT expression (BY expression)?  RB block_statement;

// scalar : ID | ((SELF | ID) DOUBLE_COLON DOLLAR_ID) | (SELF DOT ID) | (scalar_test DOT (ID | function_call)) | method_invocation ;

// scalar_test : SELF | ID | scalar_test DOT ID; 

method_invocation :(SELF | ID) DOUBLE_COLON (DOLLAR_ID | dollar_function) ;

//----------------------------------//

return_statement : RETURN (expression)? SEMI_COLON;

// return_statement : RETURN (expression | DOLLAR_ID)? SEMI_COLON;

break_statement : BREAK SEMI_COLON;

continue_statement : CONTINUE SEMI_COLON;
// mptype: INTTYPE | VOIDTYPE;

// body: funcall SEMI_COLON;

// exp: funcall | INTLIT;

// funcall: ID LB exp? RB;
// literal : INT_LITERAL | FLOAT_LITERAL | BOOL_LITERAL | STRING_LITERAL ;
// data_type : INT_TYPE | FLOAT_TYPE | BOOLEAN_TYPE | STRING_TYPE;
expression : expression1 (CONCATE | STRCOMPARE) expression1 | expression1;

expression1 : expression2 ( EQUAL | NOTEQUAL | LARGER | SMALLER | LE | SE) expression2 | expression2 ;

expression2 : expression2 (OR | AND) expression3 | expression3; 

expression3 : expression3 (ADD | SUB) expression4 | expression4;

expression4 : expression4 (MUL | DIV | MOD) expression5 | expression5;

expression5 : NOT expression5 | expression6;

expression6 : SUB expression6 | expression7;

expression7 : expression7 (LS expression RS)+ | expression8;

expression8 : expression8 DOT ID (LB expressions_list? RB)?  | expression9;   

expression9 : expression10 DOUBLE_COLON DOLLAR_ID (LB expressions_list? RB)? | expression10; // :: 

expression10 : NEW expression10 LB expressions_list? RB | operands;

index_operator : LS expression RS;

operands : literals
| ID 
| (LB expression RB) 
| indexed_array // Array(1,2,3,4)
// | multi_array 
| SELF
| NULL;

literals : ( INTLIT_ARR | STRING_LITERAL | INT_LITERAL | FLOAT_LITERAL | BOOL_LITERAL) ;

dollar_function : DOLLAR_ID (LB expressions_list? RB)?  ;

// new_object : ID (LB (expression ( COMMA expression)*)? RB)? ;

function_call : (ID (LB expressions_list? RB)? );


//------- INDEXED ARRY-------- // 
indexed_array : ARRAY LB expressions_list? RB;

// multi_array : (indexed_array COMMA?) | (ARRAY LB multi_array* RB COMMA? )  ;
// multi_array : (indexed_array (COMMA indexed_array)* ) | (ARRAY LB multi_array (COMMA multi_array)* RB )  ;
// Var a = New classID; 

compound_type : primitive_type | array_type | ID ;

expressions_list : (expression ( COMMA expression)*); 


// --------------------- Lexer-------------------------//



// // ---------------------Keywords----------------------// 
BREAK : 'Break';
CONTINUE : 'Continue'; 
IF : 'If';
ELSEIF : 'Elseif';
ELSE : 'Else';
FOREACH : 'Foreach';
// TRUE :'True'; 
// FALSE : 'False'; 
ARRAY :'Array'; 
IN : 'In';
BY : 'By'; 

//----------------------Type--------------------------// 
INT_TYPE : 'Int';
FLOAT_TYPE : 'Float';
BOOLEAN_TYPE : 'Boolean'; 
STRING_TYPE : 'String'; 
NULL : 'Null';
RETURN : 'Return';


//------------------Class Declaration---------------------//
attribute_type : IMMUTABLE | MUTABLE; 
SELF : 'Self';
NEW :'New';
CLASS : 'Class';
IMMUTABLE : 'Val'; 
MUTABLE : 'Var';
CONSTRUCTOR : 'Constructor';
DESTRUCTOR : 'Destructor';
DOLLAR_ID: '$'[_a-zA-Z0-9]+;


// //--------------------Operator---------------------//

ASSIGN : '=';

// Arithmetic operator
ADD : '+'; 
SUB: '-';
MUL: '*';
DIV: '/';
MOD : '%'; 


//Boolean operator
NOT : '!';
AND : '&&';
OR : '||'; 
STRCOMPARE : '==.';

// String operator
CONCATE : '+.';

// Comparison operator
EQUAL : '==';
NOTEQUAL : '!=';
LARGER : '>';
SMALLER : '<';
LE : '>=';
SE : '<=';




// // ------------------------------- Literal -------------------------------//
INTLIT_ARR: INT_LIT_ARR {self.text = self.text.replace("_","")};
INT_LIT_ARR: BIN_
	       | DEC_
	       | OCTAL_
	       | HEXA_;

BIN_: '0' [bB]('1'[01]* ('_' [01]+)*);
DEC_: [1-9][0-9]* ('_' [0-9]+)*;
OCTAL_: '0' ([1-7][0-7]* ('_' [0-7]+)*);
HEXA_: '0' [xX]([1-9A-F][0-9A-F]* ('_' [0-9A-F]+)*);
//-----//



 
fragment BINARY: '0' [bB](('1'[01]* ('_' [01]+)*) | '0');
fragment OCTAL :	'0'( ( [1-7][0-7]* | ('_'[0-7]) )* | '0');
fragment HEXA: '0' [xX]( ([1-9A-F][0-9A-F]* ('_' [0-9A-F]+)*) | '0'); 
fragment NATURAL : '0'| [1-9][0-9]* ('_'[0-9]+)* ; 

INT_LITERAL : NATURAL {self.text = self.text.replace("_","")} |
 HEXA{self.text = self.text.replace("_","")} | 
 OCTAL {self.text = self.text.replace("_","")} | 
 BINARY{self.text = self.text.replace("_","")} ;




BOOL_LITERAL : 'True'| 'False';  

FLOAT_LITERAL : INT_PART DECIMAL EXPONENT? {self.text = self.text.replace("_","")}  | INT_PART? DECIMAL EXPONENT {self.text = self.text.replace("_","")} | INT_PART DECIMAL? EXPONENT  {self.text = self.text.replace("_","")};
// fragment INT_PART : ([0-9] | [1-9][0-9]+) ('_'[0-9]+)*; // keep this pls 
fragment INT_PART :  [0-9] | ([1-9][0-9]* ('_'[0-9]+)*) ;
fragment DECIMAL : '.'[0-9]*; 
fragment EXPONENT : [eE][-+]? [0-9]+;
 

STRING_LITERAL:'"' (STR_CHAR | ESC_SEQ)* '"' {self.text = self.text[1:-1]};


// BLOCK_COMMENT: (('##' .*? '##') | ('##' ~['##']* )) -> skip ;


BLOCK_COMMENT : '##' .*? '##' -> skip; 


//--------------------------- Seperators -------------------------// 
LB: '('; // Left parenthesis
RB: ')'; // Right parenthesis
LP: '{'; // Left curly bracket
RP: '}'; // Right curly bracket
LS: '['; // Left square Bracket
RS: ']'; // Right square Bracket

DOUBLE_COLON : '::';
COLON : ':';
DOUBLEDOT : '..';
DOT : '.';
COMMA : ',';
SEMI_COLON: ';'; // Semi colon

ID: ([_a-zA-Z][_a-zA-Z0-9]*); 

WS: [ \t\r\n]+ -> skip; // skip spaces, tabs, newlines




//------------------Error throw--------------------------// 


fragment STR_CHAR: ~[\\"\n];
fragment ESC_SEQ: ('\\'[bfrnt]) | '\\\'' | '\\\\' | '\'"'; 
fragment ESC_ILLEGAL: ('\\' ~[bfrnt'\\]) | ('\'' ~ '"');

UNCLOSE_STRING: '"' (STR_CHAR | ESC_SEQ)* (EOF | '\n'){
clone = ['"', '\n']
if self.text[-1] in clone:
	raise UncloseString(self.text[1:-1])
else:
	raise UncloseString(self.text[1:])
};

ILLEGAL_ESCAPE: '"' (STR_CHAR | ESC_SEQ)* ESC_ILLEGAL {raise IllegalEscape(self.text[1:])};

ERROR_CHAR: .{raise ErrorToken(self.text)};



