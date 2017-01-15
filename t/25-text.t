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
            action => 'p',
            args   => {
                data => 'Primary',
                txt  => 'left',
            },
            expected => '<p class="text-left">Primary</p>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'p',
            args   => {
                data => 'Primary',
                txt  => 'center',
            },
            expected => '<p class="text-center">Primary</p>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'p',
            args   => {
                data => 'Primary',
                txt  => 'right',
            },
            expected => '<p class="text-right">Primary</p>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'p',
            args   => {
                data => 'Primary',
                txt  => 'justify',
            },
            expected => '<p class="text-justify">Primary</p>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'p',
            args   => {
                data => 'Primary',
                txt  => 'nowrap',
            },
            expected => '<p class="text-nowrap">Primary</p>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'p',
            args   => {
                data => 'Primary',
                txt  => 'lowercase',
            },
            expected => '<p class="text-lowercase">Primary</p>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'p',
            args   => {
                data => 'Primary',
                txt  => 'uppercase',
            },
            expected => '<p class="text-uppercase">Primary</p>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'p',
            args   => {
                data => 'Primary',
                txt  => 'capitalize',
            },
            expected => '<p class="text-capitalize">Primary</p>'
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
