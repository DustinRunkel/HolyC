#pragma once
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

class function_prototype
{
    llvm::Function codegen() 
    {
        //std::vector<Type*> doubles(Args.size(), Type::getDoubleTy(*TheContext));
        //llvm::FunctionType *FT  = llvm::FunctionType::get(llvm::Type::getDoubleTy(*TheContext), Doubles, false);

        //llvm::Function *F = llvm::Function::Create(FT, llvm::Function::ExternalLinkage, Name, tu_module.get());
    }
};