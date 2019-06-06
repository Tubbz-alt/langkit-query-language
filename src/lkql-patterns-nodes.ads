with LKQL.Depth_Nodes;            use LKQL.Depth_Nodes;

with LKQL.Selector_Lists; use LKQL.Selector_Lists;

package LKQL.Patterns.Nodes is

   function Filter_Node_Array (Ctx     : Eval_Context;
                               Pattern : L.Base_Pattern;
                               Nodes   : LAL.Ada_Node_Array)
                               return LAL.Ada_Node_Array;
   --  Return a node array that only contains the nodes from 'Nodes' that match
   --  'Pattern'.

   function Match_Node_pattern (Ctx     : Eval_Context;
                                Pattern : L.Node_Pattern;
                                Node    : LAL.Ada_Node) return Match_Result;
   --  Match the given node againsta a node pattern

   function Match_Kind_pattern (Ctx     : Eval_Context;
                                Pattern : L.Node_Kind_Pattern;
                                Node    : LAL.Ada_Node) return Match_Result
     with Pre => not Node.Is_Null;
   --  Match th given node against a kind pattern

   function Match_Extended_Pattern (Ctx     : Eval_Context;
                                    Pattern : L.Extended_Node_Pattern;
                                    Node    : LAL.Ada_Node)
                                    return Match_Result
     with Pre => not Node.Is_Null;
   --  Match the given node against an extended pattern

   function Matches_Kind_Name
     (Kind_Name : String; Node : LAL.Ada_Node) return Boolean;
   --  Return true if 'Node's type is named 'Type_Name' or is a subtype of
   --  a type named 'Type_Name'.

   function Match_Pattern_Details (Ctx     : Eval_Context;
                                   Details : L.Node_Pattern_Detail_List;
                                   Node    : LAL.Ada_Node)
                                   return Match_Result
     with Pre => not Node.Is_Null;
   --  Match a given node agains the 'details' (fields, properties & sekectors)
   --  of a node pattern.
   --  The 'Bindings' part of the Match result will contain references to the
   --  selector lists that are associated with a binding name in the pattern.

   function Match_Pattern_Detail (Ctx    : Eval_Context;
                                  Node   : LAL.Ada_Node;
                                  Detail : L.Node_Pattern_Detail'Class)
                                  return Match_Result
     with Pre => not Node.Is_Null;
   --  Match 'Node' against a node pattern 'detail'

   function Match_Pattern_Field (Ctx    : Eval_Context;
                                 Node   : LAL.Ada_Node;
                                 Field  : L.Node_Pattern_Field)
                                 return Match_Result
     with Pre => not Node.Is_Null;
   --  Match the expected value specified in 'Field' against the value of the
   --  field of 'Node' designated by 'Field'.

   function Match_Pattern_Property (Ctx      : Eval_Context;
                                    Node     : LAL.Ada_Node;
                                    Property : L.Node_Pattern_Property)
                                    return Match_Result
     with Pre => not Node.Is_Null;
   --  Match the exoected vaue specified in 'Property' agains the value of the
   --  property call described in 'Property' on 'Node'.

   function Match_Pattern_Selector (Ctx      : Eval_Context;
                                    Node     : LAL.Ada_Node;
                                    Selector : L.Node_Pattern_Selector)
                                    return Match_Result
     with Pre => not Node.Is_Null;
   --  Match 'Node' againt a selector apearing as a node pattern detail.
   --  If the selector has a binding name, a binding associating the said name
   --  to the output of the selector will be added to the 'Bindings' part of
   --  the 'Match_Result'.

   function Eval_Selector (Ctx     : Eval_Context;
                           Node    : LAL.Ada_Node;
                           Call    : L.Selector_Call;
                           Pattern : L.Base_Pattern;
                           Result  : out Selector_List) return Boolean;
   --  Return whether the evaluation of the given selector from 'Node' produces
   --  a valid result.
   --  If that is the case, the associated selector_list will be stored in
   --  'Result'.

   -----------------------------
   --  Node_Pattern_Predicate --
   -----------------------------

   type Node_Pattern_Predicate is new Depth_Node_Iters.Predicates.Func with
      record
         Ctx     : Eval_Context;
         Pattern : L.Base_Pattern;
      end record;
   --  Predicate that returns true when given a Depth_Node that matches
   --  'Pattern'.

   overriding function Evaluate
     (Self : in out Node_Pattern_Predicate; Node : Depth_Node) return Boolean;

   overriding function Clone
     (Self : Node_Pattern_Predicate) return Node_Pattern_Predicate;

   overriding procedure Release (Self : in out Node_Pattern_Predicate);

   function Make_Node_Pattern_Predicate (Ctx     : Eval_Context;
                                         Pattern : L.Base_Pattern)
                                         return Node_Pattern_Predicate;
   --  Create a Node_Pattern_Predicate with the given pattern and evalalution
   --  context.

private

   function Match_Detail_Value (Ctx    : Eval_Context;
                                Value  : Primitive;
                                Detail : L.Detail_Value) return Match_Result;

end LKQL.Patterns.Nodes;
