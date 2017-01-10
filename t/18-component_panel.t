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
            class  => $class,
            action => 'panel_body',
            args   => {
                data => 'Basic panel example',
            },
            expected => '<div class="panel-body">Basic panel example</div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'panel_header',
            args   => {
                data => 'Basic panel example',
            },
            expected => '<div class="panel-heading">Basic panel example</div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'panel_header',
            args   => {
                title => { data => 'Basic panel example' },
            },
            expected =>
'<div class="panel-heading"><h3 class="panel-title">Basic panel example</h3></div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'panel_footer',
            args   => {
                data => 'Basic panel footer',
            },
            expected =>
'<div class="panel-footer">Basic panel footer</div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'panel',
            args   => {
                body => {
                    data => 'Basic panel example',
                }
            },
            expected =>
'<div class="panel panel-default"><div class="panel-body">Basic panel example</div></div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'panel',
            args   => {
                header => {
                    data => 'Basic panel example',
                }
            },
            expected =>
'<div class="panel panel-default"><div class="panel-heading">Basic panel example</div></div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'panel',
            args   => {
                header => {
                    data => 'Basic panel example',
                },
                body => {
                    data => '...'
                }
            },
            expected =>
'<div class="panel panel-default"><div class="panel-heading">Basic panel example</div><div class="panel-body">...</div></div>'
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
