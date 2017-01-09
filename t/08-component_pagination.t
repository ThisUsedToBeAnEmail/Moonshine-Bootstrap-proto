use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok('Moonshine::Bootstrap');
}

subtest "build" => sub {
    my $class = Moonshine::Bootstrap->new();

    component_test(
        {
            class => $class,
            action => 'linked_li_span',
            args => {
                link => {
                    href => '#',
                    aria_label => 'Previous',
                },
                span => {
                    aria_hidden => 'true',
                    data => '&laquo;',
                }
            },
            expected => 
'<li><a href="#" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>'
        }
    );

    component_test(
        {
            class => $class,
            action => 'linked_li_span',
            args => {
                disable => 1,
                link => {
                    href => '#',
                    aria_label => 'Previous',
                },
                span => {
                    aria_hidden => 'true',
                    data => '&laquo;',
                }
            },
            expected => 
'<li class="disabled"><a href="#" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>'
        }
    );


    component_test(
        {
            class  => $class,
            action => 'pagination',
            args   => {
                count => 5,
            },
			expected =>
'<ul class="pagination"><li><a href="#" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li><li><a href="#">1</a></li><li><a href="#">2</a></li><li><a href="#">3</a></li><li><a href="#">4</a></li><li><a href="#">5</a></li><li><a href="#" aria-label="Next"><span aria-hidden="true">&raquo;</span></a></li></ul>'
        }
    );

    
    component_test(
        {
            class  => $class,
            action => 'pagination',
            args   => {
                count => 5,
                sizing => 'lg',
            },
			expected =>
'<ul class="pagination pagination-lg"><li><a href="#" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li><li><a href="#">1</a></li><li><a href="#">2</a></li><li><a href="#">3</a></li><li><a href="#">4</a></li><li><a href="#">5</a></li><li><a href="#" aria-label="Next"><span aria-hidden="true">&raquo;</span></a></li></ul>'
        }
    );

    component_test(
        {
            class => $class,
            action => 'pager',
            args => { },
            expected => '<ul class="pager"><li><a href="#"><span>Previous</span></a></li><li><a href="#"><span>Next</span></a></li></ul>'
        }
    );

    component_test(
        {
            class => $class,
            action => 'pager',
            args => { aligned => 1 },
            expected => '<ul class="pager"><li class="previous"><a href="#"><span>Previous</span></a></li><li class="next"><a href="#"><span>Next</span></a></li></ul>'
        }
    );

    component_test(
        {
            class => $class,
            action => 'pager',
            args => { aligned => 1, disable => 'both' },
            expected => '<ul class="pager"><li class="previous disabled"><a href="#"><span>Previous</span></a></li><li class="next disabled"><a href="#"><span>Next</span></a></li></ul>'
        }
    );

    component_test(
        {
            class => $class,
            action => 'pager',
            args => { aligned => 1, disable => 'both', nav => 1 },
            expected => '<nav><ul class="pager"><li class="previous disabled"><a href="#"><span>Previous</span></a></li><li class="next disabled"><a href="#"><span>Next</span></a></li></ul></nav>'
        }
    );


    component_test(
        {
            class  => $class,
            action => 'pagination',
            args   => {
                nav => 1,
                count => 5,
                sizing => 'lg',
            },
			expected =>
'<nav><ul class="pagination pagination-lg"><li><a href="#" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li><li><a href="#">1</a></li><li><a href="#">2</a></li><li><a href="#">3</a></li><li><a href="#">4</a></li><li><a href="#">5</a></li><li><a href="#" aria-label="Next"><span aria-hidden="true">&raquo;</span></a></li></ul></nav>'
        }
    );

};

sub component_test {
    my $args = shift;

    my $action = $args->{action};
    my $element = $args->{class}->$action( $args->{args} // {} );
    return is( $element->render, $args->{expected},
        "got expected $args->{expected}" );
}

done_testing();
