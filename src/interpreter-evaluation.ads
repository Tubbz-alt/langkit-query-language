with Options;
with Iters.Iterators;
with Iters.Maps;
with Interpreter.Primitives;       use Interpreter.Primitives;
with Interpreter.Eval_Contexts;    use Interpreter.Eval_Contexts;

with Langkit_Support.Text; use Langkit_Support.Text;

package Interpreter.Evaluation is

   function Check_And_Eval
     (Ctx  : Eval_Context; Node : L.LKQL_Node'Class) return Primitive;
   --  Check 'Node' and then evaluate it.

   function Eval (Ctx            : Eval_Context;
                  Node           : L.LKQL_Node'Class;
                  Expected_Kind  : Base_Primitive_Kind := No_Kind;
                  Local_Bindings : Environment_Map :=
                    String_Value_Maps.Empty_Map)
                  return Primitive;
   --  Return the result of the AST node's evaluation in the given context.
   --  An Eval_Error will be raised if the node represents an invalid query or
   --  expression.

   function Matches_Kind_Name
     (Kind_Name : String; Node : LAL.Ada_Node) return Boolean;
   --  Return true if 'Node's type is named 'Type_Name' or is a subtype of
   --  a type named 'Type_Name'.

private

   -----------------------------------------
   -- Comprehensions environment iterator --
   -----------------------------------------

   package Environment_Iters is new Iters.Iterators (Environment_Map);
   --  Iterator that yields the environments generated by a list
   --  comprehension's generator expressions.

   package Primitive_Options is new Options (Primitive);
   use Primitive_Options;

   type Comprehension_Env_Iter is new Environment_Iters.Iterator_Interface with
      record
         Binding_Name    : Unbounded_Text_Type;
         --  name ascoaited with th generator
         Current_Element : Primitive_Options.Option;
         --  Value of the next element to be yielded
         Gen             : Primitive_Iters.Iterator_Access;
         --  Iterator that yields the generator values
         Nested          : Environment_Iters.Resetable_Access;
         --  'Nested' generator that appeared at the right-hand side of the
         --  current geneartor in the generators list
      end record;

   overriding function Next (Iter   : in out Comprehension_Env_Iter;
                             Result : out Environment_Map) return Boolean;

   overriding function Clone
     (Iter : Comprehension_Env_Iter) return Comprehension_Env_Iter;

   overriding procedure Release (Iter : in out Comprehension_Env_Iter);

   type Comprehension_Env_Iter_Access is access all Comprehension_Env_Iter;

   -----------------------------
   -- Comprehesion evaluation --
   -----------------------------

   package Env_Primitive_Maps is
     new Iters.Maps (Environment_Iters, Primitive_Iters);
   --  Mapping from environment values to primitive values

   type Closure is new Env_Primitive_Maps.Map_Funcs.Func with record
      Ctx           : Eval_Context;
      --  Copy of the evaluation context at call site
      Body_Expr     : L.Expr;
      --  Body of the closure
   end record;

   overriding function Evaluate (Self    : in out Closure;
                                 Element : Environment_Map) return Primitive;

   overriding function Clone (Self : Closure) return Closure;

   overriding procedure Release (Self : in out Closure);

   function Make_Closure (Ctx            : Eval_Context;
                          Body_Expr      : L.Expr)
                          return Closure;

   type Comprehension_Guard_Filter is new Environment_Iters.Predicates.Func
   with record
      Ctx   : Eval_Context;
      Guard : L.Expr;
   end record;
   --  Func that, given an environment, computes the value of a list
   --  comprehension's guard expression in the context of this environment.

   function Evaluate (Self : in out Comprehension_Guard_Filter;
                      Element : Environment_Map) return Boolean;

   function Clone
     (Self : Comprehension_Guard_Filter) return Comprehension_Guard_Filter;

   function Make_Guard_Filter (Ctx : Eval_Context;
                               Guard : L.Expr)
                               return Comprehension_Guard_Filter;

end Interpreter.Evaluation;
