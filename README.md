# HolyC
Grammar of HolyC language. Waiting to be plugged into a LLVM backend.

# Contributing

A large amount of work for this version of the HolyC compiler needs to be done. I cannot enumerate all the items that need completed, but I will point out some quirks that I wish to preserve.

## Lexer
The lexer is pretty much done, if anything some things need to be removed.

## Parser
The grammar rules likely need to be re-evaluated and semantic actions added. The parser will act as the driver for code generation.
Invoking the parser will generate JIT'd code via a LLVM backend.

## Codegen
On invocation of a grammar rule, the LLVM IR Builder should be envoked to generate code. Ideally, I want to preserve the quirks of the language, and make it as fast as possible. Terry had no means of type-checking code, and I believe that everything must be strongly typed. This differs from traditional C, where implicit casts happen before a value hits the backend. For example in C:
```C
double d = 0;
int i = 1;

if(d==i) //This comparison will be impossible
  exit(1);
```
```HolyC
F64 d = 0;
I32 i = 1;

if(d == (F64)i ) //I must be explictly casted to F64 type, or LLVM will flip a shit.
  exit(1);
```
This follows the "no typechecking" rules of the language, and also will incoorperate the rules we must follow for LLVM IR.

## Runtime
Runtime environment TBD, work on codegen first.

## Optimizer Passes
A basic optimizer needs to be implemented. LLVM makes this easy, but optimizing code that needs to be ran is probably not optimal. The optimizer passes should happen in off-cycles of code that has already been generated, perferably in the background.

# Quirks for preservation

As seen above, the "no typechecking" rule must be preserved. This also simplifies the backend somewhat. I would like some error handling around this rule to remind compiler users, as the LLVM IR requires typechecking in a sense, and it will throw errors if values are not the right type. So, to keep LLVM from whining some sort of static type checks have to be added to the parser.

Terry did not believe in "continue". So "goto" and labels will need to be kind of a priority. 

"#define" precompiler statements will not be introduced. Terry is "not a fan".

"F64" is the only floating point type.

Switch statements can be nested and contain an array of cases. Like so:

```HolyC
U8 num = 4;
switch (num)
{
  case 1:
    //do something
    break;
  case 2...4:
    //do something
    break;
}
```
Any additional quirks should be enumerated in this section.
