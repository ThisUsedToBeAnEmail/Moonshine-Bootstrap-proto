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
            action => 'well',
            args   => {
                data => '...',
            },
            expected => '<div class="well">...</div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'well',
            args   => {
                switch => 'lg',
                data   => '...',
            },
            expected => '<div class="well well-lg">...</div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'well',
            args   => {
                switch => 'sm',
                data   => '...',
            },
            expected => '<div class="well well-sm">...</div>'
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
