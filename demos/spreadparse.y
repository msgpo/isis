 /*  $RCSfile: spreadparse.y,v $ $Revision: 2.16 $ $Date: 90/09/17 12:46:40 $  */
/*
 *	Originally coded by Robert Wisniewski
 *
 *      ISIS release V2.0, May 1990
 *      Export restrictions apply
 *
 *      The contents of this file are subject to a joint, non-exclusive
 *      copyright by members of the ISIS Project.  Permission is granted for
 *      use of this material in unmodified form in commercial or research
 *      settings.  Creation of derivative forms of this software may be
 *      subject to restriction; obtain written permission from the ISIS Project
 *      in the event of questions or for special situations.
 *      -- Copyright (c) 1990, The ISIS PROJECT
 */

%{
#include <stdio.h>
#include <ctype.h>
#include "spread.h"
#include "isis.h"

/* local variable to the pasrser */
FILE *lfp;
char str[64];
double functarray[32]; /* used to store numbers in a series so we can find desired result */
int parsetemp;
char parse_spd[32];
double atof();
%}

/* our final result should be a formula if not we should return error */
%start formula

%union  {
    int    ival;
    double dval;
    }

%token <ival> CAPLETTER SMLETTER CHARACTER DIGIT NEGSIGN
%token <dval> CONST

%type <ival> row column spreadsheet spreadname number
%type <dval> formula expr funct series restseries result news

%left '+' '-'
%left '*' '/'
%right UMINUS

%%

formula :
        { parse_val = 0; } 
     |  '=' expr
        { parse_val = $2; } 
    ;

expr : '(' expr ')'
          { $$ = $2; }
    | expr '+' expr
          { $$ = $1 + $3; }
    | expr '-' expr
          { $$ = $1 - $3; }
    | expr '*' expr
          { $$ = $1 * $3; }
    | expr '/' expr
          { if ($3 == 0) { 
                /* return error for division by 0 */
                validentry[(int)parsdep][(int)parscol][(int)parsrow] = 0;
                $$ = 0;
                valid_parse = 0;
            }
            else
                $$ = $1 / $3; }
    | result
          { $$ = $1; }
    | funct  /* these are functions I designed e.g., avg, min, max, etc. */
          { $$ = $1; }
    | news
          { $$ = $1; }
 /* these are predefined math function e.g., sin, cos, tan */
/*
    | function 
          { $$ = $1; }
*/
    | CONST
         {  $$ = $1; }
    | '-' CONST   %prec UMINUS
         {  $$ = $2 * (-1); }
    | number
         {  $$ = $1; }
    ;

