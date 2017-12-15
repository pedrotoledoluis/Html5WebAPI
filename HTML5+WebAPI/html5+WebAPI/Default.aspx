<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <meta charset="utf-8" />
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <script src="Scripts/jquery-3.2.1.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
</head>
<body>
    <div class="container">
        <div class="row">
            <div class="col-sm-6">
                <h2>Dionys</h2>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-6">
                <table id="productTable"
                    class="table table-bordered
                 table-condensed table-striped">
                    <thead>
                        <tr>
                            <th>Edit</th>
                            <th>Delete</th>
                            <th>Nombre Producto</th>
                            <th>Fecha</th>
                            <th>URL</th>
                            
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
        
        <div class="row">
            <div class="col-sm-6">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        Informacion del Bien
                    </div>
                    <div class="panel-body">
                        <div class="form-group">
                            <label for="productname">Nombre del Bien</label>
                            <input type="text" id="productname"
                                class="form-control" />
                        </div>
                        <div class="form-group">
                            <label for="introdate">
                                Fecha Registro
                            </label>
                            <input type="date" id="introdate"
                                class="form-control" />
                        </div>
                        <div class="form-group">
                            <label for="url">URL</label>
                            <input type="url" id="url"
                                class="form-control" />
                        </div>
                    </div>
                    <div class="panel-footer">
                        <div class="row">
                            <div class="col-xs-3">
                                <button type="button" id="updateButton"
                                    class="btn btn-primary"
                                    onclick="updateClick();">
                                    Agregar
                                </button>
                            </div>
                      
                            <div class="col-xs-3">
                                <button type="button" id="addButton"
                                    class="btn btn-primary"
                                    onclick="addClick();">
                                    Limpiar
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <input type="hidden" id="productid" value="0" />
    <script>

        var Product = {
            ProductId: 0,
            ProductName: "",
            IntroductionDate: "",
            Url: ""
        }

        // Handle click event on Update button
        function updateClick() {
            Product = new Object();
            Product.ProductName = $("#productname").val();
            Product.IntroductionDate = $("#introdate").val();
            Product.Url = $("#url").val();

            if ($("#updateButton").text().trim() == "Agregar") {
                productAdd(Product);
            }
            else {
                productUpdate($("#productid").val(), Product);
            }
        }
        // Handle click event on Add button
        function addClick() {
            formClear();
        }

        
        function productList() {
            // Call Web API to get a list of Product
            $.ajax({
                url: '/api/Product/',
                type: 'GET',
                dataType: 'json',
                success: function (products) {
                    productListSuccess(products);
                },
                error: function (request, message, error) {
                    handleException(request, message, error);
                }
            });
        }

        function productListSuccess(products) {
            // Iterate over the collection of data
            $.each(products, function (index, product) {
                // Add a row to the Product table
                productAddRow(product);
            });
        }

        function productAddRow(product) {
            // Check if <tbody> tag exists, add one if not
            if ($("#productTable tbody").length == 0) {
                $("#productTable").append("<tbody></tbody>");
            }
            // Append row to <table>
            $("#productTable tbody").append(
              productBuildTableRow(product));
        }

        function productBuildTableRow(product) {
            var ret =
              "<tr>" +
              "<td>" +
              "<button type='button' " +
                 "onclick='productGet(this);' " +
                 "class='btn btn-default'" +
                 "data-id='" + product.ProductId + "'>" +
                 "<span class='glyphicon glyphicon-edit'/>"
               + "</button>" +
            "</td>" +
            "<td>" +
              "<button type='button' " +
                 "onclick='productDelete(this);' " +
                 "class='btn btn-default' " +
                 "data-id='" + product.ProductId + "'>" +
                 "<span class='glyphicon glyphicon-remove' />" +
              "</button>" +
            "</td>" +
               "<td>" + product.ProductName + "</td>" +
               "<td>" + product.IntroductionDate + "</td>"
                + "<td>" + product.Url + "</td>" +
              "</tr>";
            return ret;
        }

        function handleException(request, message,
                         error) {
            var msg = "";
            msg += "Code: " + request.status + "\n";
            msg += "Text: " + request.statusText + "\n";
            if (request.responseJSON != null) {
                msg += "Message" +
                    request.responseJSON.Message + "\n";
            }
            alert(msg);
        }

        $(document).ready(function () {
            productList();
        });

        function productGet(ctl) {
            // Get product id from data- attribute
            var id = $(ctl).data("id");

            // Store product id in hidden field
            $("#productid").val(id);

            // Call Web API to get a list of Products
            $.ajax({
                url: "/api/Product/" + id,
                type: 'GET',
                dataType: 'json',
                success: function (product) {
                    productToFields(product);

                    // Change Update Button Text
                    $("#updateButton").text("Update");
                },
                error: function (request, message, error) {
                    handleException(request, message, error);
                }
            });
        }

        function productDelete(ctl) {
            var id = $(ctl).data("id");

            $.ajax({
                url: "/api/Product/" + id,
                type: 'DELETE',
                success: function (product) {
                    $(ctl).parents("tr").remove();
                },
                error: function (request, message, error) {
                    handleException(request, message, error);
                }
            });
        }

        function productToFields(product) {
            $("#productname").val(product.ProductName);
            $("#introdate").val((product.IntroductionDate).substring(0, 10));
            $("#url").val(product.Url);
        }

        function productAdd(product) {
            $.ajax({
                url: "/api/Product",
                type: 'POST',
                contentType:
                   "application/json;charset=utf-8",
                data: JSON.stringify(product),
                success: function (product) {
                    productAddSuccess(product);
                },
                error: function (request, message, error) {
                    handleException(request, message, error);
                }
            });
        }

        function productAddSuccess(product) {
            productAddRow(product);
            formClear();
        }

        function formClear() {
            $("#productname").val("");
            $("#introdate").val("");
            $("#url").val("");
        }

        

        function productUpdate(id,product) {
            $.ajax({
                url: "/api/Product/" + id,
                type: 'PUT',
                contentType:
                   "application/json;charset=utf-8",
                data: JSON.stringify(product),
                success: function (product) {
                    productUpdateSuccess(product);
                },
                error: function (request, message, error) {
                    handleException(request, message, error);
                }
            });
        }

        function productUpdateSuccess(product) {
            productUpdateInTable(product);
        }

        function productUpdateInTable(product) {
            // Find Product in <table>
            var row = $("#productTable button[data-id='" +
               product.ProductId + "']").parents("tr")[0];
            // Add changed product to table
            $(row).after(productBuildTableRow(product));
            // Remove original product
            $(row).remove();
            formClear(); // Clear form fields
            // Change Update Button Text
            $("#updateButton").text("Agregar");
        }
    </script>

</body>
</html>
