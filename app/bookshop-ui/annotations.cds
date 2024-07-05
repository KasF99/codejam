using CatalogService as service from '../../srv/cat-service';

// general
annotate CatalogService.Books with {
    title   @title: 'Title';
    author  @title: 'Author'  @Common: {
        Text           : author.name,
        TextArrangement: #TextOnly
    };
    genre   @title: 'Genre'   @Common: {
        Text           : genre.name,
        TextArrangement: #TextOnly
    };
    price   @title: 'Price';
    stock   @title: 'Stock';
};

annotate CatalogService.Books with @(
    UI                : {
        SelectionFields: [
            genre_ID,
            author_ID
        ],
        HeaderInfo     : {
            TypeName      : 'Book',
            TypeNamePlural: 'Books',
            Title         : {Value: title},
            Description   : {Value: author.name}
        },
        Identification : [{Value: ID}],
        LineItem       : {
            $value            : [
                {
                    $Type            : 'UI.DataField',
                    Value            : title,
                    Label            : 'Title',
                    ![@UI.Importance]: #High
                },
                {
                    $Type: 'UI.DataField',
                    Label: 'Author name',
                    Value: author.name,
                },
                {
                    $Type: 'UI.DataField',
                    Label: 'Genre',
                    Value: genre.name,
                },
                {
                    $Type            : 'UI.DataField',
                    Value            : price,
                    ![@UI.Importance]: #Medium
                },
                {
                    $Type                    : 'UI.DataField',
                    Value                    : stock,
                    Criticality              : criticality,
                    CriticalityRepresentation: #WithoutIcon,
                    ![@UI.Importance]        : #Medium
                }
            ],
            ![@UI.Criticality]: criticality // criticality for whole line item
        }
    },
    UI.FieldGroup #GG1: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Title',
                Value: title,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Description',
                Value: descr,
            },
            // {
            //     $Type: 'UI.DataField',
            //     Label: 'Author name',
            //     Value: author.name,
            // },
            // {
            //     $Type: 'UI.DataField',
            //     Label: 'Genre',
            //     Value: genre.name,
            // },
            {
                $Type: 'UI.DataField',
                Label: 'Author',
                Value: author_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Genre',
                Value: genre_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Stock',
                Value: stock,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Price',
                Value: price,
            },
        ],
        Label: 'GI',
    },
    UI.Facets         : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'GI',
        ID    : 'GF1',
        Target: '@UI.FieldGroup#GG1',
    }, ],
);

// value help for Authors
annotate CatalogService.Books with {
    author
    @Common.ValueListWithFixedValues: true // dropdown instead of dialog
    @Common.ValueList               : {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'Authors',
        Parameters    : [{
            $Type            : 'Common.ValueListParameterInOut',
            LocalDataProperty: author_ID,
            ValueListProperty: 'ID',
        }]
    }
};

// value help for Authors: display name instead of ID
annotate CatalogService.Authors with {
    ID @Common.Text: {
        $value                : name,
        ![@UI.TextArrangement]: #TextOnly,
    }
};

annotate CatalogService.Books with @odata.draft.enabled;
annotate service.Books with @(
    UI.DataPoint #stock : {
        Value : stock,
        TargetValue : 100,
        Criticality : criticality
    },
    UI.Chart #stock : {
        ChartType : #Donut,
        Title : 'Stock',
        Measures : [
            stock,
        ],
        MeasureAttributes : [
            {
                DataPoint : '@UI.DataPoint#stock',
                Role : #Axis1,
                Measure : stock,
            },
        ],
    },
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'stock',
            Target : '@UI.Chart#stock',
        },
    ]
);
