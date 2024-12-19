#pragma once
#include "HolyC.tab.hpp"
#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Verifier.h"
#include <map>
#include <memory>


//Scope these later on
static std::unique_ptr<llvm::LLVMContext> tu_context;
static std::unique_ptr<llvm::Module> tu_module;
static std::unique_ptr<llvm::IRBuilder<>> Builder;
static std::map<std::string, llvm::Value *> NamedValues;

static void InitModule()
{
    tu_context = std::make_unique<llvm::LLVMContext>();
    tu_module = std::make_unique<llvm::Module>("translation_unit", *tu_context);
}

class node
{
    public:
        virtual ~node() = default;
        virtual llvm::Value* codegen() = 0;
};

std::vector<llvm::Type*> args_list()
{

}

llvm::IntegerType* getIntType(int yacc_type)
{
    switch( yacc_type )
    {
        case BOOL:
            return llvm::Type::getIntNTy(*tu_context, 8);
        //case U0:
            //return llvm::Type::getVoidTy(*tu_context);
        case U8:
            return llvm::Type::getIntNTy(*tu_context, 8);
        case U16:
            return llvm::Type::getIntNTy(*tu_context, 16);
        case U32:
            return llvm::Type::getIntNTy(*tu_context, 32);
        case U64:
            return llvm::Type::getIntNTy(*tu_context, 64);
        case I8:
            return llvm::Type::getInt8Ty(*tu_context);
        case I16:
            return llvm::Type::getInt16Ty(*tu_context);
        case I32:
            return llvm::Type::getInt32Ty(*tu_context);
        case I64:
            return llvm::Type::getInt64Ty(*tu_context);
        default:
            fprintf(stderr, "Backend error: Unsupported type");

    }
}

class function_prototype
{
    public: 
        //default to void
        llvm::Type* return_type = llvm::Type::getVoidTy(*tu_context);
        std::string* name;
        std::vector<llvm::Type*> args;

    function_prototype(llvm::Type return_type, const char* name, std::vector<llvm::Type*> args )
    {
        this->return_type = &return_type;
        this->name = new std::string(name);
        this->args = args;
    }

    llvm::Function * codegen()
    {
        llvm::FunctionType *FT  = llvm::FunctionType::get(return_type, args, false);
        
        return llvm::Function::Create( FT, llvm::Function::ExternalLinkage, *name, tu_module.get());
    }
};