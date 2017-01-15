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
            action => 'li',
            args   => {
                class => 'one',
            },
            expected => '<li class="one"></li>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'h1',
            args   => {
                class => 'one',
            },
            expected => '<h1 class="one"></h1>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'h2',
            args   => {
                class => 'one',
            },
            expected => '<h2 class="one"></h2>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'h3',
            args   => {
                class => 'one',
            },
            expected => '<h3 class="one"></h3>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'h4',
            args   => {
                class => 'one',
            },
            expected => '<h4 class="one"></h4>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'h5',
            args   => {
                class => 'one',
            },
            expected => '<h5 class="one"></h5>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'h6',
            args   => {
                class => 'one',
            },
            expected => '<h6 class="one"></h6>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'ul',
            args   => {
                class => 'one',
            },
            expected => '<ul class="one"></ul>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'td',
            args   => {
                class => 'one',
            },
            expected => '<td class="one"></td>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'tr',
            args   => {
                class => 'one',
            },
            expected => '<tr class="one"></tr>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'p',
            args   => {
                lead => 1,
            },
            expected => '<p class="lead"></p>'
        }
    );

};

sub component_test {
    my $args = shift;

    my $action = $args->{action};
    my $element = $args->{class}->$action( $args->{args} // {} );
    is( $element->render, $args->{expected}, "got expected $args->{expected}" );
}

done_testing();
