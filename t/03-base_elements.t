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

    component_test(
        {
            class    => $class,
            action   => 'mark',
            args     => { data => 'Some Text' },
            expected => '<mark>Some Text</mark>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'del',
            args     => { data => 'Some Text' },
            expected => '<del>Some Text</del>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 's',
            args     => { data => 'Some Text' },
            expected => '<s>Some Text</s>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'ins',
            args     => { data => 'Some Text' },
            expected => '<ins>Some Text</ins>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'u',
            args     => { data => 'Some Text' },
            expected => '<u>Some Text</u>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'small',
            args     => { data => 'Some Text' },
            expected => '<small>Some Text</small>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'strong',
            args     => { data => 'Some Text' },
            expected => '<strong>Some Text</strong>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'em',
            args     => { data => 'Some Text' },
            expected => '<em>Some Text</em>'
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
