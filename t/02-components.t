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
        action => 'glyphicon',
        args => {
            class => 'search',
        },
        expected => '<span class="glyphicon glyphicon-search" aria-hidden="true"></span>'
    });

    component_test({
        class => $class,
        action => 'button',
        args => {
            class => 'success',
            data => 'Left',
        },
        expected => '<button class="btn btn-success" type="button">Left</button>'
    });    

    component_test({
        class => $class,
        action => 'button_group',
        args => {
            group => [
                {
                    data => 'one',
                },
                {
                    data => 'two',
                },
            ],
        },
        expected => '<div class="btn-group" role="group"><button class="btn btn-default" type="button">one</button><button class="btn btn-default" type="button">two</button></div>'
    });     
    
    # button_group sizing
    component_test({
        class => $class,
        action => 'button_group',
        args => {
            sizing => 'lg',
            group => [
                {
                    data => 'one',
                },
                {
                    data => 'two',
                },
            ],
        },
        expected => '<div class="btn-group btn-group-lg" role="group"><button class="btn btn-default" type="button">one</button><button class="btn btn-default" type="button">two</button></div>'
    });  

    component_test({
        class => $class,
        action => 'dropdown_button',
        args => {
            id => 'dropdownMenu1',
            data => 'Dropdown',
        },
        expected => '<button class="btn btn-default dropdown-toggle" id="dropdownMenu1" type="button" aria-expanded="true" aria-haspopup="true" data-toggle="dropdown">Dropdown<span class="caret"></span></button>'   
    });

    component_test({
        class => $class,
        action => 'button_toolbar',
        args => {
            toolbar => [
                {
                    group => [
                        {
                            data => 'one',
                        },
                    ],
                },
                {
                    group => [
                        {
                            data => 'two',
                        }
                    ],
                },
            ],
        },
        expected => '<div class="btn-toolbar" role="toolbar"><div class="btn-group" role="group"><button class="btn btn-default" type="button">one</button></div><div class="btn-group" role="group"><button class="btn btn-default" type="button">two</button></div></div>',
   });


    component_test({
        class => $class,
        action => 'linked_li',
        args => {
            link => 'http://some.url',
            data => 'URL',
        },
        expected => '<li><a href="http://some.url">URL</a></li>'
    });

    component_test({
        class => $class,
        action => 'linked_li',
        args => {
            link => 'http://some.url',
            data => 'URL',
            disabled => 1,
        },
        expected => '<li class="disabled"><a href="http://some.url">URL</a></li>'
    }); 

    component_test({
        class => $class,
        action => 'dropdown_header_li',
        args => {
            data => 'URL',
        },
        expected => '<li class="dropdown-header">URL</li>'
    }); 

    component_test({
        class => $class,
        action => 'dropdown_ul',
        args => {
            aria_labelledby => 'dropdownMenu1',
            list => [
                {
                    link => 'http://some.url',
                    data => 'URL',
                },
                {
                    link => 'http://second.url',
                    data => 'Second',
                }
            ],
        },
        expected => '<ul class="dropdown-menu" aria-labelledby="dropdownMenu1"><li><a href="http://some.url">URL</a></li><li><a href="http://second.url">Second</a></li></ul>' 
    });
 
    component_test({
        class => $class,
        action => 'dropdown_ul',
        args => {
            alignment => 'right',
            aria_labelledby => 'dropdownMenu1',
            list => [
                {
                    link => 'http://some.url',
                    data => 'URL',
                },
                {
                    link => 'http://second.url',
                    data => 'Second',
                }
            ],
        },
        expected => '<ul class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdownMenu1"><li><a href="http://some.url">URL</a></li><li><a href="http://second.url">Second</a></li></ul>' 
    }); 


    component_test({
        class => $class,
        action => 'dropdown_ul',
        args => {
            separators => [2],
            aria_labelledby => 'dropdownMenu1',
            list => [
                {
                    link => 'http://some.url',
                    data => 'URL',
                },
                {
                    link => 'http://second.url',
                    data => 'Second',
                }
            ],
        },
        expected => '<ul class="dropdown-menu" aria-labelledby="dropdownMenu1"><li><a href="http://some.url">URL</a></li><li class="divider" role="separator"></li><li><a href="http://second.url">Second</a></li></ul>' 
    }); 

    component_test({
        class => $class,
        action => 'dropdown_ul',
        args => {
            separators => [1, 3, 5],
            aria_labelledby => 'dropdownMenu1',
            list => [
                {
                    link => 'http://some.url',
                    data => 'URL',
                },
                {
                    link => 'http://second.url',
                    data => 'Second',
                }
            ],
        },
        expected => '<ul class="dropdown-menu" aria-labelledby="dropdownMenu1"><li class="divider" role="separator"></li><li><a href="http://some.url">URL</a></li><li class="divider" role="separator"></li><li><a href="http://second.url">Second</a></li><li class="divider" role="separator"></li></ul>' 
    }); 

    component_test({
        class => $class,
        action => 'dropdown',
        args => {
            mid => 'dropdownMenu1', 
            ul => {
                separators => [1,3,5],
                list => [
                    {
                        link => 'http://some.url',
                        data => 'URL',
                    },
                    {
                        link => 'http://second.url',
                        data => 'Second',
                    }
                ],
            },
            button => {
                id => 'dropdownMenu1',
                data => 'Dropdown',
            },
        },
        expected => '<div class="dropdown"><button class="btn btn-default dropdown-toggle" id="dropdownMenu1" type="button" aria-expanded="true" aria-haspopup="true" data-toggle="dropdown">Dropdown<span class="caret"></span></button><ul class="dropdown-menu" aria-labelledby="dropdownMenu1"><li class="divider" role="separator"></li><li><a href="http://some.url">URL</a></li><li class="divider" role="separator"></li><li><a href="http://second.url">Second</a></li><li class="divider" role="separator"></li></ul></div>'   
    });


    component_test({
        class => $class,
        action => 'dropdown',
        args => {
            mid => 'dropdownMenu1', 
            ul => {
                separators => [1,3,5],
                list => [
                    {
                        link => 'http://some.url',
                        data => 'URL',
                    },
                    {
                        link => 'http://second.url',
                        data => 'Second',
                        disabled => 1,
                    }
                ],
            },
            button => {
                id => 'dropdownMenu1',
                data => 'Dropdown',
            },
        },
        expected => '<div class="dropdown"><button class="btn btn-default dropdown-toggle" id="dropdownMenu1" type="button" aria-expanded="true" aria-haspopup="true" data-toggle="dropdown">Dropdown<span class="caret"></span></button><ul class="dropdown-menu" aria-labelledby="dropdownMenu1"><li class="divider" role="separator"></li><li><a href="http://some.url">URL</a></li><li class="divider" role="separator"></li><li class="disabled"><a href="http://second.url">Second</a></li><li class="divider" role="separator"></li></ul></div>'   
    }); 

    component_test({
        class => $class,
        action => 'dropdown',
        args => {
            mid => 'dropdownMenu1', 
            ul => {
                separators => [1,3,5],
                list => [
                    {
                        link => 'http://some.url',
                        data => 'URL',
                    },
                    {
                        data => 'Second',
                        header => 1,
                    }
                ],
            },
            button => {
                id => 'dropdownMenu1',
                data => 'Dropdown',
            },
        },
        expected => '<div class="dropdown"><button class="btn btn-default dropdown-toggle" id="dropdownMenu1" type="button" aria-expanded="true" aria-haspopup="true" data-toggle="dropdown">Dropdown<span class="caret"></span></button><ul class="dropdown-menu" aria-labelledby="dropdownMenu1"><li class="divider" role="separator"></li><li><a href="http://some.url">URL</a></li><li class="divider" role="separator"></li><li class="dropdown-header">Second</li><li class="divider" role="separator"></li></ul></div>'   
    });

     component_test({
        class => $class,
        action => 'dropdown',
        args => {
            mid => 'dropdownMenu1',
            dropup => 1,
            ul => {
                separators => [1,3,5],
                list => [
                    {
                        link => 'http://some.url',
                        data => 'URL',
                    },
                    {
                        data => 'Second',
                        header => 1,
                    }
                ],
            },
            button => {
                id => 'dropdownMenu1',
                data => 'Dropdown',
            },
        },
        expected => '<div class="dropup"><button class="btn btn-default dropdown-toggle" id="dropdownMenu1" type="button" aria-expanded="true" aria-haspopup="true" data-toggle="dropdown">Dropdown<span class="caret"></span></button><ul class="dropdown-menu" aria-labelledby="dropdownMenu1"><li class="divider" role="separator"></li><li><a href="http://some.url">URL</a></li><li class="divider" role="separator"></li><li class="dropdown-header">Second</li><li class="divider" role="separator"></li></ul></div>'   
    }); 

};

sub component_test {
    my $args = shift;

    my $action = $args->{action};
    my $element = $args->{class}->$action($args->{args} // {});
    is($element->render, $args->{expected}, "got expected $args->{expected}");
}

done_testing();
