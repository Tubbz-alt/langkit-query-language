with Langkit_Support.Text; use Langkit_Support.Text;

with Liblkqllang.Common;     use Liblkqllang.Common;
with Liblkqllang.Implementation; use Liblkqllang.Implementation;

package body Liblkqllang.Prelude is

    Prelude_Content : String :=
        "selector nextSiblings" & ASCII.LF &
        "   | AdaNode => rec it.next_sibling" & ASCII.LF &
        "   | _       => ()" & ASCII.LF &
        ""                   & ASCII.LF &
        "selector prevSiblings" & ASCII.LF &
        "   | AdaNode => rec it.previous_sibling" & ASCII.LF &
        "   | _       => ()" & ASCII.LF &
        ""                   & ASCII.LF &
        "selector parent" & ASCII.LF &
        "   | AdaNode => rec *it.parent" & ASCII.LF &
        "   | _       => ()" & ASCII.LF &
        ""                   & ASCII.LF &
        "selector children" & ASCII.LF &
        "   | AdaNode => rec *it.children" & ASCII.LF &
        "   | _       => ()" & ASCII.LF &
        ""                   & ASCII.LF &
        "selector superTypes" & ASCII.LF &
        "    | BaseTypeDecl      => rec *it.base_types()" & ASCII.LF &
        "    | _                 => ()" & ASCII.LF;


    -------------------
    -- Fetch_Prelude --
    -------------------

    procedure Fetch_Prelude (Context : Internal_Context) is
       use Liblkqllang.Analysis;
       Std : constant Internal_Unit :=
          (if Prelude_Unit = null
           then Get_From_Buffer
                   (Context  => Context,
                    Filename => "prelude",
                    Charset  => "ascii",
                    Buffer   => Prelude_Content,
                    Rule     => Default_Grammar_Rule)
           else Prelude_Unit);
    begin
       Populate_Lexical_Env (Std);
    end Fetch_Prelude;

end Liblkqllang.Prelude;
