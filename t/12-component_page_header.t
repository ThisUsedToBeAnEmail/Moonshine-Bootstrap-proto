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
            action => 'page_header',
            args   => {
                header => {
                    data => 'Example page header'
                }
            },
            expected =>
              '<div class="page-header"><h1>Example page header</h1></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'page_header',
            args   => {
                header => {
                    data => 'Example page header ',
                },
                small => 'Subtext for header',
            },
            expected =>
'<div class="page-header"><h1>Example page header <small>Subtext for header</small></h1></div>',
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
