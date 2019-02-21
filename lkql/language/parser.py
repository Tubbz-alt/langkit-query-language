from langkit.dsl import ASTNode, abstract, Field
from langkit.parsers import Grammar, Or, List, Pick
from lexer import Token

@abstract
class LKQLNode(ASTNode):
    """
    Root node class for LKQL AST nodes.
    """
    pass


@abstract
class Op(LKQLNode):
    """
    Base class for operators.
    """
    enum_node = True
    alternatives = ['plus', 'minus', 'mul', 'div', 'and', 'or', 'eq']


class BinOp(LKQLNode):
    """
    Binary operation.
    """
    left = Field()
    op = Field()
    right = Field()


class Assign(LKQLNode):
    """
    Assign expression.
    An assignment associates a name with a value, and returns Unit.
    """
    identifier = Field()
    value = Field()


class PrintStmt(LKQLNode):
    """
    `print` built-in.
    """
    value = Field()

class BoolLiteral(LKQLNode):
    """
    Booean literal
    """
    enum_node = True
    alternatives = ['true', 'false']

class Identifier(LKQLNode):
    """
    Regular identifier.
    """
    token_node = True

class Integer(LKQLNode):
    """
    Integer literal.
    """
    token_node = True

class Number(LKQLNode):
    """
    Decimal number literal.
    """
    token_node = True

class StringLiteral(LKQLNode):
    """
    String literal.
    """
    token_node = True

class DotAccess(LKQLNode):
    """
    Access to a node's field using dot notation.
    """
    receiver = Field()
    member = Field()


class Query(LKQLNode):
    """
    AST query.

    This corresponds to a 'query <identifier> when condition' block,
    where 'identifier' is a regular identifier bound to the "current" node and
    'condition' is a predicate.

    Queries are implicitly run from the root of the AST and return the list of children
    nodes that matches the condition.


    Ex:
    classesNamedA = query n when n is ClassDecl &&
                                 n.Identifier = "A"

    """
    binding = Field()
    when_clause = Field()


class IsClause(LKQLNode):
    """
    Check a node's kind using the 'is' keyword.
    """
    identifier = Field()
    kind_name = Field()


lkql_grammar = Grammar('main_rule')
G = lkql_grammar
lkql_grammar.add_rules(
    main_rule=List(Or(G.statement, G.expr, G.query)),

    statement=Or(G.assign,
                 G.print_stmt),

    print_stmt=PrintStmt(Token.Print, Token.LPar, G.expr, Token.RPar),

    is_clause=IsClause(G.identifier, Token.Is, G.identifier),

    query=Query(Token.Query, G.identifier, Token.When, List(G.expr)),

    expr=Or(BinOp(G.expr,
                  Or(Op.alt_and(Token.And),
                     Op.alt_or(Token.Or),
                     Op.alt_eq(Token.EqEq)),
                  G.plus_expr),
            G.plus_expr,
            G.assign),

    plus_expr=Or(BinOp(G.plus_expr,
                         Or(Op.alt_plus(Token.Plus),
                            Op.alt_minus(Token.Minus)),
                         G.prod_expr),
                   G.prod_expr),

    prod_expr=Or(BinOp(G.prod_expr,
                       Or(Op.alt_mul(Token.Mul),
                          Op.alt_div(Token.Div)),
                       G.value_expr),
                 G.value_expr),

    value_expr=Or(G.identifier,
                  G.number,
                  G.string_literal,
                  G.bool_literal,
                  G.integer,
                  G.assign,
                  G.dot_access,
                  G.is_clause,
                  Pick(Token.LPar, G.expr, Token.RPar)),

    assign=Assign(G.identifier, Token.Eq, Or(G.expr, G.query)),

    identifier=Identifier(Token.Identifier),

    integer=Integer(Token.Integer),

    number=Number(Token.Number),

    bool_literal=Or(BoolLiteral.alt_true(Token.TrueLit),
                    BoolLiteral.alt_false(Token.FalseLit)),

    string_literal=StringLiteral(Token.String),

    dot_access=DotAccess(G.identifier, Token.Dot, G.identifier)
)
