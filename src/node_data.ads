with Interpreter.Primitives;    use Interpreter.Primitives;
with Interpreter.Eval_Contexts; use Interpreter.Eval_Contexts;

with Liblkqllang.Analysis;

with Libadalang.Analysis;
with Libadalang.Introspection; use Libadalang.Introspection;

with Langkit_Support.Text; use Langkit_Support.Text;

package Node_Data is

   package L renames Liblkqllang.Analysis;
   package LAL renames Libadalang.Analysis;

   function Access_Data (Ctx      : Eval_Context;
                         Receiver : LAL.Ada_Node;
                         Member   : L.Identifier) return Primitive;
   --  Return the value of the field/property designated by 'Member' on
   --  'Receiver'.

   function Call_Property (Ctx           : Eval_Context;
                           Receiver      : LAL.Ada_Node;
                           Call          : L.Dot_Call) return Primitive;
   --  Call the node property designated by 'Property_Name'with the given
   --  arguments on 'Receiver'.

   function Call_Property (Ctx          : Eval_Context;
                           Receiver     : LAL.Ada_Node;
                           Property_Ref : Property_Reference;
                           Call         : L.Dot_Call) return Primitive;
   --  Call a node property with the given arguments.

private

   function Data_Reference_For_Name (Receiver : LAL.Ada_Node;
                                     Name : Text_Type)
                                     return Any_Node_Data_Reference;
   --  Return the node data type corresponding to 'Name' on the receiver
   --  node. Return None if the name is invalid.

   function Create_Primitive (Ctx    : Eval_Context;
                              Member : L.LKQL_Node;
                              Value  : Value_Type) return Primitive;
   --  Converte the given 'Value_Type' value to a 'Primitive'.
   --  An exception will be raised if no Primitve kind match the kind of
   --  'Value'.

   function To_Value_Type (Ctx         : Eval_Context;
                           Value_Expr  : L.Expr;
                           Value       : Primitive;
                           Target_Kind : Value_Kind) return Value_Type;
   --  Create a Value_Type value of kind 'Target_Kind' from the given Primitive
   --  value. An exceptioin will be raised if the conversion is illegal.

   function Built_In_Property
     (Receiver : LAL.Ada_Node; Property_Name : String) return Primitive;
   --  Return the value of the built-in property named 'Property_Name' on
   --  'Receiver'.

   function Access_Custom_Data (Ctx      : Eval_Context;
                                Receiver : LAL.Ada_Node;
                                Member   : L.Identifier) return Primitive;
   --  Return the value of the non built-in field/property designated by
   --  'Member' on 'Receiver'.

   function Is_Built_In (Name : String) return Boolean;
   --  Return whether the property named 'Name' is built-in

end Node_Data;