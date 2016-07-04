/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package localolympics.rest;

import org.restlet.Context;
import org.restlet.ext.jaxrs.JaxRsApplication;

/**
 *
 * @author averkhovtsev
 */
public class ApplicationConfig extends JaxRsApplication {


    public ApplicationConfig(Context context) {
        super(context);
        this.add(new JavaRSApp());
    }

}
