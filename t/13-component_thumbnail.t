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
            class    => $class,
            action   => 'thumbnail',
            args     => {},
            expected => '<div class="thumbnail"></div>',
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'caption',
            args     => {},
            expected => '<div class="caption"></div>',
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
