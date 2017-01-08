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
            action => 'breadcrumbs',
            args   => {
                items => [
                    {
                        link => '#',
                        data => 'Home',
                    },
                    {
                        link => '#',
                        data => 'Library',
                    },
                    {
                        active => 1,
                        data   => 'Data',
                    }
                ],
            },
            expected =>
'<ol class="breadcrumb"><li><a href="#">Home</a></li><li><a href="#">Library</a></li><li class="active">Data</li></ol>'
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