/* a funct is a function that I have designed e.g., avg, min, max, etc. */
funct :   SMLETTER SMLETTER SMLETTER '(' series ')'
          { 
          
            if (($1 == 0) && ($2 == 21) && ($3 == 6)) /* check for avg if so calc average */

                $$ = calcavg();
            else if (($1 == 12) && ($2 == 8) && ($3 == 13)) /* check for min, if so calc minimum */

                $$ = calcmin();
            else if (($1 == 12) && ($2 == 0) && ($3 == 23)) /* check for max, if so calc maximum */

                $$ = calcmax();
            else if  (($1 == 18) && ($2 == 20) && ($3 == 12)) /* check for sum, if so calc summation */
                $$ = calcsum();

            else
                valid_parse = 0; }

    | SMLETTER SMLETTER SMLETTER ' ' series
          { 
          
            if (($1 == 0) && ($2 == 21) && ($3 == 6)) /* check for avg if so calc average */
                $$ = calcavg();
            else if (($1 == 12) && ($2 == 8) && ($3 == 13)) /* check for min, if so calc minimum */
                $$ = calcmin();
            else if (($1 == 12) && ($2 == 0) && ($3 == 23)) /* check for max, if so calc maximum */
                $$ = calcmax();
            else if  (($1 == 18) && ($2 == 20) && ($3 == 12)) /* check for sum, if so calc summation */
                $$ = calcsum();
            else
                valid_parse = 0; }

    | CAPLETTER CAPLETTER CAPLETTER '(' series ')'
          { 
         
            if (($1 == 0) && ($2 == 21) && ($3 == 6)) /* check for avg if so calc average */
                $$ = calcavg();
            else if (($1 == 12) && ($2 == 8) && ($3 == 13)) /* check for min, if so calc minimum */
                $$ = calcmin();
            else if (($1 == 12) && ($2 == 0) && ($3 == 23)) /* check for max, if so calc maximum */
                $$ = calcmax();
            else if  (($1 == 18) && ($2 == 20) && ($3 == 12)) /* check for sum, if so calc summation */
                $$ = calcsum();
            else
                valid_parse = 0; }

    | CAPLETTER CAPLETTER CAPLETTER ' ' series
          { 
         
            if (($1 == 0) && ($2 == 21) && ($3 == 6)) /* check for avg if so calc average */
                $$ = calcavg();
            else if (($1 == 12) && ($2 == 8) && ($3 == 13)) /* check for min, if so calc minimum */
                $$ = calcmin();
            else if (($1 == 12) && ($2 == 0) && ($3 == 23)) /* check for max, if so calc maximum */
                $$ = calcmax();
            else if  (($1 == 18) && ($2 == 20) && ($3 == 12)) /* check for sum, if so calc summation */
                $$ = calcsum();

            else
                valid_parse = 0; }
    ;

news :   SMLETTER SMLETTER SMLETTER SMLETTER ':' series
         {
          if  (($1 == 13) && ($2 == 4) && ($3 == 22) && ($4 == 18)) /* check for news,if so subscribe */
                $$ = getnews();
            else
                valid_parse = 0; 
         }
      |  CAPLETTER CAPLETTER CAPLETTER CAPLETTER ':' series
         {
          if  (($1 == 13) && ($2 == 4) && ($3 == 22) && ($4 == 18)) /* check for news,if so subscribe */
                $$ = getnews();
            else
                valid_parse = 0; 
         }
   ;


/* a series is what my functs operate on, they are one or more numbers seperated by
   commas, as we look through the series we will keep track of the critical elements
   such as max min sum and number, in this way we will be ablel to calculate fairly
   meaningful things once we are finished. */
series : expr
          { 
            functarray[(int)parsnum] = $1;
            parsnum = parsnum + 1;
            
            $$ = 0; }
       |  expr restseries
            { 
            functarray[(int)parsnum] = $1;
            parsnum = parsnum + 1;
            
            $$ = 0; }
    ;

restseries : ',' expr
          { 
        
            functarray[(int)parsnum] = $2;
            parsnum = parsnum + 1;

           $$ = 0; }

    | ',' expr restseries
          { 
        
            functarray[(int)parsnum] = $2;
            parsnum = parsnum + 1;
            
            $$ = 0; }
    ;
   

/* a function is a predefined math function e.g., sin, cos, tan etc. */
/*function : 
{ $$ = 1; }
    ;
*/
/* result is an entry cell from either this spreadsheet or another spreadsheet */
result : column row spreadsheet
          { if ($3 == -1) 
                /* if the spreadsheet we tried to include didn't exist return error */
                valid_parse = 0; 
            else {

                $$ = entryval[$3][$1][$2];
                if (validentry[$3][$1][$2] == 0){
                    valid_parse = 0;
                }
                if (depend == 1) {
                    /* keep track of deleted dependencies */
                    temp = ((struct element *) malloc(sizeof(struct element)));
                    /* add present element to del_dep list */
                    temp->column = $1;
                    temp->row = $2;
                    temp->depth = $3;
                    temp->next = del_dep;
                    temp->prev = NULL;
                    if (del_dep != NULL)
                        del_dep->prev = temp;
                    del_dep = temp;
                               
                    look = find($3,$1,$2,parsdep,parscol,parsrow);
                    if (look == 0) { /* i.e., if the element wasn't already associated with */
                                     /* the cell, then insert it into the list  */
                        temp = ((struct element *) malloc(sizeof(struct element)));
                        temp->column = parscol;
                        temp->row = parsrow;
                        temp->depth = parsdep;
                        temp->next = dependency[$3][$1][$2];
                        temp->prev = NULL;
                        if(dependency[$3][$1][$2] != NULL)
                            dependency[$3][$1][$2]->prev = temp;
                        /*printf("about to add depend spread %i,col %i,row %i\n",$3,$1,$2);*/
                        dependency[$3][$1][$2] = temp;
                    }
                }
            }
        }
  ;


