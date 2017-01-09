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
            action => 'badge',
            args   => {
                data => '42',
            },
            expected => '<span class="badge">42</span>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'badge',
            args   => {
                data    => '4',
                wrapper => {
                    tag   => 'button',
                    class => 'btn btn-primary',
                    type  => 'button',
                    data  => 'Messages'
                }
            },
            expected =>
'<button class="btn btn-primary" type="button">Messages<span class="badge">4</span></button>'
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
