use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok('Moonshine::Bootstrap');
}

subtest "build" => sub {
    my $class = Moonshine::Bootstrap->new();
    component_test({
        class => $class,
        action => 'li',
        args => {
            class => 'one',
        },
        expected => '<li class="one"></li>'
    });

    component_test({
        class => $class,
        action => 'h1',
        args => {
            class => 'one',
        },
        expected => '<h1 class="one"></h1>'
    });

    component_test({
        class => $class,
        action => 'ul',
        args => {
            class => 'one',
        },
        expected => '<ul class="one"></ul>'
    });

    component_test({
        class => $class,
        action => 'td',
        args => {
            class => 'one',
        },
        expected => '<td class="one"></td>'
    }); 

    component_test({
        class => $class,
        action => 'tr',
        args => {
            class => 'one',
        },
        expected => '<tr class="one"></tr>'
    }); 

};

sub component_test {
    my $args = shift;

    my $action = $args->{action};
    my $element = $args->{class}->$action($args->{args} // {});
    is($element->render, $args->{expected}, "got expected $args->{expected}");
}

done_testing();