column : CAPLETTER
          { $$ = $1; }
       | SMLETTER
          { $$ = $1; }
    ;
   


row : DIGIT
          { $$ = $1; }
    | row DIGIT
          { $$ = 10 * $1 + $2; }
    ;

number : DIGIT
          { $$ = $1; }    
    | number DIGIT
          { $$ = 10 * $1 + $2; }
    | '-' number  %prec UMINUS
          { $$ = $2 * (-1); }
    ;

/*number : CONST
          { $$ = $1; }  
    | '-' number  %prec UMINUS
          { $$ = $2 * (-1); } 
    ;

*/

/* spread is the name of a spreadsheet that is trying to be accessed */
spreadsheet : 
          { $$ = parsdep;}   /* default, if no spreadsheet given give use
                                                   the spread sheet name and get level */
         
    | '[' spreadname ']'
          {   valid_parse = 1;
              parsetemp = get_spdsht_depth(parse_spd);

              /*printf("%s  returned %d\n",spdshtname,parsetemp);*/
              if (parsetemp == -1) {
                  parsetemp = check_in_global(parse_spd);
                  lfp = fopen(parse_spd,"r");
                  fclose(lfp);
                  if (lfp == NULL) {
                      sprintf(str, "%s %s %s", "**error** spreadsheet", 
                              parse_spd, "does not exist");
                      display_error(str, 1); 
                      }
                  if ((lfp != NULL) || (parsetemp != -1)) {
                      /* save_file(); */
                      /* inform everyone of a group change, i.e., we're adding parse_spd */
                      
                      lfp = fopen(parse_spd, "a");
                      if (lfp == NULL) {
                          sprintf(str, "%s %s", 
                                  "**error** unable to gain write access to file", parse_spd);
                          display_error(str, 1);
                      }
                      if (lfp != NULL) {
                          fclose(lfp);
                          if (protected == 0) {  /* it is legal to bring in more spreadsheets */
                              parsetemp = check_in_global(parse_spd);
                              if (parsetemp == -1) { /* is not open just add to this group */
                                  parsetemp = access_new_spd(parse_spd);
                                  display_all();
                                  if (parsetemp == -1)
                                      error ("You tried to access a nonexistent spreadsheet");
                              }
                              else /* already open, join its group */
                                  inform_group_change(parse_spd); 
                              parsetemp = get_spdsht_depth(parse_spd);
                          }  /* end if protected == 0 */
                          else  /* protect != 0 */
                              display_error("unable to modify group containing a write protected member", 1);
                      }  /* end if lfp != NULL */
                      else
                          fclose(lfp);
                  }
                
                      
              }
              $$ = parsetemp;
              /*printf("%s  rereturned %d\n",spdshtname,parsetemp);*/}
    ;


