with Patterns;               use Patterns;
with Patterns.Match;         use Patterns.Match;
with Interpreter.Primitives; use Interpreter.Primitives;

package body Queries is

   -------------------------
   -- Make_Query_Iterator --
   -------------------------

   function Make_Query_Iterator (Ctx  : Eval_Context;
                                 Node : LEL.Query)
                                 return Node_Iterators.Filter_Iter
   is
      Iter      : constant Node_Iterator_Access :=
        new Childs_Iterator'(Make_Childs_Iterator (Ctx.AST_Root));
      Predicate : constant Iterator_Predicate_Access :=
        Iterator_Predicate_Access (Make_Query_Predicate (Ctx, Node));
   begin
      return Node_Iterators.Filter (Iter, Predicate);
   end Make_Query_Iterator;

   --------------------------
   -- Make_Query_Predicate --
   --------------------------

   function Make_Query_Predicate
     (Ctx : Eval_Context; Query : LEL.Query) return Query_Predicate_Access
   is
   begin
      return new Query_Predicate'(Ctx, Query);
   end Make_Query_Predicate;

   --------------
   -- Evaluate --
   --------------

   overriding function Evaluate
     (Self : in out Query_Predicate; Node : Iterator_Node) return Boolean
   is
      Match : constant Match_Result :=
        Match_Pattern (Self.Ctx,
                    Self.Query.F_Pattern,
                    To_Primitive (Node.Node));
   begin
      return Match.Success;
   end Evaluate;

   -----------
   -- Clone --
   -----------

   overriding function Clone
     (Self : Query_Predicate) return Query_Predicate
   is
   begin
      return Query_Predicate'(Self.Ctx, Self.Query);
   end Clone;

end Queries;