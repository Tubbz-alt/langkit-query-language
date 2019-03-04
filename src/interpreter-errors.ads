with Langkit_Support.Text; use Langkit_Support.Text;

package Interpreter.Errors is

   Eval_Error : exception;

   type Error_Kind is (Kind_Empty_Error, Kind_Eval_Error);
   --  Denotes the kind of an error value.

   type Error_Data (Kind : Error_Kind := Kind_Empty_Error) is record
      case Kind is
         when Kind_Empty_Error =>
            null;
            --  Represents the absence of error
         when Kind_Eval_Error =>
            AST_Node     : LEL.LKQL_Node;
            --  AST node where the error occured

            Short_Message : Unbounded_Text_Type;
            --  A short description of the error
      end case;
   end record;
   --  Store an error value.

   function Is_Error (Err : Error_Data) return Boolean;
   --  Return wether the error value represents an actual error

   function Make_Empty_Error return Error_Data;

   function Make_Eval_Error (AST_Node      : LEL.LKQL_Node;
                             Short_Message : Unbounded_Text_Type)
                             return Error_Data;
   --  Create an error value of kind Eval_Error

end Interpreter.Errors;