/* spreadname is a string and is the name of the spreadsheet we are trying to acess */
spreadname : CAPLETTER
          { $$ = 0;
              parse_spd[0] = $1 + 'A';
              parse_spd[1] = '\0';  }
    | SMLETTER
          { $$ = 0;
              parse_spd[0] = $1 + 'a';
              parse_spd[1] = '\0';  }
    | DIGIT
          { $$ = 0;
              parse_spd[0] = $1 + '0';
              parse_spd[1] = '\0';  }
    | CHARACTER
          { $$ = 0;
              parse_spd[0] = $1;
              parse_spd[1] = '\0';  }
    | spreadname CAPLETTER
          { $$ = 0;
              parse_spd[strlen(parse_spd) + 1] = '\0';
              parse_spd[strlen(parse_spd)] = $2 + 'A'; }
    | spreadname SMLETTER
          { $$ = 0;
              parse_spd[strlen(parse_spd) + 1] = '\0';
              parse_spd[strlen(parse_spd)] = $2 + 'a'; }
    | spreadname DIGIT
          { $$ = 0;
              parse_spd[strlen(parse_spd) + 1] = '\0';
              parse_spd[strlen(parse_spd)] = $2 + '0'; }
    | spreadname CHARACTER
          { $$ = 0;
              parse_spd[strlen(parse_spd) + 1] = '\0';
              parse_spd[strlen(parse_spd)] = $2; }
    ;

%%

int
yylex()
{
    char c;
    char buf[51], *bufp;
    int i, dot;

    dot = 0;
    c = *(parse_str+strloc);
    strloc = strloc + 1;

    if (c == '\0')
        return(0);

    else if (isupper(c)) 
        {
        yylval.ival = c - 'A';
	return(CAPLETTER);
        }

    else if (islower(c)) 
        {
        yylval.ival = c - 'a';
	return(SMLETTER);
        }

    else if (isdigit(c) || c == '.') 
        {
        memset(buf, 0x0, sizeof(buf));
        if (c == '.')
           dot++;
        for ( i = 0; i< 50; i++ )
            {
            buf[i] = c;
            c = *(parse_str+strloc);
            ++strloc;

            if (isdigit(c))
                continue;
            if (c == '.')
                {
                if (dot++)
                    return('.');   
                continue;
                }
            break;
            }
        if (dot)
            {
            yylval.dval = atof(buf);
            return(CONST);
            }
        else
            {
            yylval.ival = atoi(buf);
            --strloc;
            return(DIGIT);
            }
        }
    else 
        return(c);
}  /* end function yylex */


void
yyerror(s)
     char s[64];
{
    /*printf("syntax error\n");*/
}  /* end function yyerror */


double
calcavg()
{
    int i, tempparsnum;
    double sum;


    sum = 0;  /*initialize sum */
    for (i = 0; i < parsnum; i++) {
        sum = sum + functarray[i];
    }
    tempparsnum = parsnum;
    parsnum = 0;
    return(sum/tempparsnum);
}   /* end function calculate average */


double
calcmin()
{
    int i;
    double lmin;

    lmin = functarray[0];
    
    for (i = 0; i < parsnum; i++) {
        if (functarray[i] < lmin)
            lmin = functarray[i];
    }
    parsnum = 0;
    return(lmin);
}  /* end function calculate minimum */


double
calcmax()
{
    int i;
    double lmax;

    lmax = functarray[0];
    
    for (i = 0; i < parsnum; i++) {
        if (functarray[i] > lmax)
            lmax = functarray[i];
    }
    parsnum = 0;
    return(lmax);
}  /* end functino calculate maximum */


double
calcsum()
{
    int i;
    double lsum;

    lsum = 0;
    
    for (i = 0; i < parsnum; i++) {
        lsum = lsum + functarray[i];
    } 
    parsnum = 0;
    return(lsum);
}  /* end function calculate summation */


double
getnews()
{
    int i;
    double lsum;

/*    isis_entry(TEST_SUBSCRIBE, test_subscribe, "test_subscribe");

    rc = news_subscribe("math", TEST_SUBSCRIBE, 5);
*/ 
    lsum = 999;
    
    parsnum = 0;
    return(lsum);
}  /* end function getnews */


void 
test_subscribe(msg_p)
message *msg_p;
{
   char subject[25], msg[50];
   int len1, len2;

   msg_get(msg_p, "%s %s", subject, &len1, msg, &len2);
   
   printf("%s: %s\n", subject, msg);

}


