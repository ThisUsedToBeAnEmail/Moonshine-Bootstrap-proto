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
            action => 'list_group_item',
            args   => {
                data => 'Hello World',
            },
            expected => '<li class="list-group-item">Hello World</li>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'list_group_item',
            args   => {
                data   => 'Hello World',
                active => 1,
            },
            expected => '<li class="list-group-item active">Hello World</li>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'list_group',
            args   => {
                items => [
                    {
                        data   => 'Hello World',
                        active => 1,
                    }
                ],
            },
            expected =>
'<ul class="list-group"><li class="list-group-item active">Hello World</li></ul>'
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
