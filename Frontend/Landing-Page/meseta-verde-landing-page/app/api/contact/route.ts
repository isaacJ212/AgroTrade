import { Resend } from 'resend'

export async function POST(request: Request) {
  try {
    const formData = await request.json()
    const { nombre, email, tipo, mensaje } = formData

    // Validar datos
    if (!nombre || !email || !mensaje) {
      return Response.json(
        { error: 'Faltan campos requeridos' },
        { status: 400 }
      )
    }

    // Validar email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(email)) {
      return Response.json(
        { error: 'Email inválido' },
        { status: 400 }
      )
    }

    // Inicializar Resend en runtime con la key proporcionada
    const resend = new Resend(process.env.RESEND_API_KEY)

    // Preparar contenido del email
    const emailContent = `
<!DOCTYPE html>
<html>
  <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
    <div style="background: linear-gradient(135deg, #38B85A 0%, #1565C0 100%); color: white; padding: 30px; border-radius: 10px; margin-bottom: 20px;">
      <h1 style="margin: 0; font-size: 28px;">Meseta Verde</h1>
      <p style="margin: 5px 0 0 0;">Nuevo contacto recibido</p>
    </div>
    
    <div style="background: #f5f5f5; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
      <p><strong>Nombre:</strong> ${nombre}</p>
      <p><strong>Email:</strong> ${email}</p>
      <p><strong>Tipo:</strong> ${tipo}</p>
      <p><strong>Mensaje:</strong></p>
      <p style="background: white; padding: 15px; border-left: 4px solid #38B85A; border-radius: 4px;">${mensaje}</p>
    </div>
    
    <div style="color: #666; font-size: 12px; text-align: center;">
      <p>Este mensaje fue enviado desde el formulario de contacto de Meseta Verde</p>
      <p>Fecha: ${new Date().toLocaleString('es-NI')}</p>
    </div>
  </body>
</html>
    `

    // Enviar email al administrador usando Resend
    try {
      const adminEmailResponse = await resend.emails.send({
        from: 'Meseta Verde <onboarding@resend.dev>',
        to: 'agrotradestartup0@gmail.com',
        replyTo: email,
        subject: `Nuevo contacto de Meseta Verde - ${tipo}`,
        html: emailContent
      })

      console.log('[v0] Email enviado al admin:', adminEmailResponse)

      // Enviar confirmación al usuario
      const userEmailResponse = await resend.emails.send({
        from: 'Meseta Verde <onboarding@resend.dev>',
        to: email,
        subject: 'Hemos recibido tu mensaje - Meseta Verde',
        html: `
<!DOCTYPE html>
<html>
  <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
    <div style="background: linear-gradient(135deg, #38B85A 0%, #1565C0 100%); color: white; padding: 30px; border-radius: 10px; margin-bottom: 20px;">
      <h1 style="margin: 0; font-size: 28px;">Meseta Verde</h1>
      <p style="margin: 5px 0 0 0;">¡Gracias por contactarnos!</p>
    </div>
    
    <div style="background: #f5f5f5; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
      <h2>Hola ${nombre},</h2>
      <p>Recibimos tu mensaje exitosamente. Nuestro equipo se pondrá en contacto contigo pronto.</p>
      <p><strong>Detalles de tu contacto:</strong></p>
      <ul>
        <li>Tipo: ${tipo}</li>
        <li>Email: ${email}</li>
      </ul>
    </div>
    
    <div style="color: #666; font-size: 12px; text-align: center;">
      <p>Gracias por tu interés en Meseta Verde - Conectamos el campo con tu mesa</p>
    </div>
  </body>
</html>
        `
      })

      console.log('[v0] Email de confirmación enviado al usuario:', userEmailResponse)

      return Response.json(
        { 
          success: true, 
          message: 'Formulario enviado correctamente',
          data: {
            nombre,
            email,
            tipo,
            timestamp: new Date().toISOString()
          }
        },
        { status: 200 }
      )
    } catch (emailError) {
      console.error('[v0] Error al enviar emails:', emailError)
      return Response.json(
        { error: 'Error al enviar el formulario', details: String(emailError) },
        { status: 500 }
      )
    }
  } catch (error) {
    console.error('[v0] Error en API de contacto:', error)
    return Response.json(
      { error: 'Error interno del servidor', details: String(error) },
      { status: 500 }
    )
  }
}
