import React from 'react'
import ReactDOM from 'react-dom'
import { OssoLogin, OssoProvider } from '@enterprise-oss/osso';

const Button = props => (
  <button {...props} />
)

const Input = ({ onChange, ...props}) => (
  <>
    <label htmlFor={props.id}>{props.label}</label>
    <input 
      {...props}
      type="email"
      onChange={(e) => onChange && onChange(e.target.value)} // Osso expects a value in change handlers rather than events
    />
  </>
)

const onSubmitPassword = (email, password) => {
  console.warn(`Submit a request to sign the user in to your server. Email: ${email}, Password: ${password}`);
  return Promise.resolve();
}

const submitSaml = (email) => {
  const csrfToken = document.querySelector('meta[name="csrf-token"]').content
  const form = document.createElement("form");
  
  const tokenInput = document.createElement("input"); 
  tokenInput.value = csrfToken;
  tokenInput.name = "authenticity_token"
  
  const emailInput = document.createElement("input"); 
  emailInput.value = email;
  emailInput.name = "email"
  
  form.action = `/users/auth/osso`;   
  form.hidden = true
  form.method = "POST";
  
  form.appendChild(tokenInput);  
  form.appendChild(emailInput);  
  document.body.appendChild(form);
  
  return form.submit();
}

const App = () => (
  <OssoProvider
    client={{
      baseUrl: 'http://localhost:9292',
    }}
  >
    <div className="container">
      <div className="main-content login">
        <h1>Welcome!</h1>
        <OssoLogin
          containerClass="login-form"
          ButtonComponent={Button}
          InputComponent={Input}
          onSamlFound={submitSaml}
          onSubmitPassword={onSubmitPassword}
        />
      </div>
    </div>
  </OssoProvider>
)

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <App />,
    document.body.appendChild(document.createElement('div')),
  )
})
