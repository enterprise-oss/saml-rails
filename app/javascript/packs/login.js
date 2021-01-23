document.addEventListener("turbolinks:load", function() {
  const loginForm = document.querySelector("#login-form");
  loginForm.addEventListener("ajax:success", (event) => {
    const [data, ..._rest] = event.detail;
    if (data.identity_provider_id) {
      return samlLogin(data.identity_provider_id)
    }

    passwordLogin(loginForm)
  });
});


function samlLogin(idpId) {
  const form = document.createElement("form");
  const tokenInput = document.createElement("input"); 
  const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
  tokenInput.value = csrfToken;
  tokenInput.name = "authenticity_token";

  form.action = `/users/auth/saml/${idpId}`;   
  form.hidden = true;
  form.method = "POST";
  
  form.appendChild(tokenInput);  
  document.body.appendChild(form);
  
  form.submit();
}

function passwordLogin(loginForm) {
  const passwordInput = document.createElement("input"); 
  passwordInput.name = "password";

  loginForm.appendChild(passwordInput);

  loginForm.action = '/users/auth/password';
}
